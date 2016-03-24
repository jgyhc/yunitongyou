//
//  CommentView.m
//  与你同游
//
//  Created by mac on 16/3/24.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import "CommentView.h"

@interface CommentView ()<UITextViewDelegate>


@end

@implementation CommentView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initializedApperance];
    }
    return self;
}

- (void)initializedApperance{
    [self addSubview:self.inputView];
    [self.inputView addSubview:self.inputText];
    [self.inputView addSubview:self.conmmentButton];
    
    
}

#pragma mark --lazy loading
- (UIView *)inputView{
    if (!_inputView) {
        _inputView = ({
            
            UIView * view = [[UIView alloc]init];
            view.backgroundColor = [UIColor colorWithRed:0.224 green:0.946 blue:0.830 alpha:1.000];
            view.frame = flexibleFrame(CGRectMake(0, 667, 375,40), NO);
            
            view;
        });
    }
    return _inputView;
}

- (UITextView *)inputText{
    if (!_inputText) {
        _inputText = ({
            UITextView * textView = [[UITextView alloc]initWithFrame:CGRectMake(20,5, 280,30)];
            textView.textColor = [UIColor blackColor];
            textView.delegate = self;
            textView.layer.cornerRadius = 5;
            textView.font = [UIFont systemFontOfSize:17];
            textView;
        });
    }
    return _inputText;
}
- (UIButton *)conmmentButton{
    if (!_conmmentButton) {
        _conmmentButton = ({
            
            UIButton * button = [[UIButton alloc]initWithFrame:flexibleFrame(CGRectMake(310, 9,40,30), NO)];
            [button setTitle:@"发送" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            button.backgroundColor = [UIColor whiteColor];
            [button setTitleColor:[UIColor colorWithWhite:0.400 alpha:1.000] forState:UIControlStateNormal];
            button.layer.cornerRadius = 10;
            
            button;
        });
    }
    return _conmmentButton;
}

@end
