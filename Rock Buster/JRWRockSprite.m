//
//  JRWRockSprite.m
//  Rock Buster
//
//  Created by Josh Wisenbaker on 12/18/13.
//  Copyright (c) 2013 Me. All rights reserved.
//

#import "JRWRockSprite.h"
#import "JRWGameScene.h"



static inline int randRock(int high) {
    return arc4random() % high;
}


@implementation JRWRockSprite

+ (instancetype)createRandomRock {
    //  We have 5 rock types, pick a random one.
    NSString *textureName = [NSString stringWithFormat:@"asteroid_%i", randRock(5)];
    JRWRockSprite *rock = [JRWRockSprite spriteNodeWithTexture:[SKTexture textureWithImageNamed:textureName]];
    
    rock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rock.size];
    rock.physicsBody.categoryBitMask = RBCasteroidCategory;
    rock.physicsBody.collisionBitMask = (RBCasteroidCategory | RBCshipCategory);
    rock.physicsBody.contactTestBitMask = (RBCasteroidCategory | RBCmissileCategory | RBCshipCategory);
    rock.physicsBody.usesPreciseCollisionDetection = YES;
    rock.physicsBody.mass = 3;
    rock.physicsBody.angularDamping = 0.0;
    
    rock.name = textureName;
  
    return rock;
}




@end
