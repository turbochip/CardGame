//
//  CGSetHand.m
//  CardGame
//
//  Created by Cox, Chip on 5/1/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import "CGSetHand.h"
@interface CGSetHand ()

@end

@implementation CGSetHand
#define HANDSIZE 15

- (CGSetHand *) dealHand: (CGSetDeck *) cardDeck
{
    for(int i=0;i<HANDSIZE;i++)
        [self.handOfCards addObject:[self drawRandomCard:cardDeck]];
    return self;
}

- (CGSetCard *) drawRandomCard: (CGSetDeck *) cardDeck
{
    CGSetCard *randomCard = nil;
    
    if (cardDeck.deckSize){
        unsigned index = arc4random() % cardDeck.deckOfCards.count;
        randomCard = cardDeck.deckOfCards[index];
        [cardDeck.deckOfCards removeObjectAtIndex:index];
//        NSLog(@"Random Card is %@",randomCard.contents);
    }
    return randomCard;
}

- (BOOL) match: (CGSetHand *) testCards
{
    BOOL qtyMatch=NO;
    BOOL colorMatch=NO;
    BOOL shapeMatch=NO;
    BOOL fillMatch=NO;
    
    for(CGSetCard *testCard in testCards.handOfCards)
    {
        NSLog(@"selected Card = %@ %d %d %ld",testCard.cardColor.description,testCard.cardShape.intValue,testCard.cardFill.intValue,testCard.cardQuantity);
    }
    BOOL Matched=NO;
    NSMutableArray * selectedCards=testCards.handOfCards;
    // Check to see if everything for each property match
    if(([selectedCards[0] cardQuantity] == [selectedCards[1] cardQuantity]) &&
       ([selectedCards[0] cardQuantity] == [selectedCards[2] cardQuantity])) qtyMatch=YES;
    if(([selectedCards[0] cardFill] == [selectedCards[1] cardFill]) &&
       ([selectedCards[0] cardFill] == [selectedCards[2] cardFill])) fillMatch=YES;
    if(([selectedCards[0] cardShape] == [selectedCards[1] cardShape]) &&
       ([selectedCards[0] cardShape] == [selectedCards[2] cardShape])) shapeMatch=YES;
    if(([[selectedCards[0] cardColor] isEqual: [selectedCards[1] cardColor]]) &&
       ([[selectedCards[0] cardColor] isEqual: [selectedCards[2] cardColor]])) colorMatch=YES;

    // check to see if all of the property is different (size(1) != size(2) != size(3))
    if(([selectedCards[0] cardQuantity]!=[selectedCards[1] cardQuantity]) &&
       ([selectedCards[0] cardQuantity]!=[selectedCards[2] cardQuantity]) &&
       ([selectedCards[1] cardQuantity]!=[selectedCards[2] cardQuantity])) qtyMatch=YES;
    if(([selectedCards[0] cardFill]!=[selectedCards[1] cardFill]) &&
       ([selectedCards[0] cardFill]!=[selectedCards[2] cardFill]) &&
       ([selectedCards[1] cardFill]!=[selectedCards[2] cardFill])) fillMatch=YES;
    if((![[selectedCards[0] cardShape] isEqual: [selectedCards[1] cardShape]]) &&
       (![[selectedCards[0] cardShape] isEqual: [selectedCards[2] cardShape]]) &&
       (![[selectedCards[1] cardShape] isEqual: [selectedCards[2] cardShape]])) shapeMatch=YES;
    if((![[selectedCards[0] cardColor] isEqual: [selectedCards[1] cardColor]]) &&
       (![[selectedCards[0] cardColor] isEqual: [selectedCards[2] cardColor]]) &&
       (![[selectedCards[1] cardColor] isEqual: [selectedCards[2] cardColor]])) colorMatch=YES;
    
    if(qtyMatch && fillMatch && shapeMatch && colorMatch) Matched=YES;
    
    return Matched;
}

@end
