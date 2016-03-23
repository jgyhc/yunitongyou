//
//  ICommentsView.m
//  与你同游
//
//  Created by Zgmanhui on 16/3/17.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import "ICommentsView.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "ICommentsCell.h"
#import "Called.h"
@interface ICommentsView ()<UITableViewDelegate, UITableViewDataSource>


@end
@implementation ICommentsView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.tableView];
        [self.tableView registerClass:[ICommentsCell class] forCellReuseIdentifier:NSStringFromClass([ICommentsCell class])];
        self.tableView.sd_layout.leftEqualToView(self).rightEqualToView(self).topEqualToView(self).heightIs(flexibleHeight(50) * 10);
    }
    return self;
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ICommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ICommentsCell class])];
    BmobObject *comment = self.dataSource[indexPath.row];
    cell.model = comment;
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

- (UITableView *)tableView {
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.rowHeight = flexibleHeight(50);
    }
    return _tableView;
}




@end
