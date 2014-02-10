//
//  Rock_Buster_ShipSprite_Tests.m
//  Rock Buster
//
//  Created by Josh Wisenbaker on 2/9/14.
//  Copyright (c) 2014 Me. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JRWShipSprite.h"

@interface Rock_Buster_ShipSprite_Tests : XCTestCase
@property JRWShipSprite *ship;
@end

@implementation Rock_Buster_ShipSprite_Tests

- (void)setUp
{
    [super setUp];
    _ship = [JRWShipSprite createShip];
    _ship.health = 100;
}

- (void)tearDown
{
    self.ship = nil;
    [super tearDown];
}

- (void)testCanCreateShip
{
    XCTAssertNotNil(self.ship, @"Couldn't create a new ship");
}

- (void)testCanGetHealth {
    XCTAssertTrue(self.ship.health == 100, @"Expected health to be 100");
}

- (void)testCanDamageShip {
    [self.ship applyDamage:10];
    XCTAssertTrue(self.ship.health == 90, @"Expected health to decrease to 90");
}



@end
