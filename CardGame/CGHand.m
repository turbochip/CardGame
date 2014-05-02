//
//  CGHand.m
//  CardGame
//
//  Created by Cox, Chip on 5/1/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import "CGHand.h"

@implementation CGHand
-(NSMutableArray *) dealHandFrom: (id) deckOfCards
{
    return nil;
}
-(NSMutableArray *) handOfCards
{
   if(!_handOfCards)
   {
       _handOfCards=[[NSMutableArray alloc] init];
   }
    self.handSize=_handOfCards.count;
    return _handOfCards;
}
@end
