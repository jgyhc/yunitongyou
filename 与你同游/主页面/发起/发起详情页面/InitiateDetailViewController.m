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
#import "JoinInView.h"
#define SIZEHEIGHT frame.size.height

@interface InitiateDetailViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *userHeaderImageView;//头像
@property (nonatomic, strong) UILabel *userIDLabel;//用户名
@property (nonatomic, strong) UIImageView *sexImageView;//性别
@property (nonatomic, strong) UILabel *initiateTimeLabel;//发起时间
@property (nonatomic, strong) UILabel *departureLabel;//出发地
@property (nonatomic, strong) UILabel *destinationLabel;//目的地

@property (nonatomic, strong) UILabel *followerNumLabel;//跟团人数

@property (nonatomic, strong) UILabel *startingLabel;//开始时间按
@property (nonatomic, strong) UILabel *returnLabel;//返回时间
@property (nonatomic, strong) InsetsLabel *infoLabel;//简介

@property (nonatomic, strong)UIScrollView *scrollView;//

@property (nonatomic, strong)InitiateDetailFollowerView *followerView;
@property (nonatomic, strong)InitiateDetailCommentView *commentView;

@property (nonatomic, strong)UIView *separatationLineView;
@property (nonatomic, strong)UIButton *leftsideButton;
@property (nonatomic, strong)UIButton *rightsideButton;
@property (nonatomic, strong) JoinInView *joinInView;

@end

@implementation InitiateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUserInterface];
//    [self setInterfaceSetting];
    
    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)initUserInterface {
    [self initBackButton];
    [self initNavTitle:@"发起详情"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.scrollView];
    self.scrollView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view, flexibleHeight(64)).bottomEqualToView(self.view);
    
    [self.scrollView addSubview:self.userHeaderImageView];
    [self.scrollView addSubview:self.userIDLabel];
    self.userIDLabel.text = @"name";
    [self.scrollView addSubview:self.initiateTimeLabel];
    self.initiateTimeLabel.text = @"刚刚";
    [self.scrollView addSubview:self.sexImageView];
    
    [self.scrollView addSubview:self.followerNumLabel];
    self.followerNumLabel.text = @"12";
    [self.scrollView addSubview:self.departureLabel];
    self.departureLabel.text  = @"就这";
    [self.scrollView addSubview:self.destinationLabel];
    self.destinationLabel.text = @"到那";
    [self.scrollView addSubview:self.startingLabel];
    self.startingLabel.text = @"今天";
    [self.scrollView addSubview:self.returnLabel];
    self.returnLabel.text = @"明天";
    [self.scrollView addSubview:self.infoLabel];
    [self.scrollView addSubview:self.leftsideButton];
    [self.scrollView addSubview:self.rightsideButton];
    [self.scrollView addSubview:self.separatationLineView];
    

    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"箭头"]];
    imageView.frame = flexibleFrame(CGRectMake(0, 0, 50, 25), NO);
    imageView.center = CGPointMake(self.view.center.x, flexibleHeight(120));
    [self.scrollView addSubview:imageView];
    
    self.userHeaderImageView.sd_layout.leftSpaceToView(self.scrollView, flexibleWidth(15)).topSpaceToView(self.scrollView, flexibleHeight(10)).widthIs(flexibleHeight(50)).heightIs(flexibleHeight(50));
    self.userHeaderImageView.sd_cornerRadiusFromWidthRatio = @(0.5);
    
    self.userIDLabel.sd_layout.leftSpaceToView(self.userHeaderImageView, flexibleWidth(5)).topEqualToView(self.userHeaderImageView).heightIs(flexibleHeight(14));
    [self.userIDLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    self.initiateTimeLabel.sd_layout.leftSpaceToView(self.userHeaderImageView, flexibleWidth(5)).bottomEqualToView(self.userHeaderImageView).heightIs(13);
    [self.initiateTimeLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    self.sexImageView.sd_layout.leftSpaceToView(self.userIDLabel, flexibleWidth(2)).centerYEqualToView(self.userIDLabel).widthIs(flexibleHeight(16)).heightIs(flexibleHeight(16));
    
    self.followerNumLabel.sd_layout.rightSpaceToView(self.scrollView ,flexibleWidth(15)).topEqualToView(self.userHeaderImageView).widthIs(flexibleHeight(50)).heightIs(flexibleHeight(50));
    
    self.departureLabel.sd_layout.leftSpaceToView(self.scrollView, flexibleWidth(15)).topSpaceToView(self.userHeaderImageView, flexibleHeight(15)).heightIs(18);
    [self.departureLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    self.destinationLabel.sd_layout.rightSpaceToView(self.scrollView, flexibleWidth(15)).topEqualToView(self.departureLabel).heightIs(18);
    [self.destinationLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    self.startingLabel.sd_layout.leftSpaceToView(self.scrollView, flexibleWidth(15)).topSpaceToView(self.departureLabel, flexibleHeight(5)).heightIs(18);
    [self.startingLabel setSingleLineAutoResizeWithMaxWidth:200];

    self.returnLabel.sd_layout.rightSpaceToView(self.scrollView, flexibleWidth(15)).topEqualToView(self.startingLabel).heightIs(18);
    [self.returnLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    self.infoLabel.sd_layout.leftSpaceToView(self.scrollView, flexibleWidth(15)).rightSpaceToView(self.scrollView, flexibleWidth(15)).topSpaceToView(self.startingLabel, flexibleHeight(10)).autoHeightRatio(0);
    
    self.leftsideButton.sd_layout.leftEqualToView(self.scrollView).widthIs(flexibleWidth(375 / 2)).heightIs(flexibleHeight(40)).topSpaceToView(self.infoLabel, flexibleHeight(15));
    
    self.rightsideButton.sd_layout.rightEqualToView(self.scrollView).widthIs(flexibleWidth(375 / 2)).heightIs(flexibleHeight(40)).topEqualToView(self.leftsideButton);
    
    self.separatationLineView.sd_layout.centerXIs(flexibleWidth(WIDTH / 4)).heightIs(flexibleHeight(2)).widthIs(flexibleWidth(375 / 2)).topSpaceToView(self.leftsideButton, 0);
    [self.scrollView addSubview:self.joinInView];
    
    self.joinInView.sd_layout.leftEqualToView(self.scrollView).rightEqualToView(self.scrollView).topSpaceToView(self.separatationLineView, 0).heightIs(flexibleHeight(10 * flexibleHeight(50)));
    [self.joinInView updateLayout];
    
    [self.scrollView setupAutoContentSizeWithBottomView:self.joinInView bottomMargin:0];
}

- (void)setInterfaceSetting {
//    _userHeaderImageView.image = [self.userObject objectForKey:@"head_portraits1"];
//    if ([self.userObject objectForKey:@"sex"]) {
//        if ([[self.userObject objectForKey:@"sex"]  isEqualToString:@"男"]) {
//            self.sexImageView.image = IMAGE_PATH(@"男.png");
//        }else {
//            self.sexImageView.image = IMAGE_PATH(@"女.png");
//        }
//    }else {
//        self.sexImageView.image = IMAGE_PATH(@"男.png");
//    }
//    if ([self.userObject objectForKey:@"userName"]) {
//        _userIDLabel.text = [self.userObject objectForKey:@"userName"];
//    }else {
//        _userIDLabel.text = [self.userObject objectForKey:@"phone_number"];
//    }
//
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *date = [dateFormatter dateFromString:[self.calledObject objectForKey:@"called_date"]];
//
//    _initiateTimeLabel.text = [self compareCurrentTime:date];
//    _followerNumLabel.text = [NSString stringWithFormat:@"%@人\n跟团", [self.calledObject objectForKey:@"number_Of_people"]];
//    _departureLabel.text = [self.calledObject objectForKey:@"point_of_departure"];
//    _destinationLabel.text = [self.calledObject objectForKey:@"destination"];
//    _startingLabel.text = [self.calledObject objectForKey:@"departure_time"];
//    _returnLabel.text = [self.calledObject objectForKey:@"arrival_time"];
//    
//#pragma mark --infoLabel
//    NSString *string = [self.calledObject objectForKey:@"content"];
//    _infoLabel.text = string;
//    float labelHeight = [self heightForString:string fontSize:14 andWidth:flexibleHeight(WIDTH - 20)];
//    _infoLabel.frame = CGRectMake(0, _startingLabel.frame.origin.y + _startingLabel.SIZEHEIGHT, CGRectGetMaxX(self.view.frame) - flexibleHeight(10), labelHeight);
//    
//#pragma mark --infoImageView
//    
//    
//    [self.scrollView addSubview:self.leftsideButton];
//    [self.scrollView addSubview:self.rightsideButton];
//    [self.scrollView addSubview:self.separatationLineView];
//    [self.scrollView insertSubview:self.followerView atIndex:0];
//    
//    [self setObjectLocation];
}




- (void)buttonClickEvent:(UIButton *)sender {
    if (sender == self.leftsideButton) {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.separatationLineView.sd_layout.centerXIs(flexibleWidth(WIDTH / 4));
            [self.separatationLineView updateLayout];
            [self.scrollView updateLayout];
        }];

    }
    if (sender == self.rightsideButton) {
        [UIView animateWithDuration:0.3 animations:^{
            self.separatationLineView.sd_layout.centerXIs(flexibleWidth(WIDTH / 4 * 3));
            [self.scrollView updateLayout];
            [self.separatationLineView updateLayout];
        }];
    }
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
            UIImageView *imageView =  [[UIImageView alloc]init];
            imageView.backgroundColor = [UIColor redColor];
            imageView.layer.masksToBounds = YES;
            imageView;
        });
    }
    return _userHeaderImageView;
}

- (UIImageView *)sexImageView {
    if (!_sexImageView) {
        _sexImageView = ({
            UIImageView *imageView =  [[UIImageView alloc]init];
            imageView.backgroundColor = [UIColor redColor];
            imageView;
        });
    }
    return _sexImageView;
}



- (UILabel *)userIDLabel {
    if (!_userIDLabel) {
        _userIDLabel = ({
            UILabel *label = [[UILabel alloc]init];
            label.font = [UIFont boldSystemFontOfSize:14];
            label.textColor = [UIColor colorWithWhite:0.298 alpha:1.000];
            label;
        });
    }
    return _userIDLabel;
}




- (UILabel *)initiateTimeLabel {
    if (!_initiateTimeLabel) {
        _initiateTimeLabel = ({
            UILabel *label = [[UILabel alloc]init];
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
            UILabel *label = [[UILabel alloc]init];
            label.backgroundColor = [UIColor colorWithRed:0.374 green:0.820 blue:0.637 alpha:1.000];
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 2;
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
            UILabel *label = [[UILabel alloc]init];
            label.textAlignment = NSTextAlignmentCenter;
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
            UILabel *label = [[UILabel alloc]init];
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
            label.font = [UIFont boldSystemFontOfSize:14];
            label.textColor = [UIColor colorWithWhite:0.601 alpha:1.000];
            NSString *string = @"凌晨12点多，落地上海，在等行李的功夫看了第四凌晨12点多，落地上海，在等行李的功夫看了第四凌晨12点多，落地上海，在等行李的功夫看了第四凌晨12点多，落地上海，在等行李的功夫看了第四凌晨12点多，落地上海，在等行李的功夫看了第四凌晨12点多，落地上海，在等行李的功夫看了第四";
            label.text = string;
            label;
        });
    }
    return _infoLabel;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = ({
            UIScrollView *scrollView = [[UIScrollView alloc]init];
            scrollView.delegate = self;
            scrollView.backgroundColor = [UIColor colorWithRed:1.000 green:0.641 blue:0.793 alpha:1.000];
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
            UIView *view = [[UIView alloc]init];
            view.backgroundColor = THEMECOLOR;
            view;
        });
    }
    return _separatationLineView;
}

- (UIButton *)leftsideButton {
    if (!_leftsideButton) {
        _leftsideButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [button setTitle:@"加入的小伙伴" forState:UIControlStateNormal];
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
            button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [button setTitle:@"评论的小伙伴" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithWhite:0.298 alpha:1.000] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [button setBackgroundColor:[UIColor whiteColor]];
            [button addTarget:self action:@selector(buttonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _rightsideButton;
}
- (JoinInView *)joinInView {
	if(_joinInView == nil) {
		_joinInView = [[JoinInView alloc] init];
	}
	return _joinInView;
}

@end
