//
//  JRWHUDSprite.h
//  Rock Buster
//
//  Created by Josh Wisenbaker on 1/24/14.
//  Copyright (c) 2014 Me. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface JRWHUDSprite : SKSpriteNode

//  Properties
@property NSInteger level;
@property NSInteger score;
@property BOOL hyperspaceOK;

//  Factory method
+ (instancetype)createHUDforFrame:(CGRect)rect;

//  Hyperspace Methods
- (void)updateHyperspaceTimer;
- (void)resetHyperspaceTimer;

//  Health bar methods
- (void)shrinkHealthBar:(CGFloat)ammount;


@end
