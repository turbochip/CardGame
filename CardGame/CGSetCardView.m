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

- (void) setCardShape:(NSInteger) shape
{
    _cardShape=shape;
    [self setNeedsDisplay];
}

- (void) setCardColor:(UIColor *) color
{
    _cardColor=color;
    [self setNeedsDisplay];
}

- (void) setCardFill:(NSInteger) fill
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

- (void) setCardBackImage:(NSString *)cardBackImage
{
    _cardBackImage=cardBackImage;
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if(!self.cardMatched)
    {
        // Drawing code
        switch((int)self.cardShape) {
            case 0:
                [self drawCircle:rect];
                break;
            case 1:
                [self drawDiamond:rect];
                break;
            case 2:
                [self drawSquiggle:rect];
                break;
        }
    } else {
        NSLog(@"Card is matched");
        UIImage *backImage=[UIImage imageNamed:self.cardBackImage];

        UIImageView *backView=[[UIImageView alloc] initWithFrame: self.bounds];
        [backView setImage:backImage];
        [self addSubview:backView];
    }
}

#define Card_Border_Percentage = 0.1



#define CARDVERTICALSPACING 10

- (void) drawDiamond:(CGRect)rect
{
    UIBezierPath *apath, *path;
    CGFloat ccx=self.frame.size.width/2;    //card horizontal size x
    CGFloat ccy=self.frame.size.height/2;   //card vertical size y
    CGFloat sw=self.frame.size.width/6;     //shape width
    CGFloat sh=self.frame.size.height/6;    //shape height
    CGFloat sox=ccx-(sw/2);                 //shape origin horizontal x
    CGFloat soy=ccy-(sh/2);  //shape origin vertical x
    path=[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:12];
    [self setClipsToBounds:YES];
    if(self.cardChosen)
        [[UIColor grayColor] setFill];
    else
        [[UIColor whiteColor] setFill];
    [path fill];
    [path stroke];
    [self.cardColor setStroke];
    switch(self.cardFill) {
        case 0:
            [self.cardColor setFill];
            break;
        case 1:
            [[UIColor whiteColor] setFill];
            break;
        case 2:
        {
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGPatternRef pattern = [self initPattern:context forRect:rect];
            CGFloat alpha = 1.0;
            CGContextSetFillPattern(context, pattern, &alpha);
            CGPatternRelease(pattern);
            break;
        }
    }
    
    if(self.cardQuantity>2)  soy=soy+(sh+CARDVERTICALSPACING);
    for(int i=0;i<self.cardQuantity;i++)
    {
        apath=[[UIBezierPath alloc] init];
        [apath moveToPoint:CGPointMake(sox+sw/2, soy)];
        [apath addLineToPoint:CGPointMake(sox+sw,soy+sh/2)];
        [apath addLineToPoint:CGPointMake(sox+sw/2, soy+sh)];
        [apath addLineToPoint:CGPointMake(sox, soy+sh/2)];
        [apath closePath];
        soy=soy-sh-CARDVERTICALSPACING;
        
        [apath setLineWidth:3.0 ];
        [apath stroke];
        [apath fill];
    }
}

- (void) drawCircle:(CGRect)rect
{
    UIBezierPath *apath,*path;
    CGFloat ccx=self.frame.size.width/2;    //card horizontal size x
    CGFloat ccy=self.frame.size.height/2;   //card vertical size y
    CGFloat sw=self.frame.size.width/6;     //shape width
    CGFloat sh=self.frame.size.height/6;    //shape height
    CGFloat sox=ccx-(sw/2);                 //shape origin horizontal x
    CGFloat soy=ccy-(sh/2);  //shape origin vertical x
    path=[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:12];
    [self setClipsToBounds:YES];
    if(self.cardChosen)
        [[UIColor grayColor] setFill];
    else
        [[UIColor whiteColor] setFill];
    [path fill];
    [path stroke];
    [self.cardColor setStroke];
    switch(self.cardFill) {
        case 0:
            [self.cardColor setFill];
            break;
        case 1:
            [[UIColor whiteColor] setFill];
            break;
        case 2:
        {
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGPatternRef pattern = [self initPattern:context forRect:rect];
            CGFloat alpha = 1.0;
            CGContextSetFillPattern(context, pattern, &alpha);
            CGPatternRelease(pattern);
            break;
        }
    }
    for(int i=0;i<self.cardQuantity;i++)
    {
        if(i<2)
            apath=[UIBezierPath bezierPathWithOvalInRect:CGRectMake(sox,soy-((sh+CARDVERTICALSPACING)*i),sw,sh)];
        else
            apath=[UIBezierPath bezierPathWithOvalInRect:CGRectMake(sox,soy+((sh+CARDVERTICALSPACING)*(i-1)),sw,sh)];
        [apath setLineWidth:3.0 ];
        [apath stroke];
        [apath fill];
    }
}

- (void) drawSquiggle:(CGRect)rect
{
    UIBezierPath *apath, *path;
    CGFloat ccx=self.frame.size.width/2;    //card horizontal size x
    CGFloat ccy=self.frame.size.height/2;   //card vertical size y
    CGFloat sw=self.frame.size.width/3;     //shape width
    CGFloat sh=self.frame.size.height/6;    //shape height
    CGFloat sox=ccx-(sw/2);                 //shape origin horizontal x
    CGFloat soy=ccy-(sh/2);  //shape origin vertical x
    path=[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:12];
    [self setClipsToBounds:YES];
    if(self.cardChosen)
        [[UIColor grayColor] setFill];
    else
        [[UIColor whiteColor] setFill];
    [path fill];
    [path stroke];
    [self.cardColor setStroke];
    switch(self.cardFill) {
        case 0:
            [self.cardColor setFill];
            break;
        case 1:
            [[UIColor whiteColor] setFill];
            break;
        case 2:
        {
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGPatternRef pattern = [self initPattern:context forRect:rect];
            CGFloat alpha = 1.0;
            CGContextSetFillPattern(context, pattern, &alpha);
            CGPatternRelease(pattern);
            break;
        }
    }
    if(self.cardQuantity>2)  soy=soy+(sh+CARDVERTICALSPACING);
    for(int i=0;i<self.cardQuantity;i++)
    {
        apath = [[UIBezierPath alloc] init];
        
        [apath moveToPoint:CGPointMake(sox, soy)];
        [apath addCurveToPoint:CGPointMake(sox+sw, soy+sh-20)
                 controlPoint1:CGPointMake(sox+(sw/2), soy)
                 controlPoint2:CGPointMake(sox+(sw/2), soy+sh-15)];
        
        [apath addArcWithCenter:CGPointMake(sox+sw,soy+sh-10)
                         radius:10
                     startAngle:3*(2*M_PI/4)
                       endAngle:1*(2*M_PI/4)
                      clockwise:YES];
        
        [apath addCurveToPoint:CGPointMake(sox, soy+20)
                 controlPoint1:CGPointMake(sox+(sw/2), soy+sh+20-15)
                 controlPoint2:CGPointMake(sox+(sw/2), soy+20)];
        
        [apath addArcWithCenter:CGPointMake(sox,soy+10)
                         radius:10
                     startAngle:1*(2*M_PI/4)
                       endAngle:3*(2*M_PI/4)
                      clockwise:YES];
        soy=soy-sh-CARDVERTICALSPACING;
        
        [apath setLineWidth:3.0 ];
        [apath stroke];
        [apath fill];
    }
}

void MyDrawColoredPattern (void *info, CGContextRef context)
{
    UIColor *dColor = (__bridge UIColor *)(info);
    CGContextSetStrokeColorWithColor(context, dColor.CGColor);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 5, 5);
    CGContextStrokePath(context);
}

- (CGPatternRef) initPattern:(CGContextRef)context forRect:(CGRect) rect
{
    static const CGPatternCallbacks callbacks = { 0, &MyDrawColoredPattern, NULL };
    
    CGContextSaveGState(context);
    CGColorSpaceRef patternSpace = CGColorSpaceCreatePattern(NULL); //I think this initializes a patternspace where we will store our pattern.
    CGContextSetFillColorSpace(context, patternSpace);
    CGColorSpaceRelease(patternSpace);
    CGPatternRef pattern = CGPatternCreate((__bridge void *)(self.cardColor),
                                           rect,
                                           CGAffineTransformIdentity,
                                           5,
                                           5,
                                           kCGPatternTilingConstantSpacing,
                                           true,
                                           &callbacks);
    return pattern;
    
}

- (void) removeSubview: (CGSetCardView *) sv
{
    [sv removeFromSuperview];
}
@end
