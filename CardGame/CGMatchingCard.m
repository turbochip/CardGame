//
//  CGMatchingCard.m
//  CardGame
//
//  Created by Cox, Chip on 5/1/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import "CGMatchingCard.h"
#import "CGCard.h"

@implementation CGMatchingCard

- (instancetype) init
{
    self=[super init];
    return self;
}

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
    newCard.cardViewButton=nil;
    NSLog(@"Creating %@,%@",newCard.cardSuit,newCard.cardRank);
    return newCard;
}

- (NSString *) cardSuit
{
    if(!_cardSuit)
        _cardSuit=@"";
    self.contents=_cardRank;
    self.contents=[self.contents stringByAppendingString:@" "];
    self.contents=[self.contents stringByAppendingString:_cardSuit];
    NSLog(@"Contents=%@",self.contents);
    return _cardSuit;
}

- (NSString *) cardRank
{
    if(!_cardRank)
        _cardRank=@"";
    self.contents=_cardRank;
    self.contents=[self.contents stringByAppendingString:@" "];
    self.contents=[self.contents stringByAppendingString:_cardSuit];
    NSLog(@"Contents=%@",self.contents);
    return _cardRank;
}


@end
