//
//  IndexViewcontroller.m
//  与你同游
//
//  Created by rimi on 15/10/12.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "InitiateViewcontroller.h"
#import "LaunchTableViewCell.h"
#import "InitiateDetailViewController.h"
#import "ImageView.h"
#import "AddActivityViewController.h"
#import <BmobSDK/Bmob.h>
#import "MJRefresh.h"
#import <MJRefresh.h>
#import "CalledModel.h"
@interface InitiateViewcontroller ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) CalledModel *calledModel;
@property (nonatomic, strong) NSMutableArray *userArray;
@property (nonatomic, strong) NSMutableArray *calledArray;
@end
@implementation InitiateViewcontroller
- (void)dealloc {
    [self.calledModel removeObserver:self forKeyPath:@"calledArray"];
    [self.calledModel removeObserver:self forKeyPath:@"userArray"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:0.929 alpha:1.000];
    [self initNavTitle:@"发起"];
    [self initRightButtonEvent:@selector(handleAddCalled:) Image:IMAGE_PATH(@"添加游记.png")];
    [self.calledModel addObserver:self forKeyPath:@"calledArray" options:NSKeyValueObservingOptionNew context:nil];
    [self.calledModel addObserver:self forKeyPath:@"userArray" options:NSKeyValueObservingOptionNew context:nil];
    [self initDataSouce];
    [self initUserInterface];
    
}
- (void)setupRefresh
{
//    [self.calledModel queryTheCalledlList];
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
//    [self.calledModel queryTheCalledlList];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
    
}


- (void)initDataSouce {
    [self setupRefresh];
    
    
}
#pragma mark -- KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"calledArray"]) {
        self.calledArray = self.calledModel.calledArray;
        for (int i = 0; i < self.calledArray.count; i ++) {
            if ([self.calledArray[i] objectForKey:@"image"]) {
                NSString *strUrl = [self.calledArray[i] objectForKey:@"image"];
                NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:strUrl]];
                UIImage *image = [UIImage imageWithData:data];
                [self.calledArray[i] setObject:image forKey:@"image"];
            }else {
                [self.calledArray[i] setObject:IMAGE_PATH(@"壁纸3.jpg") forKey:@"image"];
            }
        }
    }
    if ([keyPath isEqualToString:@"userArray"]) {
        for (int i = 0; i < self.calledModel.calledArray.count; i ++) {
            BmobObject *ob = self.calledModel.userArray[i];
            if ([ob objectForKey:@"head_portraits1"]) {
                NSString *strUrl = [ob objectForKey:@"head_portraits1"];
                NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:strUrl]];
                UIImage *image = [UIImage imageWithData:data];
                [ob setObject:image forKey:@"head_portraits1"];
                [self.userArray addObject:ob];
            }else {
                [ob setObject:nil forKey:@"head_portraits1"];
                [self.userArray addObject:ob];
            }
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }
}


- (void)initUserInterface {
    [self.view addSubview:self.tableView];
    [self initPersonButton];
}

- (void)handleAddCalled:(UIButton *)sender {
    AddActivityViewController *AAVC = [[AddActivityViewController alloc] init];
    [self.navigationController pushViewController:AAVC animated:YES];

}
#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if (self.dataSource.count == 0) {
//        self.nullData.hidden = NO;
//    }else {
//        self.nullData.hidden = YES;
//    }
    //    return self.dataSource.count;
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"cell";
    LaunchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[LaunchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }else {
        [cell removeFromSuperview];
        cell = [[LaunchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if (self.calledArray.count == 0 || self.userArray.count == 0) {
//        return cell;
//    }
//    BmobObject *object = self.calledArray[indexPath.section];
//    BmobObject *userobject = self.userArray[indexPath.section];
//    NSString *str = [object objectForKey:@"content"];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *date = [dateFormatter dateFromString:[object objectForKey:@"called_date"]];
//    [cell initUserHeaderImage:[userobject objectForKey:@"head_portraits1"] userID:[userobject objectForKey:@"userName"] userLV:@"13" launchTime:[self compareCurrentTime:date] launchDate:[object objectForKey:@"called_date"]];
//    
//    [cell initDeparture:[object objectForKey:@"point_of_departure"] destination:[object objectForKey:@"destination"] starting:[object objectForKey:@"departure_time"] reture:[object objectForKey:@"arrival_time"] info:str];
//    
//    cell.infoLabel.frame = flexibleFrame(CGRectMake(10, 80, 335, [self heightForString:str fontSize:14 andWidth:335]), NO);
//    [cell initSave:@"0" comment:@"3" follower:@"3"];
//    cell.ageLabel.text = [NSString stringWithFormat:@"%@岁", (NSString *)[userobject objectForKey:@"age"]];
//    if ([userobject objectForKey:@"sex"]) {
//        if ([[userobject objectForKey:@"sex"]  isEqualToString:@"男"]) {
//            cell.sexImage.image = IMAGE_PATH(@"男.png");
//        }else {
//            cell.sexImage.image = IMAGE_PATH(@"女.png");
//        }
//    }else {
//        cell.sexImage.image = IMAGE_PATH(@"男.png");
//    }
//
//    cell.PNumber.text = [NSString stringWithFormat:@"%d人", [(NSString *)[object objectForKey:@"number_Of_people"] intValue]];
////    [cell.followerButton setTitle:[NSString stringWithFormat:@"%@人", [object objectForKey:@"number_of_people"]] forState:UIControlStateNormal];
//    if ([object objectForKey:@"image"]) {
//         [cell.ContentButton setImage:[object objectForKey:@"image"] forState:UIControlStateNormal];
//        tableView.rowHeight = cell.saveButton.frame.size.height + cell.infoLabel.frame.size.height + cell.UserHeaderimageView.frame.size.height + cell.ContentButton.frame.size.height + 60;
//    }else {
//        [cell.ContentButton setImage:IMAGE_PATH(@"效果图1.png") forState:UIControlStateNormal];
//    }
//   
//    [cell.ContentButton addTarget:self action:@selector(handleEventImage:) forControlEvents:UIControlEventTouchUpInside];
//    [cell.UserHeaderimageView addTarget:self action:@selector(handleEventHearImage:) forControlEvents:UIControlEventTouchUpInside];
//    
//    cell.ContentButton.frame = CGRectMake(20, cell.infoLabel.frame.origin.y + cell.infoLabel.bounds.size.height + 10, flexibleHeight(70), flexibleHeight(70));
//    
//    
//    
//    CGPoint center = cell.saveButton.center;
//    center.y = tableView.rowHeight - flexibleHeight(15);
//    cell.saveButton.center = center;
//    
//    center = cell.commentButton.center;
//    center.y = tableView.rowHeight - flexibleHeight(15);
//    cell.commentButton.center = center;
//    
//    center = cell.followerButton.center;
//    center.y = tableView.rowHeight - flexibleHeight(15);
//    cell.followerButton.center = center;
//    [cell PositionTheReset];
    
    return cell;


}
#pragma mark --文本自适应
- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    UILabel *detailTextView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont boldSystemFontOfSize:fontSize];
    detailTextView.text = value;
    detailTextView.numberOfLines = 0;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize.height;
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


#pragma mark -- 图片
- (void)handleEventImage:(UIButton *)sender {
    ImageView *imgView = [[ImageView alloc] init];
    imgView.view.frame = flexibleFrame(CGRectMake(0, 0, WIDTH, HEIGHT), NO);
    [imgView ShowImage:sender.currentImage];
    float imageWidth = 0.0;
    float imageHeight = 0.0;
    if (sender.currentImage.size.width > WIDTH) {
        imageHeight = sender.currentImage.size.height * (WIDTH / sender.currentImage.size.width);
        imageWidth = WIDTH;
        
    }else {
        imageWidth = sender.currentImage.size.width;
        imageHeight = sender.currentImage.size.height;
    }
    
    imgView.iamgeView.frame = flexibleFrame(CGRectMake(0, 0, imageWidth, imageHeight), NO);
    imgView.iamgeView.center = flexibleCenter(CGPointMake(WIDTH / 2, HEIGHT / 2), NO);
    [self presentViewController:imgView animated:NO completion:^{
        
    }];
}

- (void)handleEventHearImage:(UIButton *)sender {
    
}


#pragma mark --UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    InitiateDetailViewController *IVC = [[InitiateDetailViewController alloc] init];
    IVC.userObject = self.userArray[indexPath.section];
    IVC.calledObject = self.calledArray[indexPath.section];
    [self.navigationController pushViewController:IVC animated:YES];
}
#pragma mark --getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = ({
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
            tableView.frame = flexibleFrame(CGRectMake(10, 64, WIDTH - 20, HEIGHT - 64 - 50), NO);
            tableView.dataSource = self;
            tableView.delegate = self;
            tableView.showsVerticalScrollIndicator = NO;
            tableView.rowHeight = flexibleHeight(260);
            tableView.backgroundColor = [UIColor colorWithWhite:0.929 alpha:1.000];
            tableView;
        });
        
    }
    return _tableView;
}
- (CalledModel *)calledModel {
    if (!_calledModel) {
        _calledModel = [[CalledModel alloc] init];
    }
    return _calledModel;
}

- (NSMutableArray *)userArray {
    if (!_userArray) {
        _userArray = [NSMutableArray array];
    }
    return _userArray;
}

- (NSMutableArray *)calledArray {
    if (!_calledArray) {
        _calledArray = [NSMutableArray array];
    }
    return _calledArray;
}

@end
