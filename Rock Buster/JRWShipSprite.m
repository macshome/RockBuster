//
//  JRWShipSprite.m
//  Rock Buster
//
//  Created by Josh Wisenbaker on 12/18/13.
//  Copyright (c) 2013 Me. All rights reserved.
//

#import "JRWShipSprite.h"
#import "JRWMainScene.h"

@implementation JRWShipSprite

+ (instancetype)createShip {
    JRWShipSprite *ship = [JRWShipSprite spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"Spaceship"]];
    return ship;
}

@end
