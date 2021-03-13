//
//  CreditsScreen.m
//  Don't Touch The Green Balls
//
//  Created by Lee Warren on 29/07/2014.
//  Copyright (c) 2014 Lee Warren. All rights reserved.
//

#import "CreditsScreen.h"
#import "MenuScreen.h"
#import "InAppManager.h"

@interface CreditsScreen ()
@property BOOL contentCreated;
@end

@implementation CreditsScreen


- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        self.physicsWorld.contactDelegate = self;
        
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    
    self.backgroundColor = [SKColor blackColor];
    //self.scaleMode = SKSceneScaleModeAspectFill;
    
    creditsBar = [self creditsBar];
    creditsBar.position = CGPointMake(self.size.width/2 ,self.size.height - creditsBar.size.height/2);
    [self addChild:creditsBar];
    
    //makes green balls fall from the top just top make it look better
    makeGreenBalls = [SKAction sequence: @[
                                           [SKAction performSelector:@selector(addGreenBall) onTarget:self],
                                           [SKAction waitForDuration:0.2 withRange:0.25]
                                           ]];
    [self runAction: [SKAction repeatActionForever:makeGreenBalls]];

    
    returnToMenu = [SKLabelNode labelNodeWithFontNamed:@"Default"];
    returnToMenu.text = [NSString stringWithFormat:@"Return To Menu"];
    returnToMenu.fontSize = 50;
    returnToMenu.fontColor = [SKColor whiteColor];
    returnToMenu.position = CGPointMake(self.size.width/2, self.size.height/10
                                          );
    returnToMenu.zPosition = 1.0;
    returnToMenu.name = @"MenuButton";
    [self addChild:returnToMenu];
    
    restorePurchase = [SKLabelNode labelNodeWithFontNamed:@"Default"];
    restorePurchase.text = [NSString stringWithFormat:@"Restore All Purchases"];
    restorePurchase.fontSize = 50;
    restorePurchase.fontColor = [SKColor whiteColor];
    restorePurchase.position = CGPointMake(self.size.width/2, returnToMenu.position.y + self.size.height/10
                                        );
    restorePurchase.zPosition = 1.0;
    restorePurchase.name = @"RestorePurchase";
    [self addChild:restorePurchase];

    
    
}

- (SKSpriteNode *)creditsBar
{
    creditsBox = [[SKSpriteNode alloc] init];
    creditsBox.size = CGSizeMake(self.size.width, self.size.height - self.size.height/10);
    
    downloadOtherApp = [[SKSpriteNode alloc] initWithImageNamed:@"Download My Maths Image.png"];
    downloadOtherApp.xScale = creditsBox.size.width / downloadOtherApp.size.width /4 *2;
    downloadOtherApp.yScale = downloadOtherApp.xScale;
    
    downloadOtherApp.position =CGPointMake(0, creditsBox.size.height/2 - downloadOtherApp.size.height/2 - downloadOtherApp.size.height/5);
    downloadOtherApp.zPosition = 1.0;
    downloadOtherApp.name = @"DownloadOtherApps";
    
    [creditsBox addChild:downloadOtherApp];
    
    likeFacebookPage = [[SKSpriteNode alloc] initWithImageNamed:@"Facebook Like Image.jpg"];
    likeFacebookPage.xScale = creditsBox.size.width / likeFacebookPage.size.width /4 *2;
    likeFacebookPage.yScale = likeFacebookPage.xScale;
    
    likeFacebookPage.position = CGPointMake(downloadOtherApp.position.x, downloadOtherApp.position.y - downloadOtherApp.frame.size.height/10 - likeFacebookPage.size.height);

    likeFacebookPage.zPosition = 1.0;
    likeFacebookPage.name = @"LikeFacebookPage";
    
    [creditsBox addChild:likeFacebookPage];
    
    musicReference = [[SKSpriteNode alloc] initWithImageNamed:@"Music Rights.png"];
    musicReference.xScale = creditsBox.size.width / musicReference.size.width /4 *2;
    musicReference.yScale = musicReference.xScale;
    
    musicReference.position = CGPointMake(likeFacebookPage.position.x, likeFacebookPage.position.y - likeFacebookPage.frame.size.height/30 - musicReference.size.height);
    
    musicReference.zPosition = 1.0;
    musicReference.name = @"MusicReference";
    
    [creditsBox addChild:musicReference];

    
    return creditsBox;
    
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
            SKScene *menuScreen  = [[MenuScreen alloc] initWithSize:self.size];
            SKTransition *doors = [SKTransition crossFadeWithDuration:0.6];
            [self.view presentScene:menuScreen transition:doors];
            
        }else if ([node.name isEqualToString:@"RestorePurchase"]) {
            //restore all purchases
            [[InAppManager sharedManager]restoreCompletedTransactions];
        
        }else if ([node.name isEqualToString:@"DownloadOtherApps"]) {
            
           //go to app store page
            myOtherApps = [NSURL URLWithString:@"https://itunes.apple.com/us/app/my-maths/id897368293?mt=8"];
            [[UIApplication sharedApplication] openURL:myOtherApps];
            
        }else if ([node.name isEqualToString:@"LikeFacebookPage"]) {
            
            //go to facebook liking page
            myFacebookPage = [NSURL URLWithString:@"https://www.facebook.com/pages/Dont-Touch-The-Green-Balls/662328057184503"];
            [[UIApplication sharedApplication] openURL:myFacebookPage];
        }
    }
}


@end
