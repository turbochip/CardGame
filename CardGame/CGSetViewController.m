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
//@property (nonatomic,strong) CGSetDeck * fullDeck;
//@property (nonatomic,strong) CGSetCard * setCard;
//@property (nonatomic,strong) CGSetHand * hand;
//@property (strong, nonatomic) IBOutletCollection(CGSetCardView) NSArray *TableCards;
@property (nonatomic,strong) CGSetCardView *cardView;
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
    // Do any additional setup after loading the view.
    [self start];
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
            // show card contents as title for now
            currentCard.cardViewButton.backgroundColor=currentCard.cardColor;
            
            currentCard.cardViewButton.alpha=1;
            NSMutableAttributedString *attDisp = [[NSMutableAttributedString alloc] initWithString:currentCard.contents];
            [attDisp addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,[currentCard.contents length])];
            [attDisp addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:8] range:NSMakeRange(0, [attDisp.string length])];
            //[attDisp drawAtPoint:CGPointMake(0,0)];
            currentCard.cardViewButton.cardContent=attDisp.mutableCopy;
            [attDisp drawAtPoint:[currentCard.cardViewButton center]];
            NSLog(@"Drawing %@ at %f,%f",attDisp.string,currentCard.cardViewButton.center.x,currentCard.cardViewButton.center.y);
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
