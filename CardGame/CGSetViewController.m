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

@interface CGSetViewController ()
@property (strong, nonatomic) IBOutletCollection(CGSetCardView) NSArray *tableCardTap;
@property (nonatomic,strong) CGSetCardView *cardView;

- (CGSetCard *) findCardInHand: (UIView *) tableCard;
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


- (void)start
{
    self.setCard = [[CGSetCard alloc] init];
    self.fullDeck = [[CGSetDeck alloc] init];
    self.hand = [[CGSetHand alloc] init];
    self.cardView = [[CGSetCardView alloc] init];
    self.fullDeck = [self.fullDeck createSetDeckof:self.setCard];
    self.hand = [self.hand dealHand:self.fullDeck];
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
    }
    [self start];
}

- (CGSetHand *) selectedCards
{
    if(!_selectedCards) _selectedCards=[[CGSetHand alloc] init];
    return _selectedCards;
}

- (IBAction)tableCardTap:(UITapGestureRecognizer *)sender
{
    NSLog(@"Sender=%@",sender.description);
    if(sender.view.backgroundColor!=[UIColor grayColor])
    {
        if(self.selectedCards.handOfCards.count<3)
        {
            sender.view.backgroundColor=[UIColor grayColor];
            [self.selectedCards.handOfCards addObject:[self findCardInHand:sender.view]];
            if(self.selectedCards.handOfCards.count>2)
            {
                //check for a match
                NSLog(@"checking for a match count=%ld",self.selectedCards.handOfCards.count);
                BOOL result=[self.selectedCards match:self.selectedCards];
                if(!result) {
                    for(CGSetCard * card in self.selectedCards.handOfCards)
                        card.cardViewButton.backgroundColor=[UIColor whiteColor];
                } else {
                    for(CGSetCard * card in self.selectedCards.handOfCards)
                    {
                        NSInteger randback=arc4random() % 3;
                        switch (randback) {
                            case 1:
                            {
                                UIImage *img= [UIImage imageNamed:@"MerckLogo.png"];
                                [card.cardViewButton setBackgroundImage:img forState:UIControlStateNormal];
                                break;
                            }
                            case 2:
                                break;
                            case 3:
                                break;
                        }

                    }
                }
                self.selectedCards=nil;
            }
        }
    }
}

- (CGSetCard *) findCardInHand: (UIView *) tableCard
{
    CGSetCard *playingCard;
    for (int i=0;i<self.hand.handOfCards.count;i++)
        if([[self.hand.handOfCards objectAtIndex:i] cardViewButton]==tableCard)
        {
            ((CGSetCard *)self.hand.handOfCards[i]).cardChosen=YES;
            NSLog(@"in findCardInHand %d", [(CGSetCard*) self.hand.handOfCards[i] cardChosen]);
            playingCard=[self.hand.handOfCards objectAtIndex:i];
        }
    return playingCard;
}

- (void)updateUI
{
    for(int i=0; i<self.hand.handOfCards.count;i++) {
        CGSetCard *currentCard=[self.hand.handOfCards objectAtIndex:i];
        currentCard.cardViewButton=[self.TableCards objectAtIndex:i];
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
            }
        }
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
