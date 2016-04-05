//
//  InitiateDetailViewController.m
//  与你同游
//
//  Created by rimi on 15/10/20.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "InitiateDetailViewController.h"
#import "Called.h"
#import "HeaderView.h"
#import "JoinInCell.h"
#import "ICommentsCell.h"
#import "HeaderButtonView.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "LBottomView.h"
#import <MJRefresh.h>
#import "CommentViewController.h"
#define SIZEHEIGHT frame.size.height

@interface InitiateDetailViewController ()<UITableViewDelegate, UITableViewDataSource, HeaderButtonViewDelegate, LBottomViewDelegate>

@property (nonatomic, assign) long limit;
@property (nonatomic, assign) long skip;
@property (nonatomic, assign) long Jskip;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HeaderView *headerView;
@property (nonatomic, strong) HeaderButtonView *buttonView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *commentArray;
@property (nonatomic, strong) NSMutableArray *userArray;
@property (nonatomic, strong) LBottomView *bottomView;
@property (nonatomic, assign) long type;

@end

@implementation InitiateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBackButton];
    [self initNavTitle:@"发起详情"];
    _type = 0;
    [self initUserInterface];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (_type == 0) {
            [self getCommentList];
        }else {
            [self getjoinList];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
        });
    }];
}

- (void)getMemeberList {
    [Called getMemeberWithCalledsID:_calledID Success:^(NSArray *commentArray) {
        NSLog(@"%@", commentArray);
    } failure:^(NSError *error1) {
        
    }];
}


- (void)setCalledID:(NSString *)calledID {
    _calledID = calledID;
    _skip = 0;
    _Jskip = 0;
    _limit = 15;
    [self getCommentList];
    [self getjoinList];
    [self getMemeberList];
}

- (void)getCommentList {
    
    [Called getCommentsWithLimit:_limit?_limit:10 skip:_skip?_skip:0 type:0 CalledsID:_calledID Success:^(NSArray *commentArray) {
        _skip = _skip + _limit;
        [self.commentArray addObjectsFromArray:commentArray];
        if (_type == 0) {
            [self.dataSource addObjectsFromArray:commentArray];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error1) {
        
    }];
}

- (void)setUserObject:(BmobObject *)userObject {
    _userObject = userObject;
    self.headerView.userObject = userObject;
}

- (void)getjoinList {
    [Called getJoinWithLimit:_limit?_limit:10 skip:_Jskip?_Jskip:0 CalledsID:_calledID Success:^(NSArray *commentArray) {
        [self.userArray addObjectsFromArray:commentArray];
        if (_type == 1) {
            [self.dataSource addObjectsFromArray:commentArray];
        }
        _Jskip = _Jskip + _limit;
    } failure:^(NSError *error1) {
        
    }];
}

- (void)joinCalled {
    [Called joinInCalledWithCalledID:_calledID Success:^(BOOL isSuccess) {
        if (isSuccess) {
            [self message:@"您已经报名！"];
        }
    } failure:^(NSError *error) {
        
    }];
}



- (void)thumUpCalled {
    

}

- (void)commentCalled {
    CommentViewController *comVC = [[CommentViewController alloc] init];
    comVC.objId = _calledID;
    comVC.type = 0;
    [self.navigationController pushViewController:comVC animated:YES];
}

- (void)setCalledObject:(BmobObject *)calledObject {
    _calledObject = calledObject;
    __weak typeof(self) weakSelf = self;
    [self.headerView.infoLabel setDidFinishAutoLayoutBlock:^(CGRect frame) {
        weakSelf.tableView.tableHeaderView = weakSelf.headerView;
    }];
    self.headerView.calledObject = calledObject;
}

- (void)initUserInterface {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerClass:[ICommentsCell class] forCellReuseIdentifier:NSStringFromClass([ICommentsCell class])];
    [self.tableView registerClass:[JoinInCell class] forCellReuseIdentifier:NSStringFromClass([JoinInCell class])];
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view, flexibleHeight(64)).bottomSpaceToView(self.view, flexibleHeight(50));
    [self.view addSubview:self.bottomView];
    self.bottomView.sd_layout.leftEqualToView(self.view).bottomSpaceToView(self.view, 0).rightEqualToView(self.view).heightIs(flexibleHeight(50));
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Class currentClass = [ICommentsCell class];
    ICommentsCell *cell = nil;
    if (_type == 1) {
        currentClass = [JoinInCell class];
    }
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([currentClass class])];
    BmobObject *model = self.dataSource[indexPath.row];
    cell.model = model;
    cell.indexPath = indexPath;
    if ([UserID isEqualToString:_userObject.objectId]) {
        [cell isText];
    }
    
    if (_type == 0) {
        [cell setReplayBlock:^(NSIndexPath *indexPath) {
            CommentViewController *comVC = [[CommentViewController alloc] init];
            comVC.objId = _calledID;
            comVC.type = 0;
            BmobObject *user = [model objectForKey:@"user"];
            comVC.userID = user.objectId;
            if (![[user objectForKey:@"username"] isEqualToString:@"还没取昵称哟！"]) {
                comVC.username  = [user objectForKey:@"username"];
            }else {
                comVC.username  = [user objectForKey:@"phoneNumber"];
            }
            [self.navigationController pushViewController:comVC animated:YES];
        }];
    }else {

        [cell setReplayBlock:^(NSIndexPath *indexPath) {
            [Called inviteJoinUserId:model.objectId calledID:_calledID Success:^(BOOL isSuccess) {
                if (isSuccess) {
                    [self message:@"小伙伴已经成为您的队友！"];
                }
            } failure:^(NSError *error) {
                
            }];
        }];
    
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return flexibleHeight(47);

}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.buttonView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:[self cellContentViewWith] tableView:tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_type == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 50, 100, 44)];
        view.backgroundColor = [UIColor redColor];
    }

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
        self.dataSource = self.userArray;
        _type = 1;
        [self.tableView reloadData];
        
    }else {
        self.dataSource = self.commentArray;
        _type = 0;
        [self.tableView reloadData];
        
    }
}

- (UITableView *)tableView {
	if(_tableView == nil) {
		_tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
		_buttonView = [[HeaderButtonView alloc] initWithType:0];
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

- (NSMutableArray *)userArray {
	if(_userArray == nil) {
		_userArray = [[NSMutableArray alloc] init];
	}
	return _userArray;
}

- (NSMutableArray *)commentArray {
	if(_commentArray == nil) {
		_commentArray = [[NSMutableArray alloc] init];
	}
	return _commentArray;
}

- (LBottomView *)bottomView {
	if(_bottomView == nil) {
		_bottomView = [[LBottomView alloc] init];
        _bottomView.delegate = self;
	}
	return _bottomView;
}

@end
