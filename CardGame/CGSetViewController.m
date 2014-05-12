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

@interface CGSetViewController ()
@property (strong, nonatomic) IBOutletCollection(CGSetCardView) NSArray *tableCardTap;
@property (nonatomic,strong) CGSetCardView *cardView;
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
    self.cardView = [[CGSetCardView alloc] init];
    self.fullDeck = [self.fullDeck createSetDeckof:self.setCard];
    self.hand = [self.hand dealHand:self.fullDeck];
    [self.MainDeckView setNeedsDisplay];
    [self updateUI];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    for(int i=0;i<self.TableCards.count;i++) {
        UIView *card = self.TableCards[i];
        UITapGestureRecognizer * tapRecognizer  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableCardTap:)];
        [tapRecognizer setNumberOfTapsRequired:1];
        [tapRecognizer setNumberOfTouchesRequired:1];
        [card addGestureRecognizer:tapRecognizer];
        [card setTag:i];
    }
    [self start];
}
- (IBAction)RedealButtonPress:(UIButton *)sender {
    [self removeMatchesFromBoard];
    self.hand=nil;
    self.hand=[[CGSetHand alloc] init];
    if(self.fullDeck.deckSize>=15)
    {
        self.hand = [self.hand dealHand:self.fullDeck];
        [self.MainDeckView setNeedsDisplay];
        [self updateUI];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You have exhausted your deck" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Restart", nil];
        [alert show];
    }
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
    [self removeMatchesFromBoard];
    [self updateUI];
}

- (void) removeMatchesFromBoard{
    for(int j=0;j<self.matchedCards.count;j++)
    {
        [self.hand.handOfCards replaceObjectAtIndex:((NSNumber *)[self.matchedCards objectAtIndex:j]).integerValue
                                         withObject:[self removeCardFromBoard:[self.hand.handOfCards objectAtIndex:((NSNumber *)[self.matchedCards objectAtIndex:j]).integerValue]]];
    }
    self.matchedCards=nil;
    self.selectedCards=nil;
}

- (CGSetCard *) removeCardFromBoard: (CGSetCard *) card
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
    return newCard;
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
        if([[self.hand.handOfCards objectAtIndex:i] cardViewButton]==tableCard)
        {
            ((CGSetCard *)self.hand.handOfCards[i]).cardChosen=YES;
            NSLog(@"in findCardInHand %d", [(CGSetCard*) self.hand.handOfCards[i] cardChosen]);
            break;
        }
    return i;
}

- (void)updateUI
{
    for(int i=0; i<self.hand.handOfCards.count;i++) {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
