//
//  PlayingViewController.h
//  PlainListen
//
//  Created by lanouhn on 15-4-11.
//  Copyright (c) 2015年 luck. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Reimu;

@interface PlayingViewController : UIViewController
@property (strong, nonatomic) Reimu *reimu;

+ (PlayingViewController *)mainPlayingViewController;
@end
