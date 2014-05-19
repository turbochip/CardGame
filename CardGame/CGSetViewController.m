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
- (NSInteger) findCardInHand: (UIView *) tableCard;
@end

@implementation CGSetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self start];
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
//    self.hand = [self.hand dealHand:self.fullDeck];
    
    [self updateUI];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self start];
//    self.Table=[[CGSetView alloc] initWithFrame:CGRectMake(15, 20,290, 260)];
    self.Table.backgroundColor=[UIColor darkGrayColor];
//    [self.view addSubview:self.Table];

    [self dealHand: self.hand toTable:self.Table from:self.fullDeck];
    self.TableCards=self.Table.subviews;
    [self updateUI];
}

- (void) dealHand: (CGSetHand *) Hand toTable: (CGSetView *) Table from:(CGSetDeck *) Deck
{
    for(int i=0;i<Hand.handOfCards.count;i++)
        [Hand.handOfCards removeObjectAtIndex:i];
    for(CGSetView * sv  in Table.subviews) {
        [sv removeFromSuperview];
    }
    for(int i=0;i<Hand.setHandSize;i++){
        [self dealCardToHand: Hand andTable:Table from: Deck];
    }
    self.TableCards=self.Table.subviews;
}

- (void) dealCardToHand: (CGSetHand *) Hand andTable:(CGSetView*) Table from:(CGSetDeck *) Deck
{
    [Hand.handOfCards addObject:[Hand drawRandomCard:Deck]];
    NSLog(@"Dealing Card %@",[((CGSetCard *)Hand.handOfCards.lastObject) contents]);
    CGSetCard *lCard=[Hand.handOfCards lastObject];
    [self assignHandCard:lCard toTableCard:[Table addCard]];
    UITapGestureRecognizer * tapRecognizer  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableCardTap:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [tapRecognizer setNumberOfTouchesRequired:1];
    [lCard.cardViewButton addGestureRecognizer:tapRecognizer];
    
    [lCard.cardViewButton setTag:[self.hand.handOfCards count]-1];
}

- (IBAction)RedealButtonPress:(UIButton *)sender {
    if(self.matchedCards.count){ // if there are matches on the board replace them instead of redealing the entire board.
        [self reDealMatchesOnBoard];
    } else {
        if(self.Table.subviews.count==15)
        {   //Reset entire table since we are asking for a redeal with 15 cards showing
            //First remove cards 13,14,15 from table so we are back to the standard 12 card layout
            //and then wipe the whole hand.
            for(NSInteger i=self.Table.subviews.count;i>12;i--) {
                [self removeCardAtIndex:i-1 fromBoard:self.hand];
                self.TableCards=self.Table.subviews;
            }
            // Wipeout hand
            self.hand=nil;
            self.hand=[[CGSetHand alloc] init];
            // do we have at least 12 cards left in full deck
            if(self.fullDeck.deckSize>=12)
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

- (void) resetGame
{
    //First remove cards 13,14,15 from table
    for(NSInteger i=self.Table.subviews.count;i>12;i--) {
        [self removeCardAtIndex:i-1 fromBoard:self.hand];
    }
    
    self.fullDeck=nil;
    for(CGSetCard * card in self.hand.handOfCards){
        card.cardViewButton.cardChosen=NO;
        card.cardViewButton.cardMatched=NO;
        for(UIImageView *sv in card.cardViewButton.subviews)
            sv.removeFromSuperview;
    }
    self.hand=nil;
    self.selectedCards=nil;
    self.matchedCards=nil;
    self.setScore=0;
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
    cardView.cardMatched=NO;
    cardView.cardColor=card.cardColor;
    cardView.cardShape=card.cardShape;
    cardView.cardFill=card.cardFill;
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
            NSInteger refcard=[self findCardInHand:sender.view];
            [self.selectedCards addObject:[NSNumber numberWithInteger:refcard]];
            [[self.hand.handOfCards objectAtIndex:refcard] setCardChosen:YES];
            [[[self.hand.handOfCards objectAtIndex:refcard] cardViewButton] setCardChosen:YES];
            [[[self.hand.handOfCards objectAtIndex:refcard] cardViewButton] setNeedsDisplay];
            if(self.selectedCards.count>2)
            {
                //check for a match
                BOOL result=[self.hand match: [self buildArrayFromReferenceArray:self.selectedCards]];
                if(!result) {
                    for(CGSetCard * card in [self buildArrayFromReferenceArray:self.selectedCards].handOfCards){
                        //card.cardViewButton.backgroundColor=[UIColor whiteColor];
                        card.cardChosen=NO;
                        card.cardViewButton.cardChosen=NO;
                    }
                } else {
                    //self.matchedCards=[[NSMutableArray alloc] init];
                    self.setScore++;
                    for(int i=0;i<self.selectedCards.count;i++)
                    {
                        CGSetCard *card=[self.hand.handOfCards objectAtIndex:((NSNumber *)[self.selectedCards objectAtIndex:i]).integerValue];
                        [self.matchedCards addObject:[NSNumber numberWithInteger:((NSNumber *)[self.selectedCards objectAtIndex:i]).integerValue]];
                        card.cardViewButton.cardMatched=YES;
                        NSInteger randback=(arc4random() % 3)+1;
                        switch (randback) {
                            case 1:
                                card.cardViewButton.cardBackImage=@"splogo.png";
                                [card.cardViewButton setNeedsDisplay];
                                break;
                            case 2:
                                card.cardViewButton.cardBackImage=@"MerckLogo.png";
                                [card.cardViewButton setNeedsDisplay];
                                break;
                            case 3:
                                card.cardViewButton.cardBackImage=@"bayer-logo.png";
                                [card.cardViewButton setNeedsDisplay];
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

- (void)updateUI
{
    for(int i=0; i<self.TableCards.count;i++) {
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
        NSString *tempStr=[[NSString alloc] initWithFormat:@"%ld Cards in deck",self.fullDeck.deckSize];
        [self.cardsInDeckLabel setText:tempStr];
        tempStr=nil;
        tempStr=[[NSString alloc] initWithFormat:@"%ld Sets found",self.setScore];
        [self.setsFoundLabel setText:tempStr];
        [currentCard.cardViewButton setNeedsDisplay];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
