//
//  ViewController.h
//  RedBallSpriteKit
//
//  Created by Lee Warren on 20/07/2014.
//  Copyright (c) 2014 Lee Warren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
@import AVFoundation;

@interface ViewController : UIViewController

@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;

@property (nonatomic, strong) ADBannerView *banner;

@end
