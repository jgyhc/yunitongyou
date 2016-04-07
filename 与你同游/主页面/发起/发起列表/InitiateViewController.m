//
//  IndexViewcontroller.m
//  与你同游
//
//  Created by rimi on 15/10/12.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "InitiateViewcontroller.h"
#import "LaunchTableViewCell.h"
#import "InitiateDetailViewController.h"
#import "ImageView.h"
#import "AddActivityViewController.h"
#import <BmobSDK/Bmob.h>
#import "MJRefresh.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "Called.h"
#import "ThumbUp.h"

#import "PersonalViewController.h"

#import "Collection.h"

@interface InitiateViewcontroller ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, assign) NSInteger skip;

@end
@implementation InitiateViewcontroller


- (void)viewDidLoad {
    [super viewDidLoad];
    _skip = 0;
    _limit = 10;
       self.view.backgroundColor = [UIColor colorWithWhite:0.929 alpha:1.000];
    [self initNavTitle:@"发起"];
    [self.tableView registerClass:[LaunchTableViewCell class] forCellReuseIdentifier:NSStringFromClass([LaunchTableViewCell class])];
    [self initRightButtonEvent:@selector(handleAddCalled:) Image:IMAGE_PATH(@"添加游记.png")];

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.stateLabel.font = [UIFont systemFontOfSize:flexibleHeight(12)];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:flexibleHeight(12)];
    self.tableView.mj_header = header;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
        });
    }];

    [self initUserInterface];
    [self initPersonButton];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    if (self.dataSource.count > 0) {
        [self.dataSource removeAllObjects];
    }
    
    [Called getcalledListWithLimit:_limit skip:_skip Success:^(NSArray *calleds) {
        [self.dataSource addObjectsFromArray:calleds];
        [self.tableView reloadData];
    } failure:^(NSError *error1) {
        
    }];
    

}


- (void)loadNewData {
//    [self.calledModel queryTheCalledlList];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
    
}


- (void)initUserInterface {
    self.view.backgroundColor = [UIColor colorWithWhite:0.733 alpha:1.000];
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view, flexibleHeight(64)).bottomSpaceToView(self.view, flexibleHeight(40));
}

- (void)handleAddCalled:(UIButton *)sender {
    AddActivityViewController *AAVC = [[AddActivityViewController alloc] init];
    [self.navigationController pushViewController:AAVC animated:YES];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LaunchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LaunchTableViewCell class])];
    BmobObject *obj = self.dataSource[indexPath.section];
    cell.obj = obj;

    [cell buttonCollection:^(NSInteger type) {
            if (type == 1) {
                
                [Collection CollectionWithID:obj.objectId type:0 success:^(NSString *commentID) {
                    
                } failure:^(NSError *error1) {
                    
                }];
            }
            else if (type == 0){
                [Collection cancelCollectionWithID:obj.objectId type:0 success:^(NSString *commentID) {
                    
                } failure:^(NSError *error1) {
                    
                }];
            }
    }];
    [cell buttonthumb:^(int type) {
          if (type == 1) {
                //点赞
                [ThumbUp thumUpWithID:obj.objectId type:0 success:^(NSString *commentID) {
                } failure:^(NSError *error1) {
                    
                }];
            }
            else if (type == 0){
                //取消点赞
                [ThumbUp cancelThumUpWithID:obj.objectId type:0 success:^(NSString *commentID) {
                } failure:^(NSError *error1) {
                    
                }];
            }
    }];
    [cell setPdetailBlock:^(NSIndexPath *index) {
        PersonalViewController *PVC = [[PersonalViewController alloc] init];
        PVC.userInfo = [obj objectForKey:@"user"];
        PVC.type = 1;
        [self presentViewController:PVC animated:YES completion:nil];
    }];
    
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






#pragma mark --UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BmobObject *obj = self.dataSource[indexPath.section];
    InitiateDetailViewController *IVC = [[InitiateDetailViewController alloc] init];
    IVC.calledID = obj.objectId;
    BmobObject *user = [obj objectForKey:@"user"];
    IVC.userObject = user;
    IVC.calledObject = obj;
    [self.navigationController pushViewController:IVC animated:YES];
}

#pragma mark --getter
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



- (NSMutableArray *)dataSource {
	if(_dataSource == nil) {
		_dataSource = [[NSMutableArray alloc] init];
	}
	return _dataSource;
}

@end
