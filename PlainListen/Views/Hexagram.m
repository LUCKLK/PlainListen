//
//  Hexagram.m
//  PlainListen
//
//  Created by lanouhn on 15-4-11.
//  Copyright (c) 2015年 luck. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "UILayout.h"
#import "Hexagram.h"
@interface Hexagram ()
@property (strong, nonatomic) CABasicAnimation *strokeAnimation;
@property (strong, nonatomic) CAShapeLayer *shapeLayer1;
@property (strong, nonatomic) CAShapeLayer *shapeLayer2;
@end
@implementation Hexagram
- (instancetype)init {
    if (self = [super init]) {
        [self configurationSubLayer];
    }
    return self;
}

- (void)setAfter {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.didEnd();
        NSArray *arr = [NSArray arrayWithArray:self.sublayers];
        for (CALayer *layer in arr) {
            [layer removeAllAnimations];
            [layer removeFromSuperlayer];
        }
        [self removeFromSuperlayer];
    });
}
- (CABasicAnimation *)strokeAnimation {
    if (!_strokeAnimation) {
        self.strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        self.strokeAnimation.fromValue = @(0.f);
        self.strokeAnimation.toValue = @(1.f);
        self.strokeAnimation.duration = 3.;
        self.strokeAnimation.delegate = self;
    }
    return _strokeAnimation;
}

- (void)configurationSubLayer {
    [self addAnimation];
}

- (CAShapeLayer *)smallCircle {
    CAShapeLayer *smallCircleLayer = [CAShapeLayer layer];
    smallCircleLayer.position = SCREEN_CENTER;
    UIBezierPath *smallCirclePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:100. startAngle:M_PI_2 endAngle:M_PI_2 * 5 clockwise:YES];
    smallCircleLayer.path = smallCirclePath.CGPath;
    smallCircleLayer.fillColor = nil;
    smallCircleLayer.strokeColor = [UIColor redColor].CGColor;
    smallCircleLayer.lineWidth = 2.;
    [self addSublayer:smallCircleLayer];
    return smallCircleLayer;
}

- (CAShapeLayer *)largeCircle {
    CAShapeLayer *largeCircleLayer = [CAShapeLayer layer];
    largeCircleLayer.position = SCREEN_CENTER;
    UIBezierPath *largeCirclePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:115. startAngle:M_PI endAngle:-M_PI clockwise:NO];
    largeCircleLayer.path = largeCirclePath.CGPath;
    largeCircleLayer.fillColor = nil;
    largeCircleLayer.strokeColor = [UIColor redColor].CGColor;
    largeCircleLayer.lineWidth = 2.;
    [self addSublayer:largeCircleLayer];
    return largeCircleLayer;
}

- (CAShapeLayer *)hexagram1 {
    CGMutablePathRef drawPath1 = CGPathCreateMutable();
    CGMutablePathRef path1 = CGPathCreateMutable();
    CGPathMoveToPoint(path1, NULL, - 50 * sqrtf(3.), - 50);
    CGPathAddLineToPoint(path1, NULL, 50 * sqrtf(3.), - 50);
    CGPathAddPath(drawPath1, NULL, path1);
    CGMutablePathRef path2 = CGPathCreateMutable();
    CGPathMoveToPoint(path2, NULL,50 * sqrtf(3.), - 50);
    CGPathAddLineToPoint(path2, NULL, 0, 100);
    CGPathAddPath(drawPath1, NULL, path2);
    CGMutablePathRef path3 = CGPathCreateMutable();
    CGPathMoveToPoint(path3, NULL, 0, 100);
    CGPathAddLineToPoint(path3, NULL, - 50 * sqrtf(3.), - 50);
    CGPathAddPath(drawPath1, NULL, path3);
    
    CAShapeLayer *shapeLayer1 = [CAShapeLayer layer];
    shapeLayer1.position = SCREEN_CENTER;
    shapeLayer1.path = drawPath1;
    shapeLayer1.strokeColor = [UIColor redColor].CGColor;
    shapeLayer1.lineWidth = 2.0;
    shapeLayer1.strokeEnd = 1.f;
    [self addSublayer:shapeLayer1];
    return shapeLayer1;
}
- (CAShapeLayer *)hexagram2 {
    CGMutablePathRef drawPath2 = CGPathCreateMutable();
    CGMutablePathRef path4 = CGPathCreateMutable();
    CGPathMoveToPoint(path4, NULL, 50 * sqrtf(3.), 50);
    CGPathAddLineToPoint(path4, NULL, - 50 * sqrtf(3.), 50);
    CGPathAddPath(drawPath2, NULL, path4);
    CGMutablePathRef path5 = CGPathCreateMutable();
    CGPathMoveToPoint(path5, NULL, - 50 * sqrtf(3.), 50);
    CGPathAddLineToPoint(path5, NULL, 0, - 100);
    CGPathAddPath(drawPath2, NULL, path5);
    CGMutablePathRef path6 = CGPathCreateMutable();
    CGPathMoveToPoint(drawPath2, NULL, 0, - 100);
    CGPathAddLineToPoint(drawPath2, NULL, 50 * sqrtf(3.), 50);
    CGPathAddPath(drawPath2, NULL, path6);
    
    CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
    shapeLayer2.position = SCREEN_CENTER;
    shapeLayer2.path = drawPath2;
    shapeLayer2.strokeColor = [UIColor redColor].CGColor;
    shapeLayer2.lineWidth = 2.0;
    shapeLayer2.strokeEnd = 1.f;
    [self addSublayer:shapeLayer2];
    return shapeLayer2;
}

- (void)addAnimation {
    [[self smallCircle] addAnimation:self.strokeAnimation forKey:@"smallCircle"];
    [[self largeCircle] addAnimation:self.strokeAnimation forKey:@"largeCircle"];
    self.shapeLayer1 = [self hexagram1];
    self.shapeLayer2 = [self hexagram2];
    [self.shapeLayer1 addAnimation:self.strokeAnimation forKey:@"hexagram1"];
    [self.shapeLayer2 addAnimation:self.strokeAnimation forKey:@"hexagram2"];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    CATransform3D scaleTransformFrom = CATransform3DMakeScale(0, 0, 0);
    CATransform3D scaleTransformTo = CATransform3DMakeScale(5.8, 5.8, 5.8);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:scaleTransformFrom];
    animation.toValue = [NSValue valueWithCATransform3D:scaleTransformTo];
    animation.duration = 1.;
    animation.removedOnCompletion = NO;
    animation.fillMode=kCAFillModeForwards;
    [self.shapeLayer1 addAnimation:animation forKey:@"scale1"];
    [self.shapeLayer2 addAnimation:animation forKey:@"scale2"];
}




@end
