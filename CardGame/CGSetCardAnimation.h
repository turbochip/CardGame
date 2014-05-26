//
//  CGSetCardAnimation.h
//  CardGame
//
//  Created by Chip Cox on 5/25/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGSetCardAnimation : UIView
@property (nonatomic) BOOL animateDealCard;
@property (nonatomic) CGRect dealSrcLoc;
@property (nonatomic) CGRect dealDstLoc;
@property (nonatomic) BOOL animateDiscard;
@property (nonatomic) CGRect discardSrcLoc;
@property (nonatomic) CGRect discardDstLoc;

@end
