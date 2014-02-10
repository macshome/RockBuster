//
//  Rock_Buster_HUDSprite_Tests.m
//  Rock Buster
//
//  Created by Josh Wisenbaker on 2/9/14.
//  Copyright (c) 2014 Me. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JRWHUDSprite.h"

@interface Rock_Buster_HUDSprite_Tests : XCTestCase
@property JRWHUDSprite *HUD;
@end

@implementation Rock_Buster_HUDSprite_Tests

- (void)setUp
{
    [super setUp];
    _HUD = [JRWHUDSprite createHUDforFrame:CGRectMake(0, 0, 1024, 768)];
}

- (void)tearDown
{
    self.HUD = nil;
    [super tearDown];
}

- (void)testCanCreateHUDSprite
{
    XCTAssertNotNil(self.HUD, @"Can't create the HUD sprite");
}

- (void)testCanSetLevel {
    self.HUD.level = 42;
    XCTAssertTrue(self.HUD.level == 42, @"Expected level to be equal to 42");
}

- (void)testCanSetScore {
    self.HUD.score = 1138;
    XCTAssertTrue(self.HUD.score == 1138, @"Expected score to be equal to 1138");
}

- (void)testCanSetHyperspaceOK {
    self.HUD.hyperspaceOK = YES;
    XCTAssertTrue(self.HUD.hyperspaceOK, @"Expected hyperspaceOK to be true");
}

- (void)testCanResetHyperspaceTimer {
    self.HUD.hyperspaceOK = YES;
    [self.HUD resetHyperspaceTimer];
    XCTAssertFalse(self.HUD.hyperspaceOK, @"Expected hyperspaceOK to be reset to false");
    
}

@end
