//
//  TravelNotesTabelVC.m
//  与你同游
//
//  Created by mac on 16/3/3.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import "TravelNotesTabelVC.h"
#import "TravelNotesTableViewCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"//cell高度自适应

#import "MJRefresh.h"

static NSString * const identifier = @"CELL";

@interface TravelNotesTabelVC ()

@property (nonatomic, strong) NSMutableArray * modelArray;
@end

@implementation TravelNotesTabelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerClass:[TravelNotesTableViewCell class] forCellReuseIdentifier:identifier];
    [self setupRefresh];
}

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

        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    });
    
}


#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.modelArray.count;
    
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
    cell.info = self.modelArray[indexPath.section];
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


@end
