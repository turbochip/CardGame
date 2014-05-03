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

- (NSMutableArray *) selectedCards;
- (void) updateUI;

- (NSInteger) findCardInHand: (UIButton *) title InHand: (CGMatchingHand *) hand;
@end
