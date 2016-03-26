//
//  RecordDetailViewController.m
//  viewController
//
//  Created by rimi on 15/10/16.
//  Copyright (c) 2015年 ouyang. All rights reserved.
//

#import "RecordDetailViewController.h"
#import "MJRefresh.h"
#import "CommentView.h"
#import "ShareView.h"
#import "DetailTopView.h"
#import "ICommentsView.h"
#import "JoinInCell.h"
#import "ICommentsCell.h"
#import <BmobSDK/Bmob.h>
#import "ThumbUp.h"
#import "Collection.h"
#import "Comments.h"
#import "UserModel.h"
#import "UITableView+SDAutoTableViewCellHeight.h"

#define SIZEHEIGHT frame.size.height
#define SIZEHEIGHT frame.size.height

@interface RecordDetailViewController ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UserModel * user;
#pragma mark --上
@property (nonatomic, strong) DetailTopView * topView;

#pragma mark --中
@property (nonatomic, strong) UIView      * bottomLine;
@property (nonatomic, strong) UIButton    * rightsideButton;
@property (nonatomic, strong) UIButton    * leftsideButton;
@property (nonatomic, strong) UIView      * lineView;
@property (nonatomic, strong) ICommentsView * commentView;

#pragma mark --下
@property (nonatomic, strong) UIView      * bottomView;
@property (nonatomic, strong) UIButton    * dianzanbt;
@property (nonatomic, strong) UIButton    * commentbt;
@property (nonatomic, strong) UIButton    * sharebt;
@property (nonatomic, strong) UIButton    * collectionbt;

@property (nonatomic, strong) CommentView * comment;
@property (nonatomic,assign) CGFloat keyboardHeight;
@property (nonatomic,assign) NSTimeInterval duration;

@property (nonatomic, assign) long type;
@property (nonatomic, assign) NSInteger skip;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) NSMutableArray * commentArray;
@property (nonatomic, strong) NSMutableArray * userArray;
@property (nonatomic, strong) NSArray * thumbArray;


@end

@implementation RecordDetailViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBackButton];
    [self initNavTitle:@"游记详情"];
    self.type = 0;
    self.skip = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUserInterface];
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
        if (self.type == 0) {
            [self getCommentList];
        }
        else{
            [self getThumbUpList];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
        });
    }];
}

- (void)loadNewData {
    
    if (self.type == 0) {
        [self getCommentList];
    }
    else{
        [self getThumbUpList];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    });
    
}

- (void)getCommentList{
    [Called getCommentsWithLimit:10 skip:self.skip type:1 CalledsID:self.objId Success:^(NSArray *commentArray) {
        [self.commentArray addObjectsFromArray:commentArray];
        self.skip = self.skip + 10;
        self.dataSource = self.commentArray;
        [self.tableView reloadData];
    } failure:^(NSError *error1) {
        
    }];
}
- (void)getThumbUpList{
    for (NSString * userId in self.thumbArray) {
        [self.user getInfowithObjectId:userId successBlock:^(BmobObject *object) {
             [self.userArray addObject:object];
        } failBlock:^(NSError *error) {
            
        }];
    }
    if (self.type == 1) {
        self.dataSource = self.userArray;
    }
}

- (void)initUserInterface {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerClass:[ICommentsCell class] forCellReuseIdentifier:NSStringFromClass([ICommentsCell class])];
    [self.tableView registerClass:[JoinInCell class] forCellReuseIdentifier:NSStringFromClass([JoinInCell class])];

    [self.view addSubview:self.topView];
    [self.view addSubview:self.leftsideButton];
    [self.view addSubview:self.rightsideButton];
    [self.view addSubview:self.bottomLine];
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.comment.inputView];


    
    self.topView.sd_layout.topSpaceToView(self.view,64).leftEqualToView(self.view).rightEqualToView(self.view).heightIs(flexibleHeight(HEIGHT / 3));
    
    self.leftsideButton.sd_layout.leftEqualToView(self.view).widthIs(flexibleWidth(WIDTH / 2)).heightIs(flexibleHeight(40)).topSpaceToView(self.topView, 0);
    
    self.rightsideButton.sd_layout.rightEqualToView(self.view).widthIs(flexibleWidth(WIDTH / 2)).heightIs(flexibleHeight(40)).topEqualToView(self.leftsideButton);
    
    self.bottomLine.sd_layout.centerXIs(flexibleWidth(WIDTH / 4)).heightIs(flexibleHeight(2)).widthIs(flexibleWidth(WIDTH / 2)).topSpaceToView(self.leftsideButton, 0);
    self.lineView.sd_layout.topSpaceToView(self.bottomLine, 0).leftEqualToView(self.view).rightEqualToView(self.view).heightIs(1);
    self.tableView.sd_layout.topSpaceToView(self.bottomLine, 1).leftEqualToView(self.view).rightEqualToView(self.view).bottomSpaceToView(self.view,flexibleHeight(40));

    
    self.bottomView.sd_layout.leftEqualToView(self.view).bottomEqualToView(self.view).widthIs(flexibleWidth(WIDTH)).heightIs(flexibleHeight(40));
    
    self.dianzanbt.sd_layout.leftSpaceToView(self.bottomView,WIDTH /4).topSpaceToView(self.bottomView,5).widthIs(flexibleWidth(30)).heightIs(flexibleHeight(30));
    self.commentbt.sd_layout.leftSpaceToView(self.bottomView,WIDTH / 3 + 20).topSpaceToView(self.bottomView,5).widthIs(flexibleWidth(30)).heightIs(flexibleHeight(30));
    self.sharebt.sd_layout.rightSpaceToView(self.bottomView,WIDTH / 3 + 20).topSpaceToView(self.bottomView,5).widthIs(flexibleWidth(30)).heightIs(flexibleHeight(30));
    self.collectionbt.sd_layout.rightSpaceToView(self.bottomView,WIDTH /4).topSpaceToView(self.bottomView,5).widthIs(flexibleWidth(30)).heightIs(flexibleHeight(30));
    
    
    
    

}

- (void)setTravelObject:(BmobObject *)travelObject{
    _travelObject = travelObject;
    BmobObject * user =  [travelObject objectForKey:@"userId"];
    self.objId = travelObject.objectId;
    self.topView.travelObject = travelObject;
    self.topView.userObject = user;
    
    self.thumbArray = (NSArray *)[travelObject objectForKey:@"thumbArray"];
    for (NSString * userId in self.thumbArray) {
        if ([userId isEqualToString:OBJECTID]) {
            self.dianzanbt.selected = YES;
        }
        else{
            self.dianzanbt.selected = NO;
        }
    }
    
    NSArray * collectionArray = (NSArray *)[travelObject objectForKey:@"collectionArray"];
    for (NSString * userId in collectionArray) {
        if ([userId isEqualToString:OBJECTID]) {
            self.collectionbt.selected = YES;
        }
        else{
            self.collectionbt.selected = NO;
        }
    }
    [self getCommentList];
    [self getThumbUpList];

}



- (void)buttonClick:(UIButton *)sender {
    if (sender == self.leftsideButton) {
        self.type = 0;
        self.dataSource = self.commentArray;
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomLine.sd_layout.centerXIs(flexibleWidth(WIDTH / 4));
            [self.bottomLine updateLayout];
        }];
        [self.tableView reloadData];

    }
    
    if (sender == self.rightsideButton) {
        self.type = 1;
        self.dataSource = self.userArray;
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomLine.sd_layout.centerXIs(flexibleWidth(WIDTH / 4 * 3));
            [self.bottomLine updateLayout];
        }];
        [self.tableView reloadData];
    }
}

- (void)handlePress:(UIButton *)sender{
    if (!OBJECTID) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还未登录喔！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    if (sender == self.collectionbt) {
        if (!sender.selected) {
            [Collection CollectionWithID:self.objId type:1 success:^(NSString *commentID) {
                
            } failure:^(NSError *error1) {
                
            }];
        }
        else{
            [Collection cancelCollectionWithID:self.objId type:1 success:^(NSString *commentID) {
                
            } failure:^(NSError *error1) {
                
            }];
        }

    }
    else if (sender == self.dianzanbt){
        if (!sender.selected) {
            [ThumbUp thumUpWithID:self.objId type:1 success:^(NSString *commentID) {
            } failure:^(NSError *error1) {
                
            }];
        }
        else{
            //取消点赞
            [ThumbUp cancelThumUpWithID:self.objId type:1 success:^(NSString *commentID) {
            } failure:^(NSError *error1) {
                
            }];
        }

    }
    else if (sender == self.commentbt){
         [self.comment.inputText becomeFirstResponder];
    }
    else{
        NSArray * imageArray;
        if ([self.travelObject objectForKey:@"urlArray"]) {
            imageArray = [self.travelObject objectForKey:@"urlArray"];
        }
        else{
            imageArray = nil;
        }
        [ShareView sharedWithImages:imageArray content:[self.travelObject objectForKey:@"content"]];
        
    }
    
    sender.selected = !sender.selected;
}
//发表评论
- (void)handleSend{
    
    if (![self.comment.inputText.text isEqualToString:@""]) {
         [Comments addComentWithContent:self.comment.inputText.text userID:nil type:1 objID:self.objId success:^(NSString *commentID) {
             
         } failure:^(NSError *error1) {
             
         }];
        self.comment.inputText.text = @"";
    }
    else{
        [self alertView:@"评论不能为空哟~" cancelButtonTitle:nil sureButtonTitle:@"确定"];
        
        
    }
    
    self.comment.inputView.frame = flexibleFrame(CGRectMake(0,667,375,40), NO);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Class currentClass = [ICommentsCell class];
    ICommentsCell *cell = nil;
    if (self.type == 1) {
        currentClass = [JoinInCell class];
    }
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([currentClass class])];
    BmobObject *model = self.dataSource[indexPath.row];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 2;
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

#pragma mark --键盘通知与textViewDelegate
- (void)keyboardWillShow:(NSNotification *)noti{
    CGRect keyboardRect =[noti.userInfo [UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardHeight = keyboardRect.size.height;
    self.duration = [noti.userInfo [UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:self.duration delay:0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
        self.comment.inputView.frame = flexibleFrame(CGRectMake(0,667 - (CGRectGetHeight(self.comment.inputText.bounds)+ 10 + self.keyboardHeight),375, CGRectGetHeight(self.comment.inputText.bounds) + 10), NO);
        
    } completion:nil];

}
- (void)textViewDidChange:(UITextView *)textView{
    if (![textView.text isEqualToString:@""]) {
        
        CGSize size = [textView sizeThatFits:CGSizeMake(280,CGFLOAT_MAX)];
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            self.comment.inputText.frame = flexibleFrame(CGRectMake(20,5,280, size.height), NO);
            
            self.comment.inputView.frame = flexibleFrame(CGRectMake(0,667 - (size.height + 10 + self.keyboardHeight),375, size.height + 10), NO);
        } completion:nil];

    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self.view endEditing:YES];
    
    CGSize size = [textView sizeThatFits:CGSizeMake(280,CGFLOAT_MAX)];
    [UIView animateWithDuration:self.duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.comment.inputText.frame = flexibleFrame(CGRectMake(20,5,280, size.height), NO);
        
        self.comment.inputView.frame = flexibleFrame(CGRectMake(0,667,375, size.height + 10), NO);
    } completion:nil];
    
}


#pragma mark -- getter
- (DetailTopView *)topView{
    if (!_topView) {
        _topView = [DetailTopView new];
    }
    return _topView;
}
- (UIButton *)leftsideButton {
    if (!_leftsideButton) {
        _leftsideButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [button setTitle:@"评论" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithWhite:0.298 alpha:1.000] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            button;
        });
    }
    return _leftsideButton;
}

- (UIButton *)rightsideButton {
    if (!_rightsideButton) {
        _rightsideButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [button setTitle:@"点赞" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithWhite:0.298 alpha:1.000] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [button setBackgroundColor:[UIColor whiteColor]];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _rightsideButton;
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = THEMECOLOR;
    }
    return _bottomLine;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1.0];
    }
    return _lineView;
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

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor whiteColor];//如果是clearColor,阴影则设置无效
        _bottomView.layer.shadowOffset = CGSizeMake(0, -1);
        _bottomView.layer.shadowColor= [UIColor blackColor].CGColor;
        _bottomView.layer.shadowOpacity = 0.5;
        _bottomView.layer.shadowRadius = 2;
    }
    return _bottomView;
}
- (UIButton *)dianzanbt{
    if (!_dianzanbt) {
        _dianzanbt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dianzanbt addTarget:self action:@selector(handlePress:) forControlEvents:UIControlEventTouchUpInside];
        [_dianzanbt setBackgroundImage:IMAGE_PATH(@"未点赞.png") forState:UIControlStateNormal];
        [_dianzanbt setBackgroundImage:IMAGE_PATH(@"点赞.png") forState:UIControlStateSelected];
        [self.bottomView addSubview:_dianzanbt];
    }
    return _dianzanbt;
}
- (UIButton *)commentbt{
    if (!_commentbt) {
        _commentbt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentbt addTarget:self action:@selector(handlePress:) forControlEvents:UIControlEventTouchUpInside];
        [_commentbt setBackgroundImage:IMAGE_PATH(@"评论.png") forState:UIControlStateNormal];
        [self.bottomView addSubview:_commentbt];
    }
    return _commentbt;
}

- (UIButton *)sharebt{
    if (!_sharebt) {
        _sharebt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sharebt addTarget:self action:@selector(handlePress:) forControlEvents:UIControlEventTouchUpInside];
        [_sharebt setBackgroundImage:IMAGE_PATH(@"未分享.png") forState:UIControlStateNormal];
        [self.bottomView addSubview:_sharebt];
    }
    return _sharebt;
}
- (UIButton *)collectionbt{
    if (!_collectionbt) {
        _collectionbt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectionbt addTarget:self action:@selector(handlePress:) forControlEvents:UIControlEventTouchUpInside];
        [_collectionbt setBackgroundImage:IMAGE_PATH(@"未收藏.png") forState:UIControlStateNormal];
        [_collectionbt setBackgroundImage:IMAGE_PATH(@"已收藏.png") forState:UIControlStateSelected];
        [self.bottomView addSubview:_collectionbt];
    }
    return _collectionbt;
}

- (CommentView *)comment{
    if (!_comment) {
        _comment = [[CommentView alloc]init];
        self.comment.inputText.delegate = self;
        [self.comment.conmmentButton addTarget:self action:@selector(handleSend) forControlEvents:UIControlEventTouchUpInside];
    }
    return _comment;
}

- (NSMutableArray *)dataSource {
    if(_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (NSMutableArray *)commentArray {
    if(_commentArray == nil) {
        _commentArray = [[NSMutableArray alloc] init];
    }
    return _commentArray;
}
- (NSMutableArray *)userArray {
    if(_userArray == nil) {
        _userArray = [[NSMutableArray alloc] init];
    }
    return _userArray;
}

- (UserModel *)user {
    if (!_user) {
        _user = [[UserModel alloc] init];
    }
    return _user;
}

@end

