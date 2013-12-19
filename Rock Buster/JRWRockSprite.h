//
//  JRWRockSprite.h
//  Rock Buster
//
//  Created by Josh Wisenbaker on 12/18/13.
//  Copyright (c) 2013 Me. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface JRWRockSprite : SKSpriteNode

+ (instancetype)createRandomRock;

- (id)breakRock;

@end
