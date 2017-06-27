//
//  DatePickerView.m
//  UIPickViewTest
//
//  Created by 王盛魁 on 16/2/24.
//  Copyright © 2016年 wangsk. All rights reserved.
//

#import "DatePickerView.h"
//宽度
#define WIDTH ([UIScreen mainScreen].bounds.size.width)
//高度
#define HEIGHT ([UIScreen mainScreen].bounds.size.height)

static NSInteger intStartYear = 1949; // 起始年份

@interface DatePickerView ()
@property (nonatomic, strong) UIPickerView *vDatePicker;
@property (nonatomic ) NSInteger intNumberOfDays; // 日 滚轮的个数
@property (nonatomic ) NSInteger intYear; // 年
@property (nonatomic ) NSInteger intMonth; // 月
@property (nonatomic ) NSInteger intDay; // 日

@property (nonatomic, strong) UIButton *btnCancel; // 取消
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *pickBackView;

@end

static CGFloat fPickerHeight = 82+120;

@implementation DatePickerView



- (instancetype)init{
    self = [super init];
    if (self) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction)];
        tapGesture.numberOfTapsRequired = 1;
        self.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
        self.backgroundColor = [UIColor clearColor];
        [self addGestureRecognizer:tapGesture];
        self.hidden = YES;
        
        self.backView = [[UIView alloc]init];
        self.backView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
        self.backView.backgroundColor = [UIColor blackColor];
        self.backView.alpha = 0.2;
        [self addSubview:self.backView];
        
        self.pickBackView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT, WIDTH, fPickerHeight)];
        self.pickBackView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.pickBackView];
        
        UILabel *lblTitel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
        lblTitel.text = @"日期选择";
        lblTitel.backgroundColor = [UIColor whiteColor];
        lblTitel.adjustsFontSizeToFitWidth = YES;
        lblTitel.numberOfLines = 1;
        lblTitel.textAlignment = NSTextAlignmentCenter;
        lblTitel.textColor = [UIColor colorWithRed:0.000 green:0.682 blue:0.929 alpha:1.00];
        [self.pickBackView addSubview:lblTitel];
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lblTitel.frame), WIDTH, 1)];
        line1.backgroundColor = [UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1.00];
        [self.pickBackView addSubview:line1];
        
        self.vDatePicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lblTitel.frame)+1, WIDTH, 120)];
        _vDatePicker.backgroundColor = [UIColor whiteColor];
        _vDatePicker.delegate = self;
        _vDatePicker.dataSource = self;
        _vDatePicker.showsSelectionIndicator = YES;
        [self.pickBackView addSubview:_vDatePicker];
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.vDatePicker.frame), WIDTH, 1)];
        line2.backgroundColor = [UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1.00];
        [self.pickBackView addSubview:line2];
        
        UIButton *btnCancel = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.vDatePicker.frame)+1, WIDTH/2, 40)];
        btnCancel.tag = 19001;
        btnCancel.backgroundColor = [UIColor whiteColor];
        [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [btnCancel setTitleColor:[UIColor colorWithRed:0.000 green:0.682 blue:0.929 alpha:1.00] forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.pickBackView addSubview:btnCancel];
        
        UIButton *btnEnsure = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH/2, CGRectGetMinY(btnCancel.frame), WIDTH/2, 40)];
        btnEnsure.tag = 19000;
        btnEnsure.backgroundColor = [UIColor whiteColor];
        [btnEnsure setTitle:@"确定" forState:UIControlStateNormal];
        [btnEnsure setTitleColor:[UIColor colorWithRed:0.000 green:0.682 blue:0.929 alpha:1.00] forState:UIControlStateNormal];
        [btnEnsure addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.pickBackView addSubview:btnEnsure];
        
        UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake((WIDTH-1)/2,  CGRectGetMinY(btnCancel.frame), 1, 40)];
        line3.backgroundColor = [UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1.00];
        [self.pickBackView addSubview:line3];
        
        [self selectComponentsAndRowsWithYear:[self GetYear] Month:[self GetMonth] Day:[self GetDay]];
        
    }
    return self;
}


#pragma mark - 自定义方法
// 选中输入的时间对应的位置
- (void)selectComponentsAndRowsWithYear:(NSInteger)year
                                  Month:(NSInteger)month
                                    Day:(NSInteger)day{
    
    [self settingNumberOfDayWithYear:year Month:month];
    
    self.intYear = year;
    self.intMonth = month;
    self.intDay = day;
    
    [self.vDatePicker selectRow:year - intStartYear inComponent:1 animated:YES]; //年滚轮
    [self.vDatePicker selectRow:month - 1 inComponent:2 animated:YES]; // 月滚轮
    [self.vDatePicker selectRow:day - 1 inComponent:3 animated:YES];   // 日滚轮
}
- (void)btnAction:(UIButton *)sender{
    if (sender.tag == 19000) {
        if (self.delegate  && [self.delegate respondsToSelector:@selector(datePickerTimeYear:Month:Day:)]) {
            [self.delegate datePickerTimeYear:[self adjustTimeNumber:self.intYear] Month:[self adjustTimeNumber:self.intMonth] Day:[self adjustTimeNumber:self.intDay]];
        }
    }
    [self closePickerView];
}
// 单击手势
- (void)tapGestureAction{
    [self closePickerView];
}
// 推出
- (void)showPickerView{
    self.hidden = NO;
    [UIView animateWithDuration:1.0 animations:^{
        CGRect frame = self.pickBackView.frame;
        frame.origin.y = HEIGHT - fPickerHeight;
        self.pickBackView.frame = frame;
    }];
}

// 退出
- (void)closePickerView{
    [UIView animateWithDuration:1.0 animations:^{
        CGRect frame = self.pickBackView.frame;
        frame.origin.y = HEIGHT + fPickerHeight;
        self.pickBackView.frame = frame;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 5;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 1) {
        return 100;
    }else if (component == 2){
        return 12;
    }else if (component == 3){
        return self.intNumberOfDays;
    }else{
        return 0;
    }
}
#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component == 0 || component == 4) {
        return 30;
    }else{
        return (WIDTH - 60)/3;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 25;
}


- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 1) {
        return [NSString stringWithFormat:@"%d年",(int)row+1949];
    }else if (component == 2){
        return [NSString stringWithFormat:@"%d月",(int)row+1];
    }else if (component == 3){
        return [NSString stringWithFormat:@"%d日",(int)row+1];
    }else{
        return nil;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 1) {
        self.intYear = intStartYear + row;
        [self settingNumberOfDayWithYear:self.intYear Month:self.intMonth];
    }else if (component == 2){
        self.intMonth = row + 1;
        [self settingNumberOfDayWithYear:self.intYear Month:self.intMonth];
    }else if (component == 3){
        self.intDay = row + 1;
    }
}

// 重置日滚轮的个数
- (void)settingNumberOfDayWithYear:(NSInteger)year Month:(NSInteger)month{
    if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12 ) {
        self.intNumberOfDays = 31;
    }else if (month == 4 || month == 6 || month == 9 || month == 11){
        self.intNumberOfDays = 30;
    }else{
        if ((year%4 == 0 && year%100 != 0) || (year%100 == 0 && year%400 == 0)) {
            self.intNumberOfDays = 29;
        }else{
            self.intNumberOfDays = 28;
        }
    }
    [self.vDatePicker reloadComponent:3]; // 刷新 日滚轮
}


// 获取时间-年
- (NSInteger)GetYear{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    NSString *date = [[NSString alloc]initWithString:[formatter stringFromDate:[NSDate date]]];
    return [date integerValue];
}
// 获取时间-月
- (NSInteger)GetMonth{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"M"];
    NSString *date = [[NSString alloc]initWithString:[formatter stringFromDate:[NSDate date]]];
    return [date integerValue];
}
// 获取时间-日
- (NSInteger)GetDay{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"d"];
    NSString *date = [[NSString alloc]initWithString:[formatter stringFromDate:[NSDate date]]];
    return [date integerValue];
}

- (NSString *)adjustTimeNumber:(NSInteger)timeNumber{
    if (timeNumber < 10) {
        return [NSString stringWithFormat:@"0%ld",(long)timeNumber];
    }else{
        return [NSString stringWithFormat:@"%ld",(long)timeNumber];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
