//
//  ViewController.m
//  RedBallSpriteKit
//
//  Created by Lee Warren on 20/07/2014.
//  Copyright (c) 2014 Lee Warren. All rights reserved.
//

#import "ViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "MenuScreen.h"
#import <iAd/iAd.h>
#import "InAppManager.h"
@import AVFoundation;


@interface ViewController () <ADBannerViewDelegate>



@end

@implementation ViewController


// NOTE: THIS CODE CAME FROM APPLE MOSTLY
// I DID EDIT IT, BUT THE CREDIT GOES TO APPLE'S DOCUMENTATION
// ON IAD
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (banner.isBannerLoaded) {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        // Assumes the banner view is placed at the bottom of the screen.
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        [UIView commitAnimations];
    }
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!banner.isBannerLoaded) {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        // Assumes the banner view is just off the bottom of the screen.
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        [UIView commitAnimations];
    }
}

- (void)viewDidLoad
{
    NSError *error;
    NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"Ouroboros" withExtension:@"mp3"];
    _backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    _backgroundMusicPlayer.numberOfLoops = -1;
    _backgroundMusicPlayer.volume = 0.05;
    [_backgroundMusicPlayer prepareToPlay];
    [_backgroundMusicPlayer play];
    
    MenuScreen* Menu = [[MenuScreen alloc] initWithSize:CGSizeMake(768,1024)];
    SKView *spriteView = (SKView *) self.originalContentView;
    [spriteView presentScene: Menu];
    
    
    [InAppManager sharedManager];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(unlockProduct1) name:@"feature1Purchased" object:nil];
    
    [super viewDidLoad];
    
    //SKView *spriteView = (SKView *) self.view;
    //spriteView.showsDrawCount = YES;
    //spriteView.showsNodeCount = YES;
    //spriteView.showsFPS = YES;
    
}


-(void)unlockProduct1 {
    
    NSLog(@"Our class knows that we unlocked Product 1");
    //do whatever you want from unlocking the product
    
    self.canDisplayBannerAds = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    self.banner = [[ADBannerView alloc] initWithFrame:CGRectZero];
    self.banner.delegate = self;
    [self.banner sizeToFit];
    
    if ( [[InAppManager sharedManager]isFeature1PurchasedAlready] == YES) {
        self.canDisplayBannerAds = NO;
    } else {
        self.canDisplayBannerAds = YES;
    }
    
    [super viewWillLayoutSubviews];

}

- (void) audioPlayerEndInterruption: (AVAudioPlayer *) player {
    
        [_backgroundMusicPlayer prepareToPlay];
        [_backgroundMusicPlayer play];
    
}


@end
