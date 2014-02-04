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
#import "JRWHUDSprite.h"


@interface JRWGameScene ()

@property JRWShipSprite *ship;
@property JRWHUDSprite *HUD;

@property SKNode *playObjects;
@property SKAction *rockExplodeSound;

@property BOOL contentCreated;
@property NSInteger rockCount;

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
    self.rockExplodeSound = [SKAction playSoundFileNamed:@"boom6.caf" waitForCompletion:NO];
    self.rockCount = 0;
    
    // Add the HUD node
    [self addHUD];
    
    //  Create a node to hold the play objects
    self.playObjects = [[SKNode alloc] init];
    self.playObjects.name = @"playObjects";
    [self addChild:self.playObjects];
    
    //  Add the sprites
    [self addShipShouldUseTransition:NO];
    [self addRocks];
    [self.HUD updateHyperspaceTimer];
    
    //  Set gravity
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
    
    
}

//  Add the HUD
- (void)addHUD {
    //  Create a new HUD
    self.HUD = [JRWHUDSprite createHUDforFrame:self.frame];
    
#if DEBUG
    // Set the debug level and score here to override the defaults of level 1, score 0
    self.HUD.level = 1;
    self.HUD.score = 0;
#endif
    
    //  Add the node
    [self addChild:self.HUD];
    
}



#pragma mark - Game Play Objects
//  Add a ship. The transition is for when adding a new ship to an existing game
- (void)addShipShouldUseTransition:(BOOL) useTransition {
    if (!self.ship) {
        
        //  Make a new ship and position it in the middle
        self.ship = [JRWShipSprite createShip];
        self.ship.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
        //  With no transsition just add the ship
        if (!useTransition) {
            [self.playObjects addChild:self.ship];
        } else {
            //  Transition to drop in a new ship
            [self.ship setScale:3.0];
            self.ship.alpha = 0;
            SKAction *zoom = [SKAction  scaleTo:1.0 duration:1.0];
            SKAction *fadeIn = [SKAction fadeInWithDuration:1.0];
            SKAction *dropIn = [SKAction group:@[zoom, fadeIn]];
            [self.playObjects addChild:self.ship];
            [self.ship runAction:dropIn];
        }
    }
}



//  Add a rock
- (void)addRocks {
    
    //  How many rocks are there? Make that many asteroids
    
    while ( self.rockCount < self.HUD.level * 2) {
        
        JRWRockSprite *rock = [JRWRockSprite createRandomRock];
        
        rock.position = CGPointMake(arc4random_uniform(self.size.width), arc4random_uniform(self.size.height));
        
#if DEBUG
        NSLog(@"Level is %ld with %ld rocks", self.HUD.level, (long)self.rockCount + 1);
#endif
        
        [self.playObjects addChild:rock];
        
        [self rockPhysics:rock];
        self.rockCount++;
        
    }
}

//  Add a missile
- (SKNode*) addMissile
{
    //  Load the texture
    SKSpriteNode *missile = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"missile.png"]];
    
    //  Offset for rotation
    CGFloat offsetX = missile.frame.size.width * missile.anchorPoint.x;
    CGFloat offsetY = missile.frame.size.height * missile.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    //  Make the path for the physicsbody to use
    CGPathMoveToPoint(path, NULL, 3 - offsetX, 14 - offsetY);
    CGPathAddLineToPoint(path, NULL, 1 - offsetX, 9 - offsetY);
    CGPathAddLineToPoint(path, NULL, 1 - offsetX, 0 - offsetY);
    CGPathAddLineToPoint(path, NULL, 4 - offsetX, 0 - offsetY);
    CGPathAddLineToPoint(path, NULL, 4 - offsetX, 10 - offsetY);
    
    CGPathCloseSubpath(path);
    
    //  Add the physics body no linearDamping so they just go at the same speed
    missile.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
    missile.physicsBody.linearDamping = 0.0;
    
    //  Collision maps. There are a lot of missiles, so push the job of collision detection to
    //  the objects that we want to hit.
    missile.physicsBody.categoryBitMask = RBCmissileCategory;
    missile.physicsBody.collisionBitMask = 0;
    missile.physicsBody.contactTestBitMask = 0;
    
    
#if SHOW_PHYSICS_OVERLAY
    SKShapeNode *shipOverlayShape = [[SKShapeNode alloc] init];
    shipOverlayShape.path = path;
    shipOverlayShape.strokeColor = [SKColor clearColor];
    shipOverlayShape.fillColor = [SKColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5];
    [missile addChild:shipOverlayShape];
#endif
    
    //  Release the path so we don't leak
    CGPathRelease(path);
    return missile;
}

//  Add an explosion (Adapted from Apple Sample code)
- (SKEmitterNode*) newExplosionNode: (CFTimeInterval) explosionDuration
{
    SKEmitterNode *emitter =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"JRWExplosion" ofType:@"sks"]];
    
    // Explosions always place their particles into the scene.
    emitter.targetNode = self;
    
    // Stop spawning particles after enough have been spawned.
    emitter.numParticlesToEmit = explosionDuration * emitter.particleBirthRate;
    
    // Calculate a time value that allows all the spawned particles to die. After this, the emitter node can be removed.
    
    CFTimeInterval totalTime = explosionDuration + emitter.particleLifetime+emitter.particleLifetimeRange/2;
    [emitter runAction:[SKAction sequence:@[[SKAction waitForDuration:totalTime],
                                            [SKAction removeFromParent]]]];
    return emitter;
}


- (void)detonateMissile:(SKNode *)missile
{
    SKEmitterNode *explosion = [self newExplosionNode: 0.1];
    explosion.position = missile.position;
    [self addChild:explosion];
    [missile removeFromParent];

}

#pragma mark - Hyperspace System
//  Hyperspace removes the ship then makes it appear at a random place.
//  Since we aren't dustin' crops we might appear under a rock.
- (void)hyperspace {
    
    //  If hyperspace is OK move to another z plane, move randomly, then re-appear, and move back.
    if (self.HUD.hyperspaceOK) {
        self.ship.zPosition = -1;
        self.ship.alpha = 0.0;
        
        self.ship.position = CGPointMake(arc4random_uniform(self.size.width), arc4random_uniform(self.size.height));
        
        //TODO: Figure out the timings here to have the fade happen
        SKAction *fadeIn = [SKAction fadeInWithDuration:0.25];
        [self.ship runAction:fadeIn completion:^{
            self.ship.zPosition = 0;
            [self.HUD resetHyperspaceTimer];
        }];
    }
}

#pragma mark - Game updates and logic

// This runs once every frame.
- (void)update:(NSTimeInterval)currentTime
{
    [self updatePlayerShip:currentTime];
    [self updateSpritePositions];
    [self shipSpeedLimit];
}

//  Do we need to loop a sprite to the other side of the scene?
- (void)updateSpritePositions {
    
    [self enumerateChildNodesWithName:@"/playObjects/*" usingBlock:^(SKNode *node, BOOL *stop) {
        
        //  Get the current possition
        CGPoint nodePosition = CGPointMake(node.position.x, node.position.y);
        
        
        //  If we've gone beyond the edge warp to the other side.
        if (nodePosition.x > (CGRectGetMaxX(self.frame) + 20)) {
            node.position = CGPointMake((CGRectGetMinX(self.frame) - 10), nodePosition.y);
        }
        
        if (nodePosition.x < (CGRectGetMinX(self.frame) - 20)) {
            node.position = CGPointMake((CGRectGetMaxX(self.frame) + 10), nodePosition.y);
        }
        
        if (nodePosition.y > (CGRectGetMaxY(self.frame) + 20)) {
            node.position = CGPointMake(nodePosition.x, (CGRectGetMinY(self.frame) - 10));
        }
        
        if (nodePosition.y < (CGRectGetMinY(self.frame) - 20)) {
            node.position = CGPointMake(nodePosition.x, (CGRectGetMaxY(self.frame) + 10));
        }
        
    }];
    
    //  Remove any missles that have gone off screen
    [self enumerateChildNodesWithName:@"missile" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y > (CGRectGetMaxY(self.frame)) || node.position.y < (CGRectGetMinY(self.frame)) ||
            node.position.x > (CGRectGetMaxX(self.frame)) || node.position.x < (CGRectGetMinX(self.frame))) {
            node.physicsBody = nil;
            [node removeFromParent];
        }
    }];
    
}

//  Speed limiter
- (void)shipSpeedLimit {
    
    //  Check the x velocity
    if (self.ship.physicsBody.velocity.dx >= 500) {
        self.ship.physicsBody.velocity = CGVectorMake(500, self.ship.physicsBody.velocity.dy);
    } else if (self.ship.physicsBody.velocity.dx <= -500) {
        self.ship.physicsBody.velocity = CGVectorMake(-500, self.ship.physicsBody.velocity.dy);
    }
    
    //  Check the y velocity
    if (self.ship.physicsBody.velocity.dy >= 500) {
        self.ship.physicsBody.velocity = CGVectorMake(self.ship.physicsBody.velocity.dx, 500);
    } else if (self.ship.physicsBody.velocity.dy <= -500) {
        self.ship.physicsBody.velocity = CGVectorMake(self.ship.physicsBody.velocity.dx, -500);
    }
}

//  Rock movement/physics initilizer. Using this to work around a spritekit bug.
- (void)rockPhysics:(JRWRockSprite *)rock {
    rock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rock.size];
    rock.physicsBody.categoryBitMask = RBCasteroidCategory;
    rock.physicsBody.collisionBitMask = (RBCasteroidCategory | RBCshipCategory);
    rock.physicsBody.contactTestBitMask = (RBCasteroidCategory | RBCmissileCategory | RBCshipCategory);
    rock.physicsBody.usesPreciseCollisionDetection = YES;
    switch ([rock.name integerValue]) {
        case RBbigRock:
            rock.physicsBody.mass = 5;
            break;
        case RBlargeRock:
            rock.physicsBody.mass = 4;
            break;
        case RBmediumRock:
            rock.physicsBody.mass = 3;
            break;;
        case RBsmallRock:
            rock.physicsBody.mass = 2;
            break;
        case RBtinyRock:
            rock.physicsBody.mass = 1;
            break;
    }
    rock.physicsBody.angularDamping = 0.0;
    [rock.physicsBody applyTorque:(CGFloat)arc4random_uniform(5)-5];
    [rock.physicsBody applyImpulse:CGVectorMake(-500, 901)];
}

//  We hit a rock with a missile
- (void)hitRock:(SKNode *)rock withMissile:(SKNode *)missile {
    missile.physicsBody = nil;
    [self detonateMissile:missile];

    [self breakRock:rock];
    
    // Generic rock boom
    [self runAction:self.rockExplodeSound];
    
}

//  Which rock is it? Break it like we should
//  TODO: File bug on the ordering of position and creating physicsbody
- (void)breakRock:(SKNode *)rock {
    
    //  One rock down!
    self.rockCount-- ;
    
    //  Grab some physics info about the rock we are breaking
    CGPoint position = rock.position;
    CGVector linearVelocity = rock.physicsBody.velocity;
    CGFloat angularVelocity = rock.physicsBody.angularVelocity;
    
    switch ([rock.name integerValue]) {
        case RBbigRock:
#if DEBUG
            NSLog(@"Big rock");
#endif
            [rock removeFromParent];
            self.HUD.score = self.HUD.score + 100;
            for (NSInteger i = 0; i < 2; i++) {
                JRWRockSprite *newRock = [JRWRockSprite createRockWithSize:RBlargeRock];
                self.rockCount++;
                
                newRock.position = position;
                
                [self.playObjects addChild:newRock];
                [self rockPhysics:newRock];
                newRock.physicsBody.velocity =  CGVectorMake(linearVelocity.dx * 1.2, linearVelocity.dy * 1.2);
                newRock.physicsBody.angularVelocity = (angularVelocity + 3.0);
                
                
            }
            
            break;
            
        case RBlargeRock:
#if DEBUG
            NSLog(@"Large rock");
#endif
            [rock removeFromParent];
            self.HUD.score = self.HUD.score + 150;
            for (NSInteger i = 0; i < 2; i++) {
                JRWRockSprite *newRock = [JRWRockSprite createRockWithSize:RBmediumRock];
                self.rockCount++;
                
                newRock.position = position;
                
                [self.playObjects addChild:newRock];
                [self rockPhysics:newRock];
                newRock.physicsBody.velocity =  CGVectorMake(linearVelocity.dx * 1.5, linearVelocity.dy * 1.5);
                newRock.physicsBody.angularVelocity = (angularVelocity + 2.0);
            }
            
            break;
            
        case RBmediumRock:
#if DEBUG
            NSLog(@"Medium rock");
#endif
            self.HUD.score = self.HUD.score + 200;
            [rock removeFromParent];
            for (NSInteger i = 0; i < 2; i++) {
                JRWRockSprite *newRock = [JRWRockSprite createRockWithSize:RBsmallRock];
                self.rockCount++;
                
                newRock.position = position;
                
                [self.playObjects addChild:newRock];
                [self rockPhysics:newRock];
                newRock.physicsBody.velocity =  CGVectorMake(linearVelocity.dx * 1.8, linearVelocity.dy * 1.8);
                newRock.physicsBody.angularVelocity = (angularVelocity + 1.0);
            }
            break;
            
        case RBsmallRock:
#if DEBUG
            NSLog(@"small rock");
#endif
            self.HUD.score = self.HUD.score + 300;
            [rock removeFromParent];
            
            //  Cheap way to get something to average about 50% of the time.
            if (arc4random_uniform(10) > 5) {
                for (NSInteger i = 0; i < 2; i++) {
                    JRWRockSprite *newRock = [JRWRockSprite createRockWithSize:RBtinyRock];
                    self.rockCount++;
                    
                    newRock.position = position;
                    
                    [self.playObjects addChild:newRock];
                    [self rockPhysics:newRock];
                    newRock.physicsBody.velocity =  CGVectorMake(linearVelocity.dx * 2.0, linearVelocity.dy * 2.0);
                    newRock.physicsBody.angularVelocity = (angularVelocity + .5);
                }
            }
            
            break;
            
        case RBtinyRock:
#if DEBUG
            NSLog(@"tiny rock");
#endif
            self.HUD.score = self.HUD.score + 600;
            [rock removeFromParent];
            break;
    }
    
    //  Update the score label
    [(SKLabelNode *)[self childNodeWithName:@"HUD/score"] setText: [NSString stringWithFormat:@"Score: %ld", (long)self.HUD.score]];
    
    //  If we are out of rocks it's time for the next level.
    if (self.rockCount == 0) {
        [self advanceLevel];
    };
    
    
}

//  Start the next level
- (void)advanceLevel {
    //  Take care of the UI
    self.HUD.level += 1;
    [(SKLabelNode *)[self childNodeWithName:@"HUD/level"] setText: [NSString stringWithFormat:@"Level: %ld", (long)self.HUD.level]];
    [self.HUD resetHealthBar];
    
    //  Heal the ship
    self.ship.health = 1000;
    
    //  Respawn rocks for the new level
    [self addRocks];
    
}



//  Contact callback (Adapted from Apple sample code)
- (void)didBeginContact:(SKPhysicsContact *)contact {
    
    //  SKPhysicsBody objects to hold the passed in objects
    SKPhysicsBody *firstBody;
    SKPhysicsBody *secondBody;
    
    // The contacts can appear in either order, and so normally you'd need to check
    // each against the other. In this example, the category types are well ordered, so
    // the code swaps the two bodies if they are out of order. This allows the code
    // to only test collisions once.
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    // Missiles only hit rocks
    
    if ((firstBody.categoryBitMask & RBCmissileCategory) != 0) {
        [self hitRock:secondBody.node withMissile:firstBody.node];
    }
    
    //  Hit the ship with a rock
    if ((secondBody.categoryBitMask & RBCshipCategory) != 0) {
        [self.ship applyDamage:contact.collisionImpulse / 2];
        [self.HUD shrinkHealthBar:(CGFloat)self.ship.health / 10];
    }
}

//  Ship controls
- (void)updatePlayerShip:(NSTimeInterval)currentTime
{
    /*
     Use the stored key information to control the ship. (Grabbed this from Apple sample code.)
     */
    
    if (actions[RBCPlayerForward])
    {
        [self.ship activateMainEngine];
    }
    else
    {
        [self.ship deactivateMainEngine];
    }
    
    if (actions[RBCPlayerBack])
    {
        [self hyperspace];
    }
    
    if (actions[RBCPlayerLeft])
    {
        [self.ship rotateShipLeft];
    }
    
    if (actions[RBCPlayerRight])
    {
        [self.ship rotateShipRight];
    }
    
    if (actions[RBCPlayerAction])
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
                    actions[RBCPlayerLeft] = YES;
                    break;
                case NSRightArrowFunctionKey:
                    actions[RBCPlayerRight] = YES;
                    break;
                case NSUpArrowFunctionKey:
                    actions[RBCPlayerForward] = YES;
                    break;
                case NSDownArrowFunctionKey:
                    actions[RBCPlayerBack] = YES;
                    break;
            }
        }
    }
    
    // and now we check the keyboard
    NSString *characters = [theEvent characters];
    if ([characters length]) {
        for (int s = 0; s<[characters length]; s++) {
            unichar character = [characters characterAtIndex:s];
            switch (character) {
                case 'w':
                    actions[RBCPlayerForward] = YES;
                    break;
                case 'a':
                    actions[RBCPlayerLeft] = YES;
                    break;
                case 'd':
                    actions[RBCPlayerRight] = YES;
                    break;
                case 's':
                    actions[RBCPlayerBack] = YES;
                    break;
                case ' ':
                    actions[RBCPlayerAction] = YES;
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
                    actions[RBCPlayerLeft] = NO;
                    break;
                case NSRightArrowFunctionKey:
                    actions[RBCPlayerRight] = NO;
                    break;
                case NSUpArrowFunctionKey:
                    actions[RBCPlayerForward] = NO;
                    break;
                case NSDownArrowFunctionKey:
                    actions[RBCPlayerBack] = NO;
                    break;
                case ' ':
                    actions[RBCPlayerAction] = YES;
                    break;
            }
        }
    }
    NSString *characters = [theEvent characters];
    if ([characters length]) {
        for (int s = 0; s<[characters length]; s++) {
            unichar character = [characters characterAtIndex:s];
            switch (character) {
                case 'w':
                    actions[RBCPlayerForward] = NO;
                    break;
                case 'a':
                    actions[RBCPlayerLeft] = NO;
                    break;
                case 'd':
                    actions[RBCPlayerRight] = NO;
                    break;
                case 's':
                    actions[RBCPlayerBack] = NO;
                    break;
                case ' ':
                    actions[RBCPlayerAction] = NO;
                    break;
            }
        }
    }
}




@end
