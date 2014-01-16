//
//  JRWRockSprite.h
//  Rock Buster
//
//  Created by Josh Wisenbaker on 12/18/13.
//  Copyright (c) 2013 Me. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

//  Typedef for our different rock types
typedef NS_ENUM(NSInteger, RBrockType) {
    RBbigRock,
    RBlargeRock,
    RBmediumRock,
    RBsmallRock,
    RBtinyRock
};

@interface JRWRockSprite : SKSpriteNode

+ (instancetype)createRandomRock;
+ (instancetype)createRockWithSize:(RBrockType)rockType;

@end
