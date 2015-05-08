//
//  HintView.m
//  PlainListen
//
//  Created by lanouhn on 15-4-9.
//  Copyright (c) 2015年 luck. All rights reserved.
//

#import "HintView.h"
#import "List.h"
#import "Music.h"
#import "DataHelper.h"
@interface HintView ()

@end
@implementation HintView


+ (HintView *)sharedHintView {
    static HintView *hintView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hintView = [[HintView alloc] init];
    });
    return hintView;
}


- (NSMutableArray *)containsArr {
    if (!_containsArr) {
        self.containsArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _containsArr;
}

- (void)ConfigurationWithPoint:(CGPoint)point {
    self.center = point;
    self.hidden = NO;
    self.bounds = CGRectMake(0, 0, 0, 0);
    self.layer.cornerRadius = 0.;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor redColor];
    [UIView animateWithDuration:0.5 animations:^{
        self.bounds = CGRectMake(0, 0, 64, 64);
        self.layer.cornerRadius = 32;
    } completion:^(BOOL finished) {
        self.bounds = CGRectMake(0, 0, 64, 64);
        self.center = point;
    }];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"%s", __func__);
    CGPoint point = [((UITouch *)[touches anyObject]) locationInView:[[[UIApplication sharedApplication] delegate] window]];
    self.center = point;
//    for (Contain contain in self.containsArr) {
//        contain();
//    }
}

//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"%s", __func__);
//    [UIView animateWithDuration:0.5 animations:^{
//        self.bounds = CGRectMake(0, 0, 0, 0);
//    } completion:^(BOOL finished) {
//        self.hidden = YES;
//    }];
//}

//- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
//    NSLog(@"%s", __func__);
//    [UIView animateWithDuration:0.5 animations:^{
//        self.bounds = CGRectMake(0, 0, 0, 0);
//    } completion:^(BOOL finished) {
//        self.hidden = YES;
//    }];
//}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
    [UIView animateWithDuration:0.5 animations:^{
        self.bounds = CGRectMake(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
    DataHelper *dataHelper = [DataHelper sharedDataHelper];
    NSMutableSet *set = [NSMutableSet set];
    for (Contain contain in self.containsArr) {
        List *list = contain();
        if (list) {
            [set addObject:list];
        }
    }
    for (List *list in set) {
        if (!_music.listName || _music.listName.length == 0) {
            Music *music = [_music copy];
            music.listName = list.title;
            [dataHelper insertOneMusic:music forList:list.title];
        } else {
            _music.listName = list.title;
            [dataHelper insertOneMusic:_music forList:list.title];
        }
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, self.bounds, [UIImage imageNamed:@"reimu_blue"].CGImage);
}


@end
