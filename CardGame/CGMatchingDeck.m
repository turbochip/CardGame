//
//  CGMatchingDeck.m
//  CardGame
//
//  Created by Cox, Chip on 5/1/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import "CGMatchingDeck.h"
#import "CGMatchingCard.h"

@implementation CGMatchingDeck
- (CGMatchingDeck *) createMatchingDeck
{
    CGMatchingCard * card=[[CGMatchingCard alloc] init];
    self.deckOfPlayingCards=[[NSMutableArray alloc] init];
    for( NSString *suit in [card validSuits])
    {
        for(NSString *rank in [card validRanks])
        {
            [self.deckOfPlayingCards addObject:[card createCardWithSuit:suit andRank:rank]];
        }
    }
    self.deckSize=self.deckOfPlayingCards.count;
    for (int i=0; i<self.deckSize;i++)
        NSLog(@"deckofCards Contains %@ %@",[self.deckOfPlayingCards[i] cardRank],[self.deckOfPlayingCards[i] cardSuit]);
    return self;
}

@end
