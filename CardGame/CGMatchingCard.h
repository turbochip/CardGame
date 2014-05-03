//
//  CGMatchingCard.h
//  CardGame
//
//  Created by Cox, Chip on 5/1/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import "CGCard.h"

@interface CGMatchingCard : CGCard
@property (nonatomic,weak) NSString *cardSuit;
@property (nonatomic,weak) NSString *cardRank;
@property (nonatomic,weak) UIButton *cardViewButton;
@property (nonatomic,weak) NSArray * validSuits;
@property (nonatomic) NSArray * validRanks;

- (NSArray *) validSuits;
- (NSArray *) validRanks;
- (CGCard *) createCardWithSuit: (NSString *) suit andRank: (NSString *) rank;
@end

