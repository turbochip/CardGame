//
//  CGSetCardView.h
//  CardGame
//
//  Created by Cox, Chip on 5/5/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGSetCardView : UIView
@property (nonatomic,strong) NSMutableAttributedString* cardContent;
@property (nonatomic,strong) UIColor * cardColor;
@property (nonatomic,strong) NSNumber * cardShape;
@property (nonatomic,strong) NSNumber * cardFill;
@property (nonatomic,strong) NSNumber * cardQuantity;
@property (nonatomic) BOOL cardChosen;
@property (nonatomic) BOOL cardMatched;

@end
