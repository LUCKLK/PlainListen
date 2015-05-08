//
//  PlayView.m
//  PlainListen
//
//  Created by lanouhn on 15-4-21.
//  Copyright (c) 2015年 luck. All rights reserved.
//

#import "PlayView.h"

@implementation PlayView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, self.bounds, [UIImage imageNamed:@"back.jpg"].CGImage);
}


@end
