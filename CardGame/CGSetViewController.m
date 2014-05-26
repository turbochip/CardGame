//
//  CGSetViewController.m
//  CardGame
//
//  Created by Cox, Chip on 5/1/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import "CGSetViewController.h"
#import "CGSetCard.h"
#import "CGSetDeck.h"
#import "CGSetHand.h"
#import "CGSetCardView.h"
#import "CGMainSetDeckView.h"
#import "CGSetView.h"

@interface CGSetViewController ()
@property (nonatomic) NSInteger setScore;
@property (nonatomic,strong) CGMainSetDeckView* deckView;
@property (nonatomic,strong) CGSetHand *discardHand;
- (CGSetHand *) buildArrayFromReferenceArray: (NSArray *) sourceArray;
@end

@implementation CGSetViewController
#pragma mark startup code
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)start
{
    self.setCard = [[CGSetCard alloc] init];
    self.fullDeck = [[CGSetDeck alloc] init];
    self.hand = [[CGSetHand alloc] init];
    
    self.fullDeck = [self.fullDeck createSetDeckof:self.setCard];
    [self dealHand: self.hand toTable:self.Table from:self.fullDeck];
    
    [self updateUI];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // register for orientation change notifications
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRotate:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    [self start];
    //    self.Table.backgroundColor=[UIColor darkGrayColor];
}

#pragma mark getters and setters

- (NSMutableArray *) matchedCards
{
    if(!_matchedCards)
        _matchedCards=[[NSMutableArray alloc] init];
    return _matchedCards;
}

- (NSMutableArray *) selectedCards
{
    if(!_selectedCards)
        _selectedCards=[[NSMutableArray alloc] init];
    return _selectedCards;
}

#pragma mark button presses


- (IBAction)RedealButtonPress:(UIButton *)sender {
    [self redealAction];
}

- (IBAction)dealMainDeckSwipe:(UISwipeGestureRecognizer *)sender {
    [self redealAction];
}

- (IBAction)NewGameButtonPress:(UIButton *)sender {
    [self resetGame];
}

- (IBAction)ClearMatchesButtonPress:(UIButton *)sender {
    [self reDealMatchesOnBoard];
    [self updateUI];
}

// table card tap gesture handler
- (IBAction)tableCardTap:(UITapGestureRecognizer *)sender
{
    NSLog(@"Sender.view.tag=%ld",(long)sender.view.tag);
    
    // isCardChosen is just easier to type than the full reference.
    BOOL isCardChosen=[[self.hand.handOfCards objectAtIndex:sender.view.tag] cardChosen];
    if(!isCardChosen)
    {  // card is not already chosen
        if(self.selectedCards.count<3)
        {  // we should never have more than 2 cards chosen at this point.  Once we get through here with two cards already selected, we mark the 3rd card selected and test for the number of selected cards again.
            
            //refcard is the tag from the card that got tapped.  This relates to the index of the card in the logical array
            NSInteger refcard=sender.view.tag;
            
            // build an array of selected cards using their index  that way we don't have multiple arrays of the cards.
            [self.selectedCards addObject:[NSNumber numberWithInteger:refcard]];
            //tell the lcard array that the card is chosen.
            [[self.hand.handOfCards objectAtIndex:refcard] setCardChosen:YES];
            
            //Now that we have another card selected lets see if we have 3 selected.
            if(self.selectedCards.count>2)
            {
                // Check for a match
                BOOL result=[self.hand match: [self buildArrayFromReferenceArray:self.selectedCards]];
                if(!result) {  // no match
                    
                    // buildArrayFromReferenceArray takes the selectedCards array which only has integers in it representing the index of the cards in the handofcards array and returns an actual array of those elements that can be used in the for statement.
                    for(CGSetCard * card in [self buildArrayFromReferenceArray:self.selectedCards].handOfCards){
                        // since there wasn't a match cleanup the card references to it being selected.
                        card.cardChosen=NO;
                        card.cardViewButton.cardChosen=NO;
                    }
                } else {  // we got a match
                    self.setScore++;
                    for(int i=0;i<self.selectedCards.count;i++)
                    {
                        // card is the lcard associated with the current selected card
                        CGSetCard *card=[self.hand.handOfCards objectAtIndex:((NSNumber *)[self.selectedCards objectAtIndex:i]).integerValue];
                        // add selected card to array of matched cards.  you can have more than one group matched on the board at any one time, so the matchedCards array could have 3, 6, 9 ... cards in it unitl a redeal or we are asked to clear the matches from the board.
                        [self.matchedCards addObject:[NSNumber numberWithInteger:((NSNumber *)[self.selectedCards objectAtIndex:i]).integerValue]];
                        
                        // Tell the pcard that we have a match and set the card back
                        card.cardViewButton.cardMatched=YES;
                        card.isMatched=YES;
                        NSInteger randback=(arc4random() % 3)+1;
                        switch (randback) {
                            case 1:
                                card.cardBackImage=@"splogo.png";
                                break;
                            case 2:
                                card.cardBackImage=@"MerckLogo.png";
                                break;
                            case 3:
                                card.cardBackImage=@"bayer-logo.png";
                                break;
                        }

                    }
                }
                // regardless of whether we got a match or not, we are done with the selectedCards array
                self.selectedCards=nil;
            }
        }
    }
    
    [self updateUI];
}

#pragma mark important stuff

//response to orientation change
-(void)didRotate:(NSNotification *)notification
{
    switch([[UIApplication sharedApplication] statusBarOrientation])
    {
        case UIInterfaceOrientationLandscapeLeft:
            NSLog(@"Orientation Changed to LandscapeLeft");
            break;
        case UIInterfaceOrientationLandscapeRight:
            NSLog(@"Orientation Changed to LandscapeRight");
            break;
        case UIInterfaceOrientationPortrait:
            NSLog(@"Orientation Changed to Portrait");
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            NSLog(@"Orientation Changed to PortraitUpsideDown");
            break;
    }
    for(CGSetCard *card in self.hand.handOfCards)
        [card.cardViewButton removeFromSuperview];
    [self updateUI];
}

- (void)updateUI
{
    //clear off table
/*    for (CGSetCardView *pcard in self.Table.subviews){
            [pcard removeFromSuperview];
        }
*/
    self.Table.table=nil;
    NSInteger indexTag=0;  //Tag to relate the pcard subview back to the index of the lcard.
    
    if(self.discardHand)
    {
        for(CGSetCard *card in self.discardHand.handOfCards) {
            [card.cardAnimation setAnimateDiscard:YES];
            [card.cardAnimation setDiscardDstLoc:CGRectMake(0, 500, 100, 175)];
            [card.cardAnimation setDiscardSrcLoc:card.cardViewButton.frame];
            [self doAnimationForCard:card];
        }
    }
    //For each logical card we are going to create the pcard on the table, register the tapgesture, set the color and tag it.
    for (CGSetCard *card in self.hand.handOfCards)
    {
        // add lcard to table creating a pcard then copy all the properties of the lcard display to the pcard.
        CGSetCardView *pcard=[self.Table addCard];
        // tag physical card with object index for logical card
        [pcard setTag:indexTag++];
        if(card.cardAnimation.animateDealCard)
            card.cardAnimation.dealDstLoc=pcard.frame;
        
        // create tap gesture recognizer for the physical card.
        UITapGestureRecognizer * tapRecognizer  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableCardTap:)];
        [tapRecognizer setNumberOfTapsRequired:1];
        [tapRecognizer setNumberOfTouchesRequired:1];
        [pcard addGestureRecognizer:tapRecognizer];
        
        [self assignHandCard:card toTableCard:pcard];
        
        if(card.cardAnimation.animateDealCard){
            [pcard setFrame:card.cardAnimation.dealSrcLoc];
              [self doAnimationForCard:card];
//            [pcard setFrame:card.cardAnimation.dealDstLoc];
        }
        
        [card.cardViewButton setNeedsDisplay];
        
    }
    // Handle status displays on screen.
    NSString *tempStr=[[NSString alloc] initWithFormat:@"%ld Cards in deck",(long)self.fullDeck.deckSize];
    [self.cardsInDeckLabel setText:tempStr];
    
    tempStr=nil;
    tempStr=[[NSString alloc] initWithFormat:@"%ld Sets",(long)self.setScore];
    [self.setsFoundLabel setText:tempStr];
}


#pragma mark Support Functions

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"title=%@", [alertView buttonTitleAtIndex:buttonIndex]);
    
    if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
        /* How do we exit the application */
    } else {
        [self resetGame];
    }
}

- (void) assignHandCard: (CGSetCard *) card toTableCard: (CGSetCardView *) cardView
{
    card.cardViewButton=cardView;
    cardView.cardMatched=card.isMatched;
    cardView.cardChosen=card.cardChosen;
    cardView.cardColor=card.cardColor;
    cardView.cardShape=card.cardShape;
    cardView.cardFill=card.cardFill;
    cardView.cardBackImage=card.cardBackImage;
    cardView.animateRemoveCard=card.cardAnimation.animateDiscard;
    cardView.animateDealCard=card.cardAnimation.animateDealCard;
    cardView.cardQuantity=card.cardQuantity;
}

- (CGSetHand *) buildArrayFromReferenceArray: (NSArray *) sourceArray
{
    CGSetHand *resultArray=[[CGSetHand alloc] init];
    for(int i=0;i<sourceArray.count;i++)
    {
        NSInteger obj2add=((NSNumber *)[sourceArray objectAtIndex:i]).integerValue;
        [resultArray.handOfCards addObject: [self.hand.handOfCards objectAtIndex:obj2add]];
    }
    return resultArray;
}

- (void) clearTable
{
    for(CGSetCard *lcard in self.hand.handOfCards){
        [lcard.cardAnimation setAnimateDiscard:YES];
        [lcard.cardAnimation setDiscardDstLoc:CGRectMake(0, 500, 100,175)];
        [lcard.cardAnimation setDiscardSrcLoc:lcard.cardViewButton.frame];
    }
    self.selectedCards=nil;
    self.matchedCards=nil;
    
}

- (void) dealCardToHand: (CGSetHand *) Hand andTable:(CGSetView*) Table from:(CGSetDeck *) Deck
{
    // get a random card from the deck
    [Hand.handOfCards addObject:[Hand drawRandomCard:Deck]];
    [[[Hand.handOfCards lastObject] cardAnimation] setAnimateDealCard:YES];
    [[[Hand.handOfCards lastObject] cardAnimation] setDealSrcLoc:self.MainDeckView.frame];
    CGRect dstloc=[[[Hand.handOfCards lastObject] cardViewButton] frame];
    [[[Hand.handOfCards lastObject] cardAnimation] setDealDstLoc:dstloc];
     
    NSLog(@"Dealing Card %@",[((CGSetCard *)Hand.handOfCards.lastObject) contents]);
}

- (void) dealHand: (CGSetHand *) Hand toTable: (CGSetView *) Table from:(CGSetDeck *) Deck
{
    [self clearTable];
    // deal individual cards to table
    for(int i=0;i<Hand.setHandMinimumSize;i++){
        [self dealCardToHand: Hand andTable:Table from: Deck];
    }
}

// Method called by AddMoreCards Button and by swiping main deck.
- (void) redealAction
{
    if(self.matchedCards.count){ // if there are matches on the board replace them instead of redealing the entire board.
        [self reDealMatchesOnBoard];
    } else {
        if(self.hand.handOfCards.count==self.hand.setHandMaximumSize)
        {   //Reset entire table since we are asking for a redeal with 15 cards showing
            //and then wipe the whole hand.
            //[self clearTable];
            //[self updateUI];
            // Wipeout hand
            self.discardHand = self.hand;
            self.hand=nil;
            self.hand=[[CGSetHand alloc] init];
            // do we have at least 12 cards left in full deck
            
            [self.Table setNeedsDisplay];
            
            
            if(self.fullDeck.deckSize>=self.hand.setHandMinimumSize)
            {
                //There are enough cards, so deal a new hand
                [self dealHand: self.hand toTable:self.Table from:self.fullDeck];
                [self.MainDeckView setNeedsDisplay];
            } else {
                // There are not enough cards so throw an error.
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You have exhausted your deck" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Restart", nil];
                [alert show];
            }
            
        } else {  // There are only 12 cards on the table.
            if(self.fullDeck.deckSize>=3) {  // There are 3 or more cards left in the full deck
                for (int i=self.hand.handOfCards.count;i<self.hand.setHandMaximumSize;i++){  // Add 3 new cards
                    [self dealCardToHand:self.hand andTable:self.Table from:self.fullDeck];
                }
                self.TableCards=self.Table.subviews;
                [self.MainDeckView setNeedsDisplay];
            }else { // less than 3 cards left in deck throw error.
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You have exhausted your deck" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Restart", nil];
                [alert show];
            }
        }
    } // end of check for additional matches.  If there were matches we replaced them and just skipped this method.
    [self updateUI];
    
}


- (void) reDealMatchesOnBoard{
    if(self.matchedCards.count>self.fullDeck.deckOfCards.count) {
        // There are not enough cards so throw an error.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You have exhausted your deck" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Restart", nil];
        [alert show];
    } else {
        // sort the matched array so that we remove the largest match first that way the index for the lower numbers doesn't change when we remove a card out of the middle of the hand.  For example the matched cards were array indexes 3, 8, 11.  If we remove index 3 first, then the matched array still wants to remove indexes 8 and 11, but in the self.matchedCards array, they are now at indexes 7 and 10, so if we start with the highest number and work backwards, when we remove 11, 3 and 8 don't change because they aren't shifting forward due to something being removed out from under them.
        NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO];
        self.discardHand=nil;
        self.discardHand=[[CGSetHand alloc] init];
        NSArray *sa = [self.matchedCards sortedArrayUsingDescriptors:@[sd]];  // sa=sortedarray
        for(int j=0;j<sa.count;j++) {
            NSInteger matchedCardIndex=((NSNumber *)[sa objectAtIndex:j]).integerValue;
            CGSetCardView *pcard=[[self.hand.handOfCards objectAtIndex:matchedCardIndex] cardViewButton];
            // need to animate removing cards here before we remove our link to the physical card.
            [[[self.hand.handOfCards objectAtIndex:matchedCardIndex] cardAnimation] setAnimateDiscard:YES];
            [[[self.hand.handOfCards objectAtIndex:matchedCardIndex] cardAnimation] setDiscardSrcLoc:pcard.frame];
            [[[self.hand.handOfCards objectAtIndex:matchedCardIndex] cardAnimation] setDiscardDstLoc:CGRectMake(0, 500, 100, 175)];
            [self.discardHand.handOfCards addObject:[self.hand.handOfCards objectAtIndex:matchedCardIndex]];
            [self.hand.handOfCards removeObjectAtIndex:matchedCardIndex];
        }
//        self.discardHand=self.hand;
        sa=nil;
        while(self.hand.handOfCards.count<self.hand.setHandMinimumSize){
            [self dealCardToHand:self.hand andTable:self.Table from:self.fullDeck];
        }
        self.matchedCards=nil;
        self.selectedCards=nil;
    }
}

- (void) resetGame
{
    [self clearTable];
    self.setScore=0;
    self.fullDeck=nil;
    [self start];
}

#pragma mark Animation

- (void) doAnimationForCard: (CGSetCard *) card
{
    CGSetCardView *pcard = card.cardViewButton;
    NSInteger action;
    CGRect srcloc,dstloc;
    
    if(card.cardAnimation.animateDealCard){
        action=1;
        srcloc=card.cardAnimation.dealSrcLoc;
        dstloc=card.cardAnimation.dealDstLoc;
    }
    else {
        if(card.cardAnimation.animateDiscard) {
            action=2;
            srcloc=card.cardAnimation.discardSrcLoc;
            dstloc=card.cardAnimation.discardDstLoc;
        }
        else {
            action=0;
        }
    }
    [UIView animateWithDuration:.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         NSLog(@"doAnimationForCard action= %d",action);
                         if(action!=0)
                             NSLog(@"doAnimationForCard action=%d destination %f,%f %f,%f",action,dstloc.origin.x,dstloc.origin.y,dstloc.size.width,dstloc.size.height);
                             [card.cardViewButton setFrame:dstloc];
                         }
                     completion:^(BOOL finished) {
                         switch(action) {
                             case 0:
                                 break;
                             case 1:
                                 [card.cardAnimation setAnimateDealCard:NO];
                                 break;
                             case 2:
                                 [card.cardViewButton removeFromSuperview];
                                 [card.cardAnimation setAnimateDiscard:NO];
                                 break;
                         }
                         [pcard setNeedsDisplay];
                     }];
}

@end
