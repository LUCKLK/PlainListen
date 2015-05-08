//
//  DataHelper.h
//  PlainListen
//
//  Created by lanouhn on 15-4-10.
//  Copyright (c) 2015年 luck. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Music;
@class List;
@interface DataHelper : NSObject
@property (strong, nonatomic) NSMutableArray *allMusic;     //存储所有歌曲
@property (strong, nonatomic) NSMutableDictionary *listMusics;  //列表歌曲

+ (DataHelper *)sharedDataHelper;

- (void)loadMusics; //加载所有歌曲

- (void)loadLists;  //加载列表歌曲

- (void)deleteOneMusic:(Music *)music;  //删除歌曲

- (void)insertOneMusic:(Music *)music forList:(NSString *)listName;     //插入歌曲

- (List *)creatOneListWithTitle:(NSString *)title;   //添加列表

- (void)deleteOneListWithTitle:(NSString *)title;   //删除列表

@end
