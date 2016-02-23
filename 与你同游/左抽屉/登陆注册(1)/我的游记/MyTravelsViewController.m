//
//  MyTravelsViewController.m
//  与你同游
//
//  Created by rimi on 15/10/15.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "MyTravelsViewController.h"

#import "SharedView.h"
#import "RecordDetailViewController.h"
#import "AddTravelViewController.h"
#import "PersonalViewController.h"

#import <BmobSDK/Bmob.h>
#import "TravelModel.h"
#import "TravelTableViewCell.h"
#import "MJRefresh.h"
#import <MJRefresh.h>
#import "CommentViewController.h"
#define BUTTON_TAG 100
#define LABEL_TAG 200
#define IMAGE_TAG 300


static NSString * const identifier = @"CELL";
@interface MyTravelsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *notesData;//数据
@property (nonatomic, strong) UILabel *nameLabel;//昵称
@property (nonatomic, strong) TravelModel *travelCT;
@property (nonatomic, strong) UserModel *userModel;
@property (nonatomic, strong) NSMutableArray *userArray;
@property (nonatomic, strong) BmobObject *userObject;


@end



@implementation MyTravelsViewController
- (void)dealloc {
    [self.travel removeObserver:self forKeyPath:@"travelListArray"];
    [self.travel removeObserver:self forKeyPath:@"userData"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initalizedInterface];
    [self.travel addObserver:self forKeyPath:@"travelListArray" options:NSKeyValueObservingOptionNew context:nil];
    [self.travel addObserver:self forKeyPath:@"userData" options:NSKeyValueObservingOptionNew context:nil];
}
#pragma mark -- KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"travelListArray"]) {
        self.notesData = self.travel.travelListArray;
//        for (int i = (int)self.userArray.count; i < self.notesData.count; i ++) {
//            NSLog(@"%@", [self.notesData[i] objectForKey:@"image"]);
//            if ([self.notesData[i] objectForKey:@"image"]) {
//                NSString *strUrl = [self.notesData[i] objectForKey:@"image"];
//                NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:strUrl]];
//                UIImage *image = [UIImage imageWithData:data];
//                [self.notesData[i] setObject:image forKey:@"image"];
//            }else {
//                [self.notesData[i] setObject:IMAGE_PATH(@"个人信息背景2.png") forKey:@"image"];
//            }
//        }
//        [self.tableView reloadData];
//        [self.tableView headerEndRefreshing];
    }
    if ([keyPath isEqualToString:@"userData"]) {
        self.userObject = self.travel.userData;
        if ([self.userObject objectForKey:@"head_portraits1"]) {
            NSString *strUrl = [self.userObject objectForKey:@"head_portraits1"];
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:strUrl]];
            UIImage *image = [UIImage imageWithData:data];
            [self.userObject setObject:image forKey:@"head_portraits1"];
        }else {
            [self.userObject setObject:IMAGE_PATH(@"qq.png") forKey:@"head_portraits1"];
        }
    }
    
    
}
- (void)initalizedInterface{
    
    [self initNavTitle:@"我的游记"];
    [self initBackButton];
    self.view.backgroundColor = [UIColor colorWithWhite:0.929 alpha:1.000];
    [self initRightButtonEvent:@selector(handleTravelNotes:) Image:[UIImage imageNamed:@"添加游记"]];
    [self.view addSubview:self.tableView];
    [self setupRefresh];
}

- (void)setupRefresh
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.stateLabel.font = [UIFont systemFontOfSize:flexibleHeight(12)];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:flexibleHeight(12)];
    self.tableView.mj_header = header;
}
- (void)loadNewData {
    [self.travel queryTravelWithObejectId:OBJECTID];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.notesData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TravelTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TravelTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (self.notesData.count == 0 && self.userArray.count == 0) {
        return cell;
    }
    BmobObject *object = self.notesData[indexPath.section];
//    BmobObject *self.userObject = self.userArray[indexPath.section];
//    if ([object objectForKey:@"image"]) {
//        cell.firstImageView.image = [object objectForKey:@"image"];
//    }else {
//        cell.firstImageView.image = IMAGE_PATH(@"效果图1.png");
//    }
    
    ((UILabel *)([cell.thumbUpButton subviews][1])).text = [NSString stringWithFormat:@"%@", [object objectForKey:@"number_of_thumb_up"]];
    [cell.thumbUpButton addTarget:self action:@selector(handleThumbAction:) forControlEvents:UIControlEventTouchUpInside];
    ((UILabel *)([cell.commentsButton subviews][1])).text = [NSString stringWithFormat:@"%@", [object objectForKey:@"comments_number"]];
    [cell.commentsButton addTarget:self action:@selector(handleCommentsAction:) forControlEvents:UIControlEventTouchUpInside];
    ((UILabel *)([cell.shareButton subviews][1])).text = @"0";
    [cell.shareButton addTarget:self action:@selector(handleShareAction:) forControlEvents:UIControlEventTouchUpInside];
    
//    cell.noteLabel.text = [object objectForKey:@"content"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:[object objectForKey:@"travel_date"]];
    cell.timeLabel.text = [self compareCurrentTime:date];
    cell.placeLabel.text = ([object objectForKey:@"sight_spot"])[0];
    
    cell.nameLabel.text = [self.userObject objectForKey:@"userName"];
    [cell.userPortrait setImage:[self.userObject objectForKey:@"head_portraits1"] forState:UIControlStateNormal] ;
    [cell.userPortrait addTarget:self action:@selector(handleInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * bcView = [[UIView alloc]init];
    bcView.backgroundColor = [UIColor clearColor];
    return bcView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordDetailViewController * detailVC = [[RecordDetailViewController alloc]init];
    BmobObject *object = self.notesData[indexPath.section];
    BmobObject *userobject = self.userObject;
    detailVC.object = object;
    detailVC.userobject = userobject;
    [self.navigationController pushViewController:detailVC animated:YES];
}



- (void)handleInfo:(UIButton *)sender{
    
    PersonalViewController * informationVC  = [[PersonalViewController alloc]init];
    
    [self presentViewController:informationVC animated:YES completion:nil];
    
}


- (void)handleTravelNotes:(UIButton *)sender {
    AddTravelViewController * addVC = [[AddTravelViewController alloc]init];
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)handleThumbAction:(UIButton *)sender {
    UIImageView * imageView = (UIImageView *)[sender subviews][0];
    UILabel * label = (UILabel *)[sender subviews][1];
    
    long number = [label.text longLongValue];
    
    if (sender.selected == NO) {
        label.text = [NSString stringWithFormat:@"%ld",number+1];
        imageView.image = IMAGE_PATH(@"点赞3.png");
        sender.selected = YES;
        
    }
    else{
        label.text = [NSString stringWithFormat:@"%ld",number-1];
        imageView.image = IMAGE_PATH(@"点赞2.png");
        sender.selected = NO;
        
    }
    
    
}

- (void)handleCommentsAction:(UIButton *)sender {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:((TravelTableViewCell *)sender.superview.superview)];
    BmobObject *object = self.notesData[indexPath.section];
    CommentViewController * detailVC = [[CommentViewController alloc]init];
    detailVC.phoneNumber = [object objectForKey:@"phone_number"];
    detailVC.travelDate = [object objectForKey:@"travel_date"];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (void)handleShareAction: (UIButton *)sender {
    
    [self.parentViewController.view addSubview:self.sharedView.maskButton];
    [self.parentViewController.view addSubview:self.sharedView.shareView];
    [UIView animateWithDuration:0.5 animations:^{
        
        self.sharedView.shareView.frame = flexibleFrame(CGRectMake(0,567, 375, 100), NO);
        
    }];
    
}


- (NSString *) compareCurrentTime:(NSDate *) compareDate {
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = - timeInterval;
    long temp = 0;
    NSString *result = nil;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval / 60) < 60){
        result = [NSString stringWithFormat:@"%ld分前", temp];
    }
    else if((temp = temp / 60) < 24){
        result = [NSString stringWithFormat:@"%ld小时前", temp];
    }
    else if((temp = temp / 24) < 30){
        result = [NSString stringWithFormat:@"%ld天前", temp];
    }
    else if((temp = temp / 30) < 12){
        result = [NSString stringWithFormat:@"%ld月前", temp];
    }
    else{
        temp = temp / 12;
        result = [NSString stringWithFormat:@"%ld年前", temp];
    }
    
    return  result;
}

#pragma mark --lazy loading

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = ({
            UITableView * tableView = [[UITableView alloc]initWithFrame:flexibleFrame(CGRectMake(10, 64, 355, 603), NO)];
            tableView.backgroundColor = [UIColor colorWithWhite:0.929 alpha:1.000];
            tableView.rowHeight = 400;
            tableView.showsVerticalScrollIndicator = NO;
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView;
            
        });
    }
    return _tableView;
}

- (SharedView *)sharedView{
    if (!_sharedView) {
        _sharedView = [[SharedView alloc]init];
    }
    return _sharedView;
}

- (UserModel *)travel {
    if (!_travel) {
        _travel = [[UserModel alloc] init];
    }
    return _travel;
}

- (TravelModel *)travelCT {
    if (!_travelCT) {
        _travelCT = [[TravelModel alloc] init];
    }
    return _travelCT;
}


- (UserModel *)userModel {
    if (!_userModel) {
        _userModel = [[UserModel alloc] init];
    }
    return _userModel;
}
- (NSMutableArray *)userArray {
    if (!_userArray) {
        _userArray = [NSMutableArray array];
    }
    return _userArray;
}

@end