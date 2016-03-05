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
    UIButton *_moreButton;
    BOOL _shouldOpenContentLabel;
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
    
    _shouldOpenContentLabel = NO;
    
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
    
    _moreButton = [UIButton new];
    [_moreButton setTitle:@"显示全部" forState:UIControlStateNormal];
    [_moreButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    _picContainerView = [PhotoView new];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    
    NSArray *views = @[_iconView, _nameLable,_positionImg,_position, _timeLabel, _contentLabel, _moreButton, _picContainerView];
    
    [views enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.contentView addSubview:obj];
    }];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    
    _iconView.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin)
    .widthIs(flexibleWidth(80))
    .heightIs(flexibleWidth(80));
    _iconView.layer.cornerRadius = CGRectGetMidX(_iconView.bounds);
    _iconView.clipsToBounds = YES;
    
    _nameLable.sd_layout
    .leftSpaceToView(_iconView, margin)
    .topSpaceToView(contentView,40)
    .heightIs(flexibleHeight(18));
    [_nameLable setSingleLineAutoResizeWithMaxWidth:flexibleWidth(120)];
//    _nameLable.backgroundColor = [UIColor redColor];
    
    _timeLabel.sd_layout
    .topSpaceToView(contentView,40)
    .rightSpaceToView(contentView,0)
    .widthIs(flexibleWidth(60))
    .heightIs(flexibleHeight(15));
//    _timeLabel.backgroundColor = [UIColor purpleColor];
    
    _positionImg.sd_layout
    .leftSpaceToView(_nameLable,margin)
    .topEqualToView(_nameLable)
    .heightIs(flexibleHeight(20))
    .widthIs(flexibleWidth(20));
    
    _position.sd_layout
    .leftSpaceToView(_positionImg,5)
    .topEqualToView(_nameLable)
    .rightSpaceToView(_timeLabel,5)
    .heightIs(flexibleHeight(18));
//    _position.backgroundColor = [UIColor orangeColor];
    

    
    
    _contentLabel.sd_layout
    .leftEqualToView(_iconView)
    .topSpaceToView(_iconView, 5)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    // morebutton的高度在setmodel里面设置
    _moreButton.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_contentLabel, 0)
    .widthIs(60);
    
    
    _picContainerView.sd_layout
    .leftEqualToView(_moreButton);
}


- (void)setModel:(TravelNotesModel *)model
{
    _model = model;
    
    _shouldOpenContentLabel = NO;
    
    _iconView.image = [UIImage imageNamed:model.iconName];
    _nameLable.text = model.name;
    // 防止单行文本label在重用时宽度计算不准的问题
    [_nameLable sizeToFit];
    _positionImg.image = IMAGE_PATH(@"定位选中.png");
    _position.text = @"长江师范学院";
    _contentLabel.text = model.content;
    _timeLabel.text = model.time;
    
    _picContainerView.picPathStringsArray = model.picArray;
    
    if (model.shouldShowMoreButton) { // 如果文字高度超过60
        _moreButton.sd_layout.heightIs(20);
        _moreButton.hidden = NO;
        if (model.isOpening) { // 如果需要展开
            _contentLabel.sd_layout.maxHeightIs(MAXFLOAT);
            [_moreButton setTitle:@"收起文字" forState:UIControlStateNormal];
        } else {
            _contentLabel.sd_layout.maxHeightIs(60);
            [_moreButton setTitle:@"显示全部" forState:UIControlStateNormal];
        }
    } else {
        _moreButton.sd_layout.heightIs(0);
        _moreButton.hidden = YES;
    }
    
    CGFloat picContainerTopMargin = 0;
    if (model.picArray.count) {
        picContainerTopMargin = 10;
    }
    _picContainerView.sd_layout.topSpaceToView(_moreButton, picContainerTopMargin);
    [self setupAutoHeightWithBottomView:_picContainerView bottomMargin:10];
}

- (void)moreButtonClicked
{
    if (self.moreButtonClickedBlock) {
        self.moreButtonClickedBlock(self.indexPath);
    }
}

@end
