//
//  CGSetDeck.h
//  CardGame
//
//  Created by Cox, Chip on 5/1/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import "CGDeck.h"
#import "CGSetCard.h"
@interface CGSetDeck : CGDeck

- (CGSetDeck *)createSetDeckof: (CGSetCard *) card;
@end
