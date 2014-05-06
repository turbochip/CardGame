//
//  CGSetDeck.m
//  CardGame
//
//  Created by Cox, Chip on 5/1/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import "CGSetDeck.h"
#import "CGSetCard.h"
@interface CGSetDeck ()

@property (nonatomic, weak) CGSetCard * setcard;

@end

@implementation CGSetDeck

- (CGSetDeck *)createSetDeckof: (CGSetCard *) card
{
    self.deckOfCards = [[NSMutableArray alloc] init];
    for(NSNumber *shape in card.ShapeDict.allKeys)
        for (NSNumber *fill in card.FillDict.allKeys)
            for(int i=0;i<3;i++)
                for(UIColor *color in card.ColorDict.allKeys)
                {
                    [self.deckOfCards addObject:[card createCardWithColor:color Shape:shape Fill:fill Quantity:i]];
                }
    NSLog(@"Done Adding Full Deck");
    return self;
}
@end
