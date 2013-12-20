//
//  JRWGameScene.m
//  Rock Buster
//
//  Created by Josh Wisenbaker on 12/20/13.
//  Copyright (c) 2013 Me. All rights reserved.
//

#import "JRWGameScene.h"
#import "JRWShipSprite.h"
#import "JRWRockSprite.h"

static inline CGFloat skRandf() {
    return arc4random() / (CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high) {
    return skRandf() * (high - low) + low;
}

@interface JRWGameScene ()

@property JRWShipSprite *ship;
@property NSMutableArray *rockArray;

@property int level;
@property BOOL contentCreated;
@end

@implementation JRWGameScene

#pragma mark - Scene Setup Methods
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        return self;
    }
    return nil;
}

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents {
    
    /* Setup your scene here */
    self.backgroundColor = [SKColor blackColor];
    [self addShipShouldUseTransition:NO];
    [self addHUD];
    
    //  Set to level 1
    self.level = 3;
    
    //  Set gravity
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
    
    
}

- (void)addHUD {
    
}

- (void)addShipShouldUseTransition:(BOOL) useTransition {
    if (!self.ship) {
        
        self.ship = [JRWShipSprite createShip];
        self.ship.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
        if (!useTransition) {
            [self.ship setScale:.20];
            [self addChild:self.ship];
        } else {
     
        self.ship.alpha = 0;
        SKAction *zoom = [SKAction scaleTo:.20 duration:1.0];
        SKAction *fadeIn = [SKAction fadeInWithDuration:1.0];
        SKAction *dropIn = [SKAction group:@[zoom, fadeIn]];
        [self addChild:self.ship];
        [self.ship runAction:dropIn];
        }
    }
    
}

- (void)addRock {
    //  How many rocks are there? Make that many asteroids
    for (int i = 0; i <= self.level; i++) {
        JRWRockSprite *rock = [JRWRockSprite createRandomRock];
        rock.position = CGPointMake(skRand(0, self.size.width), skRand(0, self.size.height));
        rock.name = [NSString stringWithFormat:@"rock_%i", i];
        rock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rock.size];
        rock.physicsBody.usesPreciseCollisionDetection = YES;
        rock.physicsBody.mass = 3;
        [rock.physicsBody applyTorque:10.0];
//        [rock.physicsBody app]
        [self.rockArray addObject:rock];
        [self addChild:rock];
    }
    
}

- (void)update:(NSTimeInterval)currentTime
{
    // This runs once every frame. Other sorts of logic might run from here. For example,
    // if the target ship was controlled by the computer, you might run AI from this routine.
    
    [self updatePlayerShip:currentTime];
}

- (void)updatePlayerShip:(NSTimeInterval)currentTime
{
    /*
     Use the stored key information to control the ship.
     */
    
    if (actions[kPlayerForward])
    {
        [self.ship activateMainEngine];
    }
    else
    {
        [self.ship deactivateMainEngine];
    }
    
    if (actions[kPlayerBack])
    {
        [self.ship reverseThrust];
    }
    
    if (actions[kPlayerLeft])
    {
        [self.ship rotateShipLeft];
    }
    
    if (actions[kPlayerRight])
    {
        [self.ship rotateShipRight];
    }
    
    if (actions[kPlayerAction])
    {
        [self.ship attemptMissileLaunch:currentTime];
    }
}

- (void)keyDown:(NSEvent *)theEvent
{
    /*
     Convert key down events into game actions
     */
    
    // first we check the arrow keys since they are on the numeric keypad
    if ([theEvent modifierFlags] & NSNumericPadKeyMask)
    { // arrow keys have this mask
        NSString *theArrow = [theEvent charactersIgnoringModifiers];
        unichar keyChar = 0;
        if ( [theArrow length] == 1 ) {
            keyChar = [theArrow characterAtIndex:0];
            switch (keyChar) {
                case NSLeftArrowFunctionKey:
                    actions[kPlayerLeft] = YES;
                    break;
                case NSRightArrowFunctionKey:
                    actions[kPlayerRight] = YES;
                    break;
                case NSUpArrowFunctionKey:
                    actions[kPlayerForward] = YES;
                    break;
                case NSDownArrowFunctionKey:
                    actions[kPlayerBack] = YES;
                    break;
            }
        }
    }
}

- (void)keyUp:(NSEvent *)theEvent
{
    /*
     Convert key up events into game actions
     */
    
    if ([theEvent modifierFlags] & NSNumericPadKeyMask)
    {
        NSString *theArrow = [theEvent charactersIgnoringModifiers];
        unichar keyChar = 0;
        if ( [theArrow length] == 1 ) {
            keyChar = [theArrow characterAtIndex:0];
            switch (keyChar) {
                case NSLeftArrowFunctionKey:
                    actions[kPlayerLeft] = NO;
                    break;
                case NSRightArrowFunctionKey:
                    actions[kPlayerRight] = NO;
                    break;
                case NSUpArrowFunctionKey:
                    actions[kPlayerForward] = NO;
                    break;
                case NSDownArrowFunctionKey:
                    actions[kPlayerBack] = NO;
                    break;
            }
        }
    }
}



@end
