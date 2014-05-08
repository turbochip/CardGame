//
//  CGSetCardView.m
//  CardGame
//
//  Created by Cox, Chip on 5/5/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import "CGSetCardView.h"
@interface CGSetCardView ()
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

- (void) setCardQuantity:(NSNumber *) qty
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
    // Drawing code
    [self.cardContent drawAtPoint:(CGPoint) CGPointMake(0, 0)];
}

- (void) drawCircle
{
    
}

- (void) drawDiamond
{
    // Diamond is a square or rectangle rotated 45 degrees
}

- (void) drawSquiggle
{
    
}

- (void) fillShape
{
    
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
