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

@interface CGMatchingViewController ()
@property (nonatomic,strong) CGMatchingDeck * fullDeck;
@property (nonatomic,strong) CGMatchingHand * playingHand;
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
  //  CGMatchingCard * card;
    for(int i=0;i<[self.playingHand handSize];i++)
    {
//        i++;
        NSLog(@"Hand[%d]=%@ %@",i,
              [self.playingHand.matchingHand[i] cardRank] ,[self.playingHand.matchingHand[i] cardSuit]);
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
