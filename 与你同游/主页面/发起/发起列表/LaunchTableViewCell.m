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
//@property (nonatomic, strong)UIImageView *sexImage;//性别
@property (nonatomic, strong)UILabel *ageLabel;//年龄
@property (nonatomic, strong)UILabel *followerLabel;
@property (nonatomic, strong)UILabel *PNumber;

@property (nonatomic, strong)   UIButton    * cancelButton;

@property (nonatomic, strong) BottomButtonsView *buttonView;
@property (nonatomic, copy)collection collectionblock;
@property (nonatomic, copy) thumb thumbblock;

@property (nonatomic,strong) NSString * thumbImg;
@property (nonatomic, strong)  NSString * collectionImg;
@property (nonatomic, strong)  NSString * thumbNum;
@property  (nonatomic, strong)   NSString * commentNum;
@property (nonatomic, assign)   int     thumbNumber;

@property (nonatomic,strong) UIView * backView;
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
        [self.contentView addSubview:self.cancelButton];
        
        self.backView = [UIView new];
        self.backView.backgroundColor = [UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1.0];
        [self.contentView addSubview:self.backView];
        
         self.cancelButton.sd_layout.topSpaceToView(self.contentView,10).rightSpaceToView(self.contentView,60).widthIs(flexibleWidth(40)).heightIs(flexibleWidth(20));
        
        self.followerLabel.sd_layout.rightEqualToView(self.contentView).widthIs(flexibleWidth(50)).heightIs(flexibleHeight(40)).topSpaceToView(self.contentView, 0);

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

//        
//        self.sexImage.sd_layout.leftEqualToView(self.ageLabel).topSpaceToView(self.ageLabel, flexibleHeight(5)).heightIs(flexibleHeight(10)).widthIs(flexibleHeight(10));
        
        self.PNumber.sd_layout.rightEqualToView(self.contentView).topEqualToView(self.contentView).heightIs(flexibleHeight(60)).widthIs(flexibleWidth(60));

        self.infoLabel.sd_layout.leftSpaceToView(self.contentView,flexibleWidth(15)).rightSpaceToView(self.contentView, flexibleWidth(15)).topSpaceToView(self.startingLabel, flexibleHeight(10)).autoHeightRatio(0);

        self.buttonView.sd_layout.leftEqualToView(self.contentView).rightEqualToView(self.contentView).heightIs(flexibleHeight(40)).topSpaceToView(self.infoLabel, flexibleHeight(20));
        
        self.backView.sd_layout.leftEqualToView(self.contentView).rightEqualToView(self.contentView).topSpaceToView(self.buttonView,0).heightIs(flexibleHeight(5));
        
        [self setupAutoHeightWithBottomView:self.backView bottomMargin:0];

        
        
    }
    return self;
}


- (void)handldTapEvent:(UITapGestureRecognizer *)sender {
    if (!OBJECTID) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还未登录喔！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
        if (sender.view.tag - 300 == 0) {
            if ([self.thumbImg isEqualToString:@"点赞"]) {
                self.thumbImg = @"未点赞";
                self.thumbNum = [NSString stringWithFormat:@"%d",(--self.thumbNumber)];

                if (self.thumbblock) {
                    self.thumbblock(0);
                }
                
            }
            else{
               self.thumbImg = @"点赞";
                self.thumbNum = [NSString stringWithFormat:@"%d",(++self.thumbNumber)];

                if (self.thumbblock) {
                    self.thumbblock(1);
                }
                
            }
            
        }
        
        else if (sender.view.tag- 300 == 1){
            if ([self.collectionImg isEqualToString:@"已收藏"]) {
                self.collectionImg = @"未收藏";
                if (self.collectionblock) {
                    self.collectionblock(0);
                }
                
            }
            else{
                self.collectionImg = @"已收藏";
                if (self.collectionblock) {
                    self.collectionblock(1);
                }
                
            }
        }
    [self.buttonView updateImage:@[self.thumbImg, @"评论", self.collectionImg] label:@[self.thumbNum,self.commentNum,@"收藏"]];
}

- (void)buttonCollection:(collection)collectionBlock{
    self.collectionblock = collectionBlock;
}
- (void)buttonthumb:(thumb)thumbBlock{
    self.thumbblock = thumbBlock;
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


- (void)handelEvent {
    if (_pdetailBlock) {
        self.pdetailBlock(_indexPath);
    }
}
- (void)handleDelete{
    if (_deleteActivity) {
        self.deleteActivity();
    }
}

- (void)setObj:(BmobObject *)obj {
    if (self.type == 1) {
        self.cancelButton.hidden = NO;
    }
    else{
        self.cancelButton.hidden = YES;
    }
    _obj = obj;
    BmobObject *user = [obj objectForKey:@"user"];
    self.userIDLabel.text = [user objectForKey:@"username"];
    
    self.ageLabel.text = [user objectForKey:@"age"];
    [self.UserHeaderimageView sd_setImageWithURL:[NSURL URLWithString:[user objectForKey:@"head_portraits"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"logo"]];
    self.launchTimeLabel.text = [obj objectForKey:@"called_date"];
    self.departureLabel.text = [NSString stringWithFormat:@"%@ → %@", [obj objectForKey:@"point_of_departure"], [obj objectForKey:@"destination"]];
    self.startingLabel.text = [NSString stringWithFormat:@"%@        %@", [obj objectForKey:@"departure_time"], [obj objectForKey:@"arrival_time"]];
    self.infoLabel.text = [obj objectForKey:@"content"];
    self.PNumber.text = [NSString stringWithFormat:@"%@", [obj objectForKey:@"number_Of_people"]];
    
   self.thumbImg = @"未点赞";
   self.collectionImg= @"未收藏";
    NSArray * thumbArray = (NSArray *)[obj objectForKey:@"thumbArray"];
    for (NSString * userId in thumbArray) {
        if ([userId isEqualToString:OBJECTID]) {
            self.thumbImg = @"点赞";
        }
        else{
            self.thumbImg = @"未点赞";
        }
    }
    NSArray * collectionArray = (NSArray *)[obj objectForKey:@"collectionArray"];
    for (NSString * userId in collectionArray) {
        if ([userId isEqualToString:OBJECTID]) {
           self.collectionImg = @"已收藏";
        }
        else{
           self.collectionImg = @"未收藏";
        }
    }
    self.thumbNumber = [(NSNumber *)[obj objectForKey:@"number_of_thumb_up"] intValue];

   self.thumbNum = [NSString stringWithFormat:@"%d",self.thumbNumber];
    self.commentNum = [NSString stringWithFormat:@"%@",[obj objectForKey:@"comments_number"]];

    [self.buttonView updateImage:@[self.thumbImg, @"评论", self.collectionImg] label:@[self.thumbNum,self.commentNum,@"收藏"]];
    
    
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
        [_UserHeaderimageView addTarget:self action:@selector(handelEvent) forControlEvents:UIControlEventTouchUpInside];
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
            label;
        });
        
	}
	return _infoLabel;
}


//- (UIImageView *)sexImage {
//	if(_sexImage == nil) {
//        _sexImage = ({
//            
//            UIImageView *image = [[UIImageView alloc] initWithFrame:flexibleFrame(CGRectMake(120, 52, 15, 15), NO)];
//            image.backgroundColor = [UIColor redColor];
//            image;
//        });
//	}
//	return _sexImage;
//}

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
- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton new];
        [_cancelButton setTitleColor:[UIColor colorWithRed:1.0 green:0.502 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
        [_cancelButton setTitle:@"删除" forState:UIControlStateNormal];
        _cancelButton.layer.borderWidth = 1;
        _cancelButton.layer.borderColor = [UIColor colorWithRed:1.0 green:0.502 blue:0.0 alpha:1.0].CGColor;
        _cancelButton.layer.cornerRadius = 3;
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
        //        _cancelButton.hidden = YES;
        [_cancelButton addTarget:self action:@selector(handleDelete) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

@end
