//
//  SectionHeaderView.m
//  PlainListen
//
//  Created by lanouhn on 15-4-11.
//  Copyright (c) 2015年 luck. All rights reserved.
//

#import "SectionHeaderView.h"
#import "DataHelper.h"
#import "LKAlertView.h"
@implementation SectionHeaderView 

- (void)awakeFromNib {
    // Initialization code
    self.layer.borderWidth = 1.5;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tap];
    
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    LKAlertView *alert = [[LKAlertView alloc] initWithTitle:@"提示" message:@"添加列表" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.delegate = self;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [(LKAlertView *)alertView isPrepareDismiss:YES];
    if (buttonIndex == 1) {
        DataHelper *dataHelper = [DataHelper sharedDataHelper];
        NSString *title = [alertView textFieldAtIndex:0].text;
        if ([title isEqualToString:@"list_table"]) {
            [(LKAlertView *)alertView isPrepareDismiss:NO];
            return;
        }
        if (!title || [title isEqualToString:@""]) {
            alertView.message = @"列表名重复或为空";
            [(LKAlertView *)alertView isPrepareDismiss:NO];
            return;
        }
        for (NSString *listName in [dataHelper.listMusics allKeys]) {
            if (!title || [title isEqualToString:@""] || [title isEqualToString:listName]) {
                alertView.message = @"列表名重复或为空";
                [(LKAlertView *)alertView isPrepareDismiss:NO];
                return;
            }
        }
        List *list = [dataHelper creatOneListWithTitle:title];
        self.creatList(list);
    }
}



@end
