//
//  ScenicDetailCell.m
//  与你同游
//
//  Created by Zgmanhui on 16/3/26.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import "ScenicDetailView.h"
static CGFloat maxContentLabelHeight = 50.0f;
@interface ScenicDetailView ()
@property (nonatomic, strong) UILabel *contentlabel;
@property (nonatomic, strong) UIImageView *xsjImgaeView;
@property (nonatomic, assign) BOOL isOpen;
@end
@implementation ScenicDetailView


- (void)setModel:(NSString *)model {
    _model = model;
    [self addSubview:self.contentlabel];
    _isOpen = NO;
    self.contentlabel.sd_layout.leftSpaceToView(self, flexibleWidth(15)).rightSpaceToView(self, flexibleWidth(15)).topSpaceToView(self, flexibleHeight(10)).autoHeightRatio(0);
    if ([self msgContent:model]) {
        [self addSubview:self.xsjImgaeView];
        self.xsjImgaeView.sd_layout.rightSpaceToView(self, flexibleWidth(15)).bottomSpaceToView(self, flexibleHeight(10)).heightIs(flexibleHeight(32)).widthIs(flexibleWidth(32));
        self.contentlabel.sd_layout.maxHeightIs(flexibleHeight(maxContentLabelHeight));
    }
    self.contentlabel.text = model;

    [self update];
}

- (void)update {
    if (_isOpen == NO) {
        self.contentlabel.sd_layout.maxHeightIs(flexibleHeight(maxContentLabelHeight));
        [UIView animateWithDuration:0.4 animations:^{
            self.xsjImgaeView.transform = CGAffineTransformMakeRotation(0);
        }];
    }else {
        self.contentlabel.sd_layout.maxHeightIs(MAXFLOAT);
        [UIView animateWithDuration:0.4 animations:^{
            self.xsjImgaeView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    }
    [self setupAutoHeightWithBottomView:self.contentlabel bottomMargin:flexibleHeight(10)];

}


- (BOOL)msgContent:(NSString *)content
{
    CGFloat contentW = [UIScreen mainScreen].bounds.size.width - flexibleWidth(30);
    CGRect textRect = [content boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:flexibleHeight(14)]} context:nil];
    if (textRect.size.height > flexibleHeight(maxContentLabelHeight)) {
        return YES;
    }
    return NO;
}


- (UIImageView *)xsjImgaeView {
	if(_xsjImgaeView == nil) {
		_xsjImgaeView = [[UIImageView alloc] init];
        _xsjImgaeView.image = [UIImage imageNamed:@"朝上箭头"];
	}
	return _xsjImgaeView;
}

- (UILabel *)contentlabel {
	if(_contentlabel == nil) {
		_contentlabel = [[UILabel alloc] init];
        _contentlabel.font = [UIFont systemFontOfSize:flexibleHeight(14)];
        _contentlabel.textColor = [UIColor colorWithWhite:0.274 alpha:1.000];
        
	}
	return _contentlabel;
}

@end
