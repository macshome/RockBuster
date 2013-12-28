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

//  Some random number functions
static inline CGFloat skRandf() {
    return arc4random() / (CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high) {
    return skRandf() * (high - low) + low;
}

@interface JRWGameScene ()

@property JRWShipSprite *ship;
@property SKSpriteNode *hyperspaceBar;

@property NSMutableArray *rockArray;

@property NSNumber *level;
@property NSNumber *score;
@property BOOL contentCreated;
@property BOOL hyperspaceOK;

@property int hyperspaceCount;

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
    
    //  Set to level 1
    self.level = @1;
    self.score = @0;
    self.hyperspaceOK = NO;
    
    //  Add the sprites
    [self addShipShouldUseTransition:NO];
    [self addHUD];
    [self updateHyperspaceTimer];
    
    //  Set gravity
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
    
    
}

//  Add the HUD
- (void)addHUD {
    SKNode *hud = [[SKNode alloc] init];
    hud.zPosition = 1;
    
    SKLabelNode *levelLabel =[SKLabelNode labelNodeWithFontNamed:@"Futura"];
    levelLabel.name = @"level";
    levelLabel.text = [NSString stringWithFormat:@"Level %@", self.level];
    levelLabel.fontSize = 24;
    levelLabel.position = CGPointMake(CGRectGetMinX(self.frame) + 50, CGRectGetMaxY(self.frame) -30);
    
    SKLabelNode *scoreLabel =[SKLabelNode labelNodeWithFontNamed:@"Futura"];
    scoreLabel.name = @"score";
    scoreLabel.text = [NSString stringWithFormat:@"Score: %@", self.score];
    scoreLabel.fontSize = 24;
    scoreLabel.position = CGPointMake(CGRectGetMaxX(self.frame) - 50, CGRectGetMaxY(self.frame) -30);
    
    
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
    
    [hud addChild:levelLabel];
    [hud addChild:scoreLabel];
    [hud addChild:self.hyperspaceBar];
    
    [self addChild:hud];
    
}

//  Add a ship. The transition is for when adding a new ship to an existing game
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
    for (int i = 0; i <= (int)self.level; i++) {
        JRWRockSprite *rock = [JRWRockSprite createRandomRock];
        rock.position = CGPointMake(skRand(0, self.size.width), skRand(0, self.size.height));
        rock.name = [NSString stringWithFormat:@"rock_%i", i];
        rock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rock.size];
        rock.physicsBody.usesPreciseCollisionDetection = YES;
        rock.physicsBody.mass = 3;
        [rock.physicsBody applyTorque:10.0];
        [self.rockArray addObject:rock];
        [self addChild:rock];
    }
    
}

//  Hyperspace removes the ship then makes it appear at a random place
- (void)hyperspace {
    
    if (self.hyperspaceOK) {
        self.ship.zPosition = -1;
        self.ship.alpha = 0;
        self.ship.position = CGPointMake(skRand(0, self.size.width), skRand(0, self.size.height));
        self.ship.zPosition = 0;
        self.ship.alpha = 1;
        [self resetHyperspaceTimer];
        
    }
    
}


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
}

//  Do we need to loop a sprite to the other side of the scene?
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
