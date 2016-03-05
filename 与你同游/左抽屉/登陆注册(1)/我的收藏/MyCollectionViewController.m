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
@property (nonatomic, strong)UIButton *leftsideButton;
@property (nonatomic, strong)UIButton *rightsideButton;

@property (nonatomic, strong) TravelNotesTabelVC * travelVC;

@end

@implementation MyCollectionViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUserInterface];
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
}


- (void)buttonClickEvent:(UIButton *)sender {
    if (sender == _leftsideButton) {
//        if (self.joinsView) {
//            [self.joinsView removeFromSuperview];
//            
//        }
        [UIView animateWithDuration:0.5 animations:^{
            _separatationLineView.center = CGPointMake(WIDTH / 4, flexibleHeight(105));
        }];
//        [self.view insertSubview:self.activitiesView atIndex:0];
    }
    
    else if (sender == _rightsideButton) {
//        if (self.activitiesView) {
//            [self.activitiesView removeFromSuperview];
//        }
        [UIView animateWithDuration:0.5 animations:^{
            _separatationLineView.center = CGPointMake(WIDTH / 4 * 3, flexibleHeight(105));
        }];
//        [self.view insertSubview:self.joinsView atIndex:0];
    }
}

#pragma mark --lazy loading
- (TravelNotesTabelVC *)travelVC{
    if (!_travelVC) {
        _travelVC = [[TravelNotesTabelVC alloc]init];
        
        CGRect frame = _travelVC.tableView.frame;
        frame = flexibleFrame(CGRectMake(0, flexibleHeight(110), WIDTH, HEIGHT - flexibleHeight(114)), NO);
        _travelVC.tableView.frame = frame;
    }
    return _travelVC;
}

- (UIView *)separatationLineView {
    if (!_separatationLineView) {
        _separatationLineView = ({
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(self.view.frame) / 2, 1)];
            view.backgroundColor = THEMECOLOR;
            view.center = CGPointMake(CGRectGetMaxX(self.view.frame) / 4, flexibleHeight(105));
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
            [button setTitle:@"关注的游记" forState:UIControlStateNormal];
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
            [button setTitle:@"关注的活动" forState:UIControlStateNormal];
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
