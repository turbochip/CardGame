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
    for(NSInteger shape=0;shape<3;shape++)
        for(NSInteger fill=0; fill < 3; fill++)
            for(NSInteger i=0;i<3;i++)
                for(UIColor *color in card.ColorDict.allKeys)
                {
                    [self.deckOfCards addObject:[card createCardWithColor:color Shape:shape Fill:fill Quantity:i]];
                    NSLog(@"Adding Card %@",((CGSetCard *)[self.deckOfCards lastObject]).contents );
                }
    NSLog(@"Done Adding Full Deck");
    return self;
}
@end
