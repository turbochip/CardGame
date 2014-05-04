//
//  CGCard.h
//  CardGame
//
//  Created by Cox, Chip on 5/1/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGCard : NSObject

@property (nonatomic) BOOL cardChosen;
@property (strong,nonatomic) NSString *cardBackImage;
@property (nonatomic) BOOL faceup;
@property (nonatomic,strong) NSString *contents;

@end
