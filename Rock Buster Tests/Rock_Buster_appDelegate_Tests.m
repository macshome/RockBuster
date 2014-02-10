//
//  Rock_Buster_Tests.m
//  Rock Buster Tests
//
//  Created by Josh Wisenbaker on 2/4/14.
//  Copyright (c) 2014 Me. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JRWAppDelegate.h"

@interface Rock_Buster_appDelegate_Tests : XCTestCase
@property NSApplication *app;
@property JRWAppDelegate *appDelegate;

@end

@implementation Rock_Buster_appDelegate_Tests

- (void)setUp
{
    [super setUp];
    _app = NSApp;
    _appDelegate = (JRWAppDelegate *)[_app delegate];
    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    self.app = nil;
    self.appDelegate = nil;
    [super tearDown];
}

//  Basic app launch tests
- (void)testAppLaunched
{
    XCTAssertNotNil(self.app, @"Could not find shared application");
}

- (void)testAppDelegate {
    XCTAssertNotNil(self.appDelegate, @"Could not find application delegate");
}

- (void)testConformsToNSApplicationDelegate {
    XCTAssertTrue([self.appDelegate conformsToProtocol:@protocol(NSApplicationDelegate)], @"The game sceen needs to conform to the NSApplicationDelegate protocol");
}

- (void)testWindowCreation {
    XCTAssertNotNil(self.appDelegate.window, @"Could not create window");
}

//  Texture atlas loading test
- (void)testAtlasLoaded {
    XCTAssertNotNil(self.appDelegate.artAtlas, @"Could not load art atlas");
}

//  SKView Tests
- (void)testSKViewCreation {
    XCTAssertNotNil(self.appDelegate.skView, @"Could not create SKView");
}

//  SKScene tests
- (void)testSceneCreation {
    XCTAssertNotNil(self.appDelegate.skView.scene, @"Could not create scene for SKView");
}

- (void)testSceneScaleMode {
    XCTAssertEqual(self.appDelegate.skView.scene.scaleMode, SKSceneScaleModeAspectFit, @"Scaling mode is not set to SKSceneScaleModeAspectFit");
}

//  Application quit on close test
- (void)testWillAppCloseWithLastWindow {
    XCTAssertTrue([self.appDelegate applicationShouldTerminateAfterLastWindowClosed:self.app], @"App is not set to close with last window");
}


@end
