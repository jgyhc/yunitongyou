//
//  TravelNotesTabelVC.m
//  与你同游
//
//  Created by mac on 16/3/3.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import "TravelNotesTabelVC.h"
#import "TravelNotesTableViewCell.h"
#import "SharedView.h"
#import "ShareView.h"

#import "RecordDetailViewController.h"
#import "AddTravelViewController.h"


#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

#import <BmobSDK/Bmob.h>
#import "TravelModel.h"
#import "ThumbUp.h"
#import "Collection.h"
#import "MJRefresh.h"
#import "CommentViewController.h"
#import "UITableView+SDAutoTableViewCellHeight.h"//cell高度自适应


@interface TravelNotesTabelVC ()

@property (nonatomic, strong) NSMutableArray *travelArray;//数据
@property (nonatomic, strong) SharedView *sharedView;
@property (nonatomic, strong) TravelModel *travelModel;
@end

@implementation TravelNotesTabelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initalizedInterface];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    [self getData];
}

- (void)getData{
    if (self.travelArray.count > 0) {
        [self.travelArray removeAllObjects];
    }
    
    [Collection getCollectionSuccess:^(NSArray *collections) {
        [self.travelArray addObjectsFromArray:collections];
        [self.tableView reloadData];      
    
     } type:1 failure:^(NSError *error) {
    
     }];
}
- (void)initalizedInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[TravelNotesTableViewCell class] forCellReuseIdentifier:NSStringFromClass([TravelNotesTableViewCell class])];
    self.tableView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view, flexibleHeight(64)).bottomSpaceToView(self.view, flexibleHeight(10));
    
    
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
    
    TravelNotesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TravelNotesTableViewCell class])];
    
    //注意是section,若是numberOfRows returnself.modelArray.count，则是row
    BmobObject * object = self.travelArray[indexPath.section];
    cell.info = object;
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSLog(@"object = %@",object);
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
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还未登录喔！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    AddTravelViewController * addVC = [[AddTravelViewController alloc]init];
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark --lazy loading
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
