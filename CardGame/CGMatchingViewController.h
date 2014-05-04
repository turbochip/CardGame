//
//  CGMatchingViewController.h
//  CardGame
//
//  Created by Cox, Chip on 5/1/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGMatchingHand.h"

@interface CGMatchingViewController : UIViewController

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *TableCard;

@property (strong, nonatomic) IBOutlet UILabel *ScoreLabel;

- (NSMutableArray *) selectedCards;
- (void) updateUI;
- (void) Start;
- (NSInteger) findCardInHand: (UIButton *) title InHand: (CGMatchingHand *) hand;
@end
