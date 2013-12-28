//
//  JRWHUDSprite.h
//  Rock Buster
//
//  Created by Josh Wisenbaker on 12/27/13.
//  Copyright (c) 2013 Me. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface JRWHUDSprite : SKNode

@property NSNumber *level;
@property NSNumber *score;
@property BOOL hyperspaceOK;

- (instancetype)newHUDwithFrame:(CGRect)frameSize;
- (void)resetHyperspaceTimer;


@end
