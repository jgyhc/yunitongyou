//
//  InitiateDetailViewController.m
//  与你同游
//
//  Created by rimi on 15/10/20.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "InitiateDetailViewController.h"
#import "JoinInView.h"
#import "Called.h"
#import "ICommentsView.h"
#import "HeaderView.h"
#import "ICommentsCell.h"
#import "HeaderButtonView.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#define SIZEHEIGHT frame.size.height

@interface InitiateDetailViewController ()<UITableViewDelegate, UITableViewDataSource, HeaderButtonViewDelegate>

@property (nonatomic, strong) JoinInView *joinInView;
@property (nonatomic, strong) ICommentsView *commentsView;
@property (nonatomic, assign) long limit;
@property (nonatomic, assign) long skip;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HeaderView *headerView;
@property (nonatomic, strong) HeaderButtonView *buttonView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation InitiateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBackButton];
    [self initNavTitle:@"发起详情"];
    [self initUserInterface];
    self.view.backgroundColor = [UIColor whiteColor];
}



- (void)setCalledID:(NSString *)calledID {
    _calledID = calledID;
    _limit = 15;
    [Called getCommentsWithLimit:_limit?_limit:10 skip:_skip?_skip:0 CalledsID:calledID Success:^(NSArray *commentArray) {
        [self.dataSource addObjectsFromArray:commentArray];
        _skip = _skip + _limit;
        [self.tableView reloadData];
    } failure:^(NSError *error1) {
        
    }];

}

- (void)setUserObject:(BmobObject *)userObject {
    _userObject = userObject;
    self.headerView.userObject = userObject;
}


- (void)setCalledObject:(BmobObject *)calledObject {
    _calledObject = calledObject;
    self.headerView.calledObject = calledObject;
}

- (void)initUserInterface {

    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view, flexibleHeight(64)).bottomSpaceToView(self.view, 0);
    __weak typeof(self) weakSelf = self;
    self.headerView.frameBlock = ^(CGFloat h) {
        weakSelf.headerView.frame = CGRectMake(0, 0, 0, h);
        [weakSelf.tableView layoutSubviews];
    };
    self.tableView.tableHeaderView = self.headerView;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    [self.tableView registerClass:[ICommentsCell class] forCellReuseIdentifier:NSStringFromClass([ICommentsCell class])];
    ICommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ICommentsCell class])];
    BmobObject *comment = self.dataSource[indexPath.row];
    cell.commont = comment;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return flexibleHeight(42);

}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.buttonView;
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

- (void)buttonClickEvent:(UIButton *)sender {
    if (sender == self.buttonView.rightsideButton) {
        
    }else {
    
    
    }

}

- (UITableView *)tableView {
	if(_tableView == nil) {
		_tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
	}
	return _tableView;
}


- (HeaderView *)headerView {
	if(_headerView == nil) {
		_headerView = [[HeaderView alloc] init];
	}
	return _headerView;
}

- (HeaderButtonView *)buttonView {
	if(_buttonView == nil) {
		_buttonView = [[HeaderButtonView alloc] init];
        _buttonView.delegate = self;
	}
	return _buttonView;
}

- (NSMutableArray *)dataSource {
	if(_dataSource == nil) {
		_dataSource = [[NSMutableArray alloc] init];
	}
	return _dataSource;
}

@end
