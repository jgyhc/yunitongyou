//
//  HeaderView.m
//  与你同游
//
//  Created by Zgmanhui on 16/3/21.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import "HeaderView.h"
#import <UIImageView+WebCache.h>
@interface HeaderView ()
@property (nonatomic, strong) UIImageView *userHeaderImageView;//头像
@property (nonatomic, strong) UILabel *userIDLabel;//用户名
@property (nonatomic, strong) UIImageView *sexImageView;//性别
@property (nonatomic, strong) UILabel *initiateTimeLabel;//发起时间
@property (nonatomic, strong) UILabel *departureLabel;//出发地
@property (nonatomic, strong) UILabel *destinationLabel;//目的地

@property (nonatomic, strong) UILabel *followerNumLabel;//跟团人数

@property (nonatomic, strong) UILabel *startingLabel;//开始时间按
@property (nonatomic, strong) UILabel *returnLabel;//返回时间


@end
@implementation HeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self addSubview:self.userHeaderImageView];
        [self addSubview:self.userIDLabel];
        [self addSubview:self.initiateTimeLabel];
        [self addSubview:self.sexImageView];
        
        [self addSubview:self.followerNumLabel];
        [self addSubview:self.departureLabel];
        [self addSubview:self.destinationLabel];
        [self addSubview:self.startingLabel];
        [self addSubview:self.returnLabel];
        [self addSubview:self.infoLabel];

        
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"箭头"]];
        imageView.frame = flexibleFrame(CGRectMake(0, 0, 50, 25), NO);
        imageView.center = CGPointMake(self.center.x, flexibleHeight(120));
        [self addSubview:imageView];
        
        self.userHeaderImageView.sd_layout.leftSpaceToView(self, flexibleWidth(15)).topSpaceToView(self, flexibleHeight(10)).widthIs(flexibleHeight(50)).heightIs(flexibleHeight(50));
        self.userHeaderImageView.sd_cornerRadiusFromWidthRatio = @(0.5);
        
        self.userIDLabel.sd_layout.leftSpaceToView(self.userHeaderImageView, flexibleWidth(5)).topEqualToView(self.userHeaderImageView).heightIs(flexibleHeight(14));
        [self.userIDLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        self.initiateTimeLabel.sd_layout.leftSpaceToView(self.userHeaderImageView, flexibleWidth(5)).bottomEqualToView(self.userHeaderImageView).heightIs(13);
        [self.initiateTimeLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        self.sexImageView.sd_layout.leftSpaceToView(self.userIDLabel, flexibleWidth(2)).centerYEqualToView(self.userIDLabel).widthIs(flexibleHeight(16)).heightIs(flexibleHeight(16));
        
        self.followerNumLabel.sd_layout.rightSpaceToView(self ,flexibleWidth(15)).topEqualToView(self.userHeaderImageView).widthIs(flexibleHeight(50)).heightIs(flexibleHeight(50));
        
        self.departureLabel.sd_layout.leftSpaceToView(self, flexibleWidth(15)).topSpaceToView(self.userHeaderImageView, flexibleHeight(15)).heightIs(18);
        [self.departureLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        self.destinationLabel.sd_layout.rightSpaceToView(self, flexibleWidth(15)).topEqualToView(self.departureLabel).heightIs(18);
        [self.destinationLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        self.startingLabel.sd_layout.leftSpaceToView(self, flexibleWidth(15)).topSpaceToView(self.departureLabel, flexibleHeight(5)).heightIs(18);
        [self.startingLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        self.returnLabel.sd_layout.rightSpaceToView(self, flexibleWidth(15)).topEqualToView(self.startingLabel).heightIs(18);
        [self.returnLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        self.infoLabel.sd_layout.leftSpaceToView(self, flexibleWidth(15)).rightSpaceToView(self, flexibleWidth(15)).topSpaceToView(self.startingLabel, flexibleHeight(10)).autoHeightRatio(0);
        
        [self setupAutoHeightWithBottomView:self.infoLabel bottomMargin:0];
        
    }
    return self;
}


- (void)setUserObject:(BmobObject *)userObject {
    _userObject = userObject;
    self.userIDLabel.text = [userObject objectForKey:@"username"];
    [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:[userObject objectForKey:@"head_portraits"]] placeholderImage:[UIImage imageNamed:@"logo"]];

}

- (void)setCalledObject:(BmobObject *)calledObject {
    _calledObject = calledObject;
    self.initiateTimeLabel.text = [calledObject objectForKey:@"called_date"];
    self.departureLabel.text = [calledObject objectForKey:@"point_of_departure"];
    self.destinationLabel.text = [calledObject objectForKey:@"destination"];
    self.startingLabel.text = [calledObject objectForKey:@"departure_time"];
    self.returnLabel.text = [calledObject objectForKey:@"arrival_time"];
    self.followerNumLabel.text = [NSString stringWithFormat:@"%@", [calledObject objectForKey:@"number_Of_people"]];
    self.infoLabel.text = [calledObject objectForKey:@"content"];
    [self.startingLabel updateLayout];
    [self.infoLabel updateLayout];
//    __weak typeof(self) weakSelf = self;
//    [self.infoLabel setDidFinishAutoLayoutBlock:^(CGRect frame) {
////        [self layoutSubviews];
//        weakSelf.h = frame.size.height + frame.origin.y;
//        NSLog(@"%f   %f", frame.size.height, frame.origin.y);
//    }];
    
//    _h = self.frame.size.height;

}



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

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = ({
            UILabel *label = [[UILabel alloc]init];
            label.font = [UIFont boldSystemFontOfSize:14];
            label.textColor = [UIColor colorWithWhite:0.601 alpha:1.000];
            label;
        });
    }
    return _infoLabel;
}




@end
