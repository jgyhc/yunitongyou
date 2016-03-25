//
//  LBottomView.m
//  与你同游
//
//  Created by Zgmanhui on 16/3/23.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import "LBottomView.h"

@interface LBottomView ()
@property (nonatomic, strong) UIView *commentView;
@property (nonatomic, strong) UIView *joinView;
@property (nonatomic, strong) UIView *thumupView;
@property (nonatomic, strong) UIImageView *imgaeView1;
@property (nonatomic, strong) UIImageView *imgaeView2;
@property (nonatomic, strong) UIImageView *imgaeView3;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;
@end
@implementation LBottomView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        self.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
        self.layer.shadowOpacity = 1;//阴影透明度，默认0
        self.layer.shadowRadius = 2;//阴影半径，默认3
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handldTapEvent:)];
        [self.joinView addGestureRecognizer:tap];
        UITapGestureRecognizer *comtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handldTapEvent:)];
        [self.commentView addGestureRecognizer:comtap];
        
        UITapGestureRecognizer *tptap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handldTapEvent:)];
        [self.thumupView addGestureRecognizer:tptap];
        
        [self addSubview:self.commentView];
        [self addSubview:self.joinView];
        [self addSubview:self.thumupView];
        self.commentView.sd_layout.leftEqualToView(self).bottomEqualToView(self).topEqualToView(self).widthIs(flexibleWidth(375 / 3));
        
        self.joinView.sd_layout.leftSpaceToView(self.commentView, 0).bottomEqualToView(self).topEqualToView(self).widthIs(flexibleWidth(375 / 3));
        
        self.thumupView.sd_layout.leftSpaceToView(self.joinView, 0).bottomEqualToView(self).topEqualToView(self).widthIs(flexibleWidth(375 / 3));
        
        [self.commentView addSubview:self.label2];
        [self.thumupView addSubview:self.label3];
        [self.commentView addSubview:self.imgaeView1];
        [self addSubview:self.imgaeView2];
        [self.thumupView addSubview:self.imgaeView3];
        
        
        self.imgaeView1.sd_layout.centerYEqualToView(self.commentView).leftSpaceToView(self.commentView, flexibleWidth(35)).heightIs(flexibleHeight(20)).widthEqualToHeight(1);
        
        self.imgaeView2.sd_layout.centerXEqualToView(self).centerYEqualToView(self).widthIs(flexibleHeight(50)).heightEqualToWidth(1);
        
        self.imgaeView3.sd_layout.centerYEqualToView(self.thumupView).leftSpaceToView(self.thumupView, flexibleWidth(35)).heightIs(flexibleHeight(20)).widthEqualToHeight(1);
        
        self.label2.sd_layout.centerYEqualToView(self.commentView).leftSpaceToView(self.imgaeView1, flexibleWidth(5)).heightIs(flexibleHeight(12));
        [self.label2 setSingleLineAutoResizeWithMaxWidth:100];
        
        self.label3.sd_layout.centerYEqualToView(self.thumupView).leftSpaceToView(self.imgaeView3, flexibleWidth(5)).heightIs(flexibleHeight(12));
        
        [self.label3 setSingleLineAutoResizeWithMaxWidth:100];
        
        
    }
    return self;
}


- (void)handldTapEvent:(UITapGestureRecognizer *)tap {
    if (tap.view == self.joinView) {
        if (self.delegate &&[self.delegate respondsToSelector:@selector(joinCalled)]) {
            [self.delegate joinCalled];
        }
    }
    if (tap.view == self.commentView) {
        if (self.delegate &&[self.delegate respondsToSelector:@selector(commentCalled)]) {
            [self.delegate commentCalled];
        }
    }
    if (tap.view == self.thumupView) {
        if (self.delegate &&[self.delegate respondsToSelector:@selector(thumUpCalled)]) {
            [self.delegate thumUpCalled];
        }
    }

}

- (UIView *)commentView {
	if(_commentView == nil) {
		_commentView = [[UIView alloc] init];
	}
	return _commentView;
}

- (UIView *)joinView {
	if(_joinView == nil) {
		_joinView = [[UIView alloc] init];
	}
	return _joinView;
}

- (UIView *)thumupView {
	if(_thumupView == nil) {
		_thumupView = [[UIView alloc] init];
	}
	return _thumupView;
}

- (UIImageView *)imgaeView1 {
	if(_imgaeView1 == nil) {
		_imgaeView1 = [[UIImageView alloc] init];
        _imgaeView1.image = [UIImage imageNamed:@"评论"];
	}
	return _imgaeView1;
}

- (UIImageView *)imgaeView2 {
	if(_imgaeView2 == nil) {
		_imgaeView2 = [[UIImageView alloc] init];
        _imgaeView2.image = [UIImage imageNamed:@"我要加入未选"];
	}
	return _imgaeView2;
}

- (UIImageView *)imgaeView3 {
	if(_imgaeView3 == nil) {
		_imgaeView3 = [[UIImageView alloc] init];
        _imgaeView3.image = [UIImage imageNamed:@"未点赞"];
	}
	return _imgaeView3;
}

- (UILabel *)label2 {
	if(_label2 == nil) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"评论";
        label.textColor = [UIColor colorWithWhite:0.584 alpha:1.000];
        label.font = [UIFont systemFontOfSize:flexibleHeight(12)];
        _label2 = label;
	}
	return _label2;
}

- (UILabel *)label3 {
	if(_label3 == nil) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithWhite:0.584 alpha:1.000];
        label.font = [UIFont systemFontOfSize:flexibleHeight(12)];
        label.text = @"点赞";
        _label3 = label;
	}
	return _label3;
}

@end
