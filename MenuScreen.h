//
//  MenuScreen.h
//  RedBallSpriteKit
//
//  Created by Lee Warren on 20/07/2014.
//  Copyright (c) 2014 Lee Warren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface MenuScreen : SKScene {
    
    SKAction *makeGreenBalls; // this actions call the addGreenBall fuction and adds the ball to the view
    SKSpriteNode *greenBall; // these are the actuall green balls
    
    
    //saving highscores and stuff (whether or not to show the tutorial screen)
    NSUserDefaults *defaults;
    
    SKLabelNode *greenBallInfoLabel;//the tutorial showed on the screen - greenball
    SKLabelNode *whiteBallInfoLabel;//the tutorial showed on the screen - whiteballs (powerups)
    SKSpriteNode *whiteBallPicture;//the tutorial showed on the screen - whiteballs all in one picture
    
    SKLabelNode *returnToMenu;
    SKLabelNode *removeAds;

    
}

@end
