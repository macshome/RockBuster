//
//  JRWGameScene.h
//  Rock Buster
//
//  Created by Josh Wisenbaker on 12/20/13.
//  Copyright (c) 2013 Me. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

//  Debug method to show the physicsbodys as overlays. Set to 1 to enable.
#define SHOW_PHYSICS_OVERLAY 0

// These constants are used to map keyboard events into player events.
typedef enum {
    kPlayerForward = 0,
    kPlayerLeft = 1,
    kPlayerRight = 2,
    kPlayerBack = 3,
    kPlayerAction = 4,
    kNumPlayerActions
} PlayerActions;

// These constans are used to define the physics interactions between physics bodies in the scene.
//typedef NS_OPTIONS(NSUInteger, RockBusterCollionsMask) {
//    RBCmissileCategory =  0x1 << 0,
//    RBCasteroidCategory =  0x1 << 1,
//    RBCshipCategory =  0x1 << 2
//    
//};



static  NSString const *bigRock = @"asteroid_0";
static const NSString *largeRock = @"asteroid_1";
static const NSString *mediumRock = @"asteroid_2";
static const NSString *smallRock = @"asteroid_3";
static const NSString *tinyRock = @"asteroid_4";

static const uint32_t RBCmissileCategory  =  0x1 << 0;
static const uint32_t RBCasteroidCategory  =  0x1 << 1;
static const uint32_t RBCshipCategory  =  0x1 << 2;



@interface JRWGameScene : SKScene <SKPhysicsContactDelegate>
{
    BOOL     actions[kNumPlayerActions];
}

- (SKNode*) addMissile;

@end
