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
static const CGFloat mainEngineThrust = 1000;
static const CGFloat lateralThrust = 10;
static const CGFloat firingInterval = 0.1;
static const CGFloat missileLaunchDistance = 40;
static const CGFloat engineIdleAlpha = 0.05;
static const CGFloat missileLaunchImpulse = 1000.0;

@interface JRWShipSprite ()
@property CFTimeInterval timeLastFiredMissile;
@end

@implementation JRWShipSprite

+ (instancetype)createShip {
    JRWShipSprite *ship = [JRWShipSprite spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"Spaceship"]];
    
    ship.anchorPoint = CGPointMake(0.5, 0.5);
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
    ship.physicsBody.mass = 1;
    ship.physicsBody.linearDamping = .7;
    
    ship.name = @"Ship";
    
#if SHOW_SHIP_PHYSICS_OVERLAY
    SKShapeNode *shipOverlayShape = [[SKShapeNode alloc] init];
    shipOverlayShape.path = path;
    shipOverlayShape.strokeColor = [SKColor clearColor];
    shipOverlayShape.fillColor = [SKColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.5];
    [ship addChild:shipOverlayShape];
#endif
    
    CGPathRelease(path);
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
        
        JRWGameScene *scene = (JRWGameScene *) self.scene;
        
        SKNode *missile = [scene addMissile];
        missile.position = CGPointMake(self.position.x + missileLaunchDistance*cosf(shipDirection),
                                       self.position.y + missileLaunchDistance*sinf(shipDirection));
        
        missile.name = @"missile";
        missile.zRotation = self.zRotation;
        
        [scene addChild:missile];
        
        // Just using a constant speed on the missiles
        missile.physicsBody.velocity = CGVectorMake(missileLaunchImpulse*cosf(shipDirection),
                                                    missileLaunchImpulse*sinf(shipDirection));


    }

    
}

@end
