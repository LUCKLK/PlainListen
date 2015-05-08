//
//  VerticalLayout_.m
//  PlainListen
//
//  Created by lanouhn on 15-4-9.
//  Copyright (c) 2015年 luck. All rights reserved.
//

#import "VerticalLayout_.h"
#import "UILayout.h"
@interface VerticalLayout_ ()
@property (nonatomic) NSInteger itemCount;
@property (strong, nonatomic) NSMutableArray *itemsArr;
@property (nonatomic) CGFloat lineSpace;
//@property (strong, nonatomic) NSMutableArray *indexPathsToAnimate;
@end
@implementation VerticalLayout_


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lineSpace = 10;
    }
    return self;
}

- (NSMutableArray *)itemsArr {
    if (!_itemsArr) {
        self.itemsArr = [NSMutableArray array];
    }
    return _itemsArr;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(SCREEN_WIDTH, (VERTICAL_CELL_HEIGHT + self.lineSpace) * self.itemCount);
}

- (void)prepareLayout {
    [super prepareLayout];
    [self calculatorItemLayout];
}

- (void)calculatorItemLayout {
    [self.itemsArr removeAllObjects];
    self.itemCount = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < self.itemCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attribute.frame = CGRectMake(0, (VERTICAL_CELL_HEIGHT  + self.lineSpace) * i, SCREEN_WIDTH, VERTICAL_CELL_HEIGHT);
        [self.itemsArr addObject:attribute];
    }
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.itemsArr[indexPath.item];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < self.itemsArr.count; i++) {
        UICollectionViewLayoutAttributes *attributes = self.itemsArr[i];
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            [arr addObject:attributes];
        }
    }
    return arr;
}

- (BOOL)shouldInvalidateLayoutForPreferredLayoutAttributes {
    return NO;
}


@end
