//
//  JRWMyScene.m
//  Rock Buster
//
//  Created by Josh Wisenbaker on 12/18/13.
//  Copyright (c) 2013 Me. All rights reserved.
//

#import "JRWMainScene.h"
#import "JRWShipSprite.h"
#import "JRWRockSprite.h"

static inline CGFloat skRandf() {
    return arc4random() / (CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high) {
    return skRandf() * (high - low) + low;
}

@interface JRWMainScene ()
@property JRWShipSprite *ship;
@property SKLabelNode *startTextNode;

@property NSMutableArray *rockArray;

@property BOOL contentCreated;
@property NSNumber *level;
@end

@implementation JRWMainScene

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
    
    //  Preload the textures
    SKTextureAtlas *artAtlas = [SKTextureAtlas atlasNamed:@"art"];
    [artAtlas preloadWithCompletionHandler:^{
        NSLog(@"Loaded art atlas");
    }];
    
    //  Set to level 1
    self.level = @1;
    
    //  Set gravity
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
    
    //  Add the start text
    [self addChild:[self addStartText]];
    
}


- (SKLabelNode *)addStartText {
    self.startTextNode = [SKLabelNode labelNodeWithFontNamed:@"Futura"];
    self.startTextNode.name = @"startText";
    self.startTextNode.text = @"Press 1 for One Player";
    self.startTextNode.fontSize = 42;
    self.startTextNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    return self.startTextNode;
}

- (void)removeStartText {
    SKAction *moveUp = [SKAction moveByX:0 y:(CGRectGetMaxY(self.frame)+43) duration:1.0];
    SKAction *fadeOut = [SKAction fadeOutWithDuration:1.0];
    SKAction *removeFromParent = [SKAction removeFromParent];
    SKAction *removeStartText = [SKAction group:@[moveUp, fadeOut]];
    [self.startTextNode runAction:removeStartText completion:^{
        [self addShip];
        [self addRock];
        [self.startTextNode runAction:removeFromParent];
    }];
}


- (void)addHUD {
    
}

- (void)addShip {
    if (!self.ship) {
        self.ship = [JRWShipSprite createShip];
        self.ship.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        self.ship.alpha = 0;
        SKAction *zoom = [SKAction scaleTo:.20 duration:1.0];
        SKAction *fadeIn = [SKAction fadeInWithDuration:1.0];
        SKAction *dropIn = [SKAction group:@[zoom, fadeIn]];
        [self addChild:self.ship];
        [self.ship runAction:dropIn completion:^{
            [self addHUD];
        }];
    }
    
}

- (void)addRock {
    //  How many rocks are there? Make that many asteroids
    for (int i = 0; i <= 2; i++) {
        JRWRockSprite *rock = [JRWRockSprite createRandomRock];
        rock.position = CGPointMake(skRand(0, self.size.width), skRand(0, self.size.height));
        rock.name = [NSString stringWithFormat:@"rock_%i", i];
        rock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rock.size];
        rock.physicsBody.usesPreciseCollisionDetection = YES;
        [self.rockArray addObject:rock];
        [self addChild:rock];
    }
    
}



#pragma mark - Key Press Handlers
- (void)keyDown:(NSEvent *)theEvent {
    NSString *characters = [theEvent charactersIgnoringModifiers];
    if ([characters length]) {
        for (int s = 0; s<[characters length]; s++) {
            unichar character = [characters characterAtIndex:s];
            switch (character) {
                case '1':
                    [self removeStartText];
                    break;
            }
        }
    }
}

#pragma mark - Frame Updates
-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
