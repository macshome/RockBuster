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
    
    //  Preload the textures
    SKTextureAtlas *artAtlas = [SKTextureAtlas atlasNamed:@"art"];
    [artAtlas preloadWithCompletionHandler:^{
        NSLog(@"Loaded art atlas");
    }];
    
    /* Pick a size for the scene
     Start with the current main display size.
     */
    NSInteger width = [[NSScreen mainScreen] frame].size.width;
    NSInteger height = [[NSScreen mainScreen] frame].size.height;
    JRWTitleScene *scene = [JRWTitleScene sceneWithSize:CGSizeMake(width, height)];

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
