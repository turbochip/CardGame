//
//  CGSetCard.m
//  CardGame
//
//  Created by Cox, Chip on 5/1/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import "CGSetCard.h"

@interface CGSetCard ()
typedef NS_ENUM(NSUInteger, FillType) {
    EMPTY_FILL,
    SHADED_FILL,
    SOLID_FILL
};

typedef NS_ENUM(NSUInteger, Color) {
    RED,
    GREEN,
    PURPLE
};

typedef NS_ENUM(NSUInteger, Shape) {
    CIRCLE,
    DIAMOND,
    SQUIGGLE
};

@end

@implementation CGSetCard

- (NSDictionary *) FillDict
{
    if ( ! _FillDict) {
        _FillDict = @{@1:@"Empty", @2:@"Shaded",
                      @3:@"Solid"};
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
        _ShapeDict = @{@1:@"Circle", @2:@"Diamond",
                      @3:@"Squiggle"};
    }
    return _ShapeDict;
}


- (NSInteger) cardQuantity
{
    if(!_cardQuantity) _cardQuantity=(NSInteger)1;
    if((_cardQuantity<0) || (_cardQuantity>3)) _cardQuantity=1;
    return _cardQuantity;
}


- (CGSetCard *) createCardWithColor: (UIColor *) color Shape: (NSNumber *) shape
                            Fill: (NSNumber *) fill Quantity: (NSInteger) quantity;
{
    CGSetCard * newCard = [[CGSetCard alloc] init];
    
    newCard.cardColor=color;
    newCard.cardShape=shape;
    newCard.cardFill=fill;
    newCard.cardQuantity=quantity+1;
    newCard.contents=[[NSString alloc] initWithFormat:@"%ld %@ %@ %@",
                      newCard.cardQuantity,
                      [self.ColorDict objectForKey:newCard.cardColor],
                      [self.FillDict objectForKey:newCard.cardFill],
                      [self.ShapeDict objectForKey:newCard.cardShape]];
    newCard.cardViewButton=nil;
    NSLog(@"Creating %@",newCard.contents);
    return newCard;
}
@end
