//
//  CGMatchingCard.h
//  CardGame
//
//  Created by Cox, Chip on 5/1/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import "CGCard.h"

@interface CGMatchingCard : CGCard
@property (strong,nonatomic) NSString *cardSuit;
@property (nonatomic) NSUInteger *cardRank;

@end
