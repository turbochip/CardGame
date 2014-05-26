//
//  CGMainSetDeckView.m
//  CardGame
//
//  Created by Cox, Chip on 5/11/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import "CGMainSetDeckView.h"
#import "CGCardView.h"

@implementation CGMainSetDeckView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSString *backImage;
    // Drawing code
    NSInteger randback=(arc4random() % 3)+1;
    switch (randback) {
        case 1:
            backImage=@"splogo.png";
            break;
        case 2:
            backImage=@"MerckLogo.png";
            break;
        case 3:
            backImage=@"bayer-logo.png";
            break;
    }
    UIImage *Image=[UIImage imageNamed:backImage];
    
    UIImageView *backView=[[UIImageView alloc] initWithFrame: self.bounds];
    [backView setImage:Image];
    for(UIImageView *siv in self.subviews){
        [siv removeFromSuperview];
    }
    [self addSubview:backView];
//    [self dealCardAnimation:self];
}

@end
