//
//  InterfaceHelper.m
//  PlainListen
//
//  Created by lanouhn on 15-4-10.
//  Copyright (c) 2015年 luck. All rights reserved.
//

#import "InterfaceHelper.h"
#import "HintView.h"

@implementation InterfaceHelper
+ (InterfaceHelper *)sharedInterfaceHelper; {
    static InterfaceHelper *interfaceHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        interfaceHelper = [[InterfaceHelper alloc] init];
    });
    return interfaceHelper;
}

//- (void)locationNotificationWithView:(UIView *)view byOtherView:(UIView *)other {
//    [other addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
//    CGPoint point = other.center;
//    CGRect rect = [view convertRect:view.frame toView:[[[UIApplication sharedApplication] delegate] window]];
//    NSLog(@"%@", NSStringFromCGPoint(point));
//    NSLog(@"%@", NSStringFromCGRect(rect));
//    if (rect.origin.x < point.x < rect.origin.x + rect.size.width && rect.origin.y < point.y < rect.origin.y + rect.size.width) {
//        view.layer.borderWidth = 3.0;
//    }
//    [other removeObserver:self forKeyPath:@"center"];
//}





@end
