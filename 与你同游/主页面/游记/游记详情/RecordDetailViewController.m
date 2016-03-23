//
//  RecordDetailViewController.m
//  viewController
//
//  Created by rimi on 15/10/16.
//  Copyright (c) 2015年 ouyang. All rights reserved.
//

#import "RecordDetailViewController.h"
#import "MJRefresh.h"
#import "SharedView.h"
#import "PhotoView.h"
#import "UIImageView+WebCache.h"
#import "ICommentsView.h"
#import <BmobSDK/Bmob.h>
#define SIZEHEIGHT frame.size.height
#define SIZEHEIGHT frame.size.height

@interface RecordDetailViewController ()<UIScrollViewDelegate,UITextViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

#pragma mark --上
@property (nonatomic, strong) UIImageView *iconView;//头像
@property (nonatomic, strong) UILabel     * nameLabel;//用户名
@property (nonatomic, strong) UILabel     * timeLabel;//时间
@property (nonatomic, strong) UIImageView * positionImg;
@property (nonatomic, strong) UILabel     * positionLabel;//地址
@property (nonatomic, strong) UILabel     * contentLabel;//内容
@property (nonatomic, strong) PhotoView   * picContainerView;//图片

#pragma mark --中
@property (nonatomic, strong) UIView      * seperateView;
@property (nonatomic, strong) UIView      * bottomLine;
@property (nonatomic, strong) UIButton    * rightsideButton;
@property (nonatomic, strong) UIButton    * leftsideButton;
@property (nonatomic, strong) ICommentsView * commentView;

#pragma mark --下
@property (nonatomic, strong) UIView      * bottomView;
@property (nonatomic, strong) UIButton    * dianzanbt;
@property (nonatomic, strong) UIButton    * commentbt;
@property (nonatomic, strong) UIButton    * sharebt;
@property (nonatomic, strong)   UIView      * vline1;
@property (nonatomic, strong)   UIView      * vline2;

@property (nonatomic, strong) SharedView *sharedView;
@property (nonatomic,assign) CGFloat keyboardHeight;
@property (nonatomic,assign) NSTimeInterval duration;



@end

@implementation RecordDetailViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBackButton];
    [self initNavTitle:@"游记详情"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUserInterface];
    
    
}

- (void)initUserInterface {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.scrollView];
    self.scrollView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view, flexibleHeight(64)).bottomEqualToView(self.view);

    [self.scrollView addSubview:self.iconView];
    [self.scrollView addSubview:self.nameLabel];
    [self.scrollView addSubview:self.timeLabel];
    [self.scrollView addSubview:self.positionImg];
    [self.scrollView addSubview:self.positionLabel];
    [self.scrollView addSubview:self.contentLabel];
    [self.scrollView addSubview:self.picContainerView];
    [self.scrollView addSubview:self.seperateView];
    [self.scrollView addSubview:self.bottomLine];
    [self.scrollView addSubview:self.leftsideButton];
    [self.scrollView addSubview:self.rightsideButton];
    [self.scrollView addSubview:self.commentbt];
    
    [self.view addSubview:self.bottomView];
//    [self.view addSubview:self.sharedView.inputView];
    
    self.iconView.sd_layout.leftSpaceToView(self.scrollView, 10).topSpaceToView(self.scrollView, 10).widthIs(flexibleWidth(80)).heightIs(flexibleWidth(80));
    self.iconView.layer.cornerRadius = CGRectGetMidX(_iconView.bounds);
    self.iconView.clipsToBounds = YES;
    
    self.nameLabel.sd_layout.leftSpaceToView(self.iconView, 10).topSpaceToView(self.scrollView,25).heightIs(flexibleHeight(18));
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:flexibleWidth(200)];
    
    self.timeLabel.sd_layout.topSpaceToView(self.scrollView,35).rightSpaceToView(self.scrollView,10).widthIs(flexibleWidth(60)).heightIs(flexibleHeight(15));
    
    self.positionImg.sd_layout.leftSpaceToView(self.iconView,10).topSpaceToView(self.scrollView,55).heightIs(flexibleHeight(20)).widthIs(flexibleWidth(20));
    
    self.positionLabel.sd_layout .leftSpaceToView(self.positionImg,5).topEqualToView(self.positionImg).rightSpaceToView(self.scrollView,10).heightIs(flexibleHeight(18));
    
    self.contentLabel.sd_layout .leftEqualToView(self.iconView).topSpaceToView(self.iconView, 5).rightSpaceToView(self.scrollView, 10).heightIs(flexibleHeight(60)).autoHeightRatio(0);
    
    self.picContainerView.sd_layout.leftEqualToView(self.contentLabel);
    
    self.seperateView.sd_layout.leftSpaceToView(self.scrollView,0).topSpaceToView(self.picContainerView,20).rightSpaceToView(self.scrollView,0);
    
    self.leftsideButton.sd_layout.leftEqualToView(self.scrollView).widthIs(flexibleWidth(WIDTH / 2)).heightIs(flexibleHeight(40)).topSpaceToView(self.seperateView, 0);
    
    self.rightsideButton.sd_layout.rightEqualToView(self.scrollView).widthIs(flexibleWidth(WIDTH / 2)).heightIs(flexibleHeight(40)).topEqualToView(self.leftsideButton);
    
    self.bottomLine.sd_layout.centerXIs(flexibleWidth(WIDTH / 4)).heightIs(flexibleHeight(2)).widthIs(flexibleWidth(WIDTH / 2)).topSpaceToView(self.leftsideButton, 0);
    
    
    

}

- (void)setTravelObject:(BmobObject *)travelObject{
    _travelObject = travelObject;
    BmobObject * user =  [travelObject objectForKey:@"userId"];
    
    
    NSString * imageString =[user objectForKey:@"head_portraits"];
    if (imageString.length > 0) {
        NSURL * imageUrl = [NSURL URLWithString:imageString];
        [self.iconView sd_setImageWithURL:imageUrl];
    }
    else{
        self.iconView.image = IMAGE_PATH(@"无头像.png");
    }
    self.nameLabel.text = [user objectForKey:@"username"];
    //    // 防止单行文本label在重用时宽度计算不准的问题
    [self.nameLabel sizeToFit];
    self.contentLabel.text = [travelObject objectForKey:@"content"];
    self.positionImg.image = IMAGE_PATH(@"定位选中.png");
    self.positionLabel.text = [travelObject objectForKey:@"position"];
    
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * mydate = [formatter dateFromString:[travelObject objectForKey:@"createdAt"]];
    self.timeLabel.text = [self compareCurrentTime:mydate];
    
    
    
    NSArray * pictureArray = (NSArray *)[travelObject objectForKey:@"urlArray"];
    self.picContainerView.picPathStringsArray = pictureArray;
    
    
    
    NSArray * thumbArray = (NSArray *)[travelObject objectForKey:@"thumbArray"];
    for (NSString * userId in thumbArray) {
        if ([userId isEqualToString:OBJECTID]) {
            self.dianzanbt.selected = YES;
        }
        else{
            self.dianzanbt.selected = NO;
        }
    }

    CGFloat picContainerTopMargin = 0;
    if (pictureArray.count) {
        picContainerTopMargin = 10;
    }
    self.picContainerView.sd_layout.topSpaceToView(self.contentLabel, picContainerTopMargin);
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


- (void)buttonClickEvent:(UIButton *)sender {
    if (sender == self.leftsideButton) {
//        [self.commentsView removeFromSuperview];
//        [self.scrollView addSubview:self.joinInView];
//        [UIView animateWithDuration:0.3 animations:^{
//            self.separatationLineView.sd_layout.centerXIs(flexibleWidth(WIDTH / 4));
//            [self.separatationLineView updateLayout];
//            [self.scrollView updateLayout];
//        }];
    }
    
    if (sender == self.rightsideButton) {
//        [self.scrollView addSubview:self.commentsView];
//        self.commentsView.sd_layout.leftEqualToView(self.scrollView).rightEqualToView(self.scrollView).topSpaceToView(self.separatationLineView, 0).heightIs(flexibleHeight(10 * flexibleHeight(50)));
//        [self.joinInView removeFromSuperview];
//        [UIView animateWithDuration:0.3 animations:^{
//            self.separatationLineView.sd_layout.centerXIs(flexibleWidth(WIDTH / 4 * 3));
//            [self.scrollView updateLayout];
//            [self.separatationLineView updateLayout];
//        }];
    }
}

- (void)handlePress:(UIButton *)sender{
    
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

#pragma mark --uiScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat alpha = 1 - scrollView.contentOffset.y / 250;
    self.navView.alpha = alpha;
    self.leftButton.alpha = alpha;
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


#pragma mark -- getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = ({
            UIScrollView *scrollView = [[UIScrollView alloc]init];
            scrollView.delegate = self;
            scrollView.backgroundColor = [UIColor clearColor];
            scrollView;
        });
    }
    return _scrollView;
}

- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [UIImageView new];
    }
    return _iconView;
}
- (UILabel *)nameLabel{
    if (_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = [UIColor blackColor];
    }
    return _nameLabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    }
    return _timeLabel;
}
- (UIImageView *)positionImg{
    if (!_positionImg) {
        _positionImg = [UIImageView new];
    }
    return _positionImg;
}
- (UILabel *)positionLabel{
    if (_positionLabel) {
        _positionLabel = [UILabel new];
        _positionLabel.font = [UIFont systemFontOfSize:14];
        _positionLabel.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
    }
    return _positionLabel;
}
- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
    }
    return _contentLabel;
}
- (PhotoView *)picContainerView{
    if (_picContainerView) {
         _picContainerView = [PhotoView new];
    }
    return _picContainerView;
}
- (UIView *)seperateView{
    if (!_seperateView) {
        _seperateView = [UIView new];
        _seperateView.backgroundColor = [UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1.0];
    }
    return _seperateView;
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
            [button setTitle:@"点赞" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithWhite:0.298 alpha:1.000] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [button setBackgroundColor:[UIColor whiteColor]];
            [button addTarget:self action:@selector(buttonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _rightsideButton;
}

- (UIView *)bottomView{
    if (_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor clearColor];
    }
    return _bottomView;
}
- (UIButton *)dianzanbt{
    if (!_dianzanbt) {
        _dianzanbt = [[UIButton alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0,WIDTH / 3, 40), NO)];
        [_dianzanbt addTarget:self action:@selector(handlePress:) forControlEvents:UIControlEventTouchUpInside];
        [_dianzanbt setBackgroundImage:IMAGE_PATH(@"未点赞.png") forState:UIControlStateNormal];
        [_dianzanbt setBackgroundImage:IMAGE_PATH(@"点赞.png") forState:UIControlStateSelected];
        [self.bottomView addSubview:_dianzanbt];
    }
    return _dianzanbt;
}
- (UIButton *)commentbt{
    if (!_commentbt) {
        _commentbt = [[UIButton alloc]initWithFrame:flexibleFrame(CGRectMake(WIDTH / 3, 0, WIDTH / 3, 40), NO)];
        [_commentbt addTarget:self action:@selector(handlePress:) forControlEvents:UIControlEventTouchUpInside];
        [_commentbt setBackgroundImage:IMAGE_PATH(@"评论.png") forState:UIControlStateNormal];
        [self.bottomView addSubview:_commentbt];
    }
    return _commentbt;
}

- (UIButton *)sharebt{
    if (!_sharebt) {
        _sharebt = [[UIButton alloc]initWithFrame:flexibleFrame(CGRectMake(WIDTH - WIDTH / 3, 0, WIDTH / 3, 40), NO)];
        [_sharebt addTarget:self action:@selector(handlePress:) forControlEvents:UIControlEventTouchUpInside];
        [_sharebt setBackgroundImage:IMAGE_PATH(@"未评论.png") forState:UIControlStateNormal];
        [self.bottomView addSubview:_sharebt];
    }
    return _sharebt;
}

- (SharedView *)sharedView{
    if (!_sharedView) {
        _sharedView = [[SharedView alloc]init];
        self.sharedView.inputText.delegate = self;
           }
    return _sharedView;
}

@end

