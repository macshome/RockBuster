//
//  JRWAppDelegate.m
//  Rock Buster
//
//  Created by Josh Wisenbaker on 12/18/13.
//  Copyright (c) 2013 Me. All rights reserved.
//

#import "JRWAppDelegate.h"
#import "JRWTitleScene.h"
#import "JRWGameScene.h"

@implementation JRWAppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    /* Pick a size for the scene */
    JRWTitleScene *scene = [JRWTitleScene sceneWithSize:CGSizeMake(1024, 768)];

    /* Set the scale mode to scale to fit the window */
    scene.scaleMode = SKSceneScaleModeAspectFit;

    [self.skView presentScene:scene];

#if DEBUG
    self.skView.showsFPS = YES;
    self.skView.showsNodeCount = YES;
#endif
    
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
