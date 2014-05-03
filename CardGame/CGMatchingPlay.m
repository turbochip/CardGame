//
//  CGMatchingPlay.m
//  CardGame
//
//  Created by Cox, Chip on 5/1/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import "CGMatchingPlay.h"

@implementation CGMatchingPlay
- (BOOL) matchCards: (NSMutableArray *) candidateCards
{
    BOOL matched = NO;
    
    if([[candidateCards objectAtIndex:0]cardRank] ==[[candidateCards objectAtIndex:1]cardRank]) {
        NSLog(@"Cards Rank Matches +4 points");
        matched=YES;
    }
    else {
        if([[candidateCards objectAtIndex:0]cardSuit]==[[candidateCards objectAtIndex:1]cardSuit]) {
            NSLog(@"Cards Suit Matches +1 Point");
            matched=YES;
        }
    }
    return matched;
}
- (NSInteger) calculateScore
{
    return 0;
}

@end
