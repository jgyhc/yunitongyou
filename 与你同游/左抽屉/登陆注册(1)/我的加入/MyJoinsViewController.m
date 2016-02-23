//
//  MyJoinsViewController.m
//  与你同游
//
//  Created by rimi on 15/10/15.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "MyJoinsViewController.h"
#import "MyJoinsView.h"
#import "MyActivitiesView.h"

@interface MyJoinsViewController  ()

@property (nonatomic, strong)MyJoinsView *joinsView;
@property (nonatomic, strong)MyActivitiesView *activitiesView;

@property (nonatomic, strong)UIView *separatationLineView;

@property (nonatomic, strong)UIButton *leftsideButton;
@property (nonatomic, strong)UIButton *rightsideButton;


@end

@implementation MyJoinsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUserInterface];
}
- (void)initUserInterface {
    [self initBackButton];
    [self initNavTitle:@"我的加入"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.joinsView];
    [self.view addSubview:self.leftsideButton];
    [self.view addSubview:self.rightsideButton];
    [self.view addSubview:self.separatationLineView];
}

- (void)buttonClickEvent:(UIButton *)sender {
    if (sender == _leftsideButton) {
        if (self.joinsView) {
            [self.joinsView removeFromSuperview];
            
        }
        [UIView animateWithDuration:0.5 animations:^{
            _separatationLineView.center = CGPointMake(WIDTH / 4, flexibleHeight(105));
        }];
        [self.view insertSubview:self.activitiesView atIndex:0];
    }else if (sender == _rightsideButton) {
        if (self.activitiesView) {
            [self.activitiesView removeFromSuperview];
        }
        [UIView animateWithDuration:0.5 animations:^{
            _separatationLineView.center = CGPointMake(WIDTH / 4 * 3, flexibleHeight(105));
        }];
        [self.view insertSubview:self.joinsView atIndex:0];
    }
}

- (MyJoinsView *)joinsView {
    if (!_joinsView) {
        _joinsView = [[MyJoinsView alloc]init];
        CGRect frame = _joinsView.frame;
        frame.origin.y = flexibleHeight(104);
        _joinsView.frame = frame;
    }
    return _joinsView;
}

- (MyActivitiesView *)activitiesView {
    if (!_activitiesView) {
        _activitiesView = [[MyActivitiesView alloc]init];
        CGRect frame = _activitiesView.frame;
        frame.origin.y = flexibleHeight(104);
        _activitiesView.frame = frame;
    }
    return _activitiesView;
}

- (UIView *)separatationLineView {
    if (!_separatationLineView) {
        _separatationLineView = ({
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(self.view.frame) / 2, 1)];
            view.backgroundColor = THEMECOLOR;
            view.center = CGPointMake(CGRectGetMaxX(self.view.frame) / 4 * 3, flexibleHeight(105));
            view;
        });
    }
    return _separatationLineView;
}

- (UIButton *)leftsideButton {
    if (!_leftsideButton) {
        _leftsideButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = flexibleFrame(CGRectMake(0, flexibleHeight(64), WIDTH / 2, 50), NO);
            button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            [button setTitle:@"我的发起（8）" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithWhite:0.298 alpha:1.000] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(buttonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _leftsideButton;
}

- (UIButton *)rightsideButton {
    if (!_rightsideButton) {
        _rightsideButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = flexibleFrame(CGRectMake(WIDTH / 2, flexibleHeight(64), WIDTH / 2, 50), NO);
            button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            [button setTitle:@"我的加入（10）" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithWhite:0.298 alpha:1.000] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [button setBackgroundColor:[UIColor whiteColor]];
            [button addTarget:self action:@selector(buttonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _rightsideButton;
}

@end
