//
//  JRWHUDSprite.m
//  Rock Buster
//
//  Created by Josh Wisenbaker on 12/27/13.
//  Copyright (c) 2013 Me. All rights reserved.
//

#import "JRWHUDSprite.h"

@interface JRWHUDSprite ()
@property SKSpriteNode *hyperspaceBar;

@end

@implementation JRWHUDSprite

//  Add the HUD
- (instancetype)newHUDwithFrame:(CGRect)frameSize {
    JRWHUDSprite *hud = [[JRWHUDSprite alloc] init];
    hud.zPosition = 1;
    
    SKLabelNode *levelLabel =[SKLabelNode labelNodeWithFontNamed:@"Futura"];
    levelLabel.name = @"level";
    levelLabel.text = [NSString stringWithFormat:@"Level %@", self.level];
    levelLabel.fontSize = 24;
    levelLabel.position = CGPointMake(CGRectGetMinX(frameSize) + 50, CGRectGetMaxY(frameSize) -30);
    
    SKLabelNode *scoreLabel =[SKLabelNode labelNodeWithFontNamed:@"Futura"];
    scoreLabel.name = @"score";
    scoreLabel.text = [NSString stringWithFormat:@"Score: %@", self.score];
    scoreLabel.fontSize = 24;
    scoreLabel.position = CGPointMake(CGRectGetMaxX(frameSize) - 50, CGRectGetMaxY(frameSize) -30);
    
    
    self.hyperspaceBar = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(0, 21)];
    self.hyperspaceBar.name = @"hyperspaceBar";
    self.hyperspaceBar.anchorPoint = CGPointMake(0.0, 0.5);
    self.hyperspaceBar.position = CGPointMake(CGRectGetMidX(frameSize), CGRectGetMaxY(frameSize) - 20);
    SKLabelNode *hbarLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura"];
    hbarLabel.name = @"hyperspaceLabel";
    hbarLabel.text = @"Hyperdrive:";
    hbarLabel.fontSize = 24;
    hbarLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    hbarLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    [self.hyperspaceBar addChild:hbarLabel];
    
    [hud addChild:levelLabel];
    [hud addChild:scoreLabel];
    [hud addChild:self.hyperspaceBar];
    
    return self;
    
}



- (void)updateHyperspaceTimer {
    self.hyperspaceBar.color = [SKColor redColor];
    SKAction *hyperspaceBarGrow = [SKAction resizeToWidth:100.0 duration:10.0];
    [self.hyperspaceBar runAction:hyperspaceBarGrow completion:^{
        self.hyperspaceOK = YES;
        self.hyperspaceBar.color = [SKColor greenColor];
    }];
    
}

//  Set the hyperspace timer back to 0
- (void)resetHyperspaceTimer {
    self.hyperspaceOK = NO;
    
    self.hyperspaceBar.color = [SKColor yellowColor];
    SKAction *hyperspaceBarShrink = [SKAction resizeToWidth:0.0 duration:0.25];
    [self.hyperspaceBar runAction:hyperspaceBarShrink completion:^{
        [self updateHyperspaceTimer];
    }];
    
    
}

@end
