//
//  CGMatchingCard.m
//  CardGame
//
//  Created by Cox, Chip on 5/1/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import "CGMatchingCard.h"

@implementation CGMatchingCard

- (NSArray *) validSuits
{
    if(!_validSuits)
    {
        _validSuits = [NSArray arrayWithObjects: @"S",@"H",@"D",@"C",nil];
    }
    return _validSuits;
}

- (NSArray *) validRanks
{
    if(!_validRanks)
    {
        _validRanks = [NSArray arrayWithObjects:@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K",nil];
    }
    return _validRanks;
}

- (CGMatchingCard *) createCardWithSuit: (NSString *) suit andRank: (NSString *) rank
{
    CGMatchingCard * newCard = [[CGMatchingCard alloc] init];
    
    newCard.cardSuit=suit;
    newCard.cardRank=rank;
    NSLog(@"Creating %@,%@",newCard.cardSuit,newCard.cardRank);
    return newCard;
}

@end
