//
//  PlayingViewController.m
//  PlainListen
//
//  Created by lanouhn on 15-4-11.
//  Copyright (c) 2015年 luck. All rights reserved.
//

#import "PlayingViewController.h"
#import "Music.h"
#import "Hexagram.h"
#import "Cover.h"
#import "Reimu.h"
#import "MyMusicPlayer.h"
#import "SettingsView.h"
#import "UILayout.h"
#import "PlayView.h"
@interface PlayingViewController ()
@property (strong, nonatomic) MyMusicPlayer *myPlayer;
@property (strong, nonatomic) Cover *cover;
@property (strong, nonatomic) UILabel *header;
@property (strong, nonatomic) SettingsView *setView;
@end

@implementation PlayingViewController

- (MyMusicPlayer *)myPlayer {
    if (!_myPlayer) {
        self.myPlayer = [MyMusicPlayer sharedMyMusicPlayer];
    }
    return _myPlayer;
}

+ (PlayingViewController *)mainPlayingViewController {
    static PlayingViewController *playingVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playingVC = [[PlayingViewController alloc] init];
        [[[[UIApplication sharedApplication] delegate] window] addSubview:playingVC.view];
    });
    return playingVC;
}

- (void)loadView {
    self.view = [[PlayView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof(self) mySelf = self;
    self.myPlayer.changeCover = ^(Music *music) {
        MPMediaItemArtwork *artwork = music.artwork;
        if (artwork) {
            mySelf.cover.coverImage = [artwork imageWithSize:artwork.imageCropRect.size];
        } else {
            mySelf.cover.coverImage = [UIImage imageNamed:@"placeholder"];
        }
    };
    [self configurationSubviews];
    [self configurationControl];
    [self.myPlayer addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"progress"]) {
        self.cover.progress = [[change objectForKey:@"new"] floatValue];
    }
    if ([keyPath isEqualToString:@"music"]) {
        self.header.text = ((Music *)[change objectForKey:@"new"]).title;
    }
}

- (void)configurationSubviews {
    [self configurationHeader];
    
    Hexagram *hexagram = [[Hexagram alloc] init];
    self.cover = [[Cover alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.cover.center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2, CGRectGetHeight(self.view.bounds) / 2);
    MPMediaItemArtwork *artwork = self.myPlayer.music.artwork;
    if (artwork) {
        self.cover.coverImage = [artwork imageWithSize:artwork.imageCropRect.size];
    } else {
        self.cover.coverImage = [UIImage imageNamed:@"placeholder"];
    }
    [self.view addSubview:_cover];
    self.reimu = [[Reimu alloc] init];
    [self.view.layer addSublayer:self.reimu];
    self.cover.hidden = YES;
    self.reimu.hidden = YES;
    __weak typeof(self) mySelf = self;
    hexagram.didEnd = ^() {
        mySelf.cover.hidden = NO;
        mySelf.reimu.hidden = NO;
    };
    [hexagram setAfter];
    [self.view.layer addSublayer:hexagram];
}

- (void)configurationHeader {
    self.header = [[UILabel alloc] initWithFrame:CGRectMake(30, 44, SCREEN_WIDTH - 60, 20)];
    _header.textColor = [UIColor blackColor];
    _header.backgroundColor = [UIColor clearColor];
    _header.textAlignment = NSTextAlignmentCenter;
    _header.font = [UIFont systemFontOfSize:20.];
    _header.text = [[MyMusicPlayer sharedMyMusicPlayer] music].title;
    [[MyMusicPlayer sharedMyMusicPlayer] addObserver:self forKeyPath:@"music" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self.view addSubview:_header];
}

- (void)configurationControl {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hadleSwipe:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipe];
    [leftSwipe requireGestureRecognizerToFail:tap];
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hadleSwipe:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipe];
    [rightSwipe requireGestureRecognizerToFail:tap];
}
#pragma mark - UIGestureRecognizer
- (void)handleTap:(UITapGestureRecognizer *)tap {
    CALayer *layer = [self.view.layer hitTest:[tap locationInView:self.view]];
    if (layer == self.reimu.red) {
        if (!_setView) {
            self.setView = [[SettingsView alloc] init];
            [[[[UIApplication sharedApplication] delegate] window] addSubview:_setView];
        }
        return;
    }
    if (layer == self.reimu.blue) {
        [[[[UIApplication sharedApplication] delegate] window] sendSubviewToBack:self.view];
        return;
    }
    if (self.myPlayer.isPlaying == NO) {
        [self.myPlayer canclePause];
        [self.reimu setTrans];
    } else {
        [self.reimu.timer invalidate];
        [self.myPlayer pause];
    }
    if (_setView) {
        [_setView removeFromSuperview];
        self.setView = nil;
    }
}

- (void)hadleSwipe:(UISwipeGestureRecognizer *)swipe {
    switch (swipe.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
        {
            [self.reimu setTrans];
            [self.myPlayer playBeforeMusic];
        }
            break;
        case UISwipeGestureRecognizerDirectionRight:
        {
            [self.reimu setTrans];
            [self.myPlayer playNextMusic];
        }
            break;
            
        default:
            break;
    }
}

- (void)dealloc
{
    [self.cover removeObserver:self forKeyPath:@"progress" context:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
