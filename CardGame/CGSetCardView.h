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
@property (nonatomic,strong) NSString *cardBackImage;
@property (nonatomic,strong) UIColor * cardColor;
@property (nonatomic) NSInteger cardShape;
@property (nonatomic) NSInteger cardFill;
@property (nonatomic) NSInteger cardQuantity;
@property (nonatomic) BOOL cardChosen;
@property (nonatomic) BOOL cardMatched;

- (void) removeSubview: (CGSetCardView *) sv;

@end
