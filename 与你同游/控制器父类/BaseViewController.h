//
//  BaseViewController.h
//  viewController
//
//  Created by rimi on 15/10/12.
//  Copyright (c) 2015年 ouyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseGradientView.h"
@interface BaseViewController : UIViewController
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) BaseGradientView *navView;

//设置为返回按键
- (void)initBackButton;

//设置为打开左抽屉按键
- (void)initPersonButton;

//设置Nav的颜色
- (void)setNavViewColor:(UIColor *)color;

//设置nav的右按键的事件和图片
- (void)initRightButtonEvent:(SEL)selector Image:(UIImage *)image;

//设置nav的右按键的时间和文字
- (void)initRightButtonEvent:(SEL)selector title:(NSString *)string;

//设置Nav的标题
- (void)initNavTitle:(NSString *)string;

- (void)alertView:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle   sureButtonTitle:(NSString *)sureTitle;
- (void)alertControllerShow:(NSString *)message;


- (NSString *) compareCurrentTime:(NSDate *) compareDate;

@end
