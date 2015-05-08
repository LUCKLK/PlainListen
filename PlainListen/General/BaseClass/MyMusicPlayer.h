//
//  MyMusicPlayer.h
//  PlainListen
//
//  Created by lanouhn on 15-4-11.
//  Copyright (c) 2015年 luck. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "PlayEnum.h"
#import "Music.h"

typedef void(^ChangeCover)(Music *);
@interface MyMusicPlayer : NSObject
@property (strong, nonatomic) Music *music;
@property (nonatomic) CGFloat progress;
@property (nonatomic) BOOL isPlaying;
@property (copy, nonatomic) ChangeCover changeCover;

+ (MyMusicPlayer *)sharedMyMusicPlayer;
//开始播放
- (void)playWithMusic:(Music *)music;
//暂停
- (void)pause;
//继续
- (void)canclePause;
//停止
- (void)stop;
//单曲循环
- (void)singleLoop;
//取消单曲循环
- (void)cancleSingleLoop;
//列表播放
- (void)listPlay;
//列表循环
- (void)listLoop;
//列表随机
- (void)listRandom;
//播放下一曲
- (void)playNextMusic;
//播放上一曲
- (void)playBeforeMusic;


@end
