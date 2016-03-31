//
//  TravelsViewController.m
//  与你同游
//
//  Created by rimi on 15/10/12.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "MyTravelsViewController.h"
#import "TravelNotesTableViewCell.h"
#import "ShareView.h"
#import "CommentViewController.h"
#import "ThumbUp.h"
#import "RecordDetailViewController.h"
#import "PersonalViewController.h"
#import <BmobSDK/Bmob.h>
#import "TravelModel.h"
#import "MJRefresh.h"
#import "UITableView+SDAutoTableViewCellHeight.h"//cell高度自适应


static NSString * const identifier = @"CELL";

@interface MyTravelsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *travelArray;//数据
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) TravelModel *travelModel;
@end

@implementation MyTravelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.travelModel getMyTravelNotesSuccess:^(NSArray *mytravels) {
        [self.travelArray addObjectsFromArray:mytravels];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
    [self initalizedInterface];
}
- (void)initalizedInterface{
    
    [self initNavTitle:@"我的游记"];
    [self initPersonButton];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerClass:[TravelNotesTableViewCell class] forCellReuseIdentifier:identifier];
    
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view, flexibleHeight(64)).bottomSpaceToView(self.view, flexibleHeight(0));
    
    
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
#pragma mark --点赞
    [cell buttonthumbUp:^(int type) {
        if (type == 1) {
            //点赞
            [ThumbUp thumUpWithID:object.objectId type:1 success:^(NSString *commentID) {
            } failure:^(NSError *error1) {
                
            }];
        }
        else if (type == 0){
            //取消点赞
            [ThumbUp cancelThumUpWithID:object.objectId type:1 success:^(NSString *commentID) {
            } failure:^(NSError *error1) {
                
            }];
        }
        
    }];
    
#pragma mark --评论
    [cell buttoncomment:^{
        CommentViewController * commentVC = [[CommentViewController alloc]init];
        commentVC.objId = object.objectId ;
        commentVC.type = 1;
        [self.navigationController pushViewController:commentVC animated:YES];
    }];
    
#pragma mark --分享
    [cell buttonshared:^{
        //分享
        NSArray * imageArray;
        if ([object objectForKey:@"urlArray"]) {
            imageArray = [object objectForKey:@"urlArray"];
        }
        else{
            imageArray = nil;
        }
        [ShareView sharedWithImages:imageArray content:[object objectForKey:@"content"]];
    }];
    [cell tapPresent:^{
        PersonalViewController *PVC = [[PersonalViewController alloc] init];
        PVC.userInfo = [object objectForKey:@"user"];
        PVC.type = 1;
        [self presentViewController:PVC animated:YES completion:nil];
    }];


    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BmobObject *obj = self.travelArray[indexPath.section];
    RecordDetailViewController * detail = [[RecordDetailViewController alloc]init];
    detail.travelObject = obj;
    BmobObject * user = [obj objectForKey:@"user"];
    detail.userObject = user;
    [self.navigationController pushViewController:detail animated:YES];
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

@end
