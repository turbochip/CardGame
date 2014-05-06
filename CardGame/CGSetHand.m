//
//  CGSetHand.m
//  CardGame
//
//  Created by Cox, Chip on 5/1/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import "CGSetHand.h"
@interface CGSetHand ()

@end

@implementation CGSetHand
#define HANDSIZE 15

- (CGSetHand *) dealHand: (CGSetDeck *) cardDeck
{
    for(int i=0;i<HANDSIZE;i++)
        [self.handOfCards addObject:[self drawRandomCard:cardDeck]];
    return self;
}

- (CGSetCard *) drawRandomCard: (CGSetDeck *) cardDeck
{
    CGSetCard *randomCard = nil;
    
    if (cardDeck.deckSize){
        unsigned index = arc4random() % cardDeck.deckOfCards.count;
        randomCard = cardDeck.deckOfCards[index];
        [cardDeck.deckOfCards removeObjectAtIndex:index];
        NSLog(@"Random Card is %@",randomCard.contents);
    }
    return randomCard;
}

@end
