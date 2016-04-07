//
//  TravelNotesTableViewCell.m
//  与你同游
//
//  Created by mac on 16/3/3.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import "TravelNotesTableViewCell.h"
#import "PhotoView.h"
#import "UIImageView+WebCache.h"

const CGFloat contentLabelFontSize = 15;
const CGFloat maxContentLabelHeight = 54;
@interface TravelNotesTableViewCell ()

@property (nonatomic, strong)   UIImageView * dianzanImg;
@property (nonatomic, strong)   UIImageView * commentImg;
@property (nonatomic, strong)   UIImageView * shareImg;
@property (nonatomic, strong)   UILabel     * dianzanLabel;
@property (nonatomic, strong)   UILabel     * commentLabel;
@property (nonatomic, strong)   UILabel     * shareLabel;
@property (nonatomic, strong)   UIView      * vline1;
@property (nonatomic, strong)   UIView      * vline2;

@property (nonatomic,strong) UIView * backView;

@property (nonatomic, assign)   int     thumbNumber;


@property (nonatomic,copy) thumbUp thumbUpblock;//为block声明属性（copy修饰）

@property (nonatomic,copy) share  sharedblock;

@property (nonatomic,copy) comment commentblock;
@property (nonatomic,copy)personalInfo personblock;

@end

@implementation TravelNotesTableViewCell

{
    UIImageView *_iconView;
    UIButton * _portraintbt;
    UILabel *_nameLable;
    UIImageView * _positionImg;
    UILabel * _position;
    UILabel *_timeLabel;
    UILabel *_contentLabel;
    PhotoView *_picContainerView;
    
    UIButton * _dianzanbt;
    UIButton * _commentbt;
    UIButton * _sharebt;
    
    UIView * _hline1;
    
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _iconView = [UIImageView new];
    _portraintbt = [UIButton new];
    [_portraintbt addTarget:self action:@selector(handlePortraint) forControlEvents:UIControlEventTouchUpInside];
    
    _nameLable = [UILabel new];
    _nameLable.font = [UIFont systemFontOfSize:16];
    _nameLable.textColor = [UIColor blackColor];
    
    _positionImg = [UIImageView new];
    
    _position = [UILabel new];
    _position.font = [UIFont systemFontOfSize:14];
    _position.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:contentLabelFontSize];
    _contentLabel.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
    
    _picContainerView = [PhotoView new];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:14];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    
    _dianzanbt = [UIButton new];
    _commentbt = [UIButton new];
    _sharebt = [UIButton new];
    
    [_dianzanbt addTarget:self action:@selector(handleThumbUp:) forControlEvents:UIControlEventTouchUpInside];
    [_commentbt addTarget:self action:@selector(handleComment) forControlEvents:UIControlEventTouchUpInside];
    [_sharebt addTarget:self action:@selector(handleShared) forControlEvents:UIControlEventTouchUpInside];
    
    _hline1 = [UIView new];
    _hline1.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    
    self.backView = [UIView new];
    self.backView.backgroundColor = [UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1.0];
    
    NSArray *views = @[_iconView, _portraintbt,_nameLable,_positionImg,_position, _timeLabel, _contentLabel, _picContainerView,_dianzanbt,_commentbt,_sharebt,_hline1,self.backView];
    
    [views enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.contentView addSubview:obj];
    }];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    
#pragma mark --自动布局
    _iconView.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin)
    .widthIs(flexibleWidth(80))
    .heightIs(flexibleWidth(80));
    _iconView.layer.cornerRadius = CGRectGetMidX(_iconView.bounds);
    _iconView.clipsToBounds = YES;
    
    _portraintbt.sd_layout.leftEqualToView(_iconView).topEqualToView(_iconView).widthIs(flexibleWidth(80)).heightIs(flexibleWidth(80));
    
    _nameLable.sd_layout
    .leftSpaceToView(_iconView, margin)
    .topSpaceToView(contentView,25)
    .heightIs(flexibleHeight(18));
    [_nameLable setSingleLineAutoResizeWithMaxWidth:flexibleWidth(200)];
    
    
    _timeLabel.sd_layout
    .topSpaceToView(contentView,35)
    .rightSpaceToView(contentView,10)
    .widthIs(flexibleWidth(60))
    .heightIs(flexibleHeight(15));

    
    _positionImg.sd_layout
    .leftSpaceToView(_iconView,margin)
    .topSpaceToView(contentView,55)
    .heightIs(flexibleHeight(20))
    .widthIs(flexibleWidth(20));
    
    _position.sd_layout
    .leftSpaceToView(_positionImg,5)
    .topEqualToView(_positionImg)
    .rightSpaceToView(contentView,10)
    .heightIs(flexibleHeight(18));
    
    _contentLabel.sd_layout
    .leftEqualToView(_iconView)
    .topSpaceToView(_iconView, 5)
    .rightSpaceToView(contentView, margin)
    .heightIs(flexibleHeight(60))
    .autoHeightRatio(0);
    
    _picContainerView.sd_layout
    .leftEqualToView(_contentLabel);
    
    _dianzanbt.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_picContainerView,margin)
    .heightIs(flexibleWidth(30))
    .widthIs(flexibleWidth((WIDTH - 20) / 3));
    
    _commentbt.sd_layout
    .leftSpaceToView(_dianzanbt,0)
    .topSpaceToView(_picContainerView,margin)
    .heightIs(flexibleWidth(30))
    .widthIs(flexibleWidth(_dianzanbt.bounds.size.width));
    
    _sharebt.sd_layout
    .leftSpaceToView(_commentbt,0)
    .topSpaceToView(_picContainerView,margin)
    .heightIs(flexibleWidth(30))
    .widthIs(flexibleWidth(_dianzanbt.bounds.size.width));
    
    _hline1.sd_layout
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .bottomSpaceToView(_dianzanbt,0)
    .heightIs(1);
    self.backView.sd_layout.leftEqualToView(contentView).rightEqualToView(contentView).topSpaceToView(_dianzanbt,0).heightIs(flexibleHeight(5));
    
    [self setupAutoHeightWithBottomView:self.backView bottomMargin:0];

}

#pragma mark --赋值
- (void)setObj:(BmobObject *)obj{
    _obj = obj;
    BmobObject * user =  [obj objectForKey:@"user"];

    [_iconView sd_setImageWithURL:[NSURL URLWithString:[user objectForKey:@"head_portraits"]] placeholderImage:IMAGE_PATH(@"无头像.png")];

    if (![[user objectForKey:@"username"] isEqualToString:@"还没取昵称哟！"]) {
        _nameLable.text = [user objectForKey:@"username"];
    }else {
         _nameLable.text = [user objectForKey:@"phoneNumber"];
    }

    // 防止单行文本label在重用时宽度计算不准的问题
        [_nameLable sizeToFit];
    _contentLabel.text = [obj objectForKey:@"content"];
    
    
        _position.text = [obj objectForKey:@"position"];
    
    if ([[obj objectForKey:@"position"] isEqualToString:@"未定位"]) {
         _positionImg.image = IMAGE_PATH(@"定位.png");
        _position.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
    }else{
        _positionImg.image = IMAGE_PATH(@"定位选中.png");
       
    }
    
    

    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * mydate = [formatter dateFromString:[obj objectForKey:@"createdAt"]];
    _timeLabel.text = [self compareCurrentTime:mydate];
    
    
    
     NSArray * pictureArray = (NSArray *)[obj objectForKey:@"urlArray"];
        _picContainerView.picPathStringsArray = pictureArray;
    
    
    self.dianzanImg.image = IMAGE_PATH(@"未点赞.png");
    NSArray * thumbArray = (NSArray *)[obj objectForKey:@"thumbArray"];
    for (NSString * userId in thumbArray) {
        if ([userId isEqualToString:OBJECTID]) {
           self.dianzanImg.image = IMAGE_PATH(@"点赞.png");
            self.dianzanLabel.textColor = [UIColor colorWithRed:0.2353 green:0.7569 blue:0.0275 alpha:1.0];
            _dianzanbt.selected = YES;
        }
        else{
            self.dianzanImg.image = IMAGE_PATH(@"未点赞.png");
            self.dianzanLabel.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
             _dianzanbt.selected = NO;
        }
    }
    
        self.commentImg.image = IMAGE_PATH(@"评论.png");
        self.shareImg.image = IMAGE_PATH(@"未分享.png");
    
    
        self.thumbNumber = [(NSNumber *)[obj objectForKey:@"number_of_thumb_up"] intValue];
        self.dianzanLabel.text = [NSString stringWithFormat:@"%d",self.thumbNumber];
        self.commentLabel.text = [NSString stringWithFormat:@"%@",[obj objectForKey:@"comments_number"]];
        self.shareLabel.text = @"分享";
    
        self.vline1.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
        self.vline2.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
        CGFloat picContainerTopMargin = 0;
        if (pictureArray.count) {
            picContainerTopMargin = 10;
        }
        _picContainerView.sd_layout.topSpaceToView(_contentLabel, picContainerTopMargin);
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

- (void)handleThumbUp:(UIButton *)sender{
    if (!OBJECTID) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还未登录喔！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    if (!sender.selected) {
        self.dianzanImg.image = IMAGE_PATH(@"点赞.png");
        self.dianzanLabel.textColor = [UIColor colorWithRed:0.2353 green:0.7569 blue:0.0275 alpha:1.0];
        self.dianzanLabel.text = [NSString stringWithFormat:@"%d",(++self.thumbNumber)];
        
        if (self.thumbUpblock) {
            self.thumbUpblock(1);
        }
    }
    else{
        self.dianzanImg.image = IMAGE_PATH(@"未点赞.png");
        self.dianzanLabel.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
        self.dianzanLabel.text = [NSString stringWithFormat:@"%d",(--self.thumbNumber)];
        if (self.thumbUpblock) {
            self.thumbUpblock(0);
        }
        
    }
    
    sender.selected = !sender.selected;
}

- (void)buttonthumbUp:(thumbUp)firstblock{
    self.thumbUpblock = firstblock;//对block进行持有
}

- (void)handleComment{
    if (!OBJECTID) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还未登录喔！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    if (self.commentblock) {
        self.commentblock();
    }
}

- (void)buttoncomment:(comment)secondblock{
    self.commentblock = secondblock;
}

- (void)handleShared{
    if (self.sharedblock) {
        self.sharedblock();
    }
}

- (void)buttonshared:(share)thirdblock{
    self.sharedblock = thirdblock;
}

- (void)handlePortraint{
    if (self.personblock) {
        self.personblock();
    }
}
- (void)tapPresent:(personalInfo)fourthblock{
    self.personblock = fourthblock;
}

#pragma mark --懒加载
- (UIImageView *)dianzanImg{
    if (!_dianzanImg) {
        _dianzanImg = ({
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:flexibleFrame(CGRectMake(20, 2.5, 25, 25), NO)];
            imageView.image = IMAGE_PATH(@"未点赞.png");
            [_dianzanbt addSubview:imageView];
            imageView;
            
        });
    }
    return _dianzanImg;
}

- (UIImageView *)commentImg{
    if (!_commentImg) {
        _commentImg = ({
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:flexibleFrame(CGRectMake(20, 2.5, 25, 25), NO)];
            [_commentbt addSubview:imageView];
            
            imageView;
        });
    }
    return _commentImg;
}

- (UIImageView *)shareImg{
    if (!_shareImg) {
        _shareImg = ({
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:flexibleFrame(CGRectMake(20, 2.5, 25, 25), NO)];
            [_sharebt addSubview:imageView];
            
            imageView;
            
        });
    }
    return _shareImg;
}

- (UILabel *)dianzanLabel{
    if (!_dianzanLabel) {
        _dianzanLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(50, 0,70, 30), NO)];
            label.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
            label.font = [UIFont systemFontOfSize:15];
            [_dianzanbt addSubview:label];
            label;
        });
    }
    return _dianzanLabel;
}
- (UILabel *)commentLabel{
    if (!_commentLabel) {
        _commentLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(50, 0,70, 30), NO)];
            label.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
            label.font = [UIFont systemFontOfSize:15];
            [_commentbt addSubview:label];
            label;
        });
    }
    return _commentLabel;
}
- (UILabel *)shareLabel{
    if (!_shareLabel) {
        _shareLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(50, 0,70, 30), NO)];
            label.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
            label.font = [UIFont systemFontOfSize:15];
            [_sharebt addSubview:label];
            label;
        });
    }
    return _shareLabel;
}

- (UIView *)vline1{
    if (!_vline1) {
        _vline1 = [[UIView alloc]initWithFrame:CGRectMake(120, 5, 1, 20)];
        [_dianzanbt addSubview:_vline1];
    }
    return _vline1;
}
- (UIView *)vline2{
    if (!_vline2) {
        _vline2 = [[UIView alloc]initWithFrame:CGRectMake(120, 5, 1, 20)];
        [_commentbt addSubview:_vline2];
    }
    return _vline2;
}

@end
