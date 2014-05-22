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

- (CGSetHand *) buildArrayFromReferenceArray: (NSArray *) sourceArray;
@end

@implementation CGSetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        [self start];
    }
    return self;
}

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
    
    [self start];
    self.Table.backgroundColor=[UIColor darkGrayColor];
//    self.TableCards=self.Table.subviews;
//    [self updateUI];
}

- (void) dealHand: (CGSetHand *) Hand toTable: (CGSetView *) Table from:(CGSetDeck *) Deck
{
    // remove any existing cards
    for(int i=0;i<Hand.handOfCards.count;i++)
        [Hand.handOfCards removeObjectAtIndex:i];
    
    //remove subviews from table
    for(CGSetView * sv  in Table.subviews) {
        [sv removeFromSuperview];
    }
    
    // deal individual cards to table
    for(int i=0;i<Hand.setHandMinimumSize;i++){
        [self dealCardToHand: Hand andTable:Table from: Deck];
    }
//    self.TableCards=self.Table.subviews;
}

- (void) dealCardToHand: (CGSetHand *) Hand andTable:(CGSetView*) Table from:(CGSetDeck *) Deck
{
    // get a random card from the deck
    [Hand.handOfCards addObject:[Hand drawRandomCard:Deck]];
    NSLog(@"Dealing Card %@",[((CGSetCard *)Hand.handOfCards.lastObject) contents]);
}

- (IBAction)RedealButtonPress:(UIButton *)sender {
    if(self.matchedCards.count){ // if there are matches on the board replace them instead of redealing the entire board.
        [self reDealMatchesOnBoard];
    } else {
        if(self.hand.handOfCards.count==self.hand.setHandMaximumSize)
        {   //Reset entire table since we are asking for a redeal with 15 cards showing
            //and then wipe the whole hand.
            [self clearTable];
            for(NSInteger i=self.Table.subviews.count;i>12;i--) {
                [self removeCardAtIndex:i-1 fromBoard:self.hand];
                self.TableCards=self.Table.subviews;
            }
            // Wipeout hand
            self.hand=nil;
            self.hand=[[CGSetHand alloc] init];
            // do we have at least 12 cards left in full deck
            if(self.fullDeck.deckSize>=self.hand.setHandMinimumSize)
            {
                //There are enough cards, so deal a new hand
                [self dealHand: self.hand toTable:self.Table from:self.fullDeck];
                [self.MainDeckView setNeedsDisplay];
                [self updateUI];
            } else {
                // There are not enough cards so throw an error.
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You have exhausted your deck" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Restart", nil];
                [alert show];
            }
        } else {  // There are only 12 cards on the table.
            if(self.fullDeck.deckSize>=3) {  // There are 3 or more cards left in the full deck
                for (int i=0;i<3;i++){  // Add 3 new cards
                    [self dealCardToHand:self.hand andTable:self.Table from:self.fullDeck];
                    [self updateUI];
                }
                self.TableCards=self.Table.subviews;
            }else { // less than 3 cards left in deck throw error.
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You have exhausted your deck" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Restart", nil];
                [alert show];
            }
        }
    } // end of check for additional matches.  If there were matches we replaced them and just skipped this method.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"title=%@", [alertView buttonTitleAtIndex:buttonIndex]);

    if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
        /* How do we exit the application */
    } else {
        [self resetGame];
    }
}

- (void) clearTable
{
    for(CGSetCardView *sv in self.Table.subviews)
        sv.removeFromSuperview;
    self.hand=nil;
    self.selectedCards=nil;
    self.matchedCards=nil;

}
- (void) resetGame
{
    //First remove cards 13,14,15 from table
    [self clearTable];
    self.setScore=0;
    self.fullDeck=nil;
    [self start];
}

- (IBAction)NewGameButtonPress:(UIButton *)sender {
    [self resetGame];
}

- (IBAction)ClearMatchesButtonPress:(UIButton *)sender {
    [self reDealMatchesOnBoard];
    [self updateUI];
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
    NSLog(@"Set cardview.cardbackimage to %@",cardView.cardBackImage);
    cardView.cardQuantity=card.cardQuantity;
}

- (BOOL) reDealMatchesOnBoard{
    BOOL Matches=NO;
    if(self.matchedCards.count>self.fullDeck.deckOfCards.count) {
        // There are not enough cards so throw an error.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You have exhausted your deck" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Restart", nil];
        [alert show];
    } else {
        for(int j=0;j<self.matchedCards.count;j++)
        {
            CGSetCard * oldCard=[[CGSetCard alloc] init];
            CGSetCard * newCard=[[CGSetCard alloc] init];
            Matches=YES;
            NSInteger matchedCardIndex=((NSNumber *)[self.matchedCards objectAtIndex:j]).integerValue;
            oldCard= [self.hand.handOfCards objectAtIndex:matchedCardIndex];
            newCard= [self replaceCardOnBoard:oldCard];
            [self.hand.handOfCards replaceObjectAtIndex:matchedCardIndex withObject:newCard];
            oldCard=nil;
            newCard=nil;
        }
        self.matchedCards=nil;
        self.selectedCards=nil;
    }
    return Matches;
}

- (CGSetCard *) replaceCardOnBoard: (CGSetCard *) card
{
    card.cardChosen=NO;
    card.cardViewButton.cardMatched=NO;
    card.cardViewButton.backgroundColor=[UIColor whiteColor];
    for (UIView *sv in card.cardViewButton.subviews)
    {
        [sv removeFromSuperview];
    }

    //Animate throwing cards away;
    [self.MainDeckView setNeedsDisplay];
    CGSetCard *newCard=[self.hand drawRandomCard:self.fullDeck];
    newCard.cardViewButton=card.cardViewButton;
    newCard.cardViewButton.cardColor=newCard.cardColor;
    newCard.cardViewButton.cardShape=newCard.cardShape;
    newCard.cardViewButton.cardFill=newCard.cardFill;
    newCard.cardViewButton.cardQuantity=newCard.cardQuantity;

    return newCard;
}

- (void) removeCardAtIndex: (NSInteger) index fromBoard:(CGSetHand *) hand
{
    CGSetCard * oldCard=[[CGSetCard alloc] init];
    oldCard=[hand.handOfCards objectAtIndex:index];
    
    [oldCard.cardViewButton removeSubview:oldCard.cardViewButton];
    [hand.handOfCards removeObjectAtIndex:index];
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

- (IBAction)tableCardTap:(UITapGestureRecognizer *)sender
{
    NSLog(@"Sender.view.tag=%ld",(long)sender.view.tag);
    BOOL isCardChosen=[[self.hand.handOfCards objectAtIndex:sender.view.tag] cardChosen];
    if(!isCardChosen)
    {
        if(self.selectedCards.count<3)
        {
            //sender.view.backgroundColor=[UIColor grayColor];
            //NSInteger refcard=[self findCardInHand:sender.view];
            NSInteger refcard=sender.view.tag;
            [self.selectedCards addObject:[NSNumber numberWithInteger:refcard]];
            [[self.hand.handOfCards objectAtIndex:refcard] setCardChosen:YES];
//            [[[self.hand.handOfCards objectAtIndex:refcard] cardViewButton] setCardChosen:YES];
//            [[[self.hand.handOfCards objectAtIndex:refcard] cardViewButton] setNeedsDisplay];
            if(self.selectedCards.count>2)
            {
                //check for a match
                BOOL result=[self.hand match: [self buildArrayFromReferenceArray:self.selectedCards]];
                if(!result) {
                    for(CGSetCard * card in [self buildArrayFromReferenceArray:self.selectedCards].handOfCards){
                        card.cardChosen=NO;
                        card.cardViewButton.cardChosen=NO;
                    }
                } else {
                    self.setScore++;
                    for(int i=0;i<self.selectedCards.count;i++)
                    {
                        CGSetCard *card=[self.hand.handOfCards objectAtIndex:((NSNumber *)[self.selectedCards objectAtIndex:i]).integerValue];
                        [self.matchedCards addObject:[NSNumber numberWithInteger:((NSNumber *)[self.selectedCards objectAtIndex:i]).integerValue]];
                        card.cardViewButton.cardMatched=YES;
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
                self.selectedCards=nil;
            }
        }
    }
    
    [self updateUI];
}

/*
- (NSInteger) findCardInHand: (UIView *) tableCard
{
    int i;
    for (i=0;i<self.hand.handOfCards.count;i++)
        if([[[self.hand.handOfCards objectAtIndex:i] cardViewButton] tag]==tableCard.tag)
        {
            ((CGSetCard *)self.hand.handOfCards[i]).cardChosen=YES;
            NSLog(@"in findCardInHand %d", [(CGSetCard*) self.hand.handOfCards[i] cardChosen]);
            break;
        }
    return i;
}
*/

- (void)updateUI
{
    for (CGSetCardView *pcard in self.Table.subviews)
         [pcard removeFromSuperview];
    self.Table.table=nil;
    NSInteger i=0;
    for (CGSetCard *card in self.hand.handOfCards)
    {
        CGSetCardView *pcard=[self.Table addCard];
        [self assignHandCard:card toTableCard:pcard];
        // create tap gesture recognizer for the physical card.
        UITapGestureRecognizer * tapRecognizer  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableCardTap:)];
        [tapRecognizer setNumberOfTapsRequired:1];
        [tapRecognizer setNumberOfTouchesRequired:1];
        [card.cardViewButton addGestureRecognizer:tapRecognizer];
        
        // tag physical card with object index for logical card
        [card.cardViewButton setTag:i++];
        
        if(card.cardChosen)
            card.cardViewButton.backgroundColor=[UIColor grayColor];
        else
            card.cardViewButton.backgroundColor=[UIColor whiteColor];
        
        [card.cardViewButton setNeedsDisplay];

    }
/*    for(int i=0; i<self.TableCards.count;i++) {
        CGSetCard *currentCard=[self.hand.handOfCards objectAtIndex:i];
        currentCard.cardViewButton=[self.TableCards objectAtIndex:i];
        NSLog(@"i=%d, tag=%ld",i,(long)[[self.TableCards objectAtIndex:i] tag]);
        if(currentCard.isMatched){
            // show card facedown
        }
        else {
            currentCard.cardViewButton.alpha=1;
            currentCard.cardViewButton.cardQuantity=[currentCard cardQuantity];
            currentCard.cardViewButton.cardColor=currentCard.cardColor;
            currentCard.cardViewButton.cardFill=currentCard.cardFill;
            currentCard.cardViewButton.cardShape=currentCard.cardShape;
            
            if(currentCard.cardChosen){
                // set card background to gray
                [currentCard cardViewButton].backgroundColor=[UIColor grayColor];
            }else{
                [currentCard cardViewButton].backgroundColor=[UIColor whiteColor];
            }
        }
        NSString *tempStr=[[NSString alloc] initWithFormat:@"%ld Cards in deck",(long)self.fullDeck.deckSize];
        [self.cardsInDeckLabel setText:tempStr];
        tempStr=nil;
        tempStr=[[NSString alloc] initWithFormat:@"%ld Sets",(long)self.setScore];
        [self.setsFoundLabel setText:tempStr];
        [currentCard.cardViewButton setNeedsDisplay];
    }
 */
    NSString *tempStr=[[NSString alloc] initWithFormat:@"%ld Cards in deck",(long)self.fullDeck.deckSize];
    [self.cardsInDeckLabel setText:tempStr];
    tempStr=nil;
    tempStr=[[NSString alloc] initWithFormat:@"%ld Sets",(long)self.setScore];
    [self.setsFoundLabel setText:tempStr];
//    [currentCard.cardViewButton setNeedsDisplay];
    
}

@end
