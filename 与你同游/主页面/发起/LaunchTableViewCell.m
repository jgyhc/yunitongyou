//
//  LaunchTableViewCell.m
//  viewController
//
//  Created by rimi on 15/10/12.
//  Copyright (c) 2015年 ouyang. All rights reserved.
//

#import "LaunchTableViewCell.h"
#import "BottomButtonsView.h"
@interface LaunchTableViewCell ()
@property (nonatomic, strong)UILabel *userIDLabel; //用户ID
@property (nonatomic, strong)UILabel *launchTimeLabel;//发起时间
@property (nonatomic, strong)UILabel *departureLabel;//出发地点
@property (nonatomic, strong)UILabel *startingLabel;//出发时间
@property (nonatomic, strong)UILabel *retureLabel;//返程时间
@property (nonatomic, strong)UIView *TitleView;
@property (nonatomic, strong)UIButton *ContentButton;
@property (nonatomic, strong)UIButton *UserHeaderimageView;
@property (nonatomic, strong)UILabel *infoLabel;//简介
@property (nonatomic, strong)UIImageView *sexImage;//性别
@property (nonatomic, strong)UILabel *ageLabel;//年龄
@property (nonatomic, strong)UILabel *followerLabel;
@property (nonatomic, strong)UILabel *PNumber;
@property (nonatomic, strong) BottomButtonsView *buttonView;
@end

@implementation LaunchTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        
        [self.contentView addSubview:self.userIDLabel];
        [self.contentView addSubview:self.launchTimeLabel];
        [self.contentView addSubview:self.departureLabel];
        [self.contentView addSubview:self.startingLabel];
//        [self.contentView addSubview:self.TitleView];
//        [self.contentView addSubview:self.ContentButton];
        [self.contentView addSubview:self.UserHeaderimageView];
        [self.contentView addSubview:self.infoLabel];
        [self.contentView addSubview:self.sexImage];
        [self.contentView addSubview:self.ageLabel];
//        [self.contentView addSubview:self.followerLabel];
        [self.contentView addSubview:self.PNumber];
        [self.contentView addSubview:self.buttonView];
//
//        
        self.UserHeaderimageView.sd_layout.leftSpaceToView(self.contentView,flexibleWidth(15)).
        topSpaceToView(self.contentView, flexibleHeight(15)).heightIs(flexibleHeight(35)).widthIs(flexibleHeight(35));
        self.UserHeaderimageView.sd_cornerRadiusFromWidthRatio = @(0.5);

        self.userIDLabel.sd_layout.leftSpaceToView(self.UserHeaderimageView, flexibleWidth(5)).topSpaceToView(self.contentView, flexibleHeight(20)).heightIs(flexibleHeight(12));
        [self.userIDLabel setSingleLineAutoResizeWithMaxWidth:flexibleHeight(200)];

        self.ageLabel.sd_layout.leftSpaceToView(self.userIDLabel, flexibleWidth(10)).centerYEqualToView(self.userIDLabel).heightIs(flexibleHeight(12));
        [self.ageLabel setSingleLineAutoResizeWithMaxWidth:200];

        self.launchTimeLabel.sd_layout.leftEqualToView(self.userIDLabel).topSpaceToView(self.userIDLabel, flexibleHeight(5)).heightIs(flexibleHeight(10));
        [self.launchTimeLabel setSingleLineAutoResizeWithMaxWidth:flexibleWidth(200)];
        
        self.departureLabel.sd_layout.centerXEqualToView(self.contentView).topSpaceToView(self.launchTimeLabel, flexibleHeight(10)).heightIs(flexibleHeight(14));
        [self.departureLabel setSingleLineAutoResizeWithMaxWidth:345];
        
        self.startingLabel.sd_layout.centerXEqualToView(self.contentView).topSpaceToView(self.departureLabel, flexibleHeight(5)).heightIs(flexibleHeight(12));
        [self.startingLabel setSingleLineAutoResizeWithMaxWidth:200];

        
        self.sexImage.sd_layout.leftEqualToView(self.ageLabel).topSpaceToView(self.ageLabel, flexibleHeight(5)).heightIs(flexibleHeight(10)).widthIs(flexibleHeight(10));
        
        self.PNumber.sd_layout.rightEqualToView(self.contentView).topEqualToView(self.contentView).heightIs(flexibleHeight(60)).widthIs(flexibleHeight(60));

        self.infoLabel.sd_layout.leftSpaceToView(self.contentView,flexibleWidth(15)).rightSpaceToView(self.contentView, flexibleWidth(15)).topSpaceToView(self.startingLabel, flexibleHeight(10)).autoHeightRatio(0);

        self.buttonView.sd_layout.leftEqualToView(self.contentView).rightEqualToView(self.contentView).heightIs(flexibleHeight(40)).topSpaceToView(self.infoLabel, flexibleHeight(20));
        
        [self setupAutoHeightWithBottomView:self.buttonView bottomMargin:0];
        
        
//        UIView *addressLine = [[UIView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 15, 1), NO)];
//        addressLine.center =  flexibleCenter(CGPointMake(243, 24),NO);
//        addressLine.backgroundColor = [UIColor colorWithWhite:0.298 alpha:1.000];
//        [self.contentView addSubview:addressLine];
    }
    return self;
}



- (void)PositionTheReset {
   
    UIView *bottomLineView = [[UIView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, WIDTH, 1), NO)];
    
    bottomLineView.backgroundColor = [UIColor colorWithWhite:0.800 alpha:1.000];
    [self.contentView addSubview:bottomLineView];
    
    UIView *bottomLine = [[UIView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 1, 38), NO)];
    bottomLine.backgroundColor = [UIColor colorWithWhite:0.800 alpha:1.000];
    [self.contentView addSubview:bottomLine];
    
    UIView *bottomLine2 = [[UIView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 1, 38), NO)];
    bottomLine2.backgroundColor = [UIColor colorWithWhite:0.800 alpha:1.000];
    [self.contentView addSubview:bottomLine2];

}


- (void)initUserHeaderImage:(UIImage *)image userID:(NSString *)userID userLV:(NSString *)userLV launchTime:(NSString *)launchTime launchDate:(NSString *)launchDate {
    [_UserHeaderimageView setImage:image forState:UIControlStateNormal];
    _userIDLabel.text = userID;
    _launchTimeLabel.text = launchTime;
//    _launchDateLabel.text = launchDate;
}

- (void)initDeparture:(NSString *)departure destination:(NSString *)destination starting:(NSString *)starting reture:(NSString *)reture info:(NSString *)info {
    _departureLabel.text = departure;
    _startingLabel.text = starting;
    _retureLabel.text = reture;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:info];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.headIndent = 0;
    style.firstLineHeadIndent = 25;
    style.lineSpacing = 0;
    [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    
    _infoLabel.attributedText = text;
}

- (void)initSave:(NSString *)save comment:(NSString *)comment follower:(NSString *)follower {
   
}


- (void)eventActive:(UIButton *)sender {
    sender.selected = !sender.selected;
}
                              
- (UILabel *)userIDLabel {
	if(_userIDLabel == nil) {
        _userIDLabel = ({
            UILabel *label = [[UILabel alloc]init];
            label.font = [UIFont systemFontOfSize:flexibleHeight(12)];
            label.textColor = [UIColor colorWithWhite:0.500 alpha:1.000];
            label.text = @"阿斯顿撒点哦埃及的";
            label;
        });
	}
	return _userIDLabel;
}



- (UILabel *)launchTimeLabel {
	if(_launchTimeLabel == nil) {
        _launchTimeLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:flexibleHeight(10)];
            label.textColor = [UIColor colorWithWhite:0.792 alpha:1.000];
            label.text = @"2017-12-34 12:21:12";
            label;
        });
	}
	return _launchTimeLabel;
}

- (UILabel *)departureLabel {
	if(_departureLabel == nil) {
        _departureLabel = ({
            UILabel *label = [[UILabel alloc]init];
            label.textColor = [UIColor colorWithWhite:0.364 alpha:1.000];
            label.font = [UIFont boldSystemFontOfSize:flexibleHeight(14)];
            label.text = @"重庆  ---->    香格里拉";
            label;
        });
	}
	return _departureLabel;
}



- (UILabel *)startingLabel {
	if(_startingLabel == nil) {
        _startingLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(200, 26, 260, 30), NO)];
            label.textColor = [UIColor colorWithWhite:0.723 alpha:1.000];
            label.font = [UIFont boldSystemFontOfSize:flexibleHeight(12)];
            label.text = @"2017-1-2         2017-2-3";
            label;
        });
	}
	return _startingLabel;
}

- (UILabel *)retureLabel {
	if(_retureLabel == nil) {
        _retureLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(240, 42, 260, 30), NO)];
            label.textColor = [UIColor colorWithWhite:0.723 alpha:1.000];
            label.font = [UIFont boldSystemFontOfSize:13];
            label;
        });
	}
	return _retureLabel;
}

- (UIView *)TitleView {
	if(_TitleView == nil) {
		_TitleView = [[UIView alloc] init];
	}
	return _TitleView;
}

- (UIButton *)ContentButton {
	if(_ContentButton == nil) {
        _ContentButton = ({
            UIButton *image = [[UIButton alloc] initWithFrame:CGRectMake(20, _infoLabel.frame.origin.y + _infoLabel.bounds.size.height - 15, flexibleHeight(70), flexibleHeight(70))];
            //            [image setImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
            image;
            
        });
	}
	return _ContentButton;
}

- (UIButton *)UserHeaderimageView {
	if(_UserHeaderimageView == nil) {
        _UserHeaderimageView =  [[UIButton alloc]init];
        _UserHeaderimageView.layer.masksToBounds = YES;
        _UserHeaderimageView.backgroundColor = [UIColor blueColor];
	}
	return _UserHeaderimageView;
}

- (UILabel *)infoLabel {
	if(_infoLabel == nil) {
        _infoLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(10, 75, 335, 80), NO)];
            label.numberOfLines = 0;
            label.textAlignment = NSTextAlignmentLeft;
            label.textColor = [UIColor colorWithWhite:0.601 alpha:1.000];
            label.font = [UIFont boldSystemFontOfSize:(SCREEN_HEIGHT / 667.0) * 14];
            label.text = @"开门呀开门呀开门呀别躲在里面不出声开门呀开门呀开门呀别躲在里面不出声开门呀开门呀开门呀别躲在里面不出声开门呀开门呀开门呀别躲在里面不出声开门呀开门呀开门呀别躲在里面不出声开门呀开门呀开门呀别躲在里面不出声";
            label;
        });
        
	}
	return _infoLabel;
}


- (UIImageView *)sexImage {
	if(_sexImage == nil) {
        _sexImage = ({
            
            UIImageView *image = [[UIImageView alloc] initWithFrame:flexibleFrame(CGRectMake(120, 52, 15, 15), NO)];
            image.backgroundColor = [UIColor redColor];
            image;
        });
	}
	return _sexImage;
}

- (UILabel *)ageLabel {
	if(_ageLabel == nil) {
        _ageLabel = ({
            UILabel *label = [[UILabel alloc]init];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:flexibleHeight(12)];
            label.textColor = [UIColor colorWithWhite:0.792 alpha:1.000];
            label.text = @"12岁";
            label;
        });
	}
	return _ageLabel;
}


- (UILabel *)PNumber {
	if(_PNumber == nil) {
        _PNumber = ({
            UILabel *label = [[UILabel alloc]init];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor colorWithRed:0.127 green:0.768 blue:0.503 alpha:1.000];
            label.font = [UIFont systemFontOfSize:flexibleHeight(12)];
            label.textColor = [UIColor whiteColor];
            label.text = @"12人";
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:label.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = label.bounds;
            maskLayer.path = maskPath.CGPath;
            label.layer.mask = maskLayer;
            label;
        });
        
	}
	return _PNumber;
}

- (BottomButtonsView *)buttonView {
	if(_buttonView == nil) {
		_buttonView = [[BottomButtonsView alloc] init];
        [_buttonView updateImage:@[@"点赞", @"评论", @"未收藏"] label:@[@"赞", @"评论", @"收藏"]];
	}
	return _buttonView;
}

@end
