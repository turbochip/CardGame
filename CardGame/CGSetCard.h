//
//  CGSetCard.h
//  CardGame
//
//  Created by Cox, Chip on 5/1/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import "CGCard.h"

@interface CGSetCard : CGCard
@property (nonatomic,strong) NSString *cardShape;
@property (nonatomic,strong) UIColor *cardColor;
@property (nonatomic) NSInteger cardFill;
@property (nonatomic) NSInteger cardQuantity;
@end
