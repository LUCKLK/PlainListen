//
//  MyMusicPlayer.m
//  PlainListen
//
//  Created by lanouhn on 15-4-11.
//  Copyright (c) 2015年 luck. All rights reserved.
//

#import "MyMusicPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "DataHelper.h"
#import "List.h"
@interface MyMusicPlayer () <AVAudioPlayerDelegate>
@property (strong, nonatomic) AVAudioPlayer *avAudioPlayer;
@property (strong, nonatomic) DataHelper *dataHelper;
@property (strong, nonatomic) NSMutableArray *listMusics;
@property (strong, nonatomic) NSMutableArray *randomArr;
@property (nonatomic) PlayType playType;
@end
@implementation MyMusicPlayer

- (void)setLockScreenNowPlayingInfo {
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
        [dic setObject:_music.title forKey:MPMediaItemPropertyTitle];
        if (_music.artist) {
            [dic setObject:_music.artist forKey:MPMediaItemPropertyArtist];
        }
        if (_music.artwork) {
            [dic setObject:_music.artwork forKey:MPMediaItemPropertyArtwork];
        } else {
            MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"MPMediaItemArtwork"]];
            [dic setObject:artwork forKey:MPMediaItemPropertyArtwork];
        }
        
        [dic setObject:[NSNumber numberWithDouble:self.avAudioPlayer.currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime]; //音乐当前已经播放时间
        [dic setObject:[NSNumber numberWithFloat:1.0] forKey:MPNowPlayingInfoPropertyPlaybackRate];//进度光标的速度 （这个随 自己的播放速率调整，我默认是原速播放）
        [dic setObject:[NSNumber numberWithDouble:self.avAudioPlayer.duration] forKey:MPMediaItemPropertyPlaybackDuration];//歌曲总时间设置
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dic];
    }
}

+ (MyMusicPlayer *)sharedMyMusicPlayer {
    static MyMusicPlayer *myMusicPlayer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myMusicPlayer = [[MyMusicPlayer alloc] init];
        AVAudioSession *session = [AVAudioSession sharedInstance];
        __autoreleasing NSError *error1 = nil;
        __autoreleasing NSError *error2 = nil;
        [session setCategory:AVAudioSessionCategoryPlayback error:&error1];
        [session setActive:YES error:&error2];
        myMusicPlayer.playType = ListPlay;
    });
    return myMusicPlayer;
}

- (DataHelper *)dataHelper {
    if (!_dataHelper) {
        self.dataHelper = [DataHelper sharedDataHelper];
    }
    return _dataHelper;
}

- (void)setPlayType:(PlayType)playType {
    if (_playType != playType) {
        _playType = playType;
        [self cancleSingleLoop];
    }
}

- (NSMutableArray *)randomArr {
    if (!_randomArr) {
        self.randomArr = [NSMutableArray arrayWithArray:_listMusics];
    }
    return _randomArr;
}

- (void)changeProgress {
    self.progress = self.avAudioPlayer.currentTime / self.avAudioPlayer.duration;
    if (![self.avAudioPlayer isPlaying]) {
        return;
    }
    [self performSelector:_cmd withObject:self afterDelay:1.];
}

- (void)updateList {
    if (_music.listName) {
        if (!_listMusics || _listMusics.count == 0) {
            self.listMusics = ((List *)self.dataHelper.listMusics[_music.listName]).musics;
        } else {
            if (![((Music *)[_listMusics firstObject]).listName isEqualToString:_music.listName]) {
                self.listMusics = ((List *)self.dataHelper.listMusics[_music.listName]).musics;
            }
        }
    } else {
        self.listMusics = self.dataHelper.allMusic;
    }
}

- (void)playWithMusic:(Music *)music {
    self.isPlaying = YES;
    if (_avAudioPlayer) {
        [_avAudioPlayer stop];
    }
    self.music = music;
    if (self.changeCover != nil) {
        self.changeCover(_music);
    }
    [self updateList];
    NSError __autoreleasing*error = nil;
    self.avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:music.assetURL error:&error];
    _avAudioPlayer.delegate = self;
    [_avAudioPlayer play];
    [self changeProgress];
    [self setLockScreenNowPlayingInfo];
}

- (void)pause {
    [_avAudioPlayer pause];
    self.isPlaying = NO;
}

- (void)canclePause {
    if (![_avAudioPlayer isPlaying]) {
        [_avAudioPlayer play];
    }
    NSMutableDictionary *dic = [[[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo] mutableCopy];
    [dic setObject:[NSNumber numberWithDouble:self.avAudioPlayer.currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dic];
    [self changeProgress];
    self.isPlaying = YES;
}

- (void)stop {
    [_avAudioPlayer stop];
    self.isPlaying = NO;
}

- (void)singleLoop {
    _avAudioPlayer.numberOfLoops = -1;
}

- (void)cancleSingleLoop {
    _avAudioPlayer.numberOfLoops = 0;
}

- (void)listPlay {
    self.playType = ListPlay;
}

- (void)listLoop {
    self.playType = ListLoop;
}

- (void)listRandom {
    self.playType = ListRandom;
}

- (void)playNextMusic {
    NSInteger index = [_listMusics indexOfObject:_music];
    if (index < _listMusics.count - 1) {
        [self playWithMusic:[_listMusics objectAtIndex:index + 1]];
    } else {
        [self playWithMusic:_music];
    }
}
- (void)playBeforeMusic {
    NSInteger index = [_listMusics indexOfObject:_music];
    if (index > 0) {
        [self playWithMusic:[_listMusics objectAtIndex:index - 1]];
    } else {
        [self playWithMusic:_music];
    }
}


#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    switch (_playType) {
        case ListPlay:
        {
            NSUInteger index = [self.listMusics indexOfObject:_music];
            if (index < self.listMusics.count - 1) {
                [self playWithMusic:[self.listMusics objectAtIndex:index + 1]];
            } else {
                [self stop];
            }
        }
            break;
        case ListLoop:
        {
            NSUInteger index = [self.listMusics indexOfObject:_music];
            if (index < self.listMusics.count - 1) {
                [self playWithMusic:[self.listMusics objectAtIndex:index + 1]];
            } else {
                [self playWithMusic:[self.listMusics firstObject]];
            }
        }
            break;
        case ListRandom:
        {
            [self.randomArr removeObject:_music];
            if (_randomArr.count != 0) {
                NSInteger nextIndex = arc4random() % _randomArr.count;
                [self playWithMusic:[_randomArr objectAtIndex:nextIndex]];
            } else {
                [self stop];
            }
        }
            break;
            
        default:
            [self stop];
            break;
    }
}
//音乐被打断
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player NS_DEPRECATED_IOS(2_2, 8_0) {
    [self pause];
}
//音乐打断结束
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags NS_DEPRECATED_IOS(6_0, 8_0) {
    [self canclePause];
}
//上个方法没执行时执行
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player NS_DEPRECATED_IOS(2_2, 6_0) {
    
}

@end
