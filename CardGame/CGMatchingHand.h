//
//  CGMatchingHand.h
//  CardGame
//
//  Created by Cox, Chip on 5/1/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import "CGHand.h"
#include "CGMatchingDeck.h"
#include "CGMatchingCard.h"

@interface CGMatchingHand : CGHand
- (NSMutableArray *) dealHand: (CGMatchingDeck *) cardDeck;
- (CGMatchingCard *) drawRandomCard: (CGMatchingDeck *) cardDeck;
- (void) removeCard: (CGMatchingCard *) card FromHand: (NSMutableArray *) hand;
@end
