//
//  Rock_Buster_Tests.m
//  Rock Buster Tests
//
//  Created by Josh Wisenbaker on 2/4/14.
//  Copyright (c) 2014 Me. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JRWAppDelegate.h"

@interface Rock_Buster_Tests : XCTestCase
@property NSApplication *app;

@end

@implementation Rock_Buster_Tests

- (void)setUp
{
    [super setUp];
    _app = [NSApplication sharedApplication];
    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.app = nil;
}

- (void)testAppLaunched
{
    XCTAssertNotNil(self.app, @"Could not find shared application");
}



@end
