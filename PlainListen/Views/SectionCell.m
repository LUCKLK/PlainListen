//
//  SectionCell.m
//  PlainListen
//
//  Created by lanouhn on 15-4-9.
//  Copyright (c) 2015年 luck. All rights reserved.
//

#import "SectionCell.h"
#import "InterfaceHelper.h"
#import "HintView.h"
#import "DataHelper.h"
#import "MusicListViewController.h"
@interface SectionCell ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) CGRect rect;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPress;
@end
@implementation SectionCell



- (void)setSelet:(BOOL)selet {
    _selet = selet;
    if (_selet == YES) {
        self.layer.borderWidth = 3.5;
    } else {
        self.layer.borderWidth = 1.5;
    }
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self configuration];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)layWithWindow {
    CGRect rect = [self convertRect:self.bounds toView:[[[UIApplication sharedApplication] delegate] window]];
    self.rect = rect;
}

- (void)setList:(List *)list {
    if (_list != list) {
        _list = list;
        self.titleLabel.text = _list.title;
        if (_longPress) {
            [self removeGestureRecognizer:_longPress];
        }
        self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        [self addGestureRecognizer:_longPress];
        self.selet = NO;
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress {
    DataHelper *dataHelper = [DataHelper sharedDataHelper];
    [dataHelper deleteOneListWithTitle:_list.title];
    MusicListViewController *musicListVC = [self retrunViewController];
    if (musicListVC != nil) {
        [musicListVC reloadSomething];
    }
    [self removeGestureRecognizer:_longPress];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除成功" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
    [alert show];
}



- (MusicListViewController *)retrunViewController {
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[MusicListViewController class]]) {
            return (MusicListViewController *)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    return nil;
}

- (void)configuration {
    
    self.layer.borderWidth = 1.5;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    __weak HintView *hintView = [HintView sharedHintView];
    __weak typeof(self) mySelf = self;
    Contain contain = ^List *() {
        [mySelf layWithWindow];
        if (CGRectContainsPoint(mySelf.rect, hintView.center) && hintView.hidden == NO) {
            mySelf.selet = YES;
            return mySelf.list;
        } else {
            mySelf.selet = NO;
            return nil;
        }
    };
    [hintView.containsArr addObject:contain];
    NSLog(@"%ld", hintView.containsArr.count);
//    UILongPressGestureRecognizer *longPressi = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    
}

- (void)dealloc
{
    if (_longPress) {
        [self removeGestureRecognizer:_longPress];
    }
}

@end
