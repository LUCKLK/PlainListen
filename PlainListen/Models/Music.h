//
//  Music.h
//  PlainListen
//
//  Created by lanouhn on 15-4-10.
//  Copyright (c) 2015年 luck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface Music : NSObject <NSCopying>
@property (nonatomic) MPMediaEntityPersistentID persistentID;   //唯一标识
@property (copy, nonatomic) NSString *title;        //标题
@property (copy, nonatomic) NSString *albumTitle;   //专辑名
@property (copy, nonatomic) NSString *artist;       //艺术家
@property (copy, nonatomic) NSString *genre;        //类别
@property (copy, nonatomic) NSString *composer;     //作曲家
@property (nonatomic) NSTimeInterval playbackDuration;    //播放时间
@property (nonatomic) MPMediaItemArtwork *artwork;  //封面
@property (copy, nonatomic) NSString *lyrics;       //歌词
@property (strong, nonatomic) NSURL *assetURL;        //播放地址
@property (nonatomic) NSUInteger playCount;         //播放次数
@property (copy, nonatomic) NSString *listName;     //列表名
@end
