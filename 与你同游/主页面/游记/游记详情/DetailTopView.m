//
//  DetailTopView.m
//  与你同游
//
//  Created by mac on 16/3/24.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import "DetailTopView.h"
#import "UIImageView+WebCache.h"

@interface DetailTopView ()
@property (nonatomic, strong) UIImageView *iconView;//头像
@property (nonatomic, strong) UILabel     * nameLabel;//用户名
@property (nonatomic, strong) UILabel     * timeLabel;//时间
@property (nonatomic, strong) UIImageView * positionImg;
@property (nonatomic, strong) UILabel     * positionLabel;//地址
@property (nonatomic, strong) UILabel     * contentLabel;//内容


@end

@implementation DetailTopView

- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.iconView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.timeLabel];
        [self addSubview:self.positionImg];
        [self addSubview:self.positionLabel];
        [self addSubview:self.contentLabel];
        [self addSubview:self.picContainerView];
        
        self.iconView.sd_layout.leftSpaceToView(self, 10).topSpaceToView(self, 10).widthIs(flexibleWidth(80)).heightIs(flexibleWidth(80));
        self.iconView.layer.cornerRadius = CGRectGetMidX(_iconView.bounds);
        self.iconView.clipsToBounds = YES;
        
        self.nameLabel.sd_layout.leftSpaceToView(self.iconView, 10).topSpaceToView(self,25).heightIs(flexibleHeight(18));
        [self.nameLabel setSingleLineAutoResizeWithMaxWidth:flexibleWidth(200)];
        
        self.timeLabel.sd_layout.topSpaceToView(self,35).rightSpaceToView(self,10).widthIs(flexibleWidth(60)).heightIs(flexibleHeight(15));
        
        self.positionImg.sd_layout.leftSpaceToView(self.iconView,10).topSpaceToView(self,55).heightIs(flexibleHeight(20)).widthIs(flexibleWidth(20));
        
        self.positionLabel.sd_layout .leftSpaceToView(self.positionImg,5).topEqualToView(self.positionImg).rightSpaceToView(self,10).heightIs(flexibleHeight(18));
        
        self.contentLabel.sd_layout .leftEqualToView(self.iconView).topSpaceToView(self.iconView, 5).rightSpaceToView(self, 10).heightIs(flexibleHeight(60)).autoHeightRatio(0);
        
        self.picContainerView.sd_layout.leftEqualToView(self.contentLabel);
        
        [self setupAutoHeightWithBottomView:self.picContainerView bottomMargin:20];
    }
    return self;
}

- (void)setTravelObject:(BmobObject *)travelObject{
    _travelObject = travelObject;
    BmobObject * user =  [travelObject objectForKey:@"user"];
    
    
    NSString * imageString =[user objectForKey:@"head_portraits"];
    if (imageString.length > 0) {
        NSURL * imageUrl = [NSURL URLWithString:imageString];
        [self.iconView sd_setImageWithURL:imageUrl];
    }
    else{
        self.iconView.image = IMAGE_PATH(@"无头像.png");
    }
    
    if (![[user objectForKey:@"username"] isEqualToString:@"还没取昵称哟！"]) {
        self.nameLabel.text = [user objectForKey:@"username"];
    }else {
       self.nameLabel.text = [user objectForKey:@"phoneNumber"];
    }
    
    // 防止单行文本label在重用时宽度计算不准的问题
    [self.nameLabel sizeToFit];
    self.contentLabel.text = [travelObject objectForKey:@"content"];
    
 
    self.positionLabel.text = [travelObject objectForKey:@"position"];
    if ([[travelObject objectForKey:@"position"] isEqualToString:@"未定位"]) {
        self.positionImg.image = IMAGE_PATH(@"定位.png");
        self.positionLabel.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
    }else{
        self.positionImg.image = IMAGE_PATH(@"定位选中.png");
        
    }
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * mydate = [formatter dateFromString:[travelObject objectForKey:@"createdAt"]];
    self.timeLabel.text = [self compareCurrentTime:mydate];
    
    
    
    NSArray * pictureArray = (NSArray *)[travelObject objectForKey:@"urlArray"];
    self.picContainerView.picPathStringsArray = pictureArray;
    CGFloat picContainerTopMargin = 0;
    if (pictureArray.count) {
        picContainerTopMargin = 10;
    }
    self.picContainerView.sd_layout.topSpaceToView(self.contentLabel, picContainerTopMargin);
    [self.picContainerView updateLayout];
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

- (void)handlePresent{
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleInfo)]) {
        [self.delegate handleInfo];
    }
}

#pragma mark --lazy loading

- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [UIImageView new];
        _iconView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handlePresent)];
        [_iconView addGestureRecognizer:tap];
    }
    return _iconView;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
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
    if (!_positionLabel) {
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
    if (!_picContainerView) {
        _picContainerView = [PhotoView new];
    }
    return _picContainerView;
}
@end
