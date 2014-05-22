//
//  CGSetView.h
//  CardGame
//
//  Created by Cox, Chip on 5/14/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGSetCardView.h"

@interface CGSetView : UIView
@property (nonatomic,strong) NSMutableArray *table;


- (CGSetCardView *) addCard;
@end
