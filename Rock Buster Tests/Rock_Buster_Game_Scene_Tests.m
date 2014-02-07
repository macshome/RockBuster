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
@end

@implementation Rock_Buster_Game_Scene_Tests

- (void)setUp
{
    [super setUp];
    _gameScene = [[JRWGameScene alloc] initWithSize:CGSizeMake(1024, 720)];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.gameScene = nil;
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


@end
