//
//  CGMatchingHand.m
//  CardGame
//
//  Created by Cox, Chip on 5/1/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import "CGMatchingHand.h"

@implementation CGMatchingHand
- (instancetype)init
{
    self=[super init];
    
    NSMutableArray * temp=[[NSMutableArray alloc] init];
    self.matchingHand=temp;
    return self;
}

- (NSUInteger) gethandSize
{
    return self.matchingHand.count;
}

- (CGMatchingHand *) dealHand: (CGMatchingDeck *) cardDeck
{
    CGMatchingHand * hand=[[CGMatchingHand alloc] init];

    hand.handSize=3;
    for (int i=0;i<hand.handSize;i++)
    {
        [hand.matchingHand addObject:[hand drawRandomCard:cardDeck]];
        NSLog(@"Adding %@ %@",[hand.matchingHand[i] cardRank],[hand.matchingHand[i] cardSuit]);
    }
    return hand;
}

- (CGMatchingCard *) drawRandomCard: (CGMatchingDeck *) cardDeck
{
    CGMatchingCard *randomCard = nil;
    
    if (cardDeck.deckSize){
        unsigned index = arc4random() % cardDeck.deckSize;
        randomCard = cardDeck.deckOfPlayingCards[index];
        [cardDeck.deckOfPlayingCards removeObjectAtIndex:index];
        NSLog(@"Random Card is %@ %@",randomCard.cardRank,randomCard.cardSuit);
    }
    return randomCard;
}

- (void) removeCard: (CGMatchingCard *) card FromHand: (NSMutableArray *) hand
{
    
}
@end
