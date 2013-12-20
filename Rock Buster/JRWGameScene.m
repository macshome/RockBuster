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
    
    //  Set to level 1
    self.level = 3;
    
    //  Set gravity
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
    
    
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



@end
