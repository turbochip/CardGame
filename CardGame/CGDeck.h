//
//  CGDeck.h
//  CardGame
//
//  Created by Cox, Chip on 5/1/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "CGCard.h"

@interface CGDeck : NSObject
@property (strong,nonatomic) NSMutableArray *deckOfCards;    //of cards
@property (nonatomic) NSInteger deckSize;

@end
