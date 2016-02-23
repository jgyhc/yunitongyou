//
//  MyPopWindow.m
//  弹出选择日期
//
//  Created by rimi on 15/9/21.
//  Copyright (c) 2015年 rimi. All rights reserved.
//

#import "MyPopWindow.h"

@interface MyPopWindow()

@property (nonatomic,strong) UIWindow * backWindow;

@end

@implementation MyPopWindow

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (instancetype)init{
    //弹出框的大小  这里用的是[self initWithFrame...]，所以不要if语句，否则initUserInterface会执行两次
    self = [self initWithFrame:CGRectMake(0, 0,[[UIScreen mainScreen] bounds].size.width * 0.75, [[UIScreen mainScreen] bounds].size.height * 0.6)];
//    if (self) {
//        [self initUserInterface];
//    }
    return self;
    
    
       return self;
}

- (void)initUserInterface{
    self.backgroundColor = [UIColor whiteColor];
    
    //设置中心点
    self.center = self.backWindow.center;
    [self.backWindow addSubview:self];
}
- (void)show{
    [self.backWindow makeKeyAndVisible];
    self.backWindow.alpha = 1;
}

- (void)hide{
//    [self removeFromSuperview];//若backWindow崩溃，可能原因是backWindow是局部变量，移除这句或把这句放在后面
    self.backWindow.alpha = 0;//不设置这句会出现bug
//    [self.backWindow resignKeyWindow];//注销KeyWindow
}


# pragma mark -- Getter
- (UIWindow *)backWindow{
    if (!_backWindow) {
        
        _backWindow = ({
            UIWindow * window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
            window.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
            //设置成警告级别
            window.windowLevel = UIWindowLevelAlert;
            
            window;
        });
            
    }
    return _backWindow;
}

@end
