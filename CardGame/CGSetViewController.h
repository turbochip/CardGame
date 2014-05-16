//
//  CGSetViewController.h
//  CardGame
//
//  Created by Cox, Chip on 5/1/14.
//  Copyright (c) 2014 merck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGSetCard.h"
#import "CGSetDeck.h"
#import "CGSetHand.h"
#import "CGSetView.h"

@interface CGSetViewController : UIViewController
@property (nonatomic,strong) CGSetDeck * fullDeck;
@property (nonatomic,strong) CGSetCard * setCard;
@property (nonatomic,strong) CGSetHand * hand;
@property (strong, nonatomic) NSArray *TableCards;
@property (nonatomic,strong) NSMutableArray * selectedCards;
@property (nonatomic,strong) NSMutableArray * matchedCards;
@property (strong, nonatomic) IBOutlet UILabel *setsFoundLabel;
@property (strong, nonatomic) IBOutlet UILabel *cardsInDeckLabel;
@property (strong, nonatomic) IBOutlet CGSetCardView *MainDeckView;
@property (strong, nonatomic)  CGSetView *Table;

@end
