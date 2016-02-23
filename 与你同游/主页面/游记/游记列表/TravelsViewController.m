//
//  TravelsViewController.m
//  与你同游
//
//  Created by rimi on 15/10/12.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "TravelsViewController.h"
#import "SharedView.h"
#import "RecordDetailViewController.h"
#import "AddTravelViewController.h"
#import "OtherInfoViewController.h"
#import <BmobSDK/Bmob.h>
#import "TravelModel.h"
#import "TravelTableViewCell.h"
#import <MJRefresh.h>
#import "CommentViewController.h"
#define BUTTON_TAG 100
#define LABEL_TAG 200
#define IMAGE_TAG 300


static NSString * const identifier = @"CELL";

@interface TravelsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UILabel *nameLabel;//昵称
@property (nonatomic, strong) TravelModel *travelCT;
@property (nonatomic, strong) UserModel *userModel;
@property (nonatomic, strong) NSMutableArray *userArray;
@property (nonatomic, strong) BmobObject *userObject;

//@property (nonatomic,strong) TravelCollectionViewController * collectionVC;
@end

@implementation TravelsViewController
- (void)dealloc {
    [self.travel removeObserver:self forKeyPath:@"travelListArray"];
    [self.travel removeObserver:self forKeyPath:@"travelUser"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initalizedInterface];
    [self.travel addObserver:self forKeyPath:@"travelListArray" options:NSKeyValueObservingOptionNew context:nil];
    [self.travel addObserver:self forKeyPath:@"travelUser" options:NSKeyValueObservingOptionNew context:nil];
}
#pragma mark -- KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"travelListArray"]) {
        self.notesData = self.travel.travelListArray;
        for (int i = (int)self.userArray.count; i < self.notesData.count; i ++) {
            if ([self.notesData[i] objectForKey:@"image"]) {
                NSString *strUrl = [self.notesData[i] objectForKey:@"image"];
                NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:strUrl]];
                UIImage *image = [UIImage imageWithData:data];
                [self.notesData[i] setObject:image forKey:@"image"];
            }else {
                [self.notesData[i] setObject:IMAGE_PATH(@"个人信息背景2.png") forKey:@"image"];
            }
        }
    }
    if ([keyPath isEqualToString:@"travelUser"]) {
        for (int i = (int)self.userArray.count; i < self.notesData.count; i ++) {
            BmobObject *ob = self.travel.travelUser[i];
            if ([ob objectForKey:@"head_portraits1"]) {
                NSString *strUrl = [ob objectForKey:@"head_portraits1"];
                NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:strUrl]];
                 UIImage *image = [UIImage imageWithData:data];
                [ob setObject:image forKey:@"head_portraits1"];
                [self.userArray addObject:ob];
            }else {
                [ob setObject:IMAGE_PATH(@"qq.png") forKey:@"head_portraits1"];
                [self.userArray addObject:ob];
            }
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }
    
    
}
- (void)initalizedInterface{
    
    [self initNavTitle:@"游记"];
    [self initPersonButton];
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
    [self.travel queryTheTravelListSkip:0];
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
    if (self.notesData.count == 0 || self.userArray.count == 0) {
        return cell;
    }
    BmobObject *object = self.notesData[indexPath.section];
    BmobObject *userobject = self.userArray[indexPath.section];
    
//    if ([object objectForKey:@"image"]) {
//        cell.firstImageView.image = [object objectForKey:@"image"];
//    }else {
//        cell.firstImageView.image = IMAGE_PATH(@"效果图1.png");
//    }
    
    if ([userobject objectForKey:@"head_portraits1"]) {
        [cell.userPortrait setImage:[userobject objectForKey:@"head_portraits1"] forState:UIControlStateNormal];
        
    }else {
        [cell.userPortrait setImage:[userobject objectForKey:@"测试头像1.png"] forState:UIControlStateNormal];
        
    }
    [cell.userPortrait addTarget:self action:@selector(handleInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.nameLabel.text = [userobject objectForKey:@"userName"];
     cell.placeLabel.text = ([object objectForKey:@"sight_spot"])[0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:[object objectForKey:@"travel_date"]];
    cell.timeLabel.text = [self compareCurrentTime:date];
    
    
    cell.contentLabel.text = [object objectForKey:@"content"];
    
     cell.contentLabel.frame = flexibleFrame(CGRectMake(10,90, 335, [self heightForString:[object objectForKey:@"content"] fontSize:14 andWidth:335]), NO);
    
//    cell.imageArray = @[[[object objectForKey:@"image"] mutableCopy]];
//    cell.imageArray = [NSMutableArray arrayWithObjects:[object objectForKey:@"image"], nil];
    cell.collectionView.frame = flexibleFrame(CGRectMake(20, cell.contentLabel.frame.origin.y + cell.contentLabel.frame.size.height + 10, 250, cell.collectionView.frame.size.height), NO);
    
    cell.buttomView.frame = flexibleFrame(CGRectMake(0, cell.collectionView.frame.origin.y + cell.collectionView.frame.size.height + 20,CGRectGetWidth(self.tableView.bounds),30),NO);
    
    ((UILabel *)[cell.thumbUpButton subviews][1]).text = [NSString stringWithFormat:@"%@", [object objectForKey:@"number_of_thumb_up"]];
 
    ((UILabel *)[cell.commentsButton subviews][1]).text = [NSString stringWithFormat:@"%@", [object objectForKey:@"comments_number"]];
    
    ((UILabel *)[cell.shareButton subviews][1]).text = @"0";

    [cell.thumbUpButton addTarget:self action:@selector(handleThumbAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.commentsButton addTarget:self action:@selector(handleCommentsAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.shareButton addTarget:self action:@selector(handleShareAction:) forControlEvents:UIControlEventTouchUpInside];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    tableView.rowHeight = cell.buttomView.frame.origin.y + cell.buttomView.frame.size.height;
    
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
    BmobObject *userobject = self.userArray[indexPath.section];
    detailVC.object = object;
    detailVC.userobject = userobject;
    [self.navigationController pushViewController:detailVC animated:YES];
}






#pragma mark --private methods


#pragma mark --文本自适应
- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    UILabel *detailTextView = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, width, 0),NO)];
    detailTextView.font = [UIFont boldSystemFontOfSize:fontSize];
    detailTextView.text = value;
    detailTextView.numberOfLines = 0;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize.height;
}


- (void)handleInfo:(UIButton *)sender{
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:((TravelTableViewCell *)sender.superview.superview)];
    
    BmobObject *object = self.userArray[indexPath.section];
    
    OtherInfoViewController * informationVC  = [[OtherInfoViewController alloc]init];
    
    informationVC.phone_number = [object objectForKey:@"phone_number"];
    
    [self presentViewController:informationVC animated:YES completion:nil];
    
}


- (void)handleTravelNotes:(UIButton *)sender {
    AddTravelViewController * addVC = [[AddTravelViewController alloc]init];
    [self.navigationController pushViewController:addVC animated:YES];
}

//点赞操作
- (void)handleThumbAction:(UIButton *)sender {
    UILabel * label = (UILabel *)[sender subviews][1];
    UIImageView * imageView = (UIImageView *)[sender subviews][0];
    
    long number = [label.text longLongValue];
    
    if (sender.selected == NO) {
        imageView.image = IMAGE_PATH(@"点赞.png");
        label.text = [NSString stringWithFormat:@"%ld",number+1];
        sender.selected = YES;
    }
    else{
        imageView.image = IMAGE_PATH(@"未点赞.png");
        label.text = [NSString stringWithFormat:@"%ld",number-1];
        sender.selected = NO;
        
    }
}
//评论操作
- (void)handleCommentsAction:(UIButton *)sender {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:((TravelTableViewCell *)sender.superview.superview)];
    BmobObject *object = self.notesData[indexPath.section];
    CommentViewController * detailVC = [[CommentViewController alloc]init];
    detailVC.phoneNumber = [object objectForKey:@"phone_number"];
    detailVC.travelDate = [object objectForKey:@"travel_date"];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}
//分享操作
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
            UITableView * tableView = [[UITableView alloc]initWithFrame:flexibleFrame(CGRectMake(10, 70, 355, 550), NO)];
            tableView.backgroundColor = [UIColor colorWithWhite:0.929 alpha:1.000];
            tableView.rowHeight = 400;
            tableView.showsVerticalScrollIndicator = NO;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.delegate = self;
            tableView.dataSource = self;
            [tableView registerClass:[TravelTableViewCell class] forCellReuseIdentifier:identifier];
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
