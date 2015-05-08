//
//  MusicCell.m
//  PlainListen
//
//  Created by lanouhn on 15-4-9.
//  Copyright (c) 2015年 luck. All rights reserved.
//

#import "MusicCell.h"
#import "HintView.h"
#import "DataHelper.h"
@interface MusicCell ()
@property (strong, nonatomic) IBOutlet UIImageView *iconView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPress;

@end
@implementation MusicCell

- (void)setMusic:(Music *)music {
    if (_music != music) {
        _music = music;
        self.iconView.image = [_music.artwork imageWithSize:_music.artwork.imageCropRect.size];
        self.titleLabel.text = _music.title;
        if (_longPress) {
            [self removeGestureRecognizer:_longPress];
        }
        [self addLongPressGesture];
    }
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.layer.borderWidth = 1.5;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.iconView.image = [_music.artwork imageWithSize:_music.artwork.imageCropRect.size];
    self.titleLabel.text = _music.title;
}

- (void)addLongPressGesture {
    self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self addGestureRecognizer:_longPress];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:[[[UIApplication sharedApplication] delegate] window]];
    HintView *hint = [HintView sharedHintView];
    [hint ConfigurationWithPoint:point];
    hint.music = _music;
    if (_music.listName && _music.listName.length != 0) {
        DataHelper *dataHelper = [DataHelper sharedDataHelper];
        [dataHelper deleteOneMusic:_music];
        NSLog(@"DDDDDDDDDD");
        [self removeGestureRecognizer:gesture];
        NSIndexPath *indexPath = [[self returnCollectionView] indexPathForCell:self];
        [[self returnCollectionView] deleteItemsAtIndexPaths:@[indexPath]];
    }
}

- (UICollectionView *)returnCollectionView {
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UICollectionView class]]) {
            return (UICollectionView *)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    return nil;
}

- (void)dealloc
{
    if (_longPress) {
        [self removeGestureRecognizer:_longPress];
    }
}

@end
