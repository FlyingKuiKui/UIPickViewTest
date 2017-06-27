//
//  ViewController.m
//  UIPickViewTest
//
//  Created by 王盛魁 on 16/2/23.
//  Copyright © 2016年 wangsk. All rights reserved.
//

#import "ViewController.h"
#import "DatePickerView.h"

#import "LoadingView.h"


#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<DatePickerViewDelegate>

@property (nonatomic, strong) DatePickerView *datePickerView;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btnceshi = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
    btnceshi.backgroundColor = [UIColor blueColor];
    [btnceshi addTarget:self action:@selector(btnceshi:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnceshi];
    
    UIDatePicker *date = [[UIDatePicker alloc]init];
    date.datePickerMode = UIDatePickerModeDate;
    date.frame = CGRectMake(0, 200, kWidth, 150);
//    [self.view addSubview:date];
    self.datePickerView =[[DatePickerView alloc]init];
    self.datePickerView.delegate = self;
//    [self.view addSubview:_datePickerView];

    
    
}
- (void)datePickerTimeYear:(NSString *)year Month:(NSString *)month Day:(NSString *)day{
    NSLog(@"%@-%@-%@",year,month,day);
}

- (void)btnceshi:(UIButton *)sender{
    [LoadingView showLoadingView];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
