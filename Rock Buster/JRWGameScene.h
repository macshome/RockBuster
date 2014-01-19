//
//  JRWGameScene.h
//  Rock Buster
//
//  Created by Josh Wisenbaker on 12/20/13.
//  Copyright (c) 2013 Me. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

//  Debug method to show the physicsbodies as overlays. Set to 1 to enable.
#define SHOW_PHYSICS_OVERLAY 0

// These constants are used to map keyboard events into player events.
typedef NS_ENUM(NSInteger, RockBusterControls) {
    RBCPlayerForward,
    RBCPlayerLeft,
    RBCPlayerRight,
    RBCPlayerBack,
    RBCPlayerAction,
    RBCNumPlayerActions
};

// These constans are used to define the physics interactions between physics bodies in the scene.
typedef NS_OPTIONS(NSUInteger, RockBusterCollionsMask) {
    RBCmissileCategory =  1 << 0,
    RBCasteroidCategory =  1 << 1,
    RBCshipCategory =  1 << 2
    
};




@interface JRWGameScene : SKScene <SKPhysicsContactDelegate>
{
    BOOL     actions[RBCNumPlayerActions];
}

- (SKNode*) addMissile;

@end
