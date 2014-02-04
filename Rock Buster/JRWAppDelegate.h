//
//  JRWAppDelegate.h
//  Rock Buster
//

//  Copyright (c) 2013 Me. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SpriteKit/SpriteKit.h>

@interface JRWAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet SKView *skView;

@property SKTextureAtlas *artAtlas;

@end
