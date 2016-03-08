//
//  MyCollectionViewController.m
//  与你同游
//
//  Created by rimi on 15/10/15.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "TravelNotesTabelVC.h"


@interface MyCollectionViewController ()

@property (nonatomic, strong)UIView *separatationLineView;
@property (nonatomic, strong) UIView * vline1;
@property (nonatomic, strong)UIButton *leftsideButton;
@property (nonatomic, strong)UIButton *rightsideButton;

@property (nonatomic, strong) TravelNotesTabelVC * travelVC;

@end

@implementation MyCollectionViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUserInterface];
}

- (void)viewDidDisappear:(BOOL)animated{
    [self.travelVC removeFromParentViewController];
}
- (void)initUserInterface {
    [self initBackButton];
    [self initNavTitle:@"我的关注"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addChildViewController:self.travelVC];
    [self.view addSubview:self.travelVC.tableView];
    
    [self.view addSubview:self.leftsideButton];
    [self.view addSubview:self.rightsideButton];
    [self.view addSubview:self.separatationLineView];
    [self.view addSubview:self.vline1];
}


- (void)buttonClickEvent:(UIButton *)sender {
    if (sender == _leftsideButton) {
//        if (self.joinsView) {
//            [self.joinsView removeFromSuperview];
//            
//        }
        [UIView animateWithDuration:0.5 animations:^{
            _separatationLineView.center = CGPointMake(WIDTH / 4, flexibleHeight(104));
        }];
//        [self.view insertSubview:self.activitiesView atIndex:0];
        _leftsideButton.selected = YES;
        _rightsideButton.selected = NO;
    }
    
    else if (sender == _rightsideButton) {
//        if (self.activitiesView) {
//            [self.activitiesView removeFromSuperview];
//        }
        [UIView animateWithDuration:0.5 animations:^{
            _separatationLineView.center = CGPointMake(WIDTH / 4 * 3, flexibleHeight(104));
        }];
//        [self.view insertSubview:self.joinsView atIndex:0];
        _leftsideButton.selected = NO;
        _rightsideButton.selected = YES;
    }
}

#pragma mark --lazy loading
- (TravelNotesTabelVC *)travelVC{
    if (!_travelVC) {
        _travelVC = [[TravelNotesTabelVC alloc]init];
        
        CGRect frame = _travelVC.tableView.frame;
        frame = flexibleFrame(CGRectMake(0, flexibleHeight(104), WIDTH, HEIGHT - flexibleHeight(104)), NO);
        _travelVC.tableView.frame = frame;
    }
    return _travelVC;
}

- (UIView *)separatationLineView {
    if (!_separatationLineView) {
        _separatationLineView = ({
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(self.view.frame) / 2, 2)];
            view.backgroundColor = THEMECOLOR;
            view.center = CGPointMake(CGRectGetMaxX(self.view.frame) / 4, flexibleHeight(104));
            view;
        });
    }
    return _separatationLineView;
}

- (UIView *)vline1 {
    if (!_vline1) {
        _vline1 = ({
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(WIDTH / 2, 69,1, 30)];
            view.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
           
            view;
        });
    }
    return _vline1;
}

- (UIButton *)leftsideButton {
    if (!_leftsideButton) {
        _leftsideButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = flexibleFrame(CGRectMake(0, flexibleHeight(64), WIDTH / 2, 40), NO);
            button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            [button setTitle:@"关注的游记" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithWhite:0.298 alpha:1.000] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setTitleColor:THEMECOLOR forState:UIControlStateSelected];
            button.selected = YES;
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
            button.frame = flexibleFrame(CGRectMake(WIDTH / 2, flexibleHeight(64), WIDTH / 2, 40), NO);
            button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            [button setTitle:@"关注的活动" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithWhite:0.298 alpha:1.000] forState:UIControlStateNormal];
            [button setTitleColor:THEMECOLOR forState:UIControlStateSelected];
            [button setBackgroundColor:[UIColor whiteColor]];
            button.selected = NO;
            [button addTarget:self action:@selector(buttonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _rightsideButton;
}


@end
