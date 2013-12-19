//
//  JRWRockSprite.m
//  Rock Buster
//
//  Created by Josh Wisenbaker on 12/18/13.
//  Copyright (c) 2013 Me. All rights reserved.
//

#import "JRWRockSprite.h"



static inline int randRock(int high) {
    return arc4random() % high;
}


@implementation JRWRockSprite

+ (instancetype)createRandomRock {
    //  We have 5 rock types, pick a random one.
    JRWRockSprite *rock = [JRWRockSprite spriteNodeWithTexture:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"asteroid_%i", randRock(4)]]];
    return rock;
}

- (id)breakRock {
    //  Which rock is it that we have?
    //  If it's big convert to two mediums
    //  if it's medium make 4 tiny
    //  if it's tiny it's dead
    return nil;
}


@end
