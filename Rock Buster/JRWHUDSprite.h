//
//  JRWHUDSprite.h
//  Rock Buster
//
//  Created by Josh Wisenbaker on 1/24/14.
//  Copyright (c) 2014-2024 Me. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface JRWHUDSprite : SKSpriteNode

//  Properties
@property (nonatomic) NSInteger level;
@property (nonatomic) NSInteger score;
@property (nonatomic) BOOL hyperspaceOK;

//  Factory method
+ (instancetype)createHUDforFrame:(CGRect)rect;

//  Hyperspace Methods
- (void)updateHyperspaceTimer;
- (void)resetHyperspaceTimer;

//  Health bar methods
- (void)shrinkHealthBar:(CGFloat)ammount;
- (void)resetHealthBar;


@end
