//
//  DataHelper.m
//  PlainListen
//
//  Created by lanouhn on 15-4-10.
//  Copyright (c) 2015年 luck. All rights reserved.
//

#import "DataHelper.h"
#import "Music.h"
#import "List.h"
#import "FMDB.h"
#import <MediaPlayer/MediaPlayer.h>
@interface DataHelper ()
@property (strong, nonatomic) NSMutableDictionary *sqlites; //数据库
@end

@implementation DataHelper

+ (DataHelper *)sharedDataHelper {
    static DataHelper *dataHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataHelper = [[DataHelper alloc] init];
    });
    return dataHelper;
}

- (NSMutableDictionary *)listMusics {
    if (!_listMusics) {
        self.listMusics = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    return _listMusics;
}

- (NSMutableDictionary *)sqlites {
    if (!_sqlites) {
        self.sqlites = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    return _sqlites;
}

- (NSMutableArray *)allMusic {
    if (!_allMusic) {
        self.allMusic = [NSMutableArray arrayWithCapacity:1];
    }
    return _allMusic;
}
//加载歌曲列表
- (void)loadLists {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"Lists"];
    if (![fileManager fileExistsAtPath:filePath]) {
        NSError *error = nil;
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    NSString *sqlitePath = [filePath stringByAppendingPathComponent:@"listMusic.sqlite"];
    if (![fileManager fileExistsAtPath:sqlitePath]) {
        return;
    }
    NSLog(@"%@", sqlitePath);
    FMDatabase *db = [FMDatabase databaseWithPath:sqlitePath];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
    if ([db open]) {
        FMResultSet *listSet = [db executeQuery:@"select * from list_table order by id desc;"];
        while ([listSet next]) {
            NSString *title = [listSet stringForColumn:@"title"];
            [arr addObject:title];
        }
    }
    for (NSString *fileName in arr) {
        List *list = [[List alloc] init];
        list.title = fileName;
        NSMutableArray *musicArr = [NSMutableArray arrayWithCapacity:1];
        if ([db open]) {
            NSString *execute = [NSString stringWithFormat:@"select * from %@ order by id desc;", fileName];
            FMResultSet *resultSet = [db executeQuery:execute];
            while ([resultSet next]) {
                Music *music;
                NSString *perID = [resultSet stringForColumn:@"persistentID"];
                MPMediaEntityPersistentID persistentID = [perID longLongValue];
                music = [self returnMusicWithPersistentID:persistentID];
                if (!music) {
                    Music *dele = [[Music alloc] init];
                    dele.persistentID = persistentID;
                    [self deleteMusic:dele];
                    continue;
                }
                music.listName = fileName;
                NSLog(@"%@", fileName);
                [musicArr addObject:music];
            }
            list.musics = musicArr;
            [self.listMusics setObject:list forKey:list.title];
        }
    }
}
//根据persistentID获得music
- (Music *)returnMusicWithPersistentID:(MPMediaEntityPersistentID)persistentID {
    for (Music *music in self.allMusic) {
        if (persistentID == music.persistentID) {
            return [music copy];
        }
    }
    return nil;
}
//加载ipod歌曲
- (void)loadMusics {
    MPMediaQuery *query = [MPMediaQuery songsQuery];
    NSArray *itemsArr = [query items];
    for (MPMediaItem *item in itemsArr) {
        Music *music = [[Music alloc] init];
        music.persistentID = item.persistentID;
        music.title = item.title;
        music.albumTitle = item.albumTitle;
        music.artist = item.artist;
        music.genre = item.genre;
        music.composer = item.composer;
        music.playbackDuration = item.playbackDuration;
        music.artwork = item.artwork;
        music.lyrics = item.lyrics;
        music.assetURL = item.assetURL;
        music.playCount = item.playCount;
        [self.allMusic addObject:music];
    }
}

#pragma mark - dataProcess
//创建列表
- (List *)creatOneListWithTitle:(NSString *)title {
    [self creatListWithTitle:title];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
    List *list = [[List alloc] init];
    list.title = title;
    list.Musics = arr;
    [self.listMusics setObject:list forKey:title];
    return list;
}
//删除列表
- (void)deleteOneListWithTitle:(NSString *)title {
    [self.listMusics removeObjectForKey:title];
    [self deleteListWithTitle:title];
}
//删除歌曲
- (void)deleteOneMusic:(Music *)music {
    [((List *)self.listMusics[music.listName]).musics removeObject:music];
    [self deleteMusic:music];
}
//插入歌曲
- (void)insertOneMusic:(Music *)music forList:(NSString *)listName {
    [((List *)self.listMusics[listName]).musics addObject:music];
    [self insertMusic:music forList:listName];
}

#pragma mark - sqlite
//创建列表
- (void)creatListWithTitle:(NSString *)title {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"Lists"];
    if (![fileManager fileExistsAtPath:filePath]) {
        NSError *error = nil;
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    NSString *sqlitePath = [filePath stringByAppendingPathComponent:@"listMusic.sqlite"];
    NSLog(@"%@", sqlitePath);
    FMDatabase *db = [FMDatabase databaseWithPath:sqlitePath];
    if ([db open]) {
        BOOL isOK = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS list_table (id integer PRIMARY KEY AUTOINCREMENT, title text);"];
        if (isOK) {
            NSLog(@"创建列表表成功");
            BOOL isInsert = [db executeUpdate:@"INSERT INTO list_table (title) VALUES (?);", title];
            if (isInsert) {
                NSLog(@"插入列表表成功");
                NSString *creatSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY AUTOINCREMENT, persistentID text);", title];
                BOOL result = [db executeUpdate:creatSql];
                if (result) {
                    NSLog(@"创建成功");
                } else {
                    NSLog(@"创建失败");
                }
            } else {
                NSLog(@"插入列表表失败");
            }
        } else {
            NSLog(@"创建列表表失败");
        }
    }
}
//删除列表
- (void)deleteListWithTitle:(NSString *)title {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"Lists"];
    NSString *sqlitePath = [filePath stringByAppendingPathComponent:@"listMusic.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:sqlitePath];
    if ([db open]) {
        NSString *deleteList = [NSString stringWithFormat:@"DROP TABLE %@", title];
        BOOL result = [db executeUpdate:deleteList];
        if (result) {
            NSLog(@"删除表成功");
            BOOL isDelete = [db executeUpdate:@"delete from list_table where title=?;", title];
            if (isDelete) {
                NSLog(@"从列表表删除成功");
            } else {
                NSLog(@"从列表表删除失败");
            }
        } else {
            NSLog(@"删除表失败");
        }
    }
}

//删除歌曲
- (void)deleteMusic:(Music *)music {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"Lists"];
    NSString *sqlitePath = [filePath stringByAppendingPathComponent:@"listMusic.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:sqlitePath];
    if ([db open]) {
        NSString *persistentID = [NSString stringWithFormat:@"%llu", music.persistentID];
        NSString *deleteMusic = [NSString stringWithFormat:@"delete from %@ where persistentID=%@;", music.listName, persistentID];
        BOOL result = [db executeUpdate:deleteMusic];
        if (result) {
            NSLog(@"删除成功");
        } else {
            NSLog(@"删除失败");
        }
    }
}
//插入歌曲进列表
- (void)insertMusic:(Music *)music forList:(NSString *)listName {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"Lists"];
    NSString *sqlitePath = [filePath stringByAppendingPathComponent:@"listMusic.sqlite"];
    NSLog(@"%@", sqlitePath);
    FMDatabase *db = [FMDatabase databaseWithPath:sqlitePath];
    NSLog(@"%@", db);
    if ([db open]) {
        NSString *persistentID = [NSString stringWithFormat:@"%llu", music.persistentID];
        NSString *insert = [NSString stringWithFormat:@"INSERT INTO %@ (persistentID) VALUES (%@);", listName, persistentID];
        BOOL result = [db executeUpdate:insert];
        if (result) {
            NSLog(@"插入成功");
        } else {
            NSLog(@"插入失败");
        }
    }
}


@end
