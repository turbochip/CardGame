//
//  CGSetPlay.h
//  CardGame
//
//  Created by Cox, Chip on 5/1/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGSetPlay : NSObject
- (BOOL) matchCards: (NSMutableArray *) candidateCards;
- (NSInteger) calcScore;
@end
