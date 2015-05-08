//
//  LaunchViewController.m
//  PlainListen
//
//  Created by lanouhn on 15-4-17.
//  Copyright (c) 2015年 luck. All rights reserved.
//

#import "LaunchViewController.h"
#import "UILayout.h"
#import "MusicListViewController.h"
@interface LaunchViewController ()

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    [self setSubviews];
}

- (void)setSubviews {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 7.71);
    UIImageView *firstView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Launch_first.jpeg"]];
    firstView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 6.71);
    [scrollView addSubview:firstView];
    
    UIImageView *lastView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Launch_last.jpeg"]];
    lastView.frame = CGRectMake(0, SCREEN_HEIGHT * 6.71, SCREEN_WIDTH, SCREEN_HEIGHT);
    lastView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [lastView addGestureRecognizer:tap];
    [scrollView addSubview:lastView];
    [self.view addSubview:scrollView];
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    MusicListViewController *musicListVC = [[MusicListViewController alloc] init];
    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:musicListVC];
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
