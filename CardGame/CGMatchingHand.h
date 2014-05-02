//
//  CGMatchingHand.h
//  CardGame
//
//  Created by Cox, Chip on 5/1/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import "CGHand.h"
#import "CGMatchingDeck.h"
#import "CGMatchingCard.h"

@interface CGMatchingHand : CGHand
@property (nonatomic,strong) NSMutableArray * matchingHand;
@property (nonatomic) NSInteger cardsInHand;

- (NSUInteger) gethandSize;

- (CGMatchingHand *) dealHand: (CGMatchingDeck *) cardDeck;
- (CGMatchingCard *) drawRandomCard: (CGMatchingDeck *) cardDeck;
- (void) removeCard: (CGMatchingCard *) card FromHand: (NSMutableArray *) hand;
@end
