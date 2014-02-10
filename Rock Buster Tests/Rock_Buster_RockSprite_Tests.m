//
//  Rock_Buster_RockSprite_Tests.m
//  Rock Buster
//
//  Created by Josh Wisenbaker on 2/10/14.
//  Copyright (c) 2014 Me. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JRWRockSprite.h"

@interface Rock_Buster_RockSprite_Tests : XCTestCase
@property JRWRockSprite *rock;
@end

@implementation Rock_Buster_RockSprite_Tests

- (void)setUp
{
    [super setUp];
    _rock = [JRWRockSprite createRandomRock];
}

- (void)tearDown
{
    self.rock = nil;
    [super tearDown];
}

- (void)testCanCreateRockSprite {
    XCTAssertNotNil(self.rock, @"Couldn't create rock sprite");
}



@end
