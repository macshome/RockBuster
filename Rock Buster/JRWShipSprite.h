//
//  JRWShipSprite.h
//  Rock Buster
//
//  Created by Josh Wisenbaker on 12/18/13.
//  Copyright (c) 2013 Me. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface JRWShipSprite : SKSpriteNode

//  Class method to make a new ship
+ (instancetype)createShip;

//  Methods used to control the ship.
- (void)activateMainEngine;
- (void)deactivateMainEngine;
- (void)rotateShipLeft;
- (void)rotateShipRight;
- (void)attemptMissileLaunch:(NSTimeInterval)currentTime;

//  Damage the ship
- (void) applyDamage:(NSInteger)ammount;

//  Health
@property NSInteger health;



@end
