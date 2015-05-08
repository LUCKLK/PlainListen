//
//  HintView.h
//  PlainListen
//
//  Created by lanouhn on 15-4-9.
//  Copyright (c) 2015年 luck. All rights reserved.
//

#import <UIKit/UIKit.h>
@class List;
@class Music;
typedef List *(^Contain) ();
typedef void(^InsertData)(Music *);

@interface HintView : UIView
@property (strong, nonatomic) NSMutableArray *containsArr;
@property (copy, nonatomic) InsertData insertMusic;
@property (strong, nonatomic) Music *music;

+ (HintView *)sharedHintView;

- (void)ConfigurationWithPoint:(CGPoint)point;

@end
