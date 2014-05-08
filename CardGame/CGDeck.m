//
//  CGDeck.m
//  CardGame
//
//  Created by Cox, Chip on 5/1/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import "CGDeck.h"

@implementation CGDeck
@synthesize deckOfCards = _deckOfCards;

- (NSMutableArray *) deckOfCards
{
    if(!_deckOfCards) _deckOfCards=[[NSMutableArray alloc] init];
    return _deckOfCards;
}

- (NSInteger) deckSize
{
    return self.deckOfCards.count;
}
@end
