//
//  CGSetCardView.m
//  CardGame
//
//  Created by Cox, Chip on 5/5/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import "CGSetCardView.h"
@interface CGSetCardView ()
@property (nonatomic) NSMutableAttributedString *stringToDraw;
@end

@implementation CGSetCardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (NSMutableAttributedString *) stringToDraw
{
    if(!_stringToDraw) {
        _stringToDraw = [[NSMutableAttributedString alloc] initWithString:@""];
    }
    return _stringToDraw;
}

- (void) setCardContent:(NSMutableAttributedString *) instr
{
    _cardContent=instr.mutableCopy;
    [self setNeedsDisplay];
}

- (void) setCardShape:(NSNumber *) shape
{
    _cardShape=shape;
    [self setNeedsDisplay];
}

- (void) setCardColor:(UIColor *) color
{
    _cardColor=color;
    [self setNeedsDisplay];
}

- (void) setCardFill:(NSNumber *) fill
{
    _cardFill=fill;
    [self setNeedsDisplay];
}

- (void) setCardQuantity:(NSInteger) qty
{
    _cardQuantity=qty;
    [self setNeedsDisplay];
}

- (void) setCardChosen:(BOOL) isChosen
{
    _cardChosen=isChosen;
    [self setNeedsDisplay];
}

- (void) setCardMatched:(BOOL) isMatched
{
    _cardMatched=isMatched;
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if(!self.cardMatched)
    {
        NSAttributedString *shapeToDraw;
        // Drawing code
        switch(self.cardShape.intValue) {
            case 1:
                shapeToDraw=[self drawCircle];
                break;
            case 2:
                shapeToDraw=[self drawDiamond];
                break;
            case 3:
                shapeToDraw=[self drawSquiggle];
                break;
        }
        NSLog(@"self.stringToDraw class is %@",[self.stringToDraw.class description]);
        [(NSAttributedString*)self.stringToDraw drawAtPoint:CGPointMake(0, 0)];
    } else {
        UIImage *backImage=[UIImage imageNamed:self.cardBackImage];
//        [backImage drawInRect:self.frame];

        UIImageView *backView=[[UIImageView alloc] initWithFrame: self.bounds];
        [backView setImage:backImage];
//        backView.autoresizesSubviews=YES;
        [self addSubview:backView];
        
    }
}

- (NSMutableAttributedString *) drawCircle
{
    NSString *shape=@"○";
    NSString *tempstr=@"";

    for(int i=0;i<self.cardQuantity;i++) {
        tempstr = [tempstr stringByAppendingString:shape];
    }
    self.stringToDraw=[[NSMutableAttributedString alloc] initWithString:tempstr];
    NSLog(@"Color=%@",self.cardColor.description);
    [self.stringToDraw addAttribute:NSForegroundColorAttributeName value:(UIColor*) self.cardColor range:NSMakeRange(0,[self.stringToDraw length])];
    [self.stringToDraw addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Times New Roman" size:18] range:NSMakeRange(0, [self.stringToDraw length])];
    [self addFillToShape];
    return self.stringToDraw;
}

- (NSMutableAttributedString *) drawDiamond
{
    // Diamond is a square or rectangle rotated 45 degrees
    NSString *shape=@"☐";
    NSString *tempstr=@"";
    
    for(int i=0;i<self.cardQuantity;i++) {
        tempstr = [tempstr stringByAppendingString:shape];
    }
    self.stringToDraw=[[NSMutableAttributedString alloc] initWithString:tempstr];
    NSLog(@"Color=%@",self.cardColor.description);
    [self.stringToDraw addAttribute:NSForegroundColorAttributeName value:(UIColor*) self.cardColor range:NSMakeRange(0,[self.stringToDraw length])];
    [self.stringToDraw addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Times New Roman" size:18] range:NSMakeRange(0, [self.stringToDraw length])];
    [self addFillToShape];
    return self.stringToDraw;
}

- (NSMutableAttributedString *) drawSquiggle
{
    
    NSString *shape=@"△";
    NSString *tempstr=@"";
    
    for(int i=0;i<self.cardQuantity;i++) {
        tempstr = [tempstr stringByAppendingString:shape];
    }
    self.stringToDraw=[[NSMutableAttributedString alloc] initWithString:tempstr];
    NSLog(@"Color=%@",self.cardColor.description);
    [self.stringToDraw addAttribute:NSForegroundColorAttributeName value:(UIColor*) self.cardColor range:NSMakeRange(0,[self.stringToDraw length])];
    [self.stringToDraw addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Times New Roman" size:18] range:NSMakeRange(0, [self.stringToDraw length])];
    [self addFillToShape];
    return self.stringToDraw;
}

- (void) addFillToShape
{
    switch (self.cardFill.intValue){
        case 1:
            [self.stringToDraw addAttribute:NSBackgroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [self.stringToDraw length])];
            break;
        case 2:
            [self.stringToDraw addAttribute:NSBackgroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, [self.stringToDraw length])];
            break;
        case 3:
            [self.stringToDraw addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:NSMakeRange(0, [self.stringToDraw length])];
            break;
    }
}

#define Card_Border_Percentage = 0.1

- (void) calculateSizeMultiple
{
    //based on the qty of items, determine the size of each item
    // space between cards = (card width * card_border_perentage)
    // total buffer space = (2+(qty-1))* spaceBetweenCards
    // symbolsize=(cardwidth-total buffer space)/qty
    // symbol placement
    // for 1 the shape goes in the middle of the whole card
    // for 2 divide the card in half and each shape goes in the middle of their respective halfs
    // for 3 divide the card into 3rds and each shape goes in the middle of their respective 3rds.
}
@end
