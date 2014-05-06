//
//  CGHand.h
//  CardGame
//
//  Created by Cox, Chip on 5/1/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "CGDeck.h"

@interface CGHand : NSObject
@property (nonatomic) NSInteger handSize;
@property (strong,nonatomic) NSMutableArray *handOfCards;

-(NSMutableArray *) handOfCards;
@end
