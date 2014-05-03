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
#import "CGMatchingPlay.h"

@interface CGMatchingViewController ()
@property (nonatomic,strong) CGMatchingDeck * fullDeck;
@property (nonatomic,strong) CGMatchingHand * playingHand;
@property (nonatomic,strong) NSMutableArray * selectedCards;
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

#define MATCHCOUNT 2
- (IBAction)CardTouch:(UIButton *)sender {
    if([sender isKindOfClass:[UIButton class]])
    {
        NSLog(@"Inside Card Touch = %@ button was touched",sender.currentTitle );
        NSInteger i=[self findCardInHand:sender InHand:[self playingHand]];
        if(i>=0) {
            NSLog(@"Found %@ at index %d",sender.currentTitle,(NSInteger) i);
            NSLog(@"%@",[[self.playingHand.matchingHand objectAtIndex:i] contents]);
            CGMatchingCard * card= [self.playingHand.matchingHand objectAtIndex: i];
            card.cardChosen=YES;
            [self.selectedCards addObject:card];
            sender.backgroundColor=[UIColor grayColor];
            if(self.selectedCards.count == MATCHCOUNT){
                CGMatchingPlay *cgPlay=[[CGMatchingPlay alloc] init];
                if([cgPlay matchCards:self.selectedCards]) {
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
    CGMatchingDeck * deck = [[CGMatchingDeck alloc] init];
    self.fullDeck = [[CGMatchingDeck alloc] init];
    CGMatchingHand * hand = [[CGMatchingHand alloc] init];
    self.playingHand = [[CGMatchingHand alloc] init];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fullDeck = [deck createMatchingDeck];
    self.playingHand = [hand dealHand:self.fullDeck];
    [self updateUI];
}

- (void) updateUI
{
    for(int i=0;i<[self.playingHand handSize];i++)
    {
        NSLog(@"Hand[%d]=%@ %@",i,
              [self.playingHand.matchingHand[i] cardRank] ,[self.playingHand.matchingHand[i] cardSuit]);
        NSString * Title=[[NSString alloc] initWithFormat:@"%@ %@",[self.playingHand.matchingHand[i] cardRank] ,[self.playingHand.matchingHand[i] cardSuit]];
        ((CGMatchingCard *)self.playingHand.matchingHand[i]).cardViewButton=self.TableCard[i];
        [self.TableCard[i] setBackgroundColor:[UIColor yellowColor]];

        [self.TableCard[i] setTitle:Title forState:UIControlStateNormal];
         
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
