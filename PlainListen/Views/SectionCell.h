//
//  SectionCell.h
//  PlainListen
//
//  Created by lanouhn on 15-4-9.
//  Copyright (c) 2015年 luck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Music.h"
#import "List.h"

typedef void(^SelectList) ();
@interface SectionCell : UICollectionViewCell
@property (strong, nonatomic) List *list;
@property (nonatomic) BOOL selet;
- (void)layWithWindow;
@end
