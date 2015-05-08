//
//  SectionsLayout_.m
//  PlainListen
//
//  Created by lanouhn on 15-4-9.
//  Copyright (c) 2015年 luck. All rights reserved.
//

#import "SectionsLayout_.h"
#import "UILayout.h"
@interface SectionsLayout_ ()
@property (nonatomic) NSInteger itemCount;
@property (strong, nonatomic) NSMutableArray *itemsArr;
@property (nonatomic) CGFloat lineSpace;
@end
@implementation SectionsLayout_

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lineSpace = 4.;
    }
    return self;
}

- (NSMutableArray *)itemsArr {
    if (!_itemsArr) {
        self.itemsArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _itemsArr;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(SCREEN_WIDTH / 2, (SECTION_CELL_HEIGHT + self.lineSpace) * self.itemCount + SECTION_CELL_HEIGHT / 2);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH / 2, SECTION_CELL_HEIGHT / 2);
}

- (void)prepareLayout {
    [super prepareLayout];
    [self calculatorItemLayout];
}

- (void)calculatorItemLayout {
    [self.itemsArr removeAllObjects];
    self.itemCount = [self.collectionView numberOfItemsInSection:0];
    NSIndexPath *headerIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    UICollectionViewLayoutAttributes *headerAttr = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:headerIndexPath];
    [self.itemsArr addObject:headerAttr];
    for (int i = 0; i < _itemCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = CGRectMake(0, SECTION_CELL_HEIGHT / 2 + i * (SECTION_CELL_HEIGHT + self.lineSpace) + self.lineSpace, SCREEN_WIDTH / 2, SECTION_CELL_HEIGHT);
        [self.itemsArr addObject:attributes];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.itemsArr[indexPath.item];
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if (elementKind == UICollectionElementKindSectionHeader) {
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
        attributes.frame = CGRectMake(0, 0, SCREEN_WIDTH / 2, SECTION_CELL_HEIGHT / 2);
        
        return attributes;
    }
    return nil;
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

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}


@end
