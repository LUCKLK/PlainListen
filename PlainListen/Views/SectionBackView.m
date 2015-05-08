//
//  SectionBackView.m
//  PlainListen
//
//  Created by lanouhn on 15-4-16.
//  Copyright (c) 2015年 luck. All rights reserved.
//

#import "SectionBackView.h"

@implementation SectionBackView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, self.bounds, [UIImage imageNamed:@"sectionView_back"].CGImage);
    CGContextSetLineWidth(context, 3);
    CGContextSetRGBStrokeColor(context, 255 / 255.0, 255 / 255.0, 255 / 255.0, 1.);
    CGContextMoveToPoint(context, 0, 0);
    CGPoint point[4] = {CGPointMake(self.bounds.size.width, 0), CGPointMake(self.bounds.size.width, self.bounds.size.height), CGPointMake(0, self.bounds.size.height), CGPointMake(0, 0)};
    CGContextAddLines(context, point, 4);
    CGContextDrawPath(context, kCGPathStroke);
    
}


@end
