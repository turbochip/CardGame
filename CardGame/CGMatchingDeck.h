//
//  CGMatchingDeck.h
//  CardGame
//
//  Created by Cox, Chip on 5/1/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import "CGDeck.h"

@interface CGMatchingDeck : CGDeck
@property (nonatomic,strong) NSMutableArray * deckOfPlayingCards;

- (CGMatchingDeck *) createMatchingDeck;

@end
