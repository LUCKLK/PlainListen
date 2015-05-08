//
//  Hexagram.h
//  PlainListen
//
//  Created by lanouhn on 15-4-11.
//  Copyright (c) 2015年 luck. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef void(^DidEnd) ();

@interface Hexagram : CALayer
@property (copy, nonatomic) DidEnd didEnd;

- (void)setAfter;

@end
