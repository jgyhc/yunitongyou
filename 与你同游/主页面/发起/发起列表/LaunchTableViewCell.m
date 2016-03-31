//
//  LaunchTableViewCell.m
//  viewController
//
//  Created by rimi on 15/10/12.
//  Copyright (c) 2015年 ouyang. All rights reserved.
//

#import "LaunchTableViewCell.h"
#import "BottomButtonsView.h"
#import "UIButton+WebCache.h"

@interface LaunchTableViewCell ()<BottomButtonsViewDelegate>
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
@property (nonatomic, copy)collection collectionblock;
@end

@implementation LaunchTableViewCell




- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.userIDLabel];
        [self.contentView addSubview:self.launchTimeLabel];
        [self.contentView addSubview:self.departureLabel];
        [self.contentView addSubview:self.startingLabel];
        [self.contentView addSubview:self.UserHeaderimageView];
        [self.contentView addSubview:self.infoLabel];
        [self.contentView addSubview:self.ageLabel];
        [self.contentView addSubview:self.followerLabel];
        [self.contentView addSubview:self.PNumber];
        [self.contentView addSubview:self.buttonView];
        
        self.followerLabel.sd_layout.rightEqualToView(self.contentView).widthIs(flexibleWidth(50)).heightIs(flexibleHeight(40)).topSpaceToView(self.contentView, 0);
//
        self.UserHeaderimageView.sd_layout.leftSpaceToView(self.contentView,flexibleWidth(15)).
        topSpaceToView(self.contentView, flexibleHeight(15)).heightIs(flexibleHeight(80)).widthIs(flexibleHeight(80));
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
        
        self.PNumber.sd_layout.rightEqualToView(self.contentView).topEqualToView(self.contentView).heightIs(flexibleHeight(60)).widthIs(flexibleWidth(60));

        self.infoLabel.sd_layout.leftSpaceToView(self.contentView,flexibleWidth(15)).rightSpaceToView(self.contentView, flexibleWidth(15)).topSpaceToView(self.startingLabel, flexibleHeight(10)).autoHeightRatio(0);

        self.buttonView.sd_layout.leftEqualToView(self.contentView).rightEqualToView(self.contentView).heightIs(flexibleHeight(40)).topSpaceToView(self.infoLabel, flexibleHeight(20));
        
        [self setupAutoHeightWithBottomView:self.buttonView bottomMargin:0];
        
    }
    return self;
}


- (void)handldTapEvent:(UITapGestureRecognizer *)sender {
    if (self.collectionblock) {
        self.collectionblock(1);
    }
}

- (void)buttonCollection:(collection)collectionBlock{
    self.collectionblock = collectionBlock;
}

- (UILabel *)userIDLabel {
	if(_userIDLabel == nil) {
        _userIDLabel = ({
            UILabel *label = [[UILabel alloc]init];
            label.font = [UIFont systemFontOfSize:flexibleHeight(12)];
            label.textColor = [UIColor colorWithWhite:0.500 alpha:1.000];
            label.text = @"jgyhc";
            label;
        });
	}
	return _userIDLabel;
}

- (void)setObj:(BmobObject *)obj {
    _obj = obj;
    BmobObject *user = [obj objectForKey:@"user"];
    self.userIDLabel.text = [user objectForKey:@"username"];
    
    self.ageLabel.text = [user objectForKey:@"age"];
    [self.UserHeaderimageView sd_setImageWithURL:[NSURL URLWithString:[user objectForKey:@"head_portraits"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"logo"]];
    self.launchTimeLabel.text = [obj objectForKey:@"called_date"];
    self.departureLabel.text = [NSString stringWithFormat:@"%@  ---->   %@", [obj objectForKey:@"point_of_departure"], [obj objectForKey:@"destination"]];
    self.startingLabel.text = [NSString stringWithFormat:@"%@        %@", [obj objectForKey:@"departure_time"], [obj objectForKey:@"arrival_time"]];
    self.infoLabel.text = [obj objectForKey:@"content"];
    self.PNumber.text = [NSString stringWithFormat:@"%@", [obj objectForKey:@"number_Of_people"]];
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
            label.backgroundColor = [UIColor colorWithRed:0.374 green:0.820 blue:0.637 alpha:1.000];
            label.font = [UIFont systemFontOfSize:flexibleHeight(12)];
            label.font = [UIFont boldSystemFontOfSize:15];
            label.textColor = [UIColor whiteColor];
            label;
        });
        
	}
	return _PNumber;
}

- (BottomButtonsView *)buttonView {
	if(_buttonView == nil) {
		_buttonView = [[BottomButtonsView alloc] init];
        [_buttonView updateImage:@[@"未点赞", @"评论", @"未收藏"] label:@[@"赞", @"评论", @"收藏"]];
        _buttonView.delegate = self;
	}
	return _buttonView;
}

- (UILabel *)followerLabel {
	if(_followerLabel == nil) {
		_followerLabel = [[UILabel alloc] init];
        _followerLabel.textAlignment = NSTextAlignmentCenter;
        _followerLabel.font = [UIFont systemFontOfSize:flexibleHeight(12)];
        _followerLabel.textColor = [UIColor whiteColor];
        _followerLabel.backgroundColor = [UIColor colorWithRed:0.141 green:0.933 blue:0.600 alpha:1.000];
	}
	return _followerLabel;
}

@end
