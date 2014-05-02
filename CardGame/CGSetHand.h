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
- (NSMutableArray *) dealHand: (CGSetDeck *) cardDeck;
- (CGSetCard *) drawRandomCard: (CGSetDeck *) cardDeck;
- (void) removeCard: (CGSetCard *) card FromHand: (NSMutableArray *) hand;

@end
