//
//  Music.m
//  PlainListen
//
//  Created by lanouhn on 15-4-10.
//  Copyright (c) 2015年 luck. All rights reserved.
//

#import "Music.h"

@implementation Music

- (id)copyWithZone:(NSZone *)zone {
    Music *music = [[Music allocWithZone:zone] init];
    music.persistentID = self.persistentID;
    music.title = [self.title copyWithZone:zone];
    music.albumTitle = [self.albumTitle copyWithZone:zone];
    music.artist = [self.artist copyWithZone:zone];
    music.genre = [self.genre copyWithZone:zone];
    music.composer = [self.composer copyWithZone:zone];
    music.playbackDuration = self.playbackDuration;
    music.artwork = self.artwork;
    music.lyrics = [self.lyrics copyWithZone:zone];
    music.assetURL = [self.assetURL copyWithZone:zone];
    music.playCount = self.playCount;
    music.listName = [self.listName copyWithZone:zone];
    return music;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    Music *music = [[Music allocWithZone:zone] init];
    music.persistentID = self.persistentID;
    music.title = [self.title mutableCopyWithZone:zone];
    music.albumTitle = [self.albumTitle mutableCopyWithZone:zone];
    music.artist = [self.artist mutableCopyWithZone:zone];
    music.genre = [self.genre mutableCopyWithZone:zone];
    music.composer = [self.composer mutableCopyWithZone:zone];
    music.playbackDuration = self.playbackDuration;
    music.artwork = [self.artwork mutableCopy];
    music.lyrics = [self.lyrics mutableCopyWithZone:zone];
    music.assetURL = [self.assetURL mutableCopy];
    music.playCount = self.playCount;
    music.listName = [self.listName mutableCopyWithZone:zone];
    return music;
}
@end
