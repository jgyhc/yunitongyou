//
//  SharedView.m
//  与你同游
//
//  Created by rimi on 15/10/16.
//  Copyright © 2015年 LiuCong. All rights reserved.
//

#import "PhotoSelect.h"

@interface PhotoSelect ()<UITextViewDelegate>

@property (nonatomic,strong) UILabel * label;

@end

@implementation PhotoSelect

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initializedApperance];
    }
    return self;
}

- (void)initializedApperance{
    
    [self addSubview:self.selectView];
    [self.selectView addSubview:self.firstSubView];
    [self initImportPhotoView];
    
    
}


- (void)initImportPhotoView{
    NSArray * array = @[@"从图库中选择",@"拍照",@"取消"];
    for (int i = 0; i < 3; i ++) {
        UIButton * button = [[UIButton alloc]initWithFrame:flexibleFrame(CGRectMake(0, i * 40, 355, 40), NO)];
        if (i == 2) {
            button.frame = flexibleFrame(CGRectMake(0, 90, 355, 40), NO);
            button.backgroundColor = [UIColor colorWithRed:0.439 green:0.957 blue:0.788 alpha:1.000];
            button.layer.cornerRadius = 5;
        }
        button.tag = 100 + i;
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.selectView addSubview:button];
        
    }
    UIView * lineView = [[UIView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 40, 355, 0.5),NO)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.selectView addSubview:lineView];
}

- (void)handleClick:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonClick:)]) {
        [self.delegate buttonClick:sender];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    self.label.hidden = YES;
    
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        self.label.hidden = NO;
    }
}



#pragma mark --lazy loading

-(UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:flexibleFrame(CGRectMake(10,65, 360, 100), NO)];
        
        _textView.showsVerticalScrollIndicator = NO;
        _textView.textColor = [UIColor grayColor];
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.delegate = self;
        
        self.label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(10, 10, 260, 20), NO)];
        self.label.textColor = [UIColor colorWithWhite:0.666 alpha:1.000];
        self.label.font = [UIFont systemFontOfSize:14];
        self.label.text = @"哟,记录一下呗...";
        self.label.hidden = NO;
        
        [_textView addSubview:self.label];
    }
    return _textView;
}


- (UIView *)selectView{
    
    if (!_selectView) {
        _selectView = ({
            UIView * view = [[UIView alloc]initWithFrame:flexibleFrame(CGRectMake(10, 667, 355, 140), NO)];
            view.backgroundColor = [UIColor clearColor];
            view;
        });
    }
    return _selectView;
}

- (UIView *)firstSubView{
    if (!_firstSubView) {
        _firstSubView = ({
            UIView * view = [[UIView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 355, 80), NO)];
            view.backgroundColor = [UIColor colorWithRed:0.439 green:0.957 blue:0.788 alpha:1.000];
            view.layer.cornerRadius = 5;
            view;
        });
    }
    return _firstSubView;
}


- (UIButton *)maskButton{
    if (!_maskButton) {
        _maskButton = [[UIButton alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 375, 667), NO)];
        _maskButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [_maskButton addTarget:self action:@selector(handlePress) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maskButton;
}

- (void)handlePress{
    [self.maskButton removeFromSuperview];
    [UIView animateWithDuration:0.3 animations:^{
        self.selectView.frame = flexibleFrame(CGRectMake(10,667, 355, 140), NO);
        
    }];
}



@end
