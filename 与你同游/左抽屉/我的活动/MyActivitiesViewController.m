//
//  MyActivitiesViewController.m
//  与你同游
//
//  Created by rimi on 15/10/15.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "MyActivitiesViewController.h"
#import "TopSelectButtonView.h"
#import "LaunchTableViewCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "Called.h"
#import "TravelModel.h"
#import <MJRefresh.h>
#import "InitiateDetailViewController.h"

@interface MyActivitiesViewController ()<TopSelectButtonViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) TopSelectButtonView * selectButton;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, assign) int qtype;

@property (nonatomic, assign) long limit;
@property (nonatomic, assign) long skip;
@property (nonatomic, assign) long rType;

@property (nonatomic, assign) long Jlimit;
@property (nonatomic, assign) long Jskip;

@property (nonatomic, strong) NSMutableArray * MdataSource;
@property (nonatomic, strong) NSMutableArray * JdataSource;
@end

@implementation MyActivitiesViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
    _limit = 20;
    _skip = 0;
    _Jlimit = 20;
    _Jskip = 0;
    [self getFoundList];
    [self getJoinList];
}

- (void)initUserInterface {
    [self initBackButton];
    [self initNavTitle:@"我的活动"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerClass:[LaunchTableViewCell class] forCellReuseIdentifier:NSStringFromClass([LaunchTableViewCell class])];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.selectButton];
    self.selectButton.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view, flexibleHeight(64)).heightIs(flexibleHeight(45));
    self.tableView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.selectButton, 0).bottomEqualToView(self.view);
    
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        _rType = 1;
        if (_qtype == 0) {
            _skip = 0;
            [self getFoundList];
        }else {
            _Jskip = 0;
            [self getJoinList];
        }

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
    }];
    
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _rType = 0;
        if (_qtype == 0) {
            [self getFoundList];
        }else {
            [self getJoinList];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
        });
    }];
}

- (void)getFoundList {
    [Called queryCalledsLimit:_limit skip:_skip Success:^(NSArray *calleds) {
        _skip = _skip + _limit;
        if (_rType == 1) {
            [self.MdataSource removeAllObjects];
        }
        [self.MdataSource addObjectsFromArray:calleds];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.dataSource = self.MdataSource;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];

}

- (void)getJoinList {
    [Called getCalledsLimit:_Jlimit skip:_Jskip Success:^(NSArray *calleds) {
        _Jskip = _Jskip + _Jlimit;
        if (_rType == 1) {
            [self.JdataSource removeAllObjects];
        }
        [self.JdataSource addObjectsFromArray:calleds];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (_qtype == 1) {
            self.dataSource = self.JdataSource;
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LaunchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LaunchTableViewCell class])];
    BmobObject *model = self.dataSource[indexPath.row];
//    if (_qtype == 0) {
//        cell.type = 1;
//    }
    cell.obj = model;
    
//    [cell setDeleteActivity:^{
//        [TravelModel deleteTravelOrActivity:model.objectId type:0 successBlock:^{
//            [self message:@"删除成功！"];
//             [self.MdataSource removeAllObjects];
//            [self getFoundList];
//        } failureBlock:^{
//            
//        }];
//    }];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:[self cellContentViewWith] tableView:tableView];
}
- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_qtype == 1) {
        return  NO;
    }
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (_qtype == 0) {
             BmobObject *model = self.dataSource[indexPath.row];
            [TravelModel deleteTravelOrActivity:model.objectId type:0 successBlock:^{
                [self message:@"删除成功！"];
                [self.MdataSource removeAllObjects];
                _skip = 0;
                [self getFoundList];
            } failureBlock:^{
                
            }];
           
 
        }
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BmobObject *obj = self.dataSource[indexPath.row];
    InitiateDetailViewController *IVC = [[InitiateDetailViewController alloc] init];
    IVC.calledID = obj.objectId;
    BmobObject *user = [obj objectForKey:@"user"];
    IVC.userObject = user;
    IVC.calledObject = obj;
    [self.navigationController pushViewController:IVC animated:YES];
}

- (void)clickButton:(UIButton *)sender {
    if (sender == self.selectButton.rightsideButton) {
        self.dataSource = self.JdataSource;
        _qtype = 1;
    }
    else{
        self.dataSource = self.MdataSource;
        _qtype = 0;
    }
    [self.tableView reloadData];
}

#pragma mark --lazy loading
- (UITableView *)tableView {
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (NSMutableArray *)dataSource {
    if(_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (TopSelectButtonView *)selectButton{
    if (!_selectButton) {
        _selectButton = [[TopSelectButtonView alloc]initWithType:1];
        _selectButton.delegate = self;
    }
    return _selectButton;
}
- (NSMutableArray *)MdataSource {
	if(_MdataSource == nil) {
		_MdataSource = [[NSMutableArray alloc] init];
	}
	return _MdataSource;
}

- (NSMutableArray *)JdataSource {
	if(_JdataSource == nil) {
		_JdataSource = [[NSMutableArray alloc] init];
	}
	return _JdataSource;
}

@end
