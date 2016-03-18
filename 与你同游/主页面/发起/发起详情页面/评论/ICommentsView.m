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
@interface ICommentsView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ICommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ICommentsCell class])];
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
        _tableView.rowHeight = flexibleHeight(50);
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
