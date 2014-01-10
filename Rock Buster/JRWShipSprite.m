//
//  JRWShipSprite.m
//  Rock Buster
//
//  Created by Josh Wisenbaker on 12/18/13.
//  Copyright (c) 2013 Me. All rights reserved.
//

#import "JRWShipSprite.h"
#import "JRWTitleScene.h"
#import "JRWGameScene.h"



// Used to control the ship, usually by applying physics forces to the ship.
//  TODO: Put these in a plist
static const CGFloat mainEngineThrust = 1000;
static const CGFloat firingInterval = 0.1;
static const CGFloat missileLaunchDistance = 40;
static const CGFloat engineIdleAlpha = 0.05;
static const CGFloat missileLaunchVelocity = 1000.0;

@interface JRWShipSprite ()
@property CFTimeInterval timeLastFiredMissile;
@end

@implementation JRWShipSprite

#pragma mark - Ship creation
+ (instancetype)createShip {
    JRWShipSprite *ship = [JRWShipSprite spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"Spaceship"]];
    
    //  Make the path for the physicsbody.
    //  Remember convex, no more than 12 points, wrapped anti-clockwise
    CGFloat offsetX = ship.frame.size.width * ship.anchorPoint.x;
    CGFloat offsetY = ship.frame.size.height * ship.anchorPoint.y;
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 6 - offsetX, 6 - offsetY);
    CGPathAddLineToPoint(path, NULL, 40 - offsetX, 0 - offsetY);
    CGPathAddLineToPoint(path, NULL, 70 - offsetX, 6 - offsetY);
    CGPathAddLineToPoint(path, NULL, 78 - offsetX, 20 - offsetY);
    CGPathAddLineToPoint(path, NULL, 38 - offsetX, 68 - offsetY);
    CGPathAddLineToPoint(path, NULL, 0 - offsetX, 20 - offsetY);
    
    
    CGPathCloseSubpath(path);
    
    ship.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
    
    //  Give the ship a mass of 1 and some linearDamping that makes us slow down after letting off the gas.
    ship.physicsBody.mass = 1;
    ship.physicsBody.linearDamping = .7;
    ship.physicsBody.angularDamping = 1.0;
    
    ship.name = @"Ship";
    
#if SHOW_PHYSICS_OVERLAY
    SKShapeNode *shipOverlayShape = [[SKShapeNode alloc] init];
    shipOverlayShape.path = path;
    shipOverlayShape.strokeColor = [SKColor clearColor];
    shipOverlayShape.fillColor = [SKColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.5];
    [ship addChild:shipOverlayShape];
#endif
    
    CGPathRelease(path);
    return ship;
}

//  From Apple sample code
- (CGFloat)shipOrientation
{
    // The ship art is oriented so that it faces the top of the scene, but Sprite Kit's rotation default is to the right.
    // This method calculates the ship orientation for use in other calculations.
    return self.zRotation + M_PI_2;
}

#pragma mark - Ship controls
//  TODO: Add engine exhaust and sound
- (void)activateMainEngine
{
    CGFloat shipDirection = [self shipOrientation];
    [self.physicsBody applyForce:CGVectorMake(mainEngineThrust*cosf(shipDirection), mainEngineThrust*sinf(shipDirection))];
    
}

//  TODO: Turn off engine exhaust
- (void)deactivateMainEngine
{
    
}

//  Add radians needed to make the ship turn once every 60 frames. i.e. 1 second per rotation.
- (void)rotateShipLeft
{
    self.zRotation = self.zRotation + .11;
}

- (void)rotateShipRight
{
    
    self.zRotation = self.zRotation - .11;
}

- (void)attemptMissileLaunch:(NSTimeInterval)currentTime {
    /* Fire a missile if there's one ready */
    
    CFTimeInterval timeSinceLastFired = currentTime - self.timeLastFiredMissile;
    if (timeSinceLastFired > firingInterval)
    {
        self.timeLastFiredMissile = currentTime;
        
        CGFloat shipDirection = [self shipOrientation];
        
        //  Get our main scene
        JRWGameScene *scene = (JRWGameScene *) self.scene;
        
        SKNode *missile = [scene addMissile];
        missile.position = CGPointMake(self.position.x + missileLaunchDistance*cosf(shipDirection),
                                       self.position.y + missileLaunchDistance*sinf(shipDirection));
        
        missile.name = @"missile";
        
        //  Point the missle the same direction as the ship
        missile.zRotation = self.zRotation;
        
        [scene addChild:missile];
        
        // Just using a constant speed on the missiles
        missile.physicsBody.velocity = CGVectorMake(missileLaunchVelocity*cosf(shipDirection),
                                                    missileLaunchVelocity*sinf(shipDirection));
        
        
    }
    
    
}

@end
