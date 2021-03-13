//
//  GameOverScreen.m
//  Red Ball
//
//  Created by Lee Warren on 28/07/2014.
//  Copyright (c) 2014 Lee Warren. All rights reserved.
//

#import "GameOverScreen.h"
#import "MainGame.h"
#import "MenuScreen.h"

@interface GameOverScreen ()
@property BOOL contentCreated;
@end

@implementation GameOverScreen


- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        self.physicsWorld.contactDelegate = self;
        
        defaults = [NSUserDefaults standardUserDefaults];

        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    
    self.backgroundColor = [SKColor blackColor];
    //self.scaleMode = SKSceneScaleModeAspectFill;
    
    currentScore = (int)[defaults integerForKey:@"currentScore"];
    highScore = (int)[defaults integerForKey:@"highScore"];
    
    [self addChild: [self gameOverNode]];
    
    [self addChild: [self scoreStuffNode]];
    
    menuBar = [self menuBar];
    menuBar.position = CGPointMake(self.size.width/2 ,self.size.height - menuBar.size.height/4*3);
    [self addChild:menuBar];



}

- (SKSpriteNode *)gameOverNode
{
    SKSpriteNode *gameOver = [[SKSpriteNode alloc] initWithImageNamed:@"GameOverLabel.png"];
    gameOver.xScale = self.size.width / gameOver.size.width;
    gameOver.yScale = gameOver.xScale;
    gameOver.position = CGPointMake(CGRectGetMidX(self.frame),self.frame.size.height/20*14);
    gameOver.zPosition = 1;
    gameOver.name = @"gameOverName";
    
    SKLabelNode *touchScreen = [self touchScreenLabel];
    touchScreen.position = CGPointMake(0, -gameOver.size.height/5*4);
    [gameOver addChild:touchScreen];

    
    return gameOver;
    
}

- (SKLabelNode *)touchScreenLabel
{
    
    SKLabelNode *touchLabel = [SKLabelNode labelNodeWithFontNamed:@"Default"];
    touchLabel.text = @"Tap the screen to play again";
    touchLabel.color = [SKColor whiteColor];
    touchLabel.fontSize = 50;
    touchLabel.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    //touchLabel.name = @"helloNode";
    
    SKAction *blink = [SKAction sequence:@[
                                           [SKAction fadeOutWithDuration:1.0],
                                           [SKAction fadeInWithDuration:1.0]]];
    SKAction *blinkForever = [SKAction repeatActionForever:blink];
    [touchLabel runAction: blinkForever];
    
    return touchLabel;
}

- (SKSpriteNode *)scoreStuffNode
{
    SKSpriteNode *scoreStuffHolder = [[SKSpriteNode alloc] init];
    scoreStuffHolder.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    scoreStuffHolder.zPosition = 1;
    
    scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Default"];
    scoreLabel.text = [NSString stringWithFormat:@"Score: %d",currentScore];
    scoreLabel.fontSize = 75;
    scoreLabel.fontColor = [SKColor whiteColor];
    scoreLabel.position = CGPointMake(self.size.width/2, self.size.height
                                      /2 - scoreLabel.frame.size.height*2);
    scoreLabel.zPosition = 1.0;
    [self addChild:scoreLabel];
    
    highScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Default"];
    highScoreLabel.text = [NSString stringWithFormat:@"Highscore: %d",highScore];
    highScoreLabel.fontSize = 75;
    highScoreLabel.fontColor = [SKColor whiteColor];
    highScoreLabel.position = CGPointMake(scoreLabel.position.x, scoreLabel.position.y - scoreLabel.frame.size.height/2*3
                                          );
    highScoreLabel.zPosition = 1.0;
    [self addChild:highScoreLabel];
    
    return scoreStuffHolder;
}

- (SKSpriteNode *)menuBar
{
    menuBox = [[SKSpriteNode alloc] init];
    menuBox.size = CGSizeMake(self.size.width, self.size.height/10);
    
    houseIcon = [[SKSpriteNode alloc] initWithImageNamed:@"House Icon.png"];
    houseIcon.size = CGSizeMake(menuBox.size.height, menuBox.size.height);

    //houseIcon.xScale = menuBox.size.height / houseIcon.size.width;
    //houseIcon.yScale = menuBox.size.height / houseIcon.size.height;
    houseIcon.position =CGPointMake(- menuBox.size.width/2 + houseIcon.size.width, 0);
    houseIcon.zPosition = 1.0;
    houseIcon.name = @"MenuButton";
    
    [menuBox addChild:houseIcon];
    
    
    
    
    return menuBox;
    
}

- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        
        
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];
        
        //if menu button is touched go to menu
        if ([node.name isEqualToString:@"MenuButton"]) {
            //do whatever...
            SKScene *menuScreen  = [[MenuScreen alloc] initWithSize:self.size];
            SKTransition *doors = [SKTransition crossFadeWithDuration:0.6];
            [self.view presentScene:menuScreen transition:doors];
            
        }else {
        
        //screen was randomly tapped, play again
    
        SKScene *mainGame  = [[MainGame alloc] initWithSize:self.size];
        SKTransition *doors = [SKTransition crossFadeWithDuration:0.6];
        [self.view presentScene:mainGame transition:doors];
            
        }
    }
}



@end
