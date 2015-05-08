//
//  List.h
//  PlainListen
//
//  Created by lanouhn on 15-4-10.
//  Copyright (c) 2015年 luck. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface List : NSObject
@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) NSMutableArray *musics;
@end
