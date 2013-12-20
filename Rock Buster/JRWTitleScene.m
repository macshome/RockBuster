//
//  JRWMyScene.m
//  Rock Buster
//
//  Created by Josh Wisenbaker on 12/18/13.
//  Copyright (c) 2013 Me. All rights reserved.
//

#import "JRWTitleScene.h"
#import "JRWGameScene.h"



@interface JRWTitleScene ()

@property SKLabelNode *startTextNode;
@property BOOL contentCreated;

@end

@implementation JRWTitleScene

#pragma mark - Scene Setup Methods
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        return self;
    }
    return nil;
}

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents {
    
    /* Setup your scene here */
    self.backgroundColor = [SKColor blackColor];
    
    
    //  Add the start text
    [self addChild:[self addStartText]];
    
}


- (SKLabelNode *)addStartText {
    self.startTextNode = [SKLabelNode labelNodeWithFontNamed:@"Futura"];
    self.startTextNode.name = @"startText";
    self.startTextNode.text = @"Press 1 for One Player";
    self.startTextNode.fontSize = 42;
    self.startTextNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    return self.startTextNode;
    
}

- (void)presentGameScene {
    JRWGameScene *gameScene = [[JRWGameScene alloc] initWithSize:self.size];
    SKTransition *transition = [SKTransition doorwayWithDuration:1.0];
    [self.view presentScene:gameScene transition:transition];
}




#pragma mark - Key Press Handlers
- (void)keyDown:(NSEvent *)theEvent {
    NSString *characters = [theEvent charactersIgnoringModifiers];
    if ([characters length]) {
        for (int s = 0; s<[characters length]; s++) {
            unichar character = [characters characterAtIndex:s];
            switch (character) {
                case '1':
                    [self presentGameScene];
                    break;
            }
        }
    }
}

#pragma mark - Frame Updates
-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
