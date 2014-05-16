//
//  CGSetHand.h
//  CardGame
//
//  Created by Cox, Chip on 5/1/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import "CGHand.h"
#include "CGSetCard.h"
#include "CGSetDeck.h"
@interface CGSetHand : CGHand
- (CGSetHand *) dealHand: (CGSetDeck *) cardDeck;
- (CGSetCard *) drawRandomCard: (CGSetDeck *) cardDeck;

- (BOOL) match: (CGSetHand *) selectedCards;

@end
