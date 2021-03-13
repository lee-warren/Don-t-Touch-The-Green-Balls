//
//  MenuScreen.m
//  RedBallSpriteKit
//
//  Created by Lee Warren on 20/07/2014.
//  Copyright (c) 2014 Lee Warren. All rights reserved.
//

#import "MenuScreen.h"
#import "MainGame.h"
#import "CreditsScreen.h"
#import "InAppManager.h"

@interface MenuScreen ()
@property BOOL contentCreated;
@end

@implementation MenuScreen

- (void)didMoveToView: (SKView *) view
{
    if (!self.contentCreated)
    {
        defaults = [NSUserDefaults standardUserDefaults];
        
        [self createSceneContents];
        self.contentCreated = YES;
        
    }
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor blackColor];
    //self.scaleMode = SKSceneScaleModeAspectFit;
    
    [self addChild: [self playGameNode]];
    
    self.physicsWorld.gravity = CGVectorMake(0.0f, -2.8f);
    
    //makes green balls fall from the top just top make it look better
    makeGreenBalls = [SKAction sequence: @[
                                           [SKAction performSelector:@selector(addGreenBall) onTarget:self],
                                           [SKAction waitForDuration:0.2 withRange:0.25]
                                           ]];
    [self runAction: [SKAction repeatActionForever:makeGreenBalls]];
    
    returnToMenu = [SKLabelNode labelNodeWithFontNamed:@"Default"];
    returnToMenu.text = [NSString stringWithFormat:@"About"];
    returnToMenu.fontSize = 50;
    returnToMenu.fontColor = [SKColor whiteColor];
    returnToMenu.position = CGPointMake(self.size.width/2, self.size.height/10
                                        );
    returnToMenu.zPosition = 1.0;
    returnToMenu.name = @"MenuButton";
    [self addChild:returnToMenu];

    //remove adds button
    if ( [[InAppManager sharedManager]isFeature1PurchasedAlready] == NO) {
        //ads have not yet been removed
        
        removeAds = [SKLabelNode labelNodeWithFontNamed:@"Default"];
        removeAds.text = [NSString stringWithFormat:@"Remove Ads"];
        removeAds.fontSize = 50;
        removeAds.fontColor = [SKColor whiteColor];
        removeAds.position = CGPointMake(self.size.width/2, returnToMenu.position.y + self.size.height/10
                                            );
        removeAds.zPosition = 1.0;
        removeAds.name = @"RemoveAdsButton";
        [self addChild:removeAds];
        
    }
    
    
}

- (SKSpriteNode *)playGameNode
{
    SKSpriteNode *playGame = [[SKSpriteNode alloc] initWithImageNamed:@"Game Name.png"];
    playGame.xScale = self.size.width / playGame.size.width;
    playGame.yScale = playGame.xScale;
    playGame.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)/2*3);
    playGame.zPosition = 1;
    playGame.name = @"GameName";
    
    SKLabelNode *touchScreen = [self touchScreenLabel];
    touchScreen.position = CGPointMake(0, -playGame.size.height/5*4);
    [playGame addChild:touchScreen];
    
    
    return playGame;
    
}

- (SKLabelNode *)touchScreenLabel
{
    
    SKLabelNode *touchLabel = [SKLabelNode labelNodeWithFontNamed:@"Default"];
    touchLabel.text = @"Tap the screen to play";
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

static inline CGFloat skRandf() {
    return rand() / (CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high) {
    return skRandf() * (high - low) + low;
}

- (void)addGreenBall
{
    greenBall = [[SKSpriteNode alloc] initWithImageNamed:@"Green Ball.png"];
    greenBall.size=CGSizeMake(self.size.width/15/5 * 4, self.size.width/15/5 * 4);
    greenBall.position = CGPointMake(skRand(0, self.size.width), self.size.height + 50);
    greenBall.name = @"greenBall";
    greenBall.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:greenBall.size.height/2];
    greenBall.physicsBody.usesPreciseCollisionDetection = YES;
    
    [self addChild:greenBall];
}

- (SKSpriteNode *)tutorialStuffNode
{
    SKSpriteNode *tutorialStuffHolder = [[SKSpriteNode alloc] init];
    tutorialStuffHolder.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    tutorialStuffHolder.zPosition = 1;
    
    greenBallInfoLabel = [SKLabelNode labelNodeWithFontNamed:@"Default"];
    greenBallInfoLabel.text = [NSString stringWithFormat:@"Green balls are dangerous, avoid them to survive"];
    greenBallInfoLabel.fontSize = 30;
    greenBallInfoLabel.fontColor = [SKColor whiteColor];
    greenBallInfoLabel.position = CGPointMake(self.size.width/2, self.size.height
                                      /2 - greenBallInfoLabel.frame.size.height*2);
    greenBallInfoLabel.zPosition = 1.0;
    [self addChild:greenBallInfoLabel];
    
    whiteBallInfoLabel = [SKLabelNode labelNodeWithFontNamed:@"Default"];
    whiteBallInfoLabel.text = [NSString stringWithFormat:@"White balls are good, try to hit them"];
    whiteBallInfoLabel.fontSize = 30;
    whiteBallInfoLabel.fontColor = [SKColor whiteColor];
    whiteBallInfoLabel.position = CGPointMake(greenBallInfoLabel.position.x, greenBallInfoLabel.position.y - greenBallInfoLabel.frame.size.height*3);
    whiteBallInfoLabel.zPosition = 1.0;
    [self addChild:whiteBallInfoLabel];
    
    return tutorialStuffHolder;
}

-(void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:@"greenBall" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y < 0)
            [node removeFromParent];
    }];
}

- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
         
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    //if menu button is touched go to menu
    if ([node.name isEqualToString:@"MenuButton"]) {
        //do whatever...
        SKScene *creditsScreen  = [[CreditsScreen alloc] initWithSize:self.size];
        SKTransition *doors = [SKTransition crossFadeWithDuration:0.6];
        [self.view presentScene:creditsScreen transition:doors];
        
    }else if ([node.name isEqualToString:@"RemoveAdsButton"]) {
        
        //remove the ads
        [[InAppManager sharedManager]buyFeature1];
        [self runAction:[SKAction waitForDuration:10] completion:^{
            if( [[InAppManager sharedManager] isFeature1PurchasedAlready] == YES) {
                [removeAds removeFromParent];
            }
        }];
         
    } else {
        
        //screen was randomly tapped, play again
        SKNode *helloNode = [self childNodeWithName:@"GameName"];
        if (helloNode != nil)
        {
            helloNode.name = nil;
            SKAction *moveUp = [SKAction moveToY:self.size.height - 200 duration:0.5];
            //SKAction *zoom = [SKAction scaleTo: 1.5 duration: 0.25];
            SKAction *pause = [SKAction waitForDuration: 0.3];
            SKAction *fadeAway = [SKAction fadeOutWithDuration: 0.15];
            SKAction *remove = [SKAction removeFromParent];
            SKAction *moveSequence = [SKAction sequence:@[moveUp, pause, fadeAway, remove]];
            [helloNode runAction: moveSequence completion:^{
                
                SKScene *mainGame  = [[MainGame alloc] initWithSize:self.size];
                SKTransition *doors = [SKTransition crossFadeWithDuration:0.6];
                [self.view presentScene:mainGame transition:doors];
                
                //use this code tho create tutorial screen if player hasn't played before
                //if ([defaults boolForKey:@"playedBefore"] == true){
                //SKScene *mainGame  = [[MainGame alloc] initWithSize:self.size];
                //SKTransition *doors = [SKTransition crossFadeWithDuration:0.6];
                //[self.view presentScene:mainGame transition:doors];
                // } else { //havent played before, go to tutorial screen
                //[self addChild: [self tutorialStuffNode]];
                //}
            }];
        }
    }
    }
}

@end
