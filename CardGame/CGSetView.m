//
//  CGSetView.m
//  CardGame
//
//  Created by Cox, Chip on 5/14/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import "CGSetView.h"
#import "CGSetCardView.h"

@interface CGSetView()
@property (nonatomic,strong) CGSetCardView* card;
@property (nonatomic,strong) NSMutableArray *table;
@property (nonatomic) CGFloat o_x;
@property (nonatomic) CGFloat o_y;
@end


@implementation CGSetView

#pragma mark Defines
#define FIRSTCARDX 10.0
#define FIRSTCARDY 10.0
#define CARDWIDTH 45.0
#define CARDHEIGHT 75.0
#define CARDSPACINGHORIZONTAL 5.0
#define CARDSPACINGVERTICAL 10.0

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    [self setup];

    return self;
}

#pragma mark    Setters & Getters

- (NSMutableArray *) table
{
    if(!_table) _table=[[NSMutableArray alloc] init];
    return _table;
}

#pragma mark General Functions

- (void) setup
{
    self.o_x=FIRSTCARDX;
    self.o_y=FIRSTCARDY;
    
    [self setNeedsDisplay];
}

#pragma mark Drawing Code
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
//    [self setup];

    // Drawing code
    NSLog(@"drawRect self.origin=%f,%f self.size=%f,%f",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
}

- (CGSetCardView *) addCard
{
    if(!self.table.count){
        self.o_x=FIRSTCARDX;
        self.o_y=FIRSTCARDY;
    }
    self.card=[[CGSetCardView alloc] initWithFrame:CGRectMake(self.o_x, self.o_y, CARDWIDTH, CARDHEIGHT)];
    [self.card setBackgroundColor:[UIColor whiteColor]];
    [self.table addObject:self.card];
    
    [self addSubview:self.card];
    
    self.o_x=self.o_x+CARDWIDTH+CARDSPACINGHORIZONTAL;
    NSLog(@"self.frame.origin=%f,%f  size=%f,%f",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
    NSLog(@"self.bounds.origin=%f,%f  size=%f,%f",self.bounds.origin.x,self.bounds.origin.y,self.bounds.size.width,self.bounds.size.height);
    NSLog(@"test point=%f,%f",self.o_x+CARDWIDTH+CARDSPACINGHORIZONTAL,self.o_y);
    if(!CGRectContainsPoint(self.bounds, CGPointMake(self.o_x+CARDWIDTH+CARDSPACINGHORIZONTAL, self.o_y)))
    {
        self.o_x=FIRSTCARDX;
        self.o_y=self.o_y+CARDHEIGHT+CARDSPACINGVERTICAL;
    }
    
    return self.card;
}

- (void) willRemoveSubview:(UIView *)subview
{
    self.o_x=self.o_x-CARDWIDTH-CARDSPACINGHORIZONTAL;
    if(self.o_x<=0)
    {
        self.o_y=self.o_y-CARDHEIGHT-CARDSPACINGVERTICAL;
        self.o_x=((CARDWIDTH+CARDSPACINGHORIZONTAL)*4)+CARDSPACINGHORIZONTAL;
    }
}

@end
