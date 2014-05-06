//
//  CGMatchingViewController.m
//  CardGame
//
//  Created by Cox, Chip on 5/1/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import "CGMatchingViewController.h"
#import "CGMatchingDeck.h"
#import "CGMatchingHand.h"
#import "CGMatchingCard.h"
#import "CGMatchingView.h"
#import "CGCardView.h"

@interface CGMatchingViewController ()
@property (nonatomic,strong) CGMatchingDeck * fullDeck;
@property (nonatomic,strong) CGMatchingHand * playingHand;
@property (nonatomic,strong) NSMutableArray * selectedCards;
@property (nonatomic,strong) CGMatchingCard * matchingCardClass;

@property (strong, nonatomic) IBOutlet CGCardView *CGCardViewSubController;
@end

@implementation CGMatchingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSMutableArray *) selectedCards
{
    if(!_selectedCards)
    {
        _selectedCards=[[NSMutableArray alloc] init];
    }
    
    return _selectedCards;
}

- (void) Start
{
    self.fullDeck = [[CGMatchingDeck alloc] init];
    self.playingHand = [[CGMatchingHand alloc] init];
    self.matchingCardClass=[[CGMatchingCard alloc] init];

    
    // Do any additional setup after loading the view.
    self.fullDeck = [self.fullDeck createMatchingDeck];
    self.playingHand = [self.playingHand dealHand:self.fullDeck];
    [self updateUI];

}

- (IBAction)RedealTouch:(UIButton *)sender
{
    self.fullDeck=nil;
    self.playingHand=nil;
    [self Start];
}

- (NSInteger) stringRankToInteger: (NSString *) strrank
{
    NSInteger intrank;
    for(intrank=0;intrank<self.matchingCardClass.validRanks.count;intrank++)
    {
        if([self.matchingCardClass.validRanks[intrank] isEqualToString:strrank]){
            break;
        }
    }
    return intrank+1;
}

- (IBAction)swipe:(UISwipeGestureRecognizer *)sender
{
    self.CGCardViewSubController.faceUp = !self.CGCardViewSubController.faceUp;
}

#define MATCHCOUNT 2
- (IBAction)CardTouch:(UIButton *)sender {
    if([sender isKindOfClass:[UIButton class]])
    {
        NSLog(@"Inside Card Touch = %@ button was touched",sender.currentTitle );
        NSInteger i=[self findCardInHand:sender InHand:[self playingHand]];
        if(i>=0) {
            NSLog(@"Found %@ at index %ld",sender.currentTitle,(long) i);
            NSLog(@"%@",[[self.playingHand.matchingHand objectAtIndex:i] contents]);
            CGMatchingCard * card= [self.playingHand.matchingHand objectAtIndex: i];
            card.cardChosen=YES;
            [self.selectedCards addObject:card];
            sender.backgroundColor=[UIColor grayColor];

            self.CGCardViewSubController.rank=[self stringRankToInteger:card.cardRank] ;
            self.CGCardViewSubController.suit=card.cardSuit;

            if(self.selectedCards.count == MATCHCOUNT){
                if([self.playingHand matchCards:self.selectedCards]) {
                    NSLog(@"selected cards matched");
                    NSLog(@"Flip cards on table");
                }
                else {
                    for( card in self.selectedCards)
                    {
                        card.cardChosen=NO;
                        card.cardViewButton.backgroundColor=[UIColor yellowColor];
                    }
                }
                self.selectedCards=nil;                    
            }
        }
    }
    [self updateUI];
}

- (NSInteger)findCardInHand:(UIButton *)sender InHand:(CGMatchingHand *)hand
{
    NSInteger index=0;
    for(CGMatchingCard *testTitle in hand.matchingHand) {
        NSLog(@"Testing %@ = %@",sender.currentTitle,testTitle.contents);
        if([sender isEqual:testTitle.cardViewButton])
        {
            break;
        }
        else
        {
            if(index < [hand handSize])
                index++;
            else
                index=-1;
        }
    }
        return index;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self Start];
    [self.CGCardViewSubController addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.CGCardViewSubController action:@selector(pinch:)]];
}

- (void) updateUI
{
    for(int i=0;i<[self.playingHand handSize];i++)
    {
        NSLog(@"Hand[%d]=%@ %@",i,
              [self.playingHand.matchingHand[i] cardRank] ,[self.playingHand.matchingHand[i] cardSuit]);
        NSString * Title=[[NSString alloc] initWithFormat:@"%@ %@",[self.playingHand.matchingHand[i] cardRank] ,[self.playingHand.matchingHand[i] cardSuit]];
        ((CGMatchingCard *)self.playingHand.matchingHand[i]).cardViewButton=self.TableCard[i];
        [self.TableCard[i] setTitle:Title forState:UIControlStateNormal];
        if([self.playingHand.matchingHand[i] cardChosen])
        {
//            [self.TableCard[i] setTitle:Title forState:UIControlStateNormal];
            [self.TableCard[i] setBackgroundColor:[UIColor whiteColor]];
            [self.TableCard[i] setBackgroundImage:nil forState:UIControlStateNormal];
        }
        else
        {
            [self.TableCard[i] setTitle:@"" forState:UIControlStateNormal];
            UIImage * imageName=[UIImage imageNamed:@"playingcardback.png"];
            [(UIButton *)self.TableCard[i] setBackgroundImage:imageName forState:UIControlStateNormal];
        }
    }
    self.ScoreLabel.text=@"";
    self.ScoreLabel.text=[self.ScoreLabel.text stringByAppendingFormat: @"Score test : %ld",(long)self.playingHand.score];
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
