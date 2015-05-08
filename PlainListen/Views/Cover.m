//
//  Cover.m
//  PlainListen
//
//  Created by lanouhn on 15-4-11.
//  Copyright (c) 2015年 luck. All rights reserved.
//

#import "Cover.h"

@interface Cover ()
@property (strong, nonatomic) CAShapeLayer *shapeLayer;
@property (strong, nonatomic) UIImageView *cover;
@end
@implementation Cover

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configurationSubviews];
    }
    return self;
}

- (UIImageView *)cover {
    if (!_cover) {
        self.cover = [[UIImageView alloc] init];
        [self addSubview:_cover];
    }
    return _cover;
}

- (void)configurationSubviews {
    self.layer.cornerRadius = self.bounds.size.width / 2;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.shapeLayer = [CAShapeLayer layer];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:self.bounds.size.width / 2 startAngle:M_PI_2 endAngle:M_PI_2 + 2 * M_PI clockwise:YES];
    self.shapeLayer.position = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    self.shapeLayer.path = bezierPath.CGPath;
    self.shapeLayer.fillColor = nil;
    self.shapeLayer.lineWidth = 20.;
    self.shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    self.shapeLayer.strokeEnd = 0.;
    [self.layer addSublayer:self.shapeLayer];
}

- (void)setProgress:(CGFloat)progress {
    if (_progress != progress) {
        _progress = progress;
        self.shapeLayer.strokeEnd = _progress;
        [self.shapeLayer setNeedsDisplay];
    }
}

- (void)setCoverImage:(UIImage *)coverImage {
    if (_coverImage != coverImage) {
        _coverImage = coverImage;
        self.cover.image = _coverImage;
        [self configurationImage];
    }
}

- (void)configurationImage {
    self.cover.bounds = CGRectMake(0, 0, self.bounds.size.width - 20, self.bounds.size.height - 20);
    self.cover.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    self.cover.layer.cornerRadius = self.layer.cornerRadius - 10;
    self.cover.layer.masksToBounds = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
