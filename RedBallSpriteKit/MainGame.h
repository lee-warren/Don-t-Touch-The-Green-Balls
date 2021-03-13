//
//  SpaceshipScene.h
//  SpriteWalkthrough
//
//  Created by Lee Warren on 19/07/2014.
//  Copyright (c) 2014 Lee Warren. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MainGame : SKScene <SKPhysicsContactDelegate> {
    
    SKSpriteNode *redBall; // main player
    SKSpriteNode *body; //body of the main player
    SKSpriteNode *powerUpSpot; //part of the main player where the current power up being used goes
    SKSpriteNode *hitSpot; // shows whether or not the player is current invincible
    
    SKSpriteNode *movingBar; //bar which controls the main player (redBall)
    SKSpriteNode *movingBarRectangle; //the rectangle itself
    SKLabelNode *movingBarLabel; // shown when the game begins to show player how to move
    
    SKSpriteNode *menuBar; //bar which holds the score, lives, and powerups availiable
    SKSpriteNode *menuBox; //the box which the score, lives, and powerups availiable goes in
    SKLabelNode *scoreLabel;//the score shown on the screen
    int score; //the actual score
    SKSpriteNode *livesShow; //the lives shown on the screen
    int lives; //the actual amount of lives
    SKSpriteNode *powerUp1; // first power up
    SKSpriteNode *powerUp2; // second power up
    SKSpriteNode *powerUp3; // third power up

    
    SKAction *makeGreenBalls; // this actions call the addGreenBall fuction and adds the ball to the view
    SKSpriteNode *greenBall; // these are the actuall green balls
    SKAction *moveGreenBalls; //this action moves the green balls down the screen
    float smallRateGreenBallsAreMade; //this changes to increase the rate green balls are made - the minimal
    float bigRateGreenBallsAreMade; //this changes to increase the rate green balls are made - the maximum
    float speedOfTheGreenBalls; // this changes the speed the green balls move down the screen
    
    SKAction *makePowerUpBalls; // this actions call the addPowerUpBall fuction and adds the balls to the view
    SKSpriteNode *lifeBall; // these are the life balls
    // these are the power up balls
    SKSpriteNode *shieldBall; //creates a shield around the player making them invincible
    SKSpriteNode *timeBall; // slows down time for a period of time
    SKSpriteNode *shrinkBall; // shrinks the green balls for a period of time
    
    //power Up stuff
    BOOL usingPowerUp; // this gets turned on when power up is started and turned off once it finishes so that one one power up can get used at a time
    SKAction *shieldPower; // the action that makes the shield
    BOOL shieldOn; //changes collision of redball if shield has been added
    SKSpriteNode *theShield; //the shield itself
    SKAction *clockPower; // the action that make the time slow down
    BOOL clockOn; // this makes the speed of the green balls and rate the y are made go to slow values
    float currentSpeedOfTheGreenBalls; //this save the current speed so that after the power up is completed it can reutrn to normal
    float currentSmallRateGreenBallsAreMade; //this save the rate the balls are made so that after the power up is completed it can reutrn to normal
    SKAction *shrinkPower; // the action that make the green balls smaller
    BOOL shrinkOn; //make green balls smaller instead of normal size

    
    //collision stuff
    SKAction *flashWhite; // called when collision occurs
    SKAction *invinciblePower; // the action that is called when the red ball hits a green ball and you are invincible for 3 seconds
    SKLabelNode *collisionLabel; // shown when collision occurs to show player what happened
    
    //saving highscores and stuff
    NSUserDefaults *defaults;
    int highScore;
    
}



@end
