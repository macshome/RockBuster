//
//  JRWHUDSprite.m
//  Rock Buster
//
//  Created by Josh Wisenbaker on 1/24/14.
//  Copyright (c) 2014 Me. All rights reserved.
//

#import "JRWHUDSprite.h"

@interface JRWHUDSprite ()

@property SKSpriteNode *hyperspaceBar;
@property SKSpriteNode *healthBar;

@end

@implementation JRWHUDSprite

//  Create the HUD
+ (instancetype)createHUDforFrame:(CGRect)rect {
    JRWHUDSprite *hud = [[JRWHUDSprite alloc] init];
    
    //  Set score to 0 and level to 1
    hud.score = 0;
    hud.level = 1;
    
    //  We haven't counted down hyperspace charge yet
    hud.hyperspaceOK = NO;
    
    //  Put the HUD above the play field so that things can move under it
    hud.zPosition = 1;
    hud.name = @"HUD";
    
    //  Level label
    SKLabelNode *levelLabel =[SKLabelNode labelNodeWithFontNamed:@"Futura"];
    levelLabel.name = @"level";
    levelLabel.text = [NSString stringWithFormat:@"Level %ld", (long)hud.level];
    levelLabel.fontSize = 24;
    levelLabel.position = CGPointMake(CGRectGetMaxX(rect) - 30, CGRectGetMaxY(rect) -30);
    levelLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    
    //  Score label
    SKLabelNode *scoreLabel =[SKLabelNode labelNodeWithFontNamed:@"Futura"];
    scoreLabel.name = @"score";
    scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)hud.score];
    scoreLabel.fontSize = 24;
    scoreLabel.position = CGPointMake(CGRectGetMinX(rect) + 30, CGRectGetMaxY(rect) -30);
    scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    
    //  Hyperspace bar
    hud.hyperspaceBar = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(0, 21)];
    hud.hyperspaceBar.name = @"hyperspaceBar";
    hud.hyperspaceBar.anchorPoint = CGPointMake(0.0, 0.5);
    hud.hyperspaceBar.position = CGPointMake(CGRectGetMaxX(rect) - 400, CGRectGetMaxY(rect) - 25);
    SKLabelNode *hbarLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura"];
    hbarLabel.name = @"hyperspaceLabel";
    hbarLabel.text = @"Hyperdrive:";
    hbarLabel.fontSize = 24;
    hbarLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    hbarLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    [hud.hyperspaceBar addChild:hbarLabel];
    
    //  Health bar
    hud.healthBar = [SKSpriteNode spriteNodeWithColor:[SKColor greenColor] size:CGSizeMake(100, 21)];
    hud.healthBar.name = @"healthBar";
    hud.healthBar.anchorPoint = CGPointMake(0.0, 0.5);
    hud.healthBar.position = CGPointMake(CGRectGetMinX(rect) + 400, CGRectGetMaxY(rect) - 25);
    SKLabelNode *healthBarLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura"];
    healthBarLabel.name = @"healthBarLabel";
    healthBarLabel.text = @"Shields:";
    healthBarLabel.fontSize = 24;
    healthBarLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    healthBarLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    [hud.healthBar addChild:healthBarLabel];
    
    //  Add the components to the HUD node
    [hud addChild:levelLabel];
    [hud addChild:scoreLabel];
    [hud addChild:hud.hyperspaceBar];
    [hud addChild:hud.healthBar];
    
    //  Return the hud
    return hud;
}

#pragma mark - Hyperspace UI Methods

//  Make the hyperspace bar grow over 10 seconds then enable hyperspace
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

#pragma mark - Health Bar Methods
//  Shrink the bar by the proportional ammount of damage
- (void)shrinkHealthBar:(CGFloat)ammount {
    SKAction *healthBarShrink = [SKAction resizeToWidth:ammount duration:0.25];
    [self.healthBar runAction:healthBarShrink];
    
    // Set the color according to how bad things are
    if (self.healthBar.size.width < 75.0) {
        self.healthBar.color = [SKColor yellowColor];
    }
    
    if (self.healthBar.size.width < 50) {
        self.healthBar.color = [SKColor redColor];
        SKAction *fadeOut = [SKAction fadeOutWithDuration:0.3];
        SKAction *fadeIn = [SKAction fadeInWithDuration:0.3];
        SKAction *blink = [SKAction sequence:@[fadeOut, fadeIn]];
        [self.healthBar runAction:[SKAction repeatActionForever:blink] withKey:@"blinking"];
    }
}

//  Reset the health bar
- (void)resetHealthBar {
    [self.healthBar removeAllActions];
    SKAction *resetHealthBar = [SKAction resizeToWidth:100.0 duration:1.0];
    [self.healthBar runAction:resetHealthBar];
    self.healthBar.color = [SKColor greenColor];
    
}


@end
