//
//  Rock_Buster_Game_Scene_Tests.m
//  Rock Buster
//
//  Created by Josh Wisenbaker on 2/6/14.
//  Copyright (c) 2014 Me. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JRWGameScene.h"

@interface Rock_Buster_Game_Scene_Tests : XCTestCase
@property JRWGameScene *gameScene;
@property SKNode *missile;
@end

@implementation Rock_Buster_Game_Scene_Tests

- (void)setUp
{
    [super setUp];
    _gameScene = [[JRWGameScene alloc] initWithSize:CGSizeMake(1024, 720)];
    _missile = [_gameScene addMissile];
}

- (void)tearDown
{
    self.gameScene = nil;
    [super tearDown];
    
}

- (void)testCanCreateGameScene
{
    XCTAssertNotNil(self.gameScene, @"Can't create the game scene");
}

- (void)testCanSetGameSceneSize {
    XCTAssertEqual(self.gameScene.size, CGSizeMake(1024, 720), @"Game scene size isn't what was expected");
}

- (void)testConformsToSKPhysicsContactDelegate {
    XCTAssertTrue([self.gameScene conformsToProtocol:@protocol(SKPhysicsContactDelegate)], @"The game sceen needs to conform to the SKPhysicsContactDelegate protocol");
}

- (void)testAddMissile {
    XCTAssertNotNil(self.missile, @"Can't add a missile.");
}

- (void)testMissileHasPhysicsBody {
    XCTAssertNotNil(self.missile.physicsBody, @"Missile is missing it's physics body");
}


@end
