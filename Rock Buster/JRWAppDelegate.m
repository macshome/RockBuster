//
//  JRWAppDelegate.m
//  Rock Buster
//
//  Created by Josh Wisenbaker on 12/18/13.
//  Copyright (c) 2013 Me. All rights reserved.
//

#import "JRWAppDelegate.h"
#import "JRWMyScene.h"

@implementation JRWAppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    /* Pick a size for the scene */
    SKScene *scene = [JRWMyScene sceneWithSize:CGSizeMake(1024, 768)];

    /* Set the scale mode to scale to fit the window */
    scene.scaleMode = SKSceneScaleModeAspectFit;

    [self.skView presentScene:scene];

    self.skView.showsFPS = YES;
    self.skView.showsNodeCount = YES;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
