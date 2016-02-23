//
//  SearchPopWindow.m
//  DeepBreath
//
//  Created by rimi on 15/9/27.
//  Copyright (c) 2015年 rimi. All rights reserved.
//

#import "SearchPopWindow.h"

@interface SearchPopWindow ()

@property (nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,strong)UIDatePicker * datePicker;
@property (nonatomic,strong)UIButton * surebutton;
@property (nonatomic,strong) UIButton * cancelButton;
@property (nonatomic,copy)NSString * alertTitle;

//声明一个block的属性
@property (nonatomic,copy) void(^complect)(NSString * str);
@end

@implementation SearchPopWindow

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title  complect:(void(^) (NSString * str))complect{
    
    self = [super initWithFrame:frame];
    if (self) {
        _alertTitle = title;
       
        _complect = complect;
        
        [self initalize];
    }
    return self;
}

- (void)initalize{
    [self addSubview:self.titleLabel];
    [self addSubview:self.datePicker];
    [self addSubview:self.surebutton];
    [self addSubview:self.cancelButton];
}

#pragma amrk -- Private Method
- (void)action_sureButton:(UIButton *)sender{
    
    NSDate * selectDate = [self.datePicker date];//获取被选中的时间
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy/MM/dd";
    NSString * dateString = [formatter stringFromDate:selectDate];
    _complect(dateString);

    [self action_cancelButton];
    
    
    
}

- (void)action_cancelButton{
    [self hide];
}


#pragma mark -- UIPickerViewDelegate

- (UIButton *)surebutton{
    if (!_surebutton) {
        _surebutton = [UIButton buttonWithType:UIButtonTypeCustom];
        _surebutton.frame = CGRectMake(CGRectGetWidth(self.bounds) - 160, CGRectGetHeight(self.bounds) - 50, 150, 40);
        _surebutton.backgroundColor = [UIColor colorWithRed:0.922 green:0.329 blue:0.082 alpha:1.000];
        [_surebutton setTitle:@"确定" forState:UIControlStateNormal];
        _surebutton.layer.cornerRadius = 5;
        [_surebutton addTarget:self action:@selector(action_sureButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _surebutton;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetHeight(self.bounds) - 50, 100, 40)];
        _cancelButton.layer.cornerRadius = 5;
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _cancelButton.layer.borderWidth = 1;
        _cancelButton.layer.borderColor = [UIColor orangeColor].CGColor;
        [_cancelButton addTarget:self action:@selector(action_cancelButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}



#pragma mark -- Getter
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 50)];
        _titleLabel.backgroundColor = [UIColor colorWithWhite:0.910 alpha:1.000];
        _titleLabel.textAlignment =  NSTextAlignmentCenter;
        _titleLabel.text = self.alertTitle;
    }
    return _titleLabel;
}

- (UIDatePicker *)datePicker{
    if (!_datePicker) {
        _datePicker = ({
    
            UIDatePicker * datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height * 0.75)];
            datePicker.center = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);
            datePicker.date = [NSDate date];
            datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GTM+8"];//中国在东八区
            datePicker.datePickerMode = UIDatePickerModeDate;//设置样式

            datePicker;
        });
    }
    return _datePicker;
}

- (void)drawRect:(CGRect)rect{
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, CGRectGetHeight(self.bounds) - 60)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 60)];
    path.lineWidth = 2;
    UIColor * color = [UIColor orangeColor];
    [color setStroke];
    [path stroke];
}


@end
