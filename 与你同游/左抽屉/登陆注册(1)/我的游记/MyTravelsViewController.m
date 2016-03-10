//
//  MyTravelsViewController.m
//  与你同游
//
//  Created by rimi on 15/10/15.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "MyTravelsViewController.h"
#import "RecordDetailViewController.h"
#import "AddTravelViewController.h"
#import "PersonalViewController.h"
#import "TravelNotesTabelVC.h"
#import "UITableView+SDAutoTableViewCellHeight.h"

#import <BmobSDK/Bmob.h>
#import "TravelModel.h"
#import "TravelTableViewCell.h"
#import "MJRefresh.h"
#import "CommentViewController.h"

@interface MyTravelsViewController ()

@property (nonatomic, strong) TravelNotesTabelVC * travelVC;

@end



@implementation MyTravelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initalizedInterface];
}
- (void)viewDidDisappear:(BOOL)animated{
    [self.travelVC removeFromParentViewController];
}

- (void)initalizedInterface{
    
    [self initNavTitle:@"我的游记"];
    [self initBackButton];
    self.view.backgroundColor = [UIColor colorWithWhite:0.929 alpha:1.000];
    [self initRightButtonEvent:@selector(handleTravelNotes:) Image:[UIImage imageNamed:@"添加游记"]];
    
    [self addChildViewController:self.travelVC];
    [self.view addSubview:self.travelVC.tableView];

}

- (TravelNotesTabelVC *)travelVC{
    if (!_travelVC) {
        _travelVC = [[TravelNotesTabelVC alloc]init];
        
        CGRect frame = _travelVC.tableView.frame;
        frame = flexibleFrame(CGRectMake(0, flexibleHeight(64), WIDTH, HEIGHT - flexibleHeight(64)), NO);
        _travelVC.tableView.frame = frame;
    }
    return _travelVC;
}
@end