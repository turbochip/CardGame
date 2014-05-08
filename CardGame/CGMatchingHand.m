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

#define HANDSIZE 6

- (CGMatchingHand *) dealHand: (CGMatchingDeck *) cardDeck
{
    CGMatchingHand * hand=[[CGMatchingHand alloc] init];

    hand.handSize=HANDSIZE;
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
    
    if (cardDeck.deckOfPlayingCards.count){
        unsigned index = arc4random() % cardDeck.deckOfPlayingCards.count;
        randomCard = cardDeck.deckOfPlayingCards[index];
        [cardDeck.deckOfPlayingCards removeObjectAtIndex:index];
        NSLog(@"Random Card is %@ %@",randomCard.cardRank,randomCard.cardSuit);
    }
    return randomCard;
}

- (BOOL) matchCards: (NSMutableArray *) candidateCards
{
    BOOL matched = NO;
    
    if([[candidateCards objectAtIndex:0]cardRank] ==[[candidateCards objectAtIndex:1]cardRank]) {
        NSLog(@"Cards Rank Matches +4 points");
        [self calculateScore: (NSInteger)4];
        matched=YES;
    }
    else {
        if([[candidateCards objectAtIndex:0]cardSuit]==[[candidateCards objectAtIndex:1]cardSuit]) {
            NSLog(@"Cards Suit Matches +1 Point");
            
            [self calculateScore:(NSInteger)1];
            matched=YES;
        }
    }
    if(!matched)
    {
        NSLog(@"Match Failed -1 point");
        [self calculateScore:(NSInteger)-1];
    }
    
    return matched;
}

- (void) calculateScore: (NSInteger) handScore
{
    self.score+=handScore;
}

@end
