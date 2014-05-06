//
//  CGCardView.h
//  CardGame
//
//  Created by Cox, Chip on 5/4/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGCardView : UIView
@property (nonatomic) NSUInteger rank;
@property (nonatomic,weak) NSString * suit;
@property (nonatomic) BOOL faceUp;
@property (nonatomic) CGFloat faceCardScaleFactor;
@property (nonatomic) CGFloat cardScaleFactor;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;



@end
