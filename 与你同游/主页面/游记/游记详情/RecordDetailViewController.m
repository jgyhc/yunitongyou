//
//  RecordDetailViewController.m
//  viewController
//
//  Created by rimi on 15/10/16.
//  Copyright (c) 2015年 ouyang. All rights reserved.
//

#import "RecordDetailViewController.h"
#import "RecordDetailTableViewCell.h"
#import "RecordDetailScrollImageView.h"
#import "InsetsLabel.h"
#import "TravelModel.h"
#import <BmobSDK/Bmob.h>
#define SIZEHEIGHT frame.size.height

#import "RecordDetailViewController.h"
#import "RecordDetailTableViewCell.h"
#import "RecordDetailScrollImageView.h"
#import "InsetsLabel.h"
#import "TravelModel.h"
#import <BmobSDK/Bmob.h>
#import "MJRefresh.h"
#import "TravelNotesTableViewCell.h"
#import "SharedView.h"
#define SIZEHEIGHT frame.size.height

@interface RecordDetailViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate,UITextViewDelegate>

@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIImageView *userHeaderImageView;//头像
@property (nonatomic, strong) UILabel *userIDlabel;//用户名
@property (nonatomic, strong) InsetsLabel *infoLabel;//内容
@property (nonatomic, strong) UILabel *addressLabel;//地址
@property (nonatomic, strong) UILabel *dateLabel;//时间
@property (nonatomic, strong) UIImageView *endorseImageView;//点赞的
@property (nonatomic, strong) UILabel *endorseLabel;//点赞人数
@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RecordDetailScrollImageView *scrollImageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) TravelModel *travelModel;
@property (nonatomic, strong) NSArray *commentsArray;
@property (nonatomic, strong) NSMutableArray *speakerArray;
@property (nonatomic, strong) NSMutableArray *recipientArray;

@property (nonatomic,strong) UIActivityIndicatorView * indicatorView;

@property (nonatomic,strong) TravelNotesTableViewCell * travelCell;

@property (nonatomic, strong) SharedView *sharedView;
@property (nonatomic,assign) CGFloat keyboardHeight;
@property (nonatomic,assign) NSTimeInterval duration;



@end

@implementation RecordDetailViewController
- (void)dealloc {
    [self.travelModel removeObserver:self forKeyPath:@"travelCommentArray"];
    [self.travelModel removeObserver:self forKeyPath:@"speaker"];
    [self.travelModel removeObserver:self forKeyPath:@"recipient"];
    [self.travelModel removeObserver:self forKeyPath:@"createTCommentResult"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initBackButton];
    [self initNavTitle:@"游记详情"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [self.travelModel addObserver:self forKeyPath:@"travelCommentArray" options:NSKeyValueObservingOptionNew context:nil];
    [self.travelModel addObserver:self forKeyPath:@"speaker" options:NSKeyValueObservingOptionNew context:nil];
    [self.travelModel addObserver:self forKeyPath:@"recipient" options:NSKeyValueObservingOptionNew context:nil];
    [self.travelModel addObserver:self forKeyPath:@"createTCommentResult" options:NSKeyValueObservingOptionNew context:nil];
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:1.000];
    
    [self initUserInterface];
    
    
}

- (void)initUserInterface {
    
    
    
    [self.scrollView addSubview:self.userHeaderImageView];
    [self.scrollView addSubview:self.userIDlabel];
    [self.scrollView addSubview:self.addressLabel];
    [self.scrollView addSubview:self.infoLabel];
    [self.scrollView addSubview:self.contentImageView];
    [self.scrollView addSubview:self.endorseImageView];
    [self.scrollView addSubview:self.dateLabel];
    [self.scrollView addSubview:self.endorseLabel];
    [self.scrollView addSubview:self.tableView];
    
    [self.view insertSubview:self.scrollView atIndex:0];
    [self getButton];
    [self getLoading];
    [self initInterfaceSettting];
    
    [self.view addSubview:self.sharedView.inputView];
    
    
    
}

- (void)getLoading{
    self.indicatorView = ({
        //初始化
        UIActivityIndicatorView * indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        //设置中心点
        indicatorView.center = flexibleCenter(CGPointMake(CGRectGetMidX(self.view.bounds),50), NO);
        indicatorView.color = [UIColor colorWithRed:0.145 green:0.933 blue:0.604 alpha:1.000];
        //        indicatorView.backgroundColor = [UIColor blueColor];
        
        //打开隐藏
        indicatorView.hidesWhenStopped = NO;//默认情况下是隐藏的
        
        indicatorView;
    });
    [self.tableView addSubview:self.indicatorView];
    
    [self.indicatorView startAnimating];
    
    
    
}


#pragma mark -- KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"createTCommentResult"]) {
        
    }
    
    if ([keyPath isEqualToString:@"travelCommentArray"]) {
        
        self.commentsArray = self.travelModel.travelCommentArray;
        for (int i = 0; i < self.commentsArray.count; i ++) {
            [self.travelModel findTravelCommentSpearkerWithPhoneNumber:[self.object objectForKey:@"phone_number"] Password:nil travel_date:[self.object objectForKey:@"travel_date"] travel_comments_time:[self.commentsArray[i] objectForKey:@"travel_comments_time"] userType:@"speaker" index:i];
            [self.travelModel findTravelCommentSpearkerWithPhoneNumber:[self.object objectForKey:@"phone_number"] Password:nil travel_date:[self.object objectForKey:@"travel_date"] travel_comments_time:[self.commentsArray[i] objectForKey:@"travel_comments_time"] userType:@"recipient" index:i];
        }
        
        //        [self.tableView reloadData];
    }
    if ([keyPath isEqualToString:@"speaker"]) {
        
        [self.speakerArray addObject:self.travelModel.speaker];
        
        if (self.speakerArray.count == self.commentsArray.count && self.recipientArray.count == self.commentsArray.count) {
            
            [self.tableView reloadData];
        }
    }
    if ([keyPath isEqualToString:@"recipient"]) {
        
        [self.recipientArray addObject:self.travelModel.recipient];
        
        if (self.speakerArray.count == self.commentsArray.count && self.recipientArray.count == self.commentsArray.count) {
            
            [self.tableView reloadData];
        }
    }
    
    self.tableView.frame = flexibleFrame(CGRectMake(0, self.contentImageView.frame.origin.y + self.contentImageView.bounds.size.height + 50, CGRectGetMaxX(self.view.frame),self.tableView.rowHeight * self.commentsArray.count), NO);
    
    //    self.scrollView.contentSize = CGSizeMake(375, self.tableView.frame.origin.y + self.tableView.frame.size.height);
    
    
    
}

- (void)keyboardWillShow:(NSNotification *)noti{
    CGRect keyboardRect =[noti.userInfo [UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardHeight = keyboardRect.size.height;
    self.duration = [noti.userInfo [UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:self.duration delay:0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
        self.sharedView.inputView.frame = flexibleFrame(CGRectMake(0,667 - (CGRectGetHeight(self.sharedView.inputText.bounds)+ 10 + self.keyboardHeight),375, CGRectGetHeight(self.sharedView.inputText.bounds) + 10), NO);
        
    } completion:nil];
    NSLog(@"%f",self.keyboardHeight);
}

- (void)initInterfaceSettting {
    
    [self.travelModel findTravelCommentsWithPhoneNumber:[self.object objectForKey:@"phone_number"] Password:nil travel_date:[self.object objectForKey:@"travel_date"]];
    
    if ([self.userobject objectForKey:@"head_portraits1"]) {
        self.userHeaderImageView.image = [self.userobject objectForKey:@"head_portraits1"];
    }else {
        self.userHeaderImageView.image = IMAGE_PATH(@"测试头像1.png");
    }
    _userIDlabel.text = [self.userobject objectForKey:@"userName"];
    _addressLabel.text = ([self.object objectForKey:@"sight_spot"])[0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:[self.object objectForKey:@"travel_date"]];
    self.dateLabel.text = [self compareCurrentTime:date];
    
    
    _endorseLabel.text = [NSString stringWithFormat:@"%@%@", [self.object objectForKey:@"number_of_thumb_up"],@"点赞"];
    
    
    if ([self.object objectForKey:@"image"]) {
        self.contentImageView.image = [self.object objectForKey:@"image"];
    }else {
        self.contentImageView.image = IMAGE_PATH(@"效果图1.png");
    }
    
    
    self.endorseImageView.image = [UIImage imageNamed:@"头像"];
    UILabel *label = [[UILabel alloc] initWithFrame:flexibleFrame(CGRectMake(0, 0, 50, 20), NO)];
    label.center = flexibleCenter(CGPointMake(label.frame.size.width / 2 +15, 25 + self.contentImageView.frame.origin.y + self.contentImageView.bounds.size.height), NO);
    //    CGPointMake(label.frame.size.width / 2 + flexibleHeight(15), _infoLabel.frame.origin.y + _infoLabel.SIZEHEIGHT + 20);
    label.text = @"评论";
    label.font = [UIFont italicSystemFontOfSize:15];
    [self.scrollView addSubview:label];
    
    
    
    
    
}

#pragma mark --uiScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat alpha = 1 - scrollView.contentOffset.y / 250;
    self.navView.alpha = alpha;
    self.leftButton.alpha = alpha;
}

#pragma mark --文本自适应
- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont boldSystemFontOfSize:fontSize];
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize.height;
}

#pragma mark --tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.indicatorView stopAnimating];
    [self.indicatorView removeFromSuperview];
    static NSString *identifier = @"cell";
    
    RecordDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[RecordDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    BmobObject *commentObject = self.commentsArray[indexPath.row];
    BmobObject *speaker = self.speakerArray[indexPath.row];
    BmobObject *recipient = self.recipientArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:[commentObject objectForKey:@"travel_comments_time"]];
    cell.timeLabel.text = [self compareCurrentTime:date];
    cell.contensLabel.text = [commentObject objectForKey:@"contents"];
    
    cell.speakerLabel.text = [speaker objectForKey:@"userName"];
    
    cell.receiverLabel.text = [NSString stringWithFormat:@"回复 %@：", [recipient objectForKey:@"userName"]];
    cell.receiverLabel.frame = flexibleFrame(CGRectMake(46 + [self widthForString:cell.speakerLabel.text fontSize:14], 13, 200, 20), NO);
    
    cell.userHeaderImageView.image = [speaker objectForKey:@"head_portraits1"];
    
    cell.contensLabel.frame = flexibleFrame(CGRectMake(15, 38, 345, [self heightForString:cell.contensLabel.text fontSize:13 andWidth:345]), NO);
    
    //    [cell.replayButton addTarget:self action:@selector(handleReplay:) forControlEvents:UIControlEventTouchUpInside];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    tableView.rowHeight = flexibleHeight([self heightForString:cell.contensLabel.text fontSize:13 andWidth:345] + 50);
    
    tableView.frame = flexibleFrame(CGRectMake(0, self.contentImageView.frame.origin.y + self.contentImageView.bounds.size.height + 50, CGRectGetMaxX(self.view.frame), tableView.rowHeight * self.commentsArray.count), NO);
    
    self.scrollView.contentSize = CGSizeMake(375,self.tableView.frame.origin.y + self.tableView.frame.size.height + 30);
    
    
    
    
    
    return cell;
}


//- (void)handleReplay:(UIButton *)sender{
//
//    NSIndexPath * indexPath = [self.tableView indexPathForCell:(RecordDetailTableViewCell *)sender.superview.superview];
//
//}

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

- (float) widthForString:(NSString *)value fontSize:(float)fontSize
{
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 40)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(CGFLOAT_MAX,40)];
    
    return deSize.width;
}

- (void)getButton{
    
//    self.travelCell.thumbUpButton.frame = flexibleFrame(CGRectMake(7.5, 627,120, 40), NO);
//    self.travelCell.commentsButton.frame = flexibleFrame(CGRectMake(127, 627,120, 40), NO);
//    self.travelCell.shareButton.frame = flexibleFrame(CGRectMake(246.5, 627,120, 40), NO);
//    
//    self.travelCell.thumbUpButton.backgroundColor = [UIColor whiteColor];
//    self.travelCell.commentsButton.backgroundColor = [UIColor whiteColor];
//    self.travelCell.shareButton.backgroundColor = [UIColor whiteColor];
//    
//    [self.view addSubview:self.travelCell.thumbUpButton];
//    [self.view addSubview:self.travelCell.commentsButton];
//    [self.view addSubview:self.travelCell.shareButton];
    
//    [self.travelCell.thumbUpButton addTarget:self action:@selector(handleThumbUp:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.travelCell.commentsButton addTarget:self action:@selector(handleComment:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.travelCell.shareButton addTarget:self action:@selector(handleShare:) forControlEvents:UIControlEventTouchUpInside];
//    
//    ((UILabel *)[self.travelCell.thumbUpButton subviews][1]).text = [NSString stringWithFormat:@"%@",[self.object objectForKey:@"number_of_thumb_up"]];
//    ((UILabel *)[self.travelCell.commentsButton subviews][1]).text = [NSString stringWithFormat:@"%@",[self.object objectForKey:@"comments_number"]];
    
    
}
- (void)handleThumbUp:(UIButton *)sender{
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
- (void)handleComment:(UIButton *)sender{
    
    [self.sharedView.inputText becomeFirstResponder];
    
    
    
    
}
- (void)handleShare:(UIButton *)sender{
    [self.parentViewController.view addSubview:self.sharedView.maskButton];
    [self.parentViewController.view addSubview:self.sharedView.shareView];
    [UIView animateWithDuration:0.5 animations:^{
        
        self.sharedView.shareView.frame = flexibleFrame(CGRectMake(0,567, 375, 100), NO);
        
    }];
    
}


- (void)textViewDidChange:(UITextView *)textView{
    if (![textView.text isEqualToString:@""]) {
        
        CGSize size = [textView sizeThatFits:CGSizeMake(280,CGFLOAT_MAX)];
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            self.sharedView.inputText.frame = flexibleFrame(CGRectMake(20,5,280, size.height), NO);
            
            self.sharedView.inputView.frame = flexibleFrame(CGRectMake(0,667 - (size.height + 10 + self.keyboardHeight),375, size.height + 10), NO);
        } completion:nil];
        
        
        
        
    }
    
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self.view endEditing:YES];
    
    CGSize size = [textView sizeThatFits:CGSizeMake(280,CGFLOAT_MAX)];
    [UIView animateWithDuration:self.duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.sharedView.inputText.frame = flexibleFrame(CGRectMake(20,5,280, size.height), NO);
        
        self.sharedView.inputView.frame = flexibleFrame(CGRectMake(0,667,375, size.height + 10), NO);
    } completion:nil];
    
}

//发表评论
- (void)handleSend{
    
    if (![self.sharedView.inputText.text isEqualToString:@""]) {
        [self.travelModel createATravelReviewsWithPhoneNumber:PHONE_NUMBER Password:PASSWORD travel_date:[self.object objectForKey:@"travel_date"] creatorPhoneNumber:[self.object objectForKey:@"phone_number"]   contents:self.sharedView.inputText.text];
        self.sharedView.inputText.text = @"";
    }
    else{
        [self alertView:@"评论不能为空哟~" cancelButtonTitle:nil sureButtonTitle:@"确定"];
        
        
    }
    
    self.sharedView.inputView.frame = flexibleFrame(CGRectMake(0,667,375,40), NO);
}

-(void)handleTap{
    [self textViewDidEndEditing:self.sharedView.inputText];
}


#pragma mark -- getter
- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView;
        });
    }
    return _topImageView;
}


- (RecordDetailScrollImageView *)scrollImageView {
    if (!_scrollImageView) {
        _scrollImageView = ({
            RecordDetailScrollImageView *view = [[RecordDetailScrollImageView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, WIDTH , HEIGHT / 2), NO)];
            view.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
            NSArray *imageArray = [NSArray arrayWithObjects:@"壁纸.jpg", nil];
            [view setArray:imageArray];
            view;
        });
    }
    return _scrollImageView;
}

- (UIImageView *)userHeaderImageView {
    if (!_userHeaderImageView) {
        _userHeaderImageView =  ({
            UIImageView *imageView =  [[UIImageView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 50, 50), YES)];
            imageView.center =  flexibleCenter(CGPointMake(WIDTH / 7 - 10, 54), NO);
            imageView.layer.cornerRadius = imageView.SIZEHEIGHT / 2;
            imageView.layer.masksToBounds = YES;
            imageView;
        });
    }
    return _userHeaderImageView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = ({
            UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 54, WIDTH, HEIGHT - 54), NO)];
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            
            scrollView.delegate = self;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap)];
            [scrollView addGestureRecognizer:tap];
            scrollView;
        });
    }
    return _scrollView;
}

- (UILabel *)userIDlabel {
    if (!_userIDlabel) {
        _userIDlabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 100, 30), NO)];
            label.textAlignment = NSTextAlignmentLeft;
            label.center = flexibleCenter(CGPointMake(WIDTH / 7 + 80, 42), NO);
            label.font = [UIFont boldSystemFontOfSize:16];
            label.textColor = [UIColor colorWithWhite:0.298 alpha:1.000];
            label;
        });
    }
    return _userIDlabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 100, 30), NO)];
            label.textAlignment = NSTextAlignmentRight;
            label.center = flexibleCenter(CGPointMake(WIDTH / 7 * 6 - 10, 54), NO);
            label.font = [UIFont boldSystemFontOfSize:17];
            label.textColor = [UIColor colorWithWhite:0.298 alpha:1.000];
            label;
        });
    }
    return _dateLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 100, 30), NO)];
            label.textAlignment = NSTextAlignmentLeft;
            label.center = flexibleCenter(CGPointMake(WIDTH / 7 + 80, 64), NO);
            label.font = [UIFont boldSystemFontOfSize:15];
            label.textColor = [UIColor colorWithRed:0.400 green:0.800 blue:1.000 alpha:1.000];
            label;
        });
    }
    return _addressLabel;
}

- (InsetsLabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = ({
            InsetsLabel *label = [[InsetsLabel alloc]init];
            label.textAlignment = NSTextAlignmentJustified;
            label.numberOfLines = 0;
            label.font = [UIFont boldSystemFontOfSize:14];
            label.textColor = [UIColor colorWithWhite:0.601 alpha:1.000];
            NSString *string = [self.object objectForKey:@"content"];
            label.text = string;
            float labelHeight = [self heightForString:string fontSize:14 andWidth:flexibleHeight(WIDTH - 20)];
            label.layer.masksToBounds = YES;
            label.layer.cornerRadius = 6.0f;
            //            label.backgroundColor = [UIColor redColor];
            label.backgroundColor = [UIColor colorWithWhite:1 alpha:1.000];
            label.frame = CGRectMake(0, _userHeaderImageView.frame.origin.y + _userHeaderImageView.SIZEHEIGHT, CGRectGetMaxX(self.view.frame) - flexibleHeight(10), labelHeight);
            label.center = CGPointMake(self.view.center.x, label.frame.origin.y + labelHeight / 2 + flexibleHeight(10));
            [label setInsets:UIEdgeInsetsMake(0, flexibleHeight(7), 0, flexibleHeight(7))];
            label;
        });
    }
    return _infoLabel;
}

- (UIImageView *)endorseImageView {
    if (!_endorseImageView) {
        _endorseImageView = ({
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 20, 20), NO)];
            imageView.center = CGPointMake(flexibleHeight(WIDTH - 100), self.contentImageView.frame.origin.y + self.contentImageView.SIZEHEIGHT + 20);
            imageView.layer.cornerRadius = imageView.frame.size.width / 2;
            imageView.layer.masksToBounds = YES;
            imageView;
        });
    }
    return _endorseImageView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = ({
            UITableView *tableView = [[UITableView alloc]init];
            
            tableView.rowHeight = flexibleHeight(80);
            tableView.frame = flexibleFrame(CGRectMake(0, self.contentImageView.frame.origin.y + self.contentImageView.bounds.size.height + 50, CGRectGetMaxX(self.view.frame),tableView.rowHeight * self.commentsArray.count), NO);
            tableView.dataSource = self;
            tableView.delegate = self;
            
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.scrollEnabled = NO;
            tableView.backgroundColor = [UIColor clearColor];
            tableView;
        });
    }
    return _tableView;
}

- (UILabel *)endorseLabel {
    if (!_endorseLabel) {
        _endorseLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 100, 30), NO)];
            label.textAlignment = NSTextAlignmentRight;
            label.center = flexibleCenter(CGPointMake(WIDTH / 7 * 6 - 10, self.contentImageView.frame.origin.y + self.contentImageView.SIZEHEIGHT + 20), NO);
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [UIColor colorWithWhite:0.490 alpha:1.000];
            label;
        });
    }
    return _endorseLabel;
}
- (UIImageView *)contentImageView {
    if (!_contentImageView) {
        _contentImageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:flexibleFrame(CGRectMake(10, self.infoLabel.frame.origin.y + self.infoLabel.SIZEHEIGHT, 355, 240), NO)];
            //            imageView.center = flexibleCenter(CGPointMake(WIDTH / 2, self.infoLabel.frame.origin.y + self.infoLabel.SIZEHEIGHT + 120));
            imageView.clipsToBounds = YES;
            imageView.layer.cornerRadius = 5;
            imageView.image = [UIImage imageNamed:@"个人中心背景1"];
            imageView;
        });
    }
    return _contentImageView;
}
- (TravelModel *)travelModel {
    if (!_travelModel) {
        _travelModel = [[TravelModel alloc] init];
    }
    return _travelModel;
}

-(NSArray *)commentsArray {
    if (!_commentsArray) {
        _commentsArray = [NSArray array];
    }
    return  _commentsArray;
}
- (NSMutableArray *)speakerArray {
    if (!_speakerArray) {
        _speakerArray = [NSMutableArray array];
    }
    return _speakerArray;
}
- (NSMutableArray *)recipientArray {
    if (!_recipientArray) {
        _recipientArray = [NSMutableArray array];
    }
    return _recipientArray;
}

- (TravelNotesTableViewCell *)travelCell{
    if (!_travelCell) {
        _travelCell = ({
            
            TravelNotesTableViewCell * cell = [[TravelNotesTableViewCell alloc]init];
            cell;
            
        });
    }
    return _travelCell;
}
- (SharedView *)sharedView{
    if (!_sharedView) {
        _sharedView = [[SharedView alloc]init];
        self.sharedView.inputText.delegate = self;
        [self.sharedView.conmmentButton addTarget:self action:@selector(handleSend) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sharedView;
}

@end

