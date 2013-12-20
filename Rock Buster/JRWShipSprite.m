//
//  JRWShipSprite.m
//  Rock Buster
//
//  Created by Josh Wisenbaker on 12/18/13.
//  Copyright (c) 2013 Me. All rights reserved.
//

#import "JRWShipSprite.h"
#import "JRWTitleScene.h"

// Used to control the ship, usually by applying physics forces to the ship.
static const CGFloat mainEngineThrust = 2000;
static const CGFloat reverseThrust = 1;
static const CGFloat lateralThrust = 10;
static const CGFloat firingInterval = 0.1;
static const CGFloat missileLaunchDistance = 45;
static const CGFloat engineIdleAlpha = 0.05;
static const CGFloat missileLaunchImpulse = 0.5;

@implementation JRWShipSprite

+ (instancetype)createShip {
    JRWShipSprite *ship = [JRWShipSprite spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"Spaceship"]];
    ship.name = @"Ship";
    
    ship.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ship.size];
    ship.physicsBody.mass = 3;
    ship.physicsBody.linearDamping = .8;
    return ship;
}

- (CGFloat)shipOrientation
{
    // The ship art is oriented so that it faces the top of the scene, but Sprite Kit's rotation default is to the right.
    // This method calculates the ship orientation for use in other calculations.
    return self.zRotation + M_PI_2;
}

- (void)activateMainEngine
{
    /*
     Add flames out the back and apply thrust to the ship.
     */
    
    CGFloat shipDirection = [self shipOrientation];
    [self.physicsBody applyForce:CGVectorMake(mainEngineThrust*cosf(shipDirection), mainEngineThrust*sinf(shipDirection))];
    
}

- (void)deactivateMainEngine
{
    /*
     Cut the engine exhaust.
     */
    

}

- (void)rotateShipLeft
{
    /*
     Apply a small amount of thrust to turn the ship to the left. (No visible special effect).
     */
//    [self.physicsBody applyTorque:lateralThrust];
    
    self.zRotation = self.zRotation + .11;
}

- (void)rotateShipRight
{
    /*
     Apply a small amount of thrust to turn the ship to the right. (No visible special effect).
     */
//    [self.physicsBody applyTorque:-lateralThrust];
    self.zRotation = self.zRotation - .11;
}

@end
