//
//  JRWGameScene.h
//  Rock Buster
//
//  Created by Josh Wisenbaker on 12/20/13.
//  Copyright (c) 2013 Me. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

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
static const uint32_t missileCategory  =  0x1 << 0;
static const uint32_t shipCategory     =  0x1 << 1;
static const uint32_t asteroidCategory =  0x1 << 2;
static const uint32_t planetCategory   =  0x1 << 3;
static const uint32_t edgeCategory     =  0x1 << 4;

@interface JRWGameScene : SKScene <SKPhysicsContactDelegate>
{
    BOOL     actions[kNumPlayerActions];
}

@end
