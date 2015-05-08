//
//  AppDelegate.m
//  PlainListen
//
//  Created by lanouhn on 15-4-8.
//  Copyright (c) 2015年 luck. All rights reserved.
//

#import "AppDelegate.h"
#import "DataHelper.h"
#import "MyMusicPlayer.h"
#import "PlayingViewController.h"
#import "Reimu.h"
#import "MusicListViewController.h"
#import "LaunchViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPause:
                [[MyMusicPlayer sharedMyMusicPlayer] pause];
                [[PlayingViewController mainPlayingViewController].reimu.timer invalidate];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [[MyMusicPlayer sharedMyMusicPlayer] playNextMusic];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [[MyMusicPlayer sharedMyMusicPlayer] playBeforeMusic];
                break;
            case UIEventSubtypeRemoteControlPlay:
                [[MyMusicPlayer sharedMyMusicPlayer] canclePause];
                [[PlayingViewController mainPlayingViewController].reimu setTrans];
                break;
            default:
                break;
        }
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    NSLog(@"%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]);
    DataHelper *dataHelper = [DataHelper sharedDataHelper];
    [dataHelper loadMusics];
    [dataHelper loadLists];
    
    NSUserDefaults *userDefauls = [NSUserDefaults standardUserDefaults];
    if (![userDefauls boolForKey:@"DidLaunched"]) {
        [userDefauls setBool:YES forKey:@"DidLaunched"];
        [userDefauls synchronize];
        LaunchViewController *launchVC = [[LaunchViewController alloc] init];
        [self.window setRootViewController:launchVC];
    } else {
        MusicListViewController *musicListVC = [[MusicListViewController alloc] init];
        [self.window setRootViewController:musicListVC];
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [application beginBackgroundTaskWithExpirationHandler:nil];     //后台
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
