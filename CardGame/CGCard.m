//
//  CGCard.m
//  CardGame
//
//  Created by Cox, Chip on 5/1/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import "CGCard.h"

@implementation CGCard

- (instancetype) init
{
    self=[super init];
    return self;
}

-(NSString *)contents
{
    if(!_contents) {
        _contents=@"";
    }
    return _contents;
}

@end
