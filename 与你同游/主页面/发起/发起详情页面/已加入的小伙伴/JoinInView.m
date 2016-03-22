//
//  JoinInView.m
//  与你同游
//
//  Created by Zgmanhui on 16/3/17.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import "JoinInView.h"
#import "JoinInCell.h"
@interface JoinInView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation JoinInView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.tableView];
         [self.tableView registerClass:[JoinInCell class] forCellReuseIdentifier:NSStringFromClass([JoinInCell class])];
        self.tableView.sd_layout.leftEqualToView(self).rightEqualToView(self).topEqualToView(self).heightIs(flexibleHeight(50) * 10);
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JoinInCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JoinInCell class])];
    return cell;
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


- (NSMutableArray *)dataSource {
    if(_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

@end
