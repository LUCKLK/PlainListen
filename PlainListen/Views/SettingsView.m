//
//  SettingsView.m
//  PlainListen
//
//  Created by lanouhn on 15-4-14.
//  Copyright (c) 2015年 luck. All rights reserved.
//

#import "SettingsView.h"
#import "MyMusicPlayer.h"
@interface SettingsView ()
@property (strong, nonatomic) UIImageView *playStyle;
@property (strong, nonatomic) MyMusicPlayer *myPlayer;
@end
@implementation SettingsView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.alpha = 0.75;
        self.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height / 2);
        self.bounds = CGRectZero;
        [self configuration];
    }
    return self;
}

- (MyMusicPlayer *)myPlayer {
    if (!_myPlayer) {
        self.myPlayer = [MyMusicPlayer sharedMyMusicPlayer];
    }
    return _myPlayer;
}

- (void)setPlayType:(PlayType)playType {
    if (_playType != playType) {
        _playType = playType;
        switch (_playType) {
            case ListPlay:
                [self.myPlayer listPlay];
                [self setNeedsDisplay];
                break;
            case ListLoop:
                [self.myPlayer listLoop];
                [self setNeedsDisplay];
                break;
            case ListRandom:
                [self.myPlayer listRandom];
                [self setNeedsDisplay];
                break;
            case SingleLoop:
                [self.myPlayer singleLoop];
                [self setNeedsDisplay];
                break;
                
            default:
                break;
                
        }
    }
}

- (void)configuration {
    [UIView animateWithDuration:0.5 animations:^{
        self.bounds = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 300);
        self.backgroundColor = [UIColor whiteColor];
    } completion:^(BOOL finished) {
        self.backgroundColor = [UIColor whiteColor];
        self.bounds = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 300);
    }];
    self.playType = ListPlay;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tap];
    
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    switch (_playType) {
        case ListPlay:
        {
            self.playType = ListRandom;
            
        }
            break;
        case ListRandom:
        {
            self.playType = ListLoop;
        }
            break;
        case ListLoop:
        {
            self.playType = SingleLoop;
        }
            break;
        case SingleLoop:
        {
            self.playType = ListPlay;
        }
            break;
            
        default:
            break;
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    switch (_playType) {
        case ListPlay:
        {
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextDrawImage(context, CGRectMake((CGRectGetWidth([[UIScreen mainScreen] bounds]) - 200) / 2, 50, 200, 200), [UIImage imageNamed:@"listPlay"].CGImage);
        }
            break;
        case ListLoop:
        {
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextDrawImage(context, CGRectMake((CGRectGetWidth([[UIScreen mainScreen] bounds]) - 200) / 2, 50, 200, 200), [UIImage imageNamed:@"listLoop"].CGImage);
        }
            break;
        case SingleLoop:
        {
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextDrawImage(context, CGRectMake((CGRectGetWidth([[UIScreen mainScreen] bounds]) - 200) / 2, 50, 200, 200), [UIImage imageNamed:@"singleLoop"].CGImage);
        }
            
            break;
        case ListRandom:
        {
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextDrawImage(context, CGRectMake((CGRectGetWidth([[UIScreen mainScreen] bounds]) - 200) / 2, 50, 200, 200), [UIImage imageNamed:@"random"].CGImage);
        }
            
            break;
            
        default:
            break;
    }
}

@end
