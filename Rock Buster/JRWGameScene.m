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


@interface JRWGameScene ()

@property JRWShipSprite *ship;
@property SKSpriteNode *hyperspaceBar;

@property NSMutableArray *rockArray;

@property NSInteger level;
@property NSInteger score;
@property BOOL contentCreated;
@property BOOL hyperspaceOK;

@property NSInteger hyperspaceCount;

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
    
    //  Set to level 1 and score to 0
    self.level = 1;
    self.score = 0;
    self.hyperspaceOK = NO;
    self.rockArray = [NSMutableArray array];
    
    //  Add the sprites
    [self addShipShouldUseTransition:NO];
    [self addHUD];
    [self addRock];
    [self updateHyperspaceTimer];
    
    //  Set gravity
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
    
    
}

//  Add the HUD
- (void)addHUD {
    SKNode *hud = [[SKNode alloc] init];
    
    //  Put the HUD above the play field so that things can move under it
    hud.zPosition = 1;
    
    //  Level label
    SKLabelNode *levelLabel =[SKLabelNode labelNodeWithFontNamed:@"Futura"];
    levelLabel.name = @"level";
    levelLabel.text = [NSString stringWithFormat:@"Level %ld", (long)self.level];
    levelLabel.fontSize = 24;
    levelLabel.position = CGPointMake(CGRectGetMinX(self.frame) + 50, CGRectGetMaxY(self.frame) -30);
    
    //  Score label
    SKLabelNode *scoreLabel =[SKLabelNode labelNodeWithFontNamed:@"Futura"];
    scoreLabel.name = @"score";
    scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.score];
    scoreLabel.fontSize = 24;
    scoreLabel.position = CGPointMake(CGRectGetMaxX(self.frame) - 50, CGRectGetMaxY(self.frame) -30);
    
    //  Hyperspace bar
    self.hyperspaceBar = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(0, 21)];
    self.hyperspaceBar.name = @"hyperspaceBar";
    self.hyperspaceBar.anchorPoint = CGPointMake(0.0, 0.5);
    self.hyperspaceBar.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - 20);
    SKLabelNode *hbarLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura"];
    hbarLabel.name = @"hyperspaceLabel";
    hbarLabel.text = @"Hyperdrive:";
    hbarLabel.fontSize = 24;
    hbarLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    hbarLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    [self.hyperspaceBar addChild:hbarLabel];
    
    //  Add the components to the HUD node
    [hud addChild:levelLabel];
    [hud addChild:scoreLabel];
    [hud addChild:self.hyperspaceBar];
    
    //  Add the hud node to the scene
    [self addChild:hud];
    
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
            [self addChild:self.ship];
        } else {
            //  Transition to drop in a new ship
            [self.ship setScale:3.0];
            self.ship.alpha = 0;
            SKAction *zoom = [SKAction  scaleTo:1.0 duration:1.0];
            SKAction *fadeIn = [SKAction fadeInWithDuration:1.0];
            SKAction *dropIn = [SKAction group:@[zoom, fadeIn]];
            [self addChild:self.ship];
            [self.ship runAction:dropIn];
        }
    }
}

//  Add a rock
- (void)addRock {
    
    //  How many rocks are there? Make that many asteroids
    while ([self.rockArray count] < self.level) {
        
            JRWRockSprite *rock = [JRWRockSprite createRandomRock];
            
            rock.position = CGPointMake(arc4random_uniform(self.size.width), arc4random_uniform(self.size.height));
            rock.name = [NSString stringWithFormat:@"rock_%ld", (long)self.level];
        
            rock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rock.size];
            rock.physicsBody.usesPreciseCollisionDetection = YES;
            rock.physicsBody.mass = 3;
            [rock.physicsBody applyTorque:10.0];
            
            [self.rockArray addObject:rock];
            NSLog(@"Level is %ld with %lu rocks in array", (long)self.level, [self.rockArray count]);
            [self addChild:rock];

    
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

#pragma mark - Commands
//  Hyperspace removes the ship then makes it appear at a random place
- (void)hyperspace {
    
    //  If hyperspace is OK move to another z plane, move randomly, then re-appear, and move back.
    if (self.hyperspaceOK) {
        self.ship.zPosition = -1;
        self.ship.alpha = 0.0;
        
        self.ship.position = CGPointMake(arc4random_uniform(self.size.width), arc4random_uniform(self.size.height));
        
        SKAction *fadeIn = [SKAction fadeInWithDuration:0.25];
        [self.ship runAction:fadeIn completion:^{
            self.ship.zPosition = 0;
            [self resetHyperspaceTimer];
        }];
        
    }
    
}

//  Make the hyperspace bar grow over 10 seconds then enable hyperspace
- (void)updateHyperspaceTimer {
    self.hyperspaceBar.color = [SKColor redColor];
    SKAction *hyperspaceBarGrow = [SKAction resizeToWidth:100.0 duration:10.0];
    [self.hyperspaceBar runAction:hyperspaceBarGrow completion:^{
        self.hyperspaceOK = YES;
        self.hyperspaceBar.color = [SKColor greenColor];
    }];
    
}

//  Set the hyperspace timer back to 0
- (void)resetHyperspaceTimer {
    self.hyperspaceOK = NO;
    
    self.hyperspaceBar.color = [SKColor yellowColor];
    SKAction *hyperspaceBarShrink = [SKAction resizeToWidth:0.0 duration:0.25];
    [self.hyperspaceBar runAction:hyperspaceBarShrink completion:^{
        [self updateHyperspaceTimer];
    }];
    
    
}

#pragma mark - Game updates and logic
- (void)update:(NSTimeInterval)currentTime
{
    // This runs once every frame.
    
    [self updatePlayerShip:currentTime];
    [self updateSpritePositions];
    [self shipSpeedLimit];
}

//  Do we need to loop a sprite to the other side of the scene?
//  TODO: Make this apply to all sprites on screen other than missiles
- (void)updateSpritePositions {
    //  Get the current possition
    CGPoint shipPosition = CGPointMake(self.ship.position.x, self.ship.position.y);
    
    //  If we've gone beyond the edge warp to the other side.
    if (shipPosition.x > (CGRectGetMaxX(self.frame) + 10)) {
        self.ship.position = CGPointMake((CGRectGetMinX(self.frame) - 5), shipPosition.y);
    }
    
    if (shipPosition.x < (CGRectGetMinX(self.frame) - 10)) {
        self.ship.position = CGPointMake((CGRectGetMaxX(self.frame) + 5), shipPosition.y);
    }
    
    if (shipPosition.y > (CGRectGetMaxY(self.frame) + 10)) {
        self.ship.position = CGPointMake(shipPosition.x, (CGRectGetMinY(self.frame) - 5));
    }
    
    if (shipPosition.y < (CGRectGetMinY(self.frame) - 10)) {
        self.ship.position = CGPointMake(shipPosition.x, (CGRectGetMaxY(self.frame) + 5));
    }
    
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

//  Ship controls
- (void)updatePlayerShip:(NSTimeInterval)currentTime
{
    /*
     Use the stored key information to control the ship. (Grabbed this from Apple sample code.)
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
        [self hyperspace];
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
    
    // and now we check the keyboard
    NSString *characters = [theEvent characters];
    if ([characters length]) {
        for (int s = 0; s<[characters length]; s++) {
            unichar character = [characters characterAtIndex:s];
            switch (character) {
                case 'w':
                    actions[kPlayerForward] = YES;
                    break;
                case 'a':
                    actions[kPlayerLeft] = YES;
                    break;
                case 'd':
                    actions[kPlayerRight] = YES;
                    break;
                case 's':
                    actions[kPlayerBack] = YES;
                    break;
                case ' ':
                    actions[kPlayerAction] = YES;
                    break;
                case 'r':
                    //                {
                    //                    APLSpaceScene *reset = [[APLSpaceScene alloc] initWithSize: self.frame.size];
                    //                    [self.view presentScene:reset transition:[SKTransition flipVerticalWithDuration:0.35]];
                    //                }
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
                case ' ':
                    actions[kPlayerAction] = YES;
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
                    actions[kPlayerForward] = NO;
                    break;
                case 'a':
                    actions[kPlayerLeft] = NO;
                    break;
                case 'd':
                    actions[kPlayerRight] = NO;
                    break;
                case 's':
                    actions[kPlayerBack] = NO;
                    break;
                case ' ':
                    actions[kPlayerAction] = NO;
                    break;
            }
        }
    }
}




@end
