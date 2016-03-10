//
//  InitiateDetailViewController.m
//  与你同游
//
//  Created by rimi on 15/10/20.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "InitiateDetailViewController.h"
#import "InsetsLabel.h"
#import "InitiateDetailFollowerView.h"
#import "InitiateDetailCommentView.h"

#define SIZEHEIGHT frame.size.height

@interface InitiateDetailViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *userHeaderImageView;//头像
@property (nonatomic, strong) UILabel *userIDLabel;//用户名
@property (nonatomic, strong) UILabel *userLVLabel;//等级
@property (nonatomic, strong) UIImageView *sexImageView;//性别
@property (nonatomic, strong) UILabel *ageLabel;//年龄
@property (nonatomic, strong) UILabel *initiateTimeLabel;//发起时间
@property (nonatomic, strong) UILabel *departureLabel;//出发地
@property (nonatomic, strong) UILabel *destinationLabel;//目的地

@property (nonatomic, strong) UILabel *followerNumLabel;//跟团人数

@property (nonatomic, strong) UILabel *startingLabel;//开始时间按
@property (nonatomic, strong) UILabel *returnLabel;//返回时间
@property (nonatomic, strong) InsetsLabel *infoLabel;//简介
@property (nonatomic, strong) UIImageView *infoImageView;//图片内容

@property (nonatomic, strong)UIScrollView *scrollView;//

@property (nonatomic, strong)InitiateDetailFollowerView *followerView;
@property (nonatomic, strong)InitiateDetailCommentView *commentView;

@property (nonatomic, strong)UIView *separatationLineView;
@property (nonatomic, strong)UIButton *leftsideButton;
@property (nonatomic, strong)UIButton *rightsideButton;


@end

@implementation InitiateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUserInterface];
    [self setInterfaceSetting];
    
    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)initUserInterface {
    [self initBackButton];
    [self initNavTitle:@"发起详情"];
    
    [self.view insertSubview:self.scrollView atIndex:0];
    
    [self.scrollView addSubview:self.userHeaderImageView];
    [self.scrollView addSubview:self.userIDLabel];
    [self.scrollView addSubview:self.userLVLabel];
    [self.scrollView addSubview:self.ageLabel];
    [self.scrollView addSubview:self.initiateTimeLabel];
    [self.scrollView addSubview:self.sexImageView];
    [self.scrollView addSubview:self.followerNumLabel];
    [self.scrollView addSubview:self.departureLabel];
    [self.scrollView addSubview:self.destinationLabel];
    [self.scrollView addSubview:self.startingLabel];
    [self.scrollView addSubview:self.returnLabel];
    
    [self.scrollView addSubview:self.infoLabel];
    [self.scrollView addSubview:self.infoImageView];
    

    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"箭头"]];
    imageView.frame = flexibleFrame(CGRectMake(0, 0, 50, 25), NO);
    imageView.center = CGPointMake(self.view.center.x, flexibleHeight(120));
    [self.scrollView addSubview:imageView];
    
}

- (void)setInterfaceSetting {
    _userHeaderImageView.image = [self.userObject objectForKey:@"head_portraits1"];
    if ([self.userObject objectForKey:@"sex"]) {
        if ([[self.userObject objectForKey:@"sex"]  isEqualToString:@"男"]) {
            self.sexImageView.image = IMAGE_PATH(@"男.png");
        }else {
            self.sexImageView.image = IMAGE_PATH(@"女.png");
        }
    }else {
        self.sexImageView.image = IMAGE_PATH(@"男.png");
    }
    if ([self.userObject objectForKey:@"userName"]) {
        _userIDLabel.text = [self.userObject objectForKey:@"userName"];
    }else {
        _userIDLabel.text = [self.userObject objectForKey:@"phone_number"];
    }
    _userLVLabel.text = @"3";
    _ageLabel.text = [NSString stringWithFormat:@"%@岁", (NSString *)[self.userObject objectForKey:@"age"]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:[self.calledObject objectForKey:@"called_date"]];

    _initiateTimeLabel.text = [self compareCurrentTime:date];
    _followerNumLabel.text = [NSString stringWithFormat:@"%@人\n跟团", [self.calledObject objectForKey:@"number_Of_people"]];
    _departureLabel.text = [self.calledObject objectForKey:@"point_of_departure"];
    _destinationLabel.text = [self.calledObject objectForKey:@"destination"];
    _startingLabel.text = [self.calledObject objectForKey:@"departure_time"];
    _returnLabel.text = [self.calledObject objectForKey:@"arrival_time"];
    
#pragma mark --infoLabel
    NSString *string = [self.calledObject objectForKey:@"content"];
    _infoLabel.text = string;
    float labelHeight = [self heightForString:string fontSize:14 andWidth:flexibleHeight(WIDTH - 20)];
    _infoLabel.frame = CGRectMake(0, _startingLabel.frame.origin.y + _startingLabel.SIZEHEIGHT, CGRectGetMaxX(self.view.frame) - flexibleHeight(10), labelHeight);
    
#pragma mark --infoImageView
    _infoImageView.image = [self.calledObject objectForKey:@"image"];
    _infoImageView.frame = flexibleFrame(CGRectMake(flexibleHeight(10), _infoLabel.frame.origin.y + _infoLabel.SIZEHEIGHT, 355, 240), NO);
    
    [self.scrollView addSubview:self.leftsideButton];
    [self.scrollView addSubview:self.rightsideButton];
    [self.scrollView addSubview:self.separatationLineView];
    [self.scrollView insertSubview:self.followerView atIndex:0];
    
    _scrollView.contentSize = CGSizeMake(0, _userHeaderImageView.SIZEHEIGHT + _departureLabel.SIZEHEIGHT + _startingLabel.SIZEHEIGHT + _infoLabel.SIZEHEIGHT + _infoImageView.SIZEHEIGHT + _commentView.SIZEHEIGHT + _followerView.SIZEHEIGHT + _leftsideButton.SIZEHEIGHT + flexibleHeight(100));
    
    [self setObjectLocation];
}

- (void)setObjectLocation {
    CGSize size = [self.userIDLabel.text boundingRectWithSize:CGSizeMake(80, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}context:nil].size;
    _sexImageView.center =  (CGPointMake(50 + _userLVLabel.frame.origin.x + size.width, _userIDLabel.center.y));
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat alpha = 1 - scrollView.contentOffset.y / 250;
    self.navView.alpha = alpha;
    self.leftButton.alpha = alpha;
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

#pragma mark --文本自适应
- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont boldSystemFontOfSize:fontSize];
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonClickEvent:(UIButton *)sender {
    if (sender == _leftsideButton) {
        if (self.commentView) {
            [self.commentView removeFromSuperview];
        }
        [UIView animateWithDuration:0.5 animations:^{
            _separatationLineView.center = CGPointMake(CGRectGetMaxX(self.view.frame) / 4 , _leftsideButton.frame.origin.y + _leftsideButton.SIZEHEIGHT);
        }];
        [self.scrollView insertSubview:self.followerView atIndex:0];
        _scrollView.contentSize = CGSizeMake(0, _userHeaderImageView.SIZEHEIGHT + _departureLabel.SIZEHEIGHT + _startingLabel.SIZEHEIGHT + _infoLabel.SIZEHEIGHT + _infoImageView.SIZEHEIGHT + _followerView.SIZEHEIGHT + _leftsideButton.SIZEHEIGHT + flexibleHeight(100));
    }else if (sender == _rightsideButton) {
        [self.followerView removeFromSuperview];
        [UIView animateWithDuration:0.5 animations:^{
            _separatationLineView.center = CGPointMake(CGRectGetMaxX(self.view.frame) / 4  * 3, _leftsideButton.frame.origin.y + _leftsideButton.SIZEHEIGHT);
        }];
        [self.scrollView insertSubview:self.commentView atIndex:0];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollViewContentSizeSetting) name:@"content"object:nil];
    }
}

- (void)scrollViewContentSizeSetting {
    _scrollView.contentSize = CGSizeMake(0, _userHeaderImageView.SIZEHEIGHT + _departureLabel.SIZEHEIGHT + _startingLabel.SIZEHEIGHT + _infoLabel.SIZEHEIGHT + _infoImageView.SIZEHEIGHT + _commentView.SIZEHEIGHT + _leftsideButton.SIZEHEIGHT + flexibleHeight(100));
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIImageView *)userHeaderImageView {
    if (!_userHeaderImageView) {
        _userHeaderImageView = ({
            UIImageView *imageView =  [[UIImageView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 50, 50), NO)];
            imageView.center =  flexibleCenter(CGPointMake(WIDTH / 7 - 10, 44), NO);
            imageView.layer.cornerRadius = imageView.SIZEHEIGHT / 2;
            imageView.layer.masksToBounds = YES;
            imageView;
        });
    }
    return _userHeaderImageView;
}

- (UIImageView *)sexImageView {
    if (!_sexImageView) {
        _sexImageView = ({
            UIImageView *imageView =  [[UIImageView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 16, 16), NO)];
//            imageView.center = flexibleCenter(CGPointMake(<#CGFloat x#>, <#CGFloat y#>))
            imageView.layer.cornerRadius = imageView.SIZEHEIGHT / 2;
            imageView.layer.masksToBounds = YES;
            imageView;
        });
    }
    return _sexImageView;
}

- (UIImageView *)infoImageView {
    if (!_infoImageView) {
        _infoImageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:flexibleFrame(CGRectMake(flexibleHeight(10), _infoLabel.frame.origin.y + _infoLabel.SIZEHEIGHT + 20, 355, 240), NO)];
//            CGRect frame = _followerView.frame;
//            frame.origin.y = ;
//            NSLog(@"%f", frame.origin.y);
//            imageView.frame = frame;
            imageView.clipsToBounds = YES;
            imageView.layer.cornerRadius = 5;
            imageView.image = [UIImage imageNamed:@"个人中心背景1"];
            imageView;
        });
    }
    return _infoImageView;
}

- (UILabel *)userIDLabel {
    if (!_userIDLabel) {
        _userIDLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 80, 30), NO)];
            label.textAlignment = NSTextAlignmentLeft;
            label.center = flexibleCenter(CGPointMake(WIDTH / 7 + 70, 32), NO);
            label.font = [UIFont boldSystemFontOfSize:16];
            label.textColor = [UIColor colorWithWhite:0.298 alpha:1.000];
            label;
        });
    }
    return _userIDLabel;
}

- (UILabel *)userLVLabel {
    if (!_userLVLabel) {
        _userLVLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 20, 20), NO)];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor whiteColor];
            label.layer.borderWidth = 1.0f;
            label.layer.borderColor = [UIColor colorWithRed:1.000 green:0.800 blue:0.400 alpha:1.000].CGColor;
            label.layer.cornerRadius = flexibleHeight(10);
            label.layer.masksToBounds = YES;
            label.center = flexibleCenter(CGPointMake(WIDTH / 7 + 13, 53), NO);
            label.font = [UIFont boldSystemFontOfSize:15];
            label.textColor = [UIColor colorWithRed:1.000 green:0.502 blue:0.000 alpha:1.000];
            label;
        });
    }
    return _userLVLabel;
}

- (UILabel *)ageLabel {
    if (!_ageLabel) {
        _ageLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 35, 30), NO)];
            label.textAlignment = NSTextAlignmentLeft;
            CGRect frame = label.frame;
            frame.origin.x = _userIDLabel.frame.origin.x;
            frame.origin.y = _userLVLabel.frame.origin.y;
            label.frame = frame;
            label.font = [UIFont boldSystemFontOfSize:13];
            label.textColor = [UIColor colorWithWhite:0.702 alpha:1.000];
            label;
        });
    }
    return _ageLabel;
}

- (UILabel *)initiateTimeLabel {
    if (!_initiateTimeLabel) {
        _initiateTimeLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 85, 30), NO)];
            label.textAlignment = NSTextAlignmentLeft;
            CGRect frame = label.frame;
            frame.origin.x = _userIDLabel.frame.origin.x + flexibleHeight(50);
            frame.origin.y = _userLVLabel.frame.origin.y;
            label.frame = frame;
            label.font = [UIFont boldSystemFontOfSize:13];
            label.textColor = [UIColor colorWithWhite:0.702 alpha:1.000];
            label;
        });
    }
    return _initiateTimeLabel;
}

- (UILabel *)followerNumLabel {
    if (!_followerNumLabel) {
        _followerNumLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 50, 50), NO)];
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 2;
            label.center = flexibleCenter(CGPointMake(WIDTH / 7 * 6 + 10, 44), NO);
            label.backgroundColor = THEMECOLOR;
            label.font = [UIFont boldSystemFontOfSize:15];
            label.textColor = [UIColor whiteColor];
            label;
        });
    }
    return _followerNumLabel;
}

- (UILabel *)departureLabel {
    if (!_departureLabel) {
        _departureLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 85, 25), NO)];
            label.textAlignment = NSTextAlignmentCenter;
            label.center = flexibleCenter(CGPointMake(WIDTH / 3 - 20, 110), NO);
            label.font = [UIFont boldSystemFontOfSize:18];
            label.textColor = [UIColor colorWithWhite:0.298 alpha:1.000];
            label;
        });
    }
    return _departureLabel;
}

- (UILabel *)destinationLabel {
    if (!_destinationLabel) {
        _destinationLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 85, 25), NO)];
            label.textAlignment = NSTextAlignmentCenter;
            label.center = flexibleCenter(CGPointMake(WIDTH / 3 * 2 + 20, 110), NO);
            label.font = [UIFont boldSystemFontOfSize:18];
            label.textColor = [UIColor colorWithWhite:0.298 alpha:1.000];
            label;
        });
    }
    return _destinationLabel;
}

- (UILabel *)startingLabel {
    if (!_startingLabel) {
        _startingLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 85, 25), NO)];
            label.textAlignment = NSTextAlignmentCenter;
            label.center = flexibleCenter(CGPointMake(WIDTH / 3 - 20, 140), NO);
            label.font = [UIFont boldSystemFontOfSize:15];
            label.textColor = [UIColor colorWithWhite:0.298 alpha:1.000];
            label;
        });
    }
    return _startingLabel;
}

- (UILabel *)returnLabel {
    if (!_returnLabel) {
        _returnLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 85, 25), NO)];
            label.textAlignment = NSTextAlignmentCenter;
            label.center = flexibleCenter(CGPointMake(WIDTH / 3 * 2 + 20, 140), NO);
            label.font = [UIFont boldSystemFontOfSize:15];
            label.textColor = [UIColor colorWithWhite:0.298 alpha:1.000];
            label;
        });
    }
    return _returnLabel;
}

- (InsetsLabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = ({
            InsetsLabel *label = [[InsetsLabel alloc]init];
            label.textAlignment = NSTextAlignmentJustified;
            label.numberOfLines = 0;
            label.font = [UIFont boldSystemFontOfSize:14];
            label.textColor = [UIColor colorWithWhite:0.601 alpha:1.000];
            NSString *string = @"凌晨12点多，落地上海，在等行李的功夫看了第四";
            label.text = string;
            float labelHeight = [self heightForString:string fontSize:14 andWidth:flexibleHeight(WIDTH - 20)];
            label.layer.masksToBounds = YES;
            label.layer.cornerRadius = 6.0f;
            //            label.backgroundColor = [UIColor redColor];
            label.backgroundColor = [UIColor colorWithWhite:1 alpha:1.000];
            label.frame = CGRectMake(0, _startingLabel.frame.origin.y + _startingLabel.SIZEHEIGHT, CGRectGetMaxX(self.view.frame) - flexibleHeight(10), labelHeight);
            [label setInsets:UIEdgeInsetsMake(0, flexibleHeight(7), 0, flexibleHeight(7))];
            label;
        });
    }
    return _infoLabel;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = ({
            UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 22, WIDTH, HEIGHT - 22 ), NO)];
            scrollView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
            scrollView.delegate = self;
            scrollView.showsVerticalScrollIndicator = NO;
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView;
        });
    }
    return _scrollView;
}

- (InitiateDetailFollowerView *)followerView {
    if (!_followerView) {
        _followerView = [[InitiateDetailFollowerView alloc]init];
        CGRect frame = _followerView.frame;
        frame.origin.y = self.leftsideButton.frame.origin.y + self.leftsideButton.SIZEHEIGHT;
        _followerView.frame = frame;
    }
    return _followerView;
}

- (InitiateDetailCommentView *)commentView {
    if (!_commentView) {
        _commentView = [[InitiateDetailCommentView alloc] init];
        CGRect frame = _commentView.frame;
        frame.origin.y = self.leftsideButton.frame.origin.y + self.leftsideButton.SIZEHEIGHT;
        _commentView.frame = frame;
    }
    return _commentView;
}

- (UIView *)separatationLineView {
    if (!_separatationLineView) {
        _separatationLineView = ({
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(self.view.frame) / 2, 1)];
            view.backgroundColor = THEMECOLOR;
            view.center = CGPointMake(CGRectGetMaxX(self.view.frame) / 4 , _leftsideButton.frame.origin.y + _leftsideButton.SIZEHEIGHT);
            view;
        });
    }
    return _separatationLineView;
}

- (UIButton *)leftsideButton {
    if (!_leftsideButton) {
        _leftsideButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = flexibleFrame(CGRectMake(0, _infoImageView.frame.origin.y + flexibleHeight(260), WIDTH / 2, 50), NO);
            CGRect frame = button.frame;
            frame.origin.y = _infoImageView.frame.origin.y + _infoImageView.SIZEHEIGHT + flexibleHeight(20);
            button.frame = frame;
            button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            [button setTitle:@"加入" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithWhite:0.298 alpha:1.000] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(buttonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
            
            button;
        });
    }
    return _leftsideButton;
}

- (UIButton *)rightsideButton {
    if (!_rightsideButton) {
        _rightsideButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = flexibleFrame(CGRectMake(WIDTH / 2, _infoImageView.frame.origin.y + flexibleHeight(260), WIDTH / 2, 50), NO);
            CGRect frame = button.frame;
            frame.origin.y = _infoImageView.frame.origin.y + _infoImageView.SIZEHEIGHT + flexibleHeight(20);
            button.frame = frame;
            button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            [button setTitle:@"评论" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithWhite:0.298 alpha:1.000] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [button setBackgroundColor:[UIColor whiteColor]];
            [button addTarget:self action:@selector(buttonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _rightsideButton;
}
@end
