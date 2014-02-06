//
//  Rock_Buster_Title_Scene_Tests.m
//  Rock Buster
//
//  Created by Josh Wisenbaker on 2/5/14.
//  Copyright (c) 2014 Me. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JRWTitleScene.h"

@interface Rock_Buster_Title_Scene_Tests : XCTestCase
@property JRWTitleScene *titleScene;
@end

@implementation Rock_Buster_Title_Scene_Tests

- (void)setUp
{
    [super setUp];
    _titleScene = [JRWTitleScene sceneWithSize:CGSizeMake(1024, 720)];
    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testTitleSceneExists {
    XCTAssertNotNil(self.titleScene, @"Couldn't init the title secene");
}

- (void)testCanSetTitleSceneSize {
    XCTAssertEqual(self.titleScene.size, CGSizeMake(1024, 720), @"Title scene size wasn't set as expected");
}



@end
