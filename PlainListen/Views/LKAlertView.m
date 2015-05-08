//
//  LKAlertView.m
//  PlainListen
//
//  Created by lanouhn on 15-4-17.
//  Copyright (c) 2015年 luck. All rights reserved.
//

#import "LKAlertView.h"

@implementation LKAlertView

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    if (_prepareDismiss) {
        [super dismissWithClickedButtonIndex:buttonIndex animated:animated];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
