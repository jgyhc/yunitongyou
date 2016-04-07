//
//  TopSelectButtonView.m
//  与你同游
//
//  Created by mac on 16/4/2.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import "TopSelectButtonView.h"

@interface TopSelectButtonView ()

@property (nonatomic, strong) UIView * separatorView;
@property (nonatomic, strong)UIView *separatationLineView;

@end

@implementation TopSelectButtonView

- (instancetype)initWithType:(int)type{
    if (self = [super init]) {
        self.separatorView = [UIView new];
        self.separatorView.backgroundColor = [UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1.0];
        [self addSubview:self.separatorView];
        [self addSubview:self.leftsideButton];
        [self addSubview:self.rightsideButton];
        [self addSubview:self.separatationLineView];
        
        self.leftsideButton.sd_layout.leftEqualToView(self).widthIs(flexibleWidth(WIDTH / 2)).heightIs(flexibleHeight(40)).topEqualToView(self);
        self.rightsideButton.sd_layout.rightEqualToView(self).widthIs(flexibleWidth(WIDTH / 2)).heightIs(flexibleHeight(40)).topEqualToView(self.leftsideButton);
        if (type == 1) {
            [self.rightsideButton setTitle:@"发起的活动" forState:UIControlStateNormal];
            [self.leftsideButton setTitle:@"参加的活动" forState:UIControlStateNormal];
        }
        else{
            [self.rightsideButton setTitle:@"收藏的游记" forState:UIControlStateNormal];
            [self.leftsideButton setTitle:@"收藏的活动" forState:UIControlStateNormal];
        }
        
        self.separatorView.sd_layout.leftEqualToView(self).topSpaceToView(self.leftsideButton,0).rightEqualToView(self).heightIs(flexibleHeight(5));
        
        self.separatationLineView.sd_layout.centerXIs(flexibleWidth(WIDTH / 4)).heightIs(flexibleHeight(2)).widthIs(flexibleWidth(375 / 2)).topSpaceToView(self.leftsideButton, 0);
        
        UIView *line  = [UIView new];
        line.backgroundColor = [UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1.0];
        [self addSubview:line];
        line.sd_layout.leftSpaceToView(self,flexibleWidth(WIDTH / 2)).heightIs(1).topSpaceToView(self, 2).heightIs(flexibleHeight(36)).widthIs(flexibleWidth(1));
 
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
            [self.separatationLineView updateLayout];
             [self updateLayout];
        }];
    }
    if (self.delegate &&[self.delegate respondsToSelector:@selector(clickButton:)]) {
        [self.delegate clickButton:sender];
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
