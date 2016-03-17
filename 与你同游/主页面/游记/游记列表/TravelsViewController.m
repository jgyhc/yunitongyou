//
//  TravelsViewController.m
//  与你同游
//
//  Created by rimi on 15/10/12.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "TravelsViewController.h"
#import "TravelNotesTableViewCell.h"
#import "SharedView.h"

#import "RecordDetailViewController.h"
#import "AddTravelViewController.h"

#import "OtherInfoViewController.h"

#import <BmobSDK/Bmob.h>
#import "TravelModel.h"
#import "MJRefresh.h"
#import "CommentViewController.h"
#import "UITableView+SDAutoTableViewCellHeight.h"//cell高度自适应


static NSString * const identifier = @"CELL";

@interface TravelsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *travelArray;//数据
@property (nonatomic, strong) NSMutableArray *userArray;//用户
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) SharedView *sharedView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) TravelModel *travelModel;
@end

@implementation TravelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.travelModel queryTheTravelListSuccessBlock:^(NSArray *objectArray) {
        [self.travelArray addObjectsFromArray:objectArray];
        [self.tableView reloadData];
        
    } failBlock:^(NSError *error) {
        
    }];
    [self initalizedInterface];
}
- (void)initalizedInterface{
    
    [self initNavTitle:@"游记"];
    [self initPersonButton];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initRightButtonEvent:@selector(handleTravelNotes:) Image:[UIImage imageNamed:@"添加游记"]];
    [self.tableView registerClass:[TravelNotesTableViewCell class] forCellReuseIdentifier:identifier];
    self.tableView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view, flexibleHeight(64)).bottomSpaceToView(self.view, flexibleHeight(0));
    [self.view addSubview:self.tableView];
    
    [self setupRefresh];
}
#pragma mark --刷新
- (void)setupRefresh
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.stateLabel.font = [UIFont systemFontOfSize:flexibleHeight(12)];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:flexibleHeight(12)];
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
        });
    }];
}

- (void)loadNewData {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    });
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.travelArray.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TravelNotesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TravelNotesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    BmobObject * object = self.travelArray[indexPath.section];
    //注意是section,若是numberOfRows returnself.modelArray.count，则是row
    cell.info = object;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * bcView = [[UIView alloc]init];
    bcView.backgroundColor = [UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1.0];
    return bcView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    //    id model = self.travelArray[indexPath.section];//注意是section
    //    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[TravelNotesTableViewCell class] contentViewWidth:[self cellContentViewWith]];//如果self.travelArray[indexPath.section]是BmobObject类型，就会崩溃
    
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

- (void)handleTravelNotes:(UIButton *)sender {
    if (!OBJECTID) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还未登录！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    AddTravelViewController * addVC = [[AddTravelViewController alloc]init];
    [self.navigationController pushViewController:addVC animated:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = ({
            UITableView *tableView = [[UITableView alloc]init];
            tableView.dataSource = self;
            tableView.delegate = self;
            tableView.showsVerticalScrollIndicator = NO;
            tableView;
        });
        
    }
    return _tableView;
}
- (TravelModel *)travelModel{
    if (!_travelModel) {
        _travelModel = [[TravelModel alloc]init];
    }
    return _travelModel;
}

- (NSMutableArray *)travelArray {
    if (!_travelArray) {
        _travelArray = [NSMutableArray array];
    }
    return _travelArray;
}

- (NSMutableArray *)userArray {
    if (!_userArray) {
        _userArray = [NSMutableArray array];
    }
    return _userArray;
}
@end
