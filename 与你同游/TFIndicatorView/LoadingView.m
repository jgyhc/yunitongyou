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
@property (nonatomic, strong) UIWindow *bgWindow;
@property (nonatomic, strong) TFIndicatorView *indicator;
@end


@implementation LoadingView


#pragma mark -- show
- (void)show {
    self.center = self.bgWindow.center;
    [self.bgWindow addSubview:self];
    self.frame = flexibleFrame(CGRectMake(0, 0, 375, 667), NO);
    [self.indicator startAnimating];
    [self addSubview:self.indicator];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0.177 alpha:0.420];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hide];
    });
}
#pragma mark -- remove
- (void)hide {
    [self.indicator stopAnimating];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0.684 alpha:0.000];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
#pragma mark -- getter
- (UIWindow *)bgWindow {
    if (!_bgWindow) {
        _bgWindow = ({
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window;
        });
    }
    return _bgWindow;
}

- (TFIndicatorView *)indicator {
	if(_indicator == nil) {
        _indicator = [[TFIndicatorView alloc] initWithFrame:CGRectMake(0, 0, flexibleHeight(50), flexibleHeight(50))];
        _indicator.center = flexibleCenter(CGPointMake(375 / 2, 667 / 2), NO);
	}
	return _indicator;
}

@end
