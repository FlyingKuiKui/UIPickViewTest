//
//  LoadingView.m
//  UIPickViewTest
//
//  Created by 王盛魁 on 16/5/27.
//  Copyright © 2016年 wangsk. All rights reserved.
//

#import "LoadingView.h"

static CGFloat viewWidth = 80;
static CGFloat viewHeight = 80;
static CGFloat fTimer = 0;
@interface LoadingView ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *logBackView;
@property (nonatomic, strong) UIImageView *imgvLoad;
@property (nonatomic, strong) UILabel *lblPrompt;
@property (nonatomic, strong) CADisplayLink *dispalyLink; // 循环执行
@property (nonatomic, strong) NSTimer *timer;
@end



@implementation LoadingView
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = 0.2;
    }
    return _backView;
}

- (UIView *)logBackView{
    if (!_logBackView) {
        _logBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
        _logBackView.backgroundColor = [UIColor clearColor];
        _logBackView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    }
    return _logBackView;
}

- (UIImageView *)imgvLoad{
    if (!_imgvLoad) {
        _imgvLoad = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loading.png"]];
        _imgvLoad.frame = CGRectMake(0, 0, 77, 77);
        _imgvLoad.center = CGPointMake(CGRectGetWidth(self.logBackView.frame)/2, CGRectGetHeight(self.logBackView.frame)/2);
    }
    return _imgvLoad;
}

- (UILabel *)lblPrompt{
    if (!_lblPrompt) {
        _lblPrompt = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.logBackView.frame), [UIScreen mainScreen].bounds.size.width, 30)];
        [_lblPrompt setTextAlignment:NSTextAlignmentCenter];
        [_lblPrompt setTextColor:[UIColor whiteColor]];
        [_lblPrompt setText:@"Loading..."];
    }
    return _lblPrompt;
}
+ (LoadingView *)shareLoadingView{
    static LoadingView *loadingView = nil;
    static dispatch_once_t onceToken;
    UIView *view = [[UIApplication sharedApplication].windows firstObject];
    dispatch_once(&onceToken, ^{
        loadingView = [[LoadingView alloc]initWithView:view];
    });
    return loadingView;
}


- (id)initWithView:(UIView *)view {
    NSAssert(view, @"View must not be nil.");
    return [self initWithFrame:view.bounds];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backView];
        [self addSubview:self.logBackView];
        [self addSubview:self.lblPrompt];

        UIImageView *imgvBack = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logoIcon.png"]];
        imgvBack.frame = CGRectMake(0, 0, 55, 55);
        imgvBack.center = CGPointMake(CGRectGetWidth(self.logBackView.frame)/2, CGRectGetHeight(self.logBackView.frame)/2);
        [self.logBackView addSubview:imgvBack];
        [self.logBackView addSubview:self.imgvLoad];
//        self.dispalyLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(dispalyAction)];
    }
    return self;
}

+ (void)showLoadingView{
    UIView *view = [[UIApplication sharedApplication].windows firstObject];
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:self]) {
            [subview removeFromSuperview];
        }
    }
    [view addSubview:[LoadingView shareLoadingView]];
    [[LoadingView shareLoadingView] startTimer];
    
//    [[LoadingView shareLoadingView].dispalyLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}
+ (void)hiddenLoadingView{
    UIView *view = [[UIApplication sharedApplication].windows firstObject];
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:self]) {
            [subview removeFromSuperview];
        }
    }
    [[LoadingView shareLoadingView] stopTimer];
//    [[LoadingView shareLoadingView].dispalyLink invalidate];
}

- (void)startTimer{
    if (self.timer) {
        [self stopTimer];
    }
    self.timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)stopTimer{
    [self.timer invalidate];
}

- (void)timerAction{
    self.imgvLoad.transform = CGAffineTransformRotate(_imgvLoad.transform, M_PI * 30 /180);
    fTimer++;
    if (fTimer == 100) {
        [self.class hiddenLoadingView];
        fTimer = 0;
//        [self stopTimer];
    }
}


- (void)dispalyAction{
    CGFloat angle = M_PI * 6/ 180;
    self.imgvLoad.transform = CGAffineTransformRotate(_imgvLoad.transform, angle);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
