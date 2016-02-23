//
//  SharedView.m
//  与你同游
//
//  Created by rimi on 15/10/16.
//  Copyright © 2015年 LiuCong. All rights reserved.
//

#import "SharedView.h"

#define  BUTTON_TAG 100

@interface SharedView ()<UITextViewDelegate>

@property (nonatomic,strong) UILabel * label;

@end

@implementation SharedView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initializedApperance];
    }
    return self;
}

- (void)initializedApperance{
    [self addSubview:self.shareView];
    [self initButton];
    
    [self addSubview:self.selectView];
    //    [self addSubview:self.importPhotoButton];
    [self.selectView addSubview:self.firstSubView];
    
    [self initImportPhotoView];
    [self addSubview:self.inputView];
    [self.inputView addSubview:self.inputText];
    [self.inputView addSubview:self.conmmentButton];
    
    
}

- (void)initButton{
    
    NSArray * imageArray = @[@"qq.png",@"weibo.png",@"weixin.png"];
    NSArray * titleArray = @[@"QQ",@"微博",@"微信"];
    for (int i = 0; i < 3; i ++) {
        UIButton * button = [[UIButton alloc]initWithFrame:flexibleFrame(CGRectMake(55 + 110 * i, 5, 50, 60), NO)];
        [self.shareView addSubview:button];
        
        UIImageView * ImageView = [[UIImageView alloc]initWithFrame:flexibleFrame(CGRectMake(5, 0, 40,40), NO)];
        ImageView.image = IMAGE_PATH(imageArray[i]);
        [button addSubview:ImageView];
        
        UILabel * label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(10, 43, 40, 10), NO)];
        label.text = titleArray[i];
        label.font = [UIFont systemFontOfSize:14];
        button.tag = BUTTON_TAG + i;
        [button addTarget:self action:@selector(handleShared:) forControlEvents:UIControlEventTouchUpInside];
        [button addSubview:label];
        
    }
    
    UIButton * cancelButton = [[UIButton alloc]initWithFrame:flexibleFrame(CGRectMake(0, 66, 375, 34), NO)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(handleCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:cancelButton];
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
        button.tag = 200 + i;
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.selectView addSubview:button];
        
    }
    UIView * lineView = [[UIView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 40, 355, 0.5),NO)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.selectView addSubview:lineView];
}

- (void)handleShared:(UIButton *)sender{
    NSLog(@"分享");
}

- (void)handleCancel{
    [self handlePress];
}

- (void)handleDelete{
    
    [self.photoImageView removeFromSuperview];
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


- (UIView *)shareView{
    if (!_shareView) {
        _shareView = [[UIImageView alloc]initWithFrame:flexibleFrame(CGRectMake(0,667, 375, 100), NO)];
        _shareView.backgroundColor = [UIColor colorWithRed:0.439 green:0.957 blue:0.788 alpha:1.000];
        _shareView.userInteractionEnabled = YES;
        
        UIView * view = [[UIView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 65, 375, 1), NO)];
        view.backgroundColor = [UIColor whiteColor];
        
        [_shareView addSubview:view];
        
    }
    return _shareView;
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

- (UIButton *)importPhotoButton{
    if (!_importPhotoButton) {
        _importPhotoButton = ({
            
            UIButton * button = [[UIButton alloc]initWithFrame:flexibleFrame(CGRectMake(30, 175, 80, 80), NO)];
            [button setBackgroundImage:IMAGE_PATH(@"添加相片.png") forState:UIControlStateNormal];
            button.backgroundColor = [UIColor whiteColor];
            
            button;
        });
    }
    return _importPhotoButton;
}

- (UIImageView *)photoImageView{
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc]initWithFrame:flexibleFrame(CGRectMake(30, 175, 80, 80), NO)];
        _photoImageView.layer.cornerRadius = 5;
        _photoImageView.clipsToBounds = YES;
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleDelete)];
        longPress.minimumPressDuration = 2;
        [_photoImageView addGestureRecognizer:longPress];
        _photoImageView.userInteractionEnabled = YES;
        
    }
    return _photoImageView;
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
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.shareView.frame = flexibleFrame(CGRectMake(0,667, 375, 100), NO);
        
    }];
    [UIView animateWithDuration:0.5 animations:^{
        
        self.selectView.frame = flexibleFrame(CGRectMake(10,667, 355, 140), NO);
        
    }];
}


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
