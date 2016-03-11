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
#import "TravelNotesTabelVC.h"
#import "UITableView+SDAutoTableViewCellHeight.h"//cell高度自适应

//#define BUTTON_TAG 100
//#define LABEL_TAG 200
//#define IMAGE_TAG 300


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
- (void)dealloc {
    [self.travelModel removeObserver:self forKeyPath:@"travelListArray"];
    [self.travelModel removeObserver:self forKeyPath:@"travelUser"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.travelModel addObserver:self forKeyPath:@"travelListArray" options:NSKeyValueObservingOptionNew context:nil];
    [self.travelModel addObserver:self forKeyPath:@"travelUser" options:NSKeyValueObservingOptionNew context:nil];
    [self.tableView registerClass:[TravelNotesTableViewCell class] forCellReuseIdentifier:identifier];
    
      [self initalizedInterface];
}
- (void)initalizedInterface{
    
    [self initNavTitle:@"游记"];
    [self initPersonButton];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initRightButtonEvent:@selector(handleTravelNotes:) Image:[UIImage imageNamed:@"添加游记"]];
     [self setupRefresh];
     self.tableView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view, flexibleHeight(64)).bottomSpaceToView(self.view, flexibleHeight(0));
    [self.view addSubview:self.tableView];
    //    TravelNotesTabelVC * travelVC = [[TravelNotesTabelVC alloc]init];
    //    CGRect frame = travelVC.tableView.frame;
    //    frame = flexibleFrame(CGRectMake(0, flexibleHeight(64), WIDTH, HEIGHT - flexibleHeight(64)), NO);
    //    travelVC.tableView.frame = frame;
    //    [self addChildViewController:travelVC];
    //    [self.view addSubview:travelVC.tableView];
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
    });
    
}
#pragma mark -- KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"travelListArray"]) {
        
        self.travelArray = self.travelModel.travelListArray;
    }
    if ([keyPath isEqualToString:@"travelUser"]) {
        self.userArray = self.travelModel.travelUser;
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }
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
    //注意是section,若是numberOfRows returnself.modelArray.count，则是row
    cell.model = self.travelArray[indexPath.section];
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
    id model = self.travelArray[indexPath.section];//注意是section
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[TravelNotesTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    
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
