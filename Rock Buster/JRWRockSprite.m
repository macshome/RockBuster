//
//  JRWRockSprite.m
//  Rock Buster
//
//  Created by Josh Wisenbaker on 12/18/13.
//  Copyright (c) 2013 Me. All rights reserved.
//

#import "JRWRockSprite.h"
#import "JRWGameScene.h"


//  Just trying this to see if performance improves
static inline int randRock(int high) {
    return arc4random() % high;
}


@implementation JRWRockSprite // COV_NF_LINE



+ (instancetype)createRandomRock {
    //  We have 5 rock types, pick a random one.
    JRWRockSprite *rock = [self createRockWithSize:randRock(5)];
    return rock;
}

+ (instancetype)createRockWithSize:(RBrockType)rockType {
    JRWRockSprite *rock = [JRWRockSprite spriteNodeWithTexture:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"asteroid_%li", rockType]]];
    
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
    
    rock.name = [@(rockType) stringValue];
    
    return rock;
}


@end
