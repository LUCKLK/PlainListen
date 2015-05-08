//
//  Reimu.m
//  LearnToDraw
//
//  Created by lanouhn on 15-4-13.
//  Copyright (c) 2015年 luck. All rights reserved.
//

#import "Reimu.h"
#import <UIKit/UIKit.h>
@interface Reimu ()
@property (strong, nonatomic) CAEmitterLayer *emitterLayer;
@end
@implementation Reimu
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.position = CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) / 2, CGRectGetHeight([[UIScreen mainScreen] bounds]) / 2);
        [self configurationSubLayer];
    }
    return self;
}

- (void)configurationSubLayer {
    [self configurationRed];
    [self configurationBlue];
//    [self configurationEmitter];
    [self setTrans];
}

- (void)setTrans {
    [self.timer invalidate];
//    self.timer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(setCircle) userInfo:nil repeats:YES];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(setCircle) userInfo:nil repeats:YES];
    [self.timer fire];
}
- (void)setCircle {
    [self setNeedsLayout];
}

- (void)configurationEmitter {
    self.emitterLayer = [CAEmitterLayer layer];
    _emitterLayer.bounds = CGRectZero;
    _emitterLayer.position = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    _emitterLayer.renderMode = kCAEmitterLayerAdditive;
    _emitterLayer.emitterShape = kCAEmitterLayerLine;
    CAEmitterCell *fire = [CAEmitterCell emitterCell];
    _emitterLayer.emitterPosition = CGPointMake(0.5, 0.5);
    fire.birthRate = 5;     //粒子出生率
    fire.lifetime = 1.;    //粒子生命时间
    fire.lifetimeRange = 0.5;   //生命时间变化范围
    
    fire.color = [[UIColor colorWithRed:0.0 green:0.5 blue:0.9 alpha:0.8] CGColor];  //粒子颜色
    //fire.contents = (id)[[UIImage imageNamed:@"Particles_fire.png"] CGImage];
    fire.contents = (id)[[UIImage imageNamed:@"snow"] CGImage]; //cell内容，一般是一个CGImage
    fire.velocity = 40;     //速度
    fire.velocityRange = 1; //速度范围
    fire.emissionRange = 2; //发射角度
    fire.scaleSpeed = 0.2;  //变大速度
    fire.spin = 3;        //旋转
    [fire setName:@"fire"];  //cell名字，方便根据名字以后查找修改
    _emitterLayer.emitterCells = [NSArray arrayWithObject:fire];
    [self addSublayer:_emitterLayer];
}


- (void)configurationRed {
    self.red = [CAShapeLayer layer];
    _red.bounds = CGRectMake(0, 0, 50, 50);
    _red.position = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    _red.cornerRadius = 25;
    _red.masksToBounds = YES;
    _red.contents = (id)[UIImage imageNamed:@"reimu_red"].CGImage;
    _red.anchorPoint = CGPointMake(0.5, -2.);
    [self addSublayer:_red];
}

- (void)configurationBlue {
    self.blue = [CAShapeLayer layer];
    _blue.bounds = CGRectMake(0, 0, 50, 50);
    _blue.position = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    _blue.cornerRadius = 25;
    _blue.masksToBounds = YES;
    _blue.contents = (id)[UIImage imageNamed:@"reimu_blue"].CGImage;
    _blue.anchorPoint = CGPointMake(0.5, 3.);
    [self addSublayer:_blue];
}

- (void)layoutSublayers {
    CATransform3D redTransform = CATransform3DRotate(_red.transform, M_PI / 180 * -5, 0, 0, 1);
    _red.transform = redTransform;
    CATransform3D whiteTransform = CATransform3DRotate(_blue.transform, M_PI / 180 * -5, 0, 0, 1);
    _blue.transform = whiteTransform;
}

//- (void)addAnima {
//    [_red addAnimation:[self circleAnimation] forKey:@"red"];
//    [_white addAnimation:[self circleAnimation] forKey:@"white"];
//}

//- (CABasicAnimation *)circleAnimation {
//    CATransform3D transform1 = CATransform3DMakeRotation(0, 0, 0, 1);
//    CATransform3D transform2 = CATransform3DMakeRotation(M_PI, 0, 0, 1);
//    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform"];
////    anima.delegate = self;
//    anima.removedOnCompletion = YES;
//    anima.fromValue = [NSValue valueWithCATransform3D:transform1];
//    anima.toValue = [NSValue valueWithCATransform3D:transform2];
//    anima.duration = 2;
//    return anima;
//}

//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
//    [self addAnima];
//}

@end
