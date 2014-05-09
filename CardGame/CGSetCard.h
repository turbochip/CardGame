//
//  CGSetCard.h
//  CardGame
//
//  Created by Cox, Chip on 5/1/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import "CGCard.h"
#import "CGSetCardView.h"

@interface CGSetCard : CGCard
@property (nonatomic) NSNumber *cardShape;
@property (nonatomic) UIColor *cardColor;
@property (nonatomic) NSNumber *cardFill;
@property (nonatomic) NSInteger cardQuantity;
@property (nonatomic,strong) NSString *contents;
@property (nonatomic) BOOL isMatched;
@property (nonatomic,weak) CGSetCardView *cardViewButton;
@property (nonatomic,strong) UITapGestureRecognizer* tapRecognizer;
@property (nonatomic,strong) NSDictionary *FillDict;
@property (nonatomic,strong) NSDictionary *ColorDict;
@property (nonatomic,strong) NSDictionary *ShapeDict;

- (CGCard *) createCardWithColor: (UIColor *) color Shape: (NSNumber *) shape Fill: (NSNumber*) fill Quantity: (NSInteger) quantity;


@end