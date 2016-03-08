//
//  TravelNotesTableViewCell.m
//  与你同游
//
//  Created by mac on 16/3/3.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import "TravelNotesTableViewCell.h"
#import "TravelNotesModel.h"

#import "UIView+SDAutoLayout.h"

#import "PhotoView.h"

const CGFloat contentLabelFontSize = 15;
const CGFloat maxContentLabelHeight = 54;

@implementation TravelNotesTableViewCell

{
    UIImageView *_iconView;
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
    
    _nameLable = [UILabel new];
    _nameLable.font = [UIFont systemFontOfSize:15];
    _nameLable.textColor = [UIColor blackColor];
    
    _positionImg = [UIImageView new];
    
    _position = [UILabel new];
    _position.font = [UIFont systemFontOfSize:13];
    _position.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:contentLabelFontSize];
    _contentLabel.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
    
    _picContainerView = [PhotoView new];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    
    _dianzanbt = [UIButton new];
    _commentbt = [UIButton new];

    _sharebt = [UIButton new];
    
    _hline1 = [UIView new];
    _hline1.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    
    NSArray *views = @[_iconView, _nameLable,_positionImg,_position, _timeLabel, _contentLabel, _picContainerView,_dianzanbt,_commentbt,_sharebt,_hline1];
    
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
    
    _nameLable.sd_layout
    .leftSpaceToView(_iconView, margin)
    .topSpaceToView(contentView,25)
    .heightIs(flexibleHeight(18));
    [_nameLable setSingleLineAutoResizeWithMaxWidth:flexibleWidth(200)];

    
    _timeLabel.sd_layout
    .topSpaceToView(contentView,40)
    .rightSpaceToView(contentView,0)
    .widthIs(flexibleWidth(60))
    .heightIs(flexibleHeight(15));

    
    _positionImg.sd_layout
    .leftSpaceToView(_iconView,margin)
    .topSpaceToView(contentView,50)
    .heightIs(flexibleHeight(20))
    .widthIs(flexibleWidth(20));
    
    _position.sd_layout
    .leftSpaceToView(_positionImg,5)
    .topEqualToView(_positionImg)
    .rightSpaceToView(_timeLabel,5)
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
    
    [self setupAutoHeightWithBottomView:_dianzanbt bottomMargin:0];
}

#pragma mark --赋值
- (void)setModel:(TravelNotesModel *)model
{
    _model = model;
    
    _iconView.image = [UIImage imageNamed:model.iconName];
    _nameLable.text = model.name;
    // 防止单行文本label在重用时宽度计算不准的问题
    [_nameLable sizeToFit];
    _positionImg.image = IMAGE_PATH(@"定位选中.png");
    _position.text = @"长江师范学院";
    _contentLabel.text = model.content;
    _timeLabel.text = model.time;
    
    _picContainerView.picPathStringsArray = model.picArray;
    
    self.dianzanImg.image = IMAGE_PATH(@"未点赞.png");
    self.commentImg.image = IMAGE_PATH(@"评论.png");
    self.shareImg.image = IMAGE_PATH(@"未分享.png");
    self.dianzanLabel.text = @"10";
    self.commentLabel.text = @"34";
    self.shareLabel.text = @"分享";
    
       self.vline1.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
       self.vline2.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    
    CGFloat picContainerTopMargin = 0;
    if (model.picArray.count) {
        picContainerTopMargin = 10;
    }
    _picContainerView.sd_layout.topSpaceToView(_contentLabel, picContainerTopMargin);
    
}

#pragma mark --懒加载
- (UIImageView *)dianzanImg{
    if (!_dianzanImg) {
        _dianzanImg = ({
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:flexibleFrame(CGRectMake(20, 2.5, 25, 25), NO)];
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
