//
//  HeaderButtonView.m
//  与你同游
//
//  Created by Zgmanhui on 16/3/21.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import "HeaderButtonView.h"

@interface HeaderButtonView ()
@property (nonatomic, strong) UIView * separatorView;
@property (nonatomic, strong)UIView *separatationLineView;

@end

@implementation HeaderButtonView


- (instancetype)initWithType:(int)type
{
    self = [super init];
    if (self) {
        self.separatorView = [UIView new];
        self.separatorView.backgroundColor = [UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1.0];
        [self addSubview:self.separatorView];
        [self addSubview:self.leftsideButton];
        [self addSubview:self.rightsideButton];
        [self addSubview:self.separatationLineView];
        
        self.separatorView.sd_layout.leftEqualToView(self).topEqualToView(self).rightEqualToView(self).heightIs(flexibleHeight(5));
        self.leftsideButton.sd_layout.leftEqualToView(self).widthIs(flexibleWidth(375 / 2)).heightIs(flexibleHeight(40)).topSpaceToView(self.separatorView, 0);
        self.rightsideButton.sd_layout.rightEqualToView(self).widthIs(flexibleWidth(375 / 2)).heightIs(flexibleHeight(40)).topEqualToView(self.leftsideButton);
        if (type == 1) {
            [self.rightsideButton setTitle:@"点赞" forState:UIControlStateNormal];
        }
        else{
            [self.rightsideButton setTitle:@"加入" forState:UIControlStateNormal];
        }
        self.separatationLineView.sd_layout.centerXIs(flexibleWidth(WIDTH / 4)).heightIs(flexibleHeight(2)).widthIs(flexibleWidth(375 / 2)).topSpaceToView(self.leftsideButton, 0);
        
        UIView *line  = [UIView new];
        line.backgroundColor = [UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1.0];
        [self addSubview:line];
        line.sd_layout.leftEqualToView(self).rightEqualToView(self).heightIs(1).topSpaceToView(self.leftsideButton, 0);
        
    }
    return self;
}


- (void)buttonClickEvent:(UIButton *)sender {
    if (sender == self.leftsideButton) {
        [UIView animateWithDuration:0.3 animations:^{
            self.separatationLineView.sd_layout.centerXIs(flexibleWidth(WIDTH / 4));
            [self.separatationLineView updateLayout];
            [self updateLayout];
        }];
    }
    
    if (sender == self.rightsideButton) {
        
        
        [UIView animateWithDuration:0.3 animations:^{
            self.separatationLineView.sd_layout.centerXIs(flexibleWidth(WIDTH / 4 * 3));
            [self updateLayout];
            [self.separatationLineView updateLayout];
        }];
    }
    if (self.delegate &&[self.delegate respondsToSelector:@selector(buttonClickEvent:)]) {
        [self.delegate buttonClickEvent:sender];
    }
}

- (UIView *)separatationLineView {
    if (!_separatationLineView) {
        _separatationLineView = ({
            UIView *view = [[UIView alloc]init];
            view.backgroundColor = THEMECOLOR;
            view;
        });
    }
    return _separatationLineView;
}

- (UIButton *)leftsideButton {
    if (!_leftsideButton) {
        _leftsideButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [button setTitle:@"评论" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithWhite:0.298 alpha:1.000] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(buttonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
            
            button;
        });
    }
    return _leftsideButton;
}

- (UIButton *)rightsideButton {
    if (!_rightsideButton) {
        _rightsideButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [button setTitleColor:[UIColor colorWithWhite:0.298 alpha:1.000] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [button setBackgroundColor:[UIColor whiteColor]];
            [button addTarget:self action:@selector(buttonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _rightsideButton;
}
@end
