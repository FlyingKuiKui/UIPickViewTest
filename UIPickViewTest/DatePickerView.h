//
//  DatePickerView.h
//  UIPickViewTest
//
//  Created by 王盛魁 on 16/2/24.
//  Copyright © 2016年 wangsk. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DatePickerViewDelegate <NSObject>

- (void)datePickerTimeYear:(NSString *)year Month:(NSString *)month Day:(NSString *)day;

@end

@interface DatePickerView : UIView <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, assign) id <DatePickerViewDelegate> delegate;
// 推出
- (void)showPickerView;

@end
