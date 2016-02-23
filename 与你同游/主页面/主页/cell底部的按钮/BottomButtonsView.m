//
//  BottomButtonsView.m
//  与你同游
//
//  Created by Zgmanhui on 16/2/22.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import "BottomButtonsView.h"

@interface BottomButtonsView ()
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UIView *view3;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;
@property (nonatomic, strong) UIImageView *imgaeView1;
@property (nonatomic, strong) UIImageView *imgaeView2;
@property (nonatomic, strong) UIImageView *imgaeView3;
@end

@implementation BottomButtonsView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.view1];
        [self addSubview:self.view2];
        [self addSubview:self.view3];
        [self.view1 addSubview:self.label1];
        [self.view2 addSubview:self.label2];
        [self.view3 addSubview:self.label3];
        [self.view1 addSubview:self.imgaeView1];
        [self.view2 addSubview:self.imgaeView2];
        [self.view3 addSubview:self.imgaeView3];
        
        self.view1.sd_layout.leftEqualToView(self).bottomEqualToView(self).topEqualToView(self).widthRatioToView(self, 1 / 3);
        
        self.view2.sd_layout.leftEqualToView(self.view1).bottomEqualToView(self).topEqualToView(self).widthRatioToView(self, 1 / 3);
        
        self.view3.sd_layout.leftEqualToView(self.view2).bottomEqualToView(self).topEqualToView(self).widthRatioToView(self, 1 / 3);
        
        self.imgaeView1.sd_layout.centerYEqualToView(self.view1).leftSpaceToView(self.view1, flexibleWidth(75)).heightIs(flexibleHeight(20)).widthEqualToHeight(1);
        
        self.imgaeView2.sd_layout.centerYEqualToView(self.view2).leftSpaceToView(self.view2, flexibleWidth(75)).heightIs(flexibleHeight(20)).widthEqualToHeight(1);
        
        self.imgaeView3.sd_layout.centerYEqualToView(self.view3).leftSpaceToView(self.view3, flexibleWidth(75)).heightIs(flexibleHeight(20)).widthEqualToHeight(1);
        
        
        self.label1.sd_layout.centerYEqualToView(self.view1).leftSpaceToView(self.imgaeView1, flexibleWidth(5)).heightIs(flexibleHeight(12)).widthEqualToHeight(1);
        
        self.label2.sd_layout.centerYEqualToView(self.view2).leftSpaceToView(self.imgaeView2, flexibleWidth(5)).heightIs(flexibleHeight(12)).widthEqualToHeight(1);
        
        
        self.label3.sd_layout.centerYEqualToView(self.view3).leftSpaceToView(self.imgaeView3, flexibleWidth(5)).heightIs(flexibleHeight(12)).widthEqualToHeight(1);
    }
    return self;
}

- (void)updateImage:(NSArray *)imageArray label:(NSArray *)lableString {
    self.label1.text = lableString[0];
    self.label2.text = lableString[1];
    self.label3.text = lableString[2];
    
    self.imgaeView1.image = [UIImage imageNamed:imageArray[0]];
    self.imgaeView1.image = [UIImage imageNamed:imageArray[1]];
    self.imgaeView1.image = [UIImage imageNamed:imageArray[2]];

}

- (UIImageView *)imgaeView3 {
	if(_imgaeView3 == nil) {
		_imgaeView3 = [[UIImageView alloc] init];
	}
	return _imgaeView3;
}

- (UIImageView *)imgaeView2 {
	if(_imgaeView2 == nil) {
		_imgaeView2 = [[UIImageView alloc] init];
	}
	return _imgaeView2;
}

- (UIImageView *)imgaeView1 {
	if(_imgaeView1 == nil) {
		_imgaeView1 = [[UIImageView alloc] init];
	}
	return _imgaeView1;
}

- (UILabel *)label3
{
    if (!_label3) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithWhite:0.584 alpha:1.000];
        label.font = [UIFont systemFontOfSize:flexibleHeight(12)];
        _label3 = label;
    }
    return _label3;
}


- (UILabel *)label2 {
	if(_label2 == nil) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithWhite:0.584 alpha:1.000];
        label.font = [UIFont systemFontOfSize:flexibleHeight(12)];
        _label2 = label;
	}
	return _label2;
}

- (UILabel *)label1 {
	if(_label1 == nil) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithWhite:0.584 alpha:1.000];
        label.font = [UIFont systemFontOfSize:flexibleHeight(12)];
        _label1 = label;
	}
	return _label1;
}

- (UIView *)view3 {
	if(_view3 == nil) {
		_view3 = [[UIView alloc] init];
	}
	return _view3;
}

- (UIView *)view2 {
	if(_view2 == nil) {
		_view2 = [[UIView alloc] init];
	}
	return _view2;
}

- (UIView *)view1 {
	if(_view1 == nil) {
		_view1 = [[UIView alloc] init];
	}
	return _view1;
}

@end
