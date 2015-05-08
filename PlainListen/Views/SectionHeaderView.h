//
//  SectionHeaderView.h
//  PlainListen
//
//  Created by lanouhn on 15-4-11.
//  Copyright (c) 2015年 luck. All rights reserved.
//

#import <UIKit/UIKit.h>
@class List;
typedef void(^CreatList)(List *);
@interface SectionHeaderView : UICollectionReusableView <UIAlertViewDelegate>
@property (copy, nonatomic) CreatList creatList;
@end
