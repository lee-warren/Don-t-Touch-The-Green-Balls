//
//  SpaceshipScene.m
//  SpriteWalkthrough
//
//  Created by Lee Warren on 19/07/2014.
//  Copyright (c) 2014 Lee Warren. All rights reserved.
//

#import "MainGame.h"
#import "GameOverScreen.h"

@interface MainGame ()
@property BOOL contentCreated;
@end

@implementation MainGame

static const uint32_t redBallCategory = 0x1 << 0;
static const uint32_t greenBallCategory = 0x1 << 1;
static const uint32_t lifeBallCategory = 0x1 << 2;
static const uint32_t shieldBallCategory = 0x1 << 3;
static const uint32_t timeBallCategory = 0x1 << 4;
static const uint32_t shrinkBallCategory = 0x1 << 5;

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
    self.scaleMode = SKSceneScaleModeAspectFill;
    
    lives = 3;
    //highScore = [defaults integerForKey:@"highScore"];
    shieldOn = false;
    
    menuBar = [self menuBar];
    menuBar.position = CGPointMake(self.size.width/2 ,self.size.height - self.size.height/5/2);
    [self addChild:menuBar];

    redBall = [self redBall];
    redBall.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height / 3);
    redBall.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:body.size.height / 2];
    redBall.physicsBody.dynamic = YES;
    //collision stuff
    redBall.physicsBody.categoryBitMask = redBallCategory;
    [self addChild:redBall];
    
    movingBar = [self movingBar];
    movingBar.alpha = 0.25;
    movingBar.position = CGPointMake(self.size.width/2 , 125);
    [self addChild:movingBar];
    
    //gravity stuff
    //gravity = -2.8;
    self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
    
    //makes the enemy
    speedOfTheGreenBalls = 2.5;
    smallRateGreenBallsAreMade = 0.04;
    bigRateGreenBallsAreMade = smallRateGreenBallsAreMade + (smallRateGreenBallsAreMade/2);
    
    makeGreenBalls = [SKAction sequence: @[
                                                [SKAction performSelector:@selector(changeSpeedAndRate) onTarget:self],
                                                [SKAction performSelector:@selector(addGreenBall) onTarget:self]
                                                ]];
    //[self runAction: [SKAction repeatActionForever:makeGreenBalls]];
    [self runAction:makeGreenBalls];
    
    //make power up balls - both life and other power up
    makePowerUpBalls = [SKAction sequence: @[
                                             [SKAction waitForDuration:10 withRange:20],
                                             [SKAction performSelector:@selector(addPowerUpBall) onTarget:self]
                                           ]];
    [self runAction: [SKAction repeatActionForever:makePowerUpBalls]];
    
    //sets up what will happen later
    flashWhite = [SKAction sequence:@[
                                      [SKAction runBlock:^{
        self.backgroundColor = [SKColor whiteColor];
        [self runAction:[SKAction waitForDuration:0.1]completion:^{
            self.backgroundColor = [SKColor blackColor];
        }];
    }]]];
}

- (SKSpriteNode *)redBall
{
    body = [[SKSpriteNode alloc] initWithImageNamed:@"Red Ball.png" ];
    body.size=CGSizeMake(self.size.width/15, self.size.width/15);
    body.zPosition = 1;
    
    powerUpSpot = [[SKSpriteNode alloc] initWithImageNamed:@"Blank.png" ];
    powerUpSpot.size = body.size;
    powerUpSpot.zPosition = 2;
    [body addChild:powerUpSpot];
    
    hitSpot = [[SKSpriteNode alloc] initWithImageNamed:@"Blank.png" ];
    hitSpot.size = body.size;
    hitSpot.zPosition = 3;
    [body addChild:hitSpot];
    
    return body;
}

- (SKSpriteNode *)movingBar
{
    movingBarRectangle = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(self.size.width, self.size.height/8)];

    return movingBarRectangle;
}

- (SKSpriteNode *)menuBar
{
    menuBox = [[SKSpriteNode alloc] init];
    menuBox.size = CGSizeMake(self.size.width, self.size.height/9);
    
    
    scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Default"];
    scoreLabel.text = [NSString stringWithFormat:@"%d",score];
    scoreLabel.fontSize = 100;
    scoreLabel.fontColor = [SKColor whiteColor];
    scoreLabel.position = CGPointMake(0 , -livesShow.size.height/2);
    scoreLabel.zPosition = 1.0;
    //scoreLabel.position = menuBox.position;
    [menuBox addChild:scoreLabel];
    
    livesShow = [[SKSpriteNode alloc] initWithImageNamed:@"3Life"];
    livesShow.size=CGSizeMake(menuBox.size.width/4.5, menuBox.size.height/2);
    livesShow.zPosition = 1.0;
    livesShow.position = CGPointMake(-menuBox.size.width/3 +menuBox.size.width/12, livesShow.size.height/2);

    [menuBox addChild:livesShow];
    
    powerUp1 = [[SKSpriteNode alloc] initWithImageNamed:@"Blank"];
    powerUp1.size=CGSizeMake(menuBox.size.height/2, menuBox.size.height/2);
    powerUp1.zPosition = 1.0;
    powerUp1.position = CGPointMake( menuBox.size.width/3 - menuBox.size.width/12 - powerUp1.size.width, powerUp1.size.height/2);
    powerUp1.name = @"Blank";
    
    [menuBox addChild:powerUp1];
    
    powerUp2 = [[SKSpriteNode alloc] initWithImageNamed:@"Blank"];
    powerUp2.size=CGSizeMake(menuBox.size.height/2, menuBox.size.height/2);
    powerUp2.zPosition = 1.0;
    powerUp2.position = CGPointMake( menuBox.size.width/3 - menuBox.size.width/12, powerUp2.size.height/2);
    powerUp2.name = @"Blank";
    
    [menuBox addChild:powerUp2];
    
    powerUp3 = [[SKSpriteNode alloc] initWithImageNamed:@"Blank"];
    powerUp3.size=CGSizeMake(menuBox.size.height/2, menuBox.size.height/2);
    powerUp3.zPosition = 1.0;
    powerUp3.position = CGPointMake( menuBox.size.width/3 - menuBox.size.width/12 + powerUp3.size.width, powerUp3.size.height/2);
    powerUp3.name = @"Blank";
    
    [menuBox addChild:powerUp3];

    
    return menuBox;
    
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
    
    moveGreenBalls = [SKAction moveToY:0 - self.size.height/4  duration:speedOfTheGreenBalls];
    [greenBall runAction: moveGreenBalls];
    
    if (shrinkOn == YES) {
        greenBall.size=CGSizeMake(self.size.width/15/5 * 2, self.size.width/15/5 * 2);
    }
    
    greenBall.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:greenBall.size.height/2];
    greenBall.physicsBody.usesPreciseCollisionDetection = YES;
    greenBall.physicsBody.dynamic = YES;
    
    //collision stuff
    greenBall.physicsBody.categoryBitMask = greenBallCategory;
    greenBall.physicsBody.collisionBitMask = greenBallCategory | redBallCategory;
    greenBall.physicsBody.contactTestBitMask = greenBallCategory | redBallCategory;
    
    //add points to score
    score = score + 1;
    scoreLabel.text = [NSString stringWithFormat:@"%d",score];
    
    [self addChild:greenBall];
    
    [self runAction:[SKAction waitForDuration:smallRateGreenBallsAreMade withRange:bigRateGreenBallsAreMade] completion:^{
        [self runAction: makeGreenBalls];
    }];

    
}

- (void)changeSpeedAndRate
{
    if (clockOn == YES) {
        
        speedOfTheGreenBalls = 4.0;
        smallRateGreenBallsAreMade = 0.25;
        bigRateGreenBallsAreMade = smallRateGreenBallsAreMade + (smallRateGreenBallsAreMade/2);

    } else {
        
        // speeds up the rate greenballs are made and how long it takes them to reach the bottom
        speedOfTheGreenBalls = speedOfTheGreenBalls - (2500 - score)/3000;
        
        smallRateGreenBallsAreMade = smallRateGreenBallsAreMade - (2000 - score)/15000;
        bigRateGreenBallsAreMade = smallRateGreenBallsAreMade + (smallRateGreenBallsAreMade/2);
        
    }
    
    
    

}

- (void)addPowerUpBall
{
    
    int randomNumber = arc4random_uniform(4);
    switch(randomNumber) {
        case 0: //creates the life ball
            lifeBall = [[SKSpriteNode alloc] initWithImageNamed:@"Life Ball.png"];
            lifeBall.size=CGSizeMake(self.size.width/15/5 * 4, self.size.width/15/5 * 4);
            lifeBall.position = CGPointMake(skRand(0, self.size.width), self.size.height + 50);
            lifeBall.name = @"lifeBall";
            
            [lifeBall runAction:[SKAction moveToY:0 - self.size.height/4  duration:3.5]];
            lifeBall.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:lifeBall.size.height/2];
            lifeBall.physicsBody.usesPreciseCollisionDetection = YES;
            lifeBall.physicsBody.dynamic = YES;
            
            //collision stuff
            lifeBall.physicsBody.categoryBitMask = lifeBallCategory;
            lifeBall.physicsBody.collisionBitMask = lifeBallCategory | redBallCategory;
            lifeBall.physicsBody.contactTestBitMask = lifeBallCategory | redBallCategory;
            
            [self addChild:lifeBall];
            break;
        
        case 1: //creates the time ball
            timeBall = [[SKSpriteNode alloc] initWithImageNamed:@"Clock Power Up Ball.png"];
            timeBall.size=CGSizeMake(self.size.width/15/5 * 4, self.size.width/15/5 * 4);
            timeBall.position = CGPointMake(skRand(0, self.size.width), self.size.height + 50);
            timeBall.name = @"timeBall";
            
            [timeBall runAction:[SKAction moveToY:0 - self.size.height/4  duration:3.5]];
            timeBall.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:timeBall.size.height/2];
            timeBall.physicsBody.usesPreciseCollisionDetection = YES;
            timeBall.physicsBody.dynamic = YES;
            
            //collision stuff
            timeBall.physicsBody.categoryBitMask = timeBallCategory;
            timeBall.physicsBody.collisionBitMask = timeBallCategory | redBallCategory;
            timeBall.physicsBody.contactTestBitMask = timeBallCategory | redBallCategory;
            
            [self addChild:timeBall];
            break;
        
        case 2: // creates the shield ball
            shieldBall = [[SKSpriteNode alloc] initWithImageNamed:@"Shield Power Up Ball.png"];
            shieldBall.size=CGSizeMake(self.size.width/15/5 * 4, self.size.width/15/5 * 4);
            shieldBall.position = CGPointMake(skRand(0, self.size.width), self.size.height + 50);
            shieldBall.name = @"shieldBall";
            
            [shieldBall runAction:[SKAction moveToY:0 - self.size.height/4  duration:3.5]];
            shieldBall.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:shieldBall.size.height/2];
            shieldBall.physicsBody.usesPreciseCollisionDetection = YES;
            shieldBall.physicsBody.dynamic = YES;
            
            //collision stuff
            shieldBall.physicsBody.categoryBitMask = shieldBallCategory;
            shieldBall.physicsBody.collisionBitMask = shieldBallCategory | redBallCategory;
            shieldBall.physicsBody.contactTestBitMask = shieldBallCategory | redBallCategory;
            
            [self addChild:shieldBall];
            break;
            
        case 3: // creates the shrink ball
            shrinkBall = [[SKSpriteNode alloc] initWithImageNamed:@"Shrink Power Up Ball.png"];
            shrinkBall.size=CGSizeMake(self.size.width/15/5 * 4, self.size.width/15/5 * 4);
            shrinkBall.position = CGPointMake(skRand(0, self.size.width), self.size.height + 50);
            shrinkBall.name = @"shrinkBall";
            
            [shrinkBall runAction:[SKAction moveToY:0 - self.size.height/4  duration:3.5]];
            shrinkBall.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:shrinkBall.size.height/2];
            shrinkBall.physicsBody.usesPreciseCollisionDetection = YES;
            shrinkBall.physicsBody.dynamic = YES;
            
            //collision stuff
            shrinkBall.physicsBody.categoryBitMask = shrinkBallCategory;
            shrinkBall.physicsBody.collisionBitMask = shrinkBallCategory | redBallCategory;
            shrinkBall.physicsBody.contactTestBitMask = shrinkBallCategory | redBallCategory;
            
            [self addChild:shrinkBall];
            break;

    }

    //add points to score
    score = score + 1;
    scoreLabel.text = [NSString stringWithFormat:@"%d",score];
    
}

//-(void) update: ( CFTimeInterval )currentTime  {
    
    // Called before each frame is rendered
    
    //gravity becomes stronger
    //gravity = gravity - 0.0001;

    //self.physicsWorld.gravity = CGVectorMake(0.0f, gravity);
    
//}

-(void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:@"greenBall" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y < 0)
            [node removeFromParent];
    }];
    
    [self enumerateChildNodesWithName:@"lifeBall" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y < 0)
            [node removeFromParent];
    }];
    
    [self enumerateChildNodesWithName:@"powerBall" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y < 0)
            [node removeFromParent];
    }];
}

- (void) didBeginContact:(SKPhysicsContact *)contact
{
    SKSpriteNode *firstNode, *secondNode;
    
    firstNode = (SKSpriteNode *)contact.bodyA.node;
    secondNode = (SKSpriteNode *) contact.bodyB.node;
    
    //collision between redball and greenball
    if ((contact.bodyA.categoryBitMask == redBallCategory)
        && (contact.bodyB.categoryBitMask == greenBallCategory))
    {
        if (shieldOn == true) {
            //collision between green ball and shield around the red ball
            //checks to see if the first or second object was the green ball and removes the green ball
            if([contact.bodyA.node.name isEqualToString:@"greenBall"] )
            {
                [contact.bodyA.node removeFromParent];
            }else{
                [contact.bodyB.node removeFromParent];
            }
        } else {
        
            [self runAction: flashWhite];
            
            [self runAction: [SKAction performSelector:@selector(invinciblePower) onTarget:self]];
        
            lives = lives - 1;
        
            collisionLabel = [SKLabelNode labelNodeWithFontNamed:@"Default"];
            collisionLabel.text = [NSString stringWithFormat:@"-1"];
            collisionLabel.fontSize = 40;
            collisionLabel.fontColor = [SKColor whiteColor];
            collisionLabel.position = CGPointMake(contact.contactPoint.x, contact.contactPoint.y + self.size.height/5);
            [self addChild:collisionLabel];
            [collisionLabel runAction:[SKAction fadeAlphaTo:0.0 duration:1.0] completion:^{
                [collisionLabel removeFromParent];
            }];

        
            //checks to see if the first or second object was the green ball and removes the green ball
            if([contact.bodyA.node.name isEqualToString:@"greenBall"] )
            {
                [contact.bodyA.node removeFromParent];
            }else{
                [contact.bodyB.node removeFromParent];
            }
        }
    }
    
    //collision between redball and lifeball
    if ((contact.bodyA.categoryBitMask == redBallCategory)
        && (contact.bodyB.categoryBitMask == lifeBallCategory))
    {
        //[self runAction: flashWhite];
        
        if (lives == 3) {
            //do nothing
        } else {
            lives = lives + 1;
            
            collisionLabel = [SKLabelNode labelNodeWithFontNamed:@"Default"];
            collisionLabel.text = [NSString stringWithFormat:@"+1"];
            collisionLabel.fontSize = 40;
            collisionLabel.fontColor = [SKColor whiteColor];
            collisionLabel.position = CGPointMake(contact.contactPoint.x, contact.contactPoint.y + self.size.height/5);
            [self addChild:collisionLabel];
            [collisionLabel runAction:[SKAction fadeAlphaTo:0.0 duration:1.0] completion:^{
                [collisionLabel removeFromParent];
            }];
        }
        
        //checks to see if the first or second object was the life ball and removes the life ball
        if([contact.bodyA.node.name isEqualToString:@"lifeBall"] )
        {
            [contact.bodyA.node removeFromParent];
        }else{
            [contact.bodyB.node removeFromParent];
        }
    }
    
    //collision between redball and shield power up
    if ((contact.bodyA.categoryBitMask == redBallCategory)
        && (contact.bodyB.categoryBitMask == shieldBallCategory))
    {
        //[self runAction: flashWhite];
        
        if ([powerUp1.name  isEqual: @"Blank"]) {
            powerUp1.texture = [SKTexture textureWithImageNamed:@"Shield Power Up"];
            powerUp1.name = @"Shield";
        } else if ([powerUp2.name  isEqual: @"Blank"]) {
            powerUp2.texture = [SKTexture textureWithImageNamed:@"Shield Power Up"];
            powerUp2.name = @"Shield";
        } else if ([powerUp3.name  isEqual: @"Blank"]) {
            powerUp3.texture = [SKTexture textureWithImageNamed:@"Shield Power Up"];
            powerUp3.name = @"Shield";
        }
        
        //powerUpSpot.texture = [SKTexture textureWithImageNamed:@"Shield Power Up"];

        
        //checks to see if the first or second object was the life ball and removes the life ball
        if([contact.bodyA.node.name isEqualToString:@"shieldBall"] )
        {
            [contact.bodyA.node removeFromParent];
        }else{
            [contact.bodyB.node removeFromParent];
        }
    }
    
    //collision between redball and clock power up
    if ((contact.bodyA.categoryBitMask == redBallCategory)
        && (contact.bodyB.categoryBitMask == timeBallCategory))
    {
        //[self runAction: flashWhite];
        
        if ([powerUp1.name  isEqual: @"Blank"]) {
            powerUp1.texture = [SKTexture textureWithImageNamed:@"Clock Power Up"];
            powerUp1.name = @"Clock";
        } else if ([powerUp2.name  isEqual: @"Blank"]) {
            powerUp2.texture = [SKTexture textureWithImageNamed:@"Clock Power Up"];
            powerUp2.name = @"Clock";
        } else if ([powerUp3.name  isEqual: @"Blank"]) {
            powerUp3.texture = [SKTexture textureWithImageNamed:@"Clock Power Up"];
            powerUp3.name = @"Clock";
        }
        
        //checks to see if the first or second object was the life ball and removes the life ball
        if([contact.bodyA.node.name isEqualToString:@"timeBall"] )
        {
            [contact.bodyA.node removeFromParent];
        }else{
            [contact.bodyB.node removeFromParent];
        }
    }
    
    //collision between redball and shrink power up
    if ((contact.bodyA.categoryBitMask == redBallCategory)
        && (contact.bodyB.categoryBitMask == shrinkBallCategory))
    {
        //[self runAction: flashWhite];
        
        if ([powerUp1.name  isEqual: @"Blank"]) {
            powerUp1.texture = [SKTexture textureWithImageNamed:@"Shrink Power Up"];
            powerUp1.name = @"Shrink";
        } else if ([powerUp2.name  isEqual: @"Blank"]) {
            powerUp2.texture = [SKTexture textureWithImageNamed:@"Shrink Power Up"];
            powerUp2.name = @"Shrink";
        } else if ([powerUp3.name  isEqual: @"Blank"]) {
            powerUp3.texture = [SKTexture textureWithImageNamed:@"Shrink Power Up"];
            powerUp3.name = @"Shrink";
        }
        
        //checks to see if the first or second object was the life ball and removes the life ball
        if([contact.bodyA.node.name isEqualToString:@"shrinkBall"] )
        {
            [contact.bodyA.node removeFromParent];
        }else{
            [contact.bodyB.node removeFromParent];
        }
    }
    
    if (lives == 3){
        livesShow.texture = [SKTexture textureWithImageNamed:@"3Life"];
    } if (lives == 2){
        livesShow.texture = [SKTexture textureWithImageNamed:@"2Life"];
    } if (lives == 1){
        livesShow.texture = [SKTexture textureWithImageNamed:@"1Life"];
    } if (lives  < 1){
        livesShow.texture = [SKTexture textureWithImageNamed:@"0Life"];
        //you lose
        //you lose
        //you lose
        shieldOn = NO;
        clockOn = NO;
        
        redBall.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:body.size.height / 2];
        redBall.physicsBody.categoryBitMask = redBallCategory;
        
        [theShield removeFromParent];
        speedOfTheGreenBalls = currentSpeedOfTheGreenBalls ;
        smallRateGreenBallsAreMade = currentSmallRateGreenBallsAreMade;
        
        usingPowerUp = NO;
        powerUpSpot.texture = [SKTexture textureWithImageNamed:@"Blank"];
        
        powerUp1.name = @"Blank";
        powerUp1.texture = [SKTexture textureWithImageNamed:@"Blank"];
        powerUp2.name = @"Blank";
        powerUp2.texture = [SKTexture textureWithImageNamed:@"Blank"];
        powerUp3.name = @"Blank";
        powerUp3.texture = [SKTexture textureWithImageNamed:@"Blank"];
        
        //self.scene.view.paused = YES;
        
        [defaults setInteger:score forKey:@"currentScore"];
        
        if (score > [defaults integerForKey:@"highScore"]){
            [defaults setInteger:score forKey:@"highScore"];
        }
    
        [defaults synchronize];
        
        SKScene *gameOverScreen  = [[GameOverScreen alloc] initWithSize:self.size];
        //SKTransition *slideDown = [SKTransition moveInWithDirection:SKTransitionDirectionUp duration:0.5];
        SKTransition *appear = [SKTransition fadeWithDuration:1];
        [self.view presentScene:gameOverScreen transition:appear];
        
    }
}

- (void)invinciblePower {
    
    usingPowerUp = YES;
    shieldOn = YES;
    hitSpot.texture = [SKTexture textureWithImageNamed:@"Light Orange Ball"];
    
    SKAction *blink = [SKAction sequence:@[
                                           [SKAction fadeAlphaTo:0.3 duration:0.25],
                                           [SKAction fadeAlphaTo:1.0 duration:0.25]
                                           ]];
    SKAction *blinkForever = [SKAction repeatActionForever:blink];
    [hitSpot runAction: blinkForever withKey:@"blinking"];
    
    [self runAction:[SKAction waitForDuration: 1.5] completion:^{
        shieldOn = NO;
        
        usingPowerUp = NO;
        hitSpot.texture = [SKTexture textureWithImageNamed:@"Blank"];
        [hitSpot removeActionForKey:@"blinking"];
    }];
    
}

- (void)shieldPower {
    
    usingPowerUp = YES;
    shieldOn = YES;
    powerUpSpot.texture = [SKTexture textureWithImageNamed:@"Shield Power Up"];
    
    theShield = [[SKSpriteNode alloc] initWithImageNamed:@"Yellow Ball.png" ];
    theShield.size = CGSizeMake(body.size.height *3, body.size.width *3);
    theShield.position = CGPointMake(0, 0);
    theShield.alpha = 0.5;
    theShield.name = @"Shield";
    //theShield.zPosition = 0;
    
    redBall.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:theShield.size.height / 2];
    redBall.physicsBody.categoryBitMask = redBallCategory;
    [redBall addChild:theShield];
    
    SKAction *blink = [SKAction sequence:@[
                                           [SKAction fadeAlphaTo:0.7 duration:0.5],
                                           
                                           [SKAction fadeAlphaTo:0.1 duration:0.5]]];
    SKAction *blinkForever = [SKAction repeatActionForever:blink];
    [theShield runAction: blinkForever];
    
    [self runAction:[SKAction waitForDuration: 10] completion:^{
        shieldOn = NO;
        
        redBall.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:body.size.height / 2];
        redBall.physicsBody.categoryBitMask = redBallCategory;
        
        [theShield removeFromParent];
        
        usingPowerUp = NO;
        powerUpSpot.texture = [SKTexture textureWithImageNamed:@"Blank"];
    }];
    
}

- (void)clockPower {
    
    usingPowerUp = YES;
    
    currentSpeedOfTheGreenBalls = speedOfTheGreenBalls;
    currentSmallRateGreenBallsAreMade = smallRateGreenBallsAreMade;
    
    clockOn = YES;
    powerUpSpot.texture = [SKTexture textureWithImageNamed:@"Clock Power Up"];
    
    
    [self runAction:[SKAction waitForDuration: 10] completion:^{
        clockOn = NO;
        
        speedOfTheGreenBalls = currentSpeedOfTheGreenBalls ;
        smallRateGreenBallsAreMade = currentSmallRateGreenBallsAreMade;

        
        usingPowerUp = NO;
        powerUpSpot.texture = [SKTexture textureWithImageNamed:@"Blank"];
    }];
}

- (void)shrinkPower {
    
    usingPowerUp = YES;
    
    shrinkOn = YES;
    powerUpSpot.texture = [SKTexture textureWithImageNamed:@"Shrink Power Up"];
    
    
    [self runAction:[SKAction waitForDuration: 10] completion:^{
        shrinkOn = NO;
        
        usingPowerUp = NO;
        powerUpSpot.texture = [SKTexture textureWithImageNamed:@"Blank"];
    }];

    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        
        CGPoint locationOfFinger = [touch locationInNode:self];
        
        if (![movingBar containsPoint:locationOfFinger]) {
            //do nothing
        }else if ([movingBar containsPoint:locationOfFinger]) {
            SKAction *movePlayer = [SKAction moveTo:CGPointMake(locationOfFinger.x, self.size.height / 3) duration:0];
            [redBall runAction:movePlayer];
        }
    
        if ( [touches count] >= 2) {
            // do something if the screen was touch with two fingers
            
            //self.backgroundColor = [SKColor orangeColor];
            
            if (([powerUp1.name isEqualToString: @"Shield"])&&(usingPowerUp == NO)) {
                powerUp1.name = powerUp2.name;
                powerUp1.texture = powerUp2.texture;
                powerUp2.name = powerUp3.name;
                powerUp2.texture = powerUp3.texture;
                powerUp3.name = @"Blank";
                powerUp3.texture = [SKTexture textureWithImageNamed:@"Blank"];
                [self runAction: [SKAction performSelector:@selector(shieldPower) onTarget:self]];
                return;
            } else if (([powerUp1.name isEqualToString: @"Clock"])&&(usingPowerUp == NO)) {
                powerUp1.name = powerUp2.name;
                powerUp1.texture = powerUp2.texture;
                powerUp2.name = powerUp3.name;
                powerUp2.texture = powerUp3.texture;
                powerUp3.name = @"Blank";
                powerUp3.texture = [SKTexture textureWithImageNamed:@"Blank"];
                [self runAction: [SKAction performSelector:@selector(clockPower) onTarget:self]];
                return;
            } else if (([powerUp1.name isEqualToString: @"Shrink"])&&(usingPowerUp == NO)) {
                powerUp1.name = powerUp2.name;
                powerUp1.texture = powerUp2.texture;
                powerUp2.name = powerUp3.name;
                powerUp2.texture = powerUp3.texture;
                powerUp3.name = @"Blank";
                powerUp3.texture = [SKTexture textureWithImageNamed:@"Blank"];
                [self runAction: [SKAction performSelector:@selector(shrinkPower) onTarget:self]];
                return;
            }
        }
    }
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    for (UITouch *touch in touches) {
        
        CGPoint locationOfFinger = [touch locationInNode:self];
        
        
        SKAction *movePlayer = [SKAction moveTo:CGPointMake(locationOfFinger.x, self.size.height / 3) duration:0];
        [redBall runAction:movePlayer];
        
        
        if ( [touches count] >= 2) {
            // do something if the screen was touch with two fingers
            
            //self.backgroundColor = [SKColor orangeColor];
                
            if (([powerUp1.name isEqualToString: @"Shield"])&&(usingPowerUp == NO)) {
                powerUp1.name = powerUp2.name;
                powerUp1.texture = powerUp2.texture;
                powerUp2.name = powerUp3.name;
                powerUp2.texture = powerUp3.texture;
                powerUp3.name = @"Blank";
                powerUp3.texture = [SKTexture textureWithImageNamed:@"Blank"];
                [self runAction: [SKAction performSelector:@selector(shieldPower) onTarget:self]];
                return;
            } else if (([powerUp1.name isEqualToString: @"Clock"])&&(usingPowerUp == NO)) {
                powerUp1.name = powerUp2.name;
                powerUp1.texture = powerUp2.texture;
                powerUp2.name = powerUp3.name;
                powerUp2.texture = powerUp3.texture;
                powerUp3.name = @"Blank";
                powerUp3.texture = [SKTexture textureWithImageNamed:@"Blank"];
                [self runAction: [SKAction performSelector:@selector(clockPower) onTarget:self]];
                return;
            } else if (([powerUp1.name isEqualToString: @"Shrink"])&&(usingPowerUp == NO)) {
                powerUp1.name = powerUp2.name;
                powerUp1.texture = powerUp2.texture;
                powerUp2.name = powerUp3.name;
                powerUp2.texture = powerUp3.texture;
                powerUp3.name = @"Blank";
                powerUp3.texture = [SKTexture textureWithImageNamed:@"Blank"];
                [self runAction: [SKAction performSelector:@selector(shrinkPower) onTarget:self]];
                return;
            }
            
        } else {
            // do something else
        }

    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}


@end