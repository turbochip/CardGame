//
//  CGSetCard.m
//  CardGame
//
//  Created by Cox, Chip on 5/1/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import "CGSetCard.h"

@interface CGSetCard ()
typedef NS_ENUM(NSInteger, FillType) {
    EMPTY_FILL,
    SHADED_FILL,
    SOLID_FILL
};

typedef NS_ENUM(NSInteger, Color) {
    RED,
    GREEN,
    PURPLE
};

typedef NS_ENUM(NSInteger, Shape) {
    CIRCLE,
    DIAMOND,
    SQUIGGLE
};

@end

@implementation CGSetCard

- (NSDictionary *) FillDict
{
    if ( ! _FillDict) {
        _FillDict = @{@0:@"Solid", @1:@"Empty",
                      @2:@"Shaded"};
    }
    return _FillDict;
}

- (NSDictionary *) ColorDict
{
    if(! _ColorDict) {
        _ColorDict = @{[UIColor redColor]:@"Red", [UIColor greenColor]:@"Green", [UIColor purpleColor]:@"Purple"};
    }
    return _ColorDict;
}

- (NSDictionary *) ShapeDict
{
    if ( ! _ShapeDict) {
        _ShapeDict = @{@0:@"Circle", @1:@"Diamond",
                      @2:@"Squiggle"};
    }
    return _ShapeDict;
}


- (NSInteger) cardQuantity
{
    if(!_cardQuantity) _cardQuantity=(NSInteger)1;
    if((_cardQuantity<0) || (_cardQuantity >3)) _cardQuantity=1;
    return _cardQuantity;
}


- (CGSetCard *) createCardWithColor: (UIColor *) color
                              Shape: (NSInteger) shape
                               Fill: (NSInteger) fill
                           Quantity: (NSInteger) quantity;
{
    CGSetCard * newCard = [[CGSetCard alloc] init];
    
    newCard.cardColor=color;
    newCard.cardShape=shape;
    newCard.cardFill=fill;
    newCard.cardQuantity=quantity+1;
    newCard.contents=[[NSString alloc] initWithFormat:@"%ld %@ %@ %@",
                      (long)newCard.cardQuantity,
                      [self.ColorDict objectForKey:newCard.cardColor],
                      [self.FillDict objectForKey:[NSNumber numberWithLong:newCard.cardFill]],
                      [self.ShapeDict objectForKey:[NSNumber numberWithLong:newCard.cardShape]]];

    newCard.cardViewButton=nil;
    NSLog(@"Creating %@",newCard.contents);
    return newCard;
}
@end
