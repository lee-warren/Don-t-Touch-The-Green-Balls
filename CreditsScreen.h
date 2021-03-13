//
//  CreditsScreen.h
//  Don't Touch The Green Balls
//
//  Created by Lee Warren on 29/07/2014.
//  Copyright (c) 2014 Lee Warren. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface CreditsScreen : SKScene <SKPhysicsContactDelegate> {
    
    
    SKAction *makeGreenBalls; // this actions call the addGreenBall fuction and adds the ball to the view
    SKSpriteNode *greenBall; // these are the actuall green balls

    
    SKLabelNode *returnToMenu;
    SKLabelNode *restorePurchase;
    
    
    SKSpriteNode *creditsBar;
    SKSpriteNode *creditsBox;
    
    SKSpriteNode *downloadOtherApp;
    NSURL *myOtherApps;
    
    SKSpriteNode *likeFacebookPage;
    NSURL *myFacebookPage;
    
    SKSpriteNode *musicReference;
    
    
    
}

@end
