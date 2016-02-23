//
//  LoadingView.m
//  与你同游
//
//  Created by rimi on 15/10/20.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "LoadingView.h"
#import "TFIndicatorView.h"

@interface LoadingView ()
@property (nonatomic, strong) UIWindow *backWindow;
@property (nonatomic, strong) TFIndicatorView *indicator;
@end


@implementation LoadingView
- (instancetype)init{
    self = [super init];
    if (self) {
        [self initializedApperance];
        
    }
    return self;
}
- (void)initializedApperance {
    self.center = self.backWindow.center;
    [self.backWindow addSubview:self];
    TFIndicatorView *indicator = [[TFIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    indicator.center = flexibleCenter(CGPointMake(WIDTH / 2, HEIGHT / 2), NO);
    indicator.bounds = flexibleFrame(CGRectMake(0, 0, 100, 100), NO);
    
    [indicator startAnimating];
    self.indicator = indicator;
    self.frame = flexibleFrame(CGRectMake(0, 0, 375, 667), NO);
//    self.backgroundColor = [UIColor redColor];
    [self addSubview:indicator];
}

#pragma makr --Getter
-(UIWindow *)backWindow {
    if (!_backWindow) {
        _backWindow = ({
            UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            window.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
//            window.backgroundColor = [UIColor redColor];
            window.windowLevel = UIWindowLevelAlert;
            window;
        });
    }
    return _backWindow;
    
}
//显示弹出框
- (void)show {
    [self.backWindow makeKeyAndVisible];
}
//隐藏弹出框
- (void)hide {
    [self.indicator stopAnimating];
    self.backWindow.hidden = YES;
    [self.backWindow resignKeyWindow];
    [self removeFromSuperview];
}
@end
