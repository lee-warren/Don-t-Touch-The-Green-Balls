//
//  GameOverScreen.h
//  Red Ball
//
//  Created by Lee Warren on 28/07/2014.
//  Copyright (c) 2014 Lee Warren. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameOverScreen : SKScene <SKPhysicsContactDelegate> {
    
    
    SKLabelNode *scoreLabel;//the score shown on the screen
    int currentScore;
    SKLabelNode *highScoreLabel;//the highscore shown on the screen
    int highScore;
    
    //menubar (to hold icons)
    SKSpriteNode *menuBar; //bar which holds the share and home icons
    SKSpriteNode *menuBox; //the box which the stuff goes in
    
    SKSpriteNode *houseIcon; //the house icon that when clicked will send you home

    
    //saving highscores and stuff
    NSUserDefaults *defaults;

}


@end
