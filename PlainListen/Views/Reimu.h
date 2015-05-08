//
//  Reimu.h
//  LearnToDraw
//
//  Created by lanouhn on 15-4-13.
//  Copyright (c) 2015年 luck. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface Reimu : CALayer
@property (strong, nonatomic) CAShapeLayer *red;
@property (strong, nonatomic) CAShapeLayer *blue;
@property (strong, nonatomic) NSTimer *timer;

- (void)setTrans;

@end
