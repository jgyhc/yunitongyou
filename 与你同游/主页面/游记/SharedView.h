//
//  SharedView.h
//  与你同游
//
//  Created by rimi on 15/10/16.
//  Copyright © 2015年 LiuCong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SharedView : UIView

@property (nonatomic,strong) UIButton * maskButton;

//分享
@property (nonatomic,strong) UIView * shareView;
@property (nonatomic,strong) UIView * selectView;
@property (nonatomic,strong) UIView * firstSubView;

//导入照片
@property (nonatomic,strong) UITextView * textView;
@property (nonatomic,strong) UIButton * importPhotoButton;
@property (nonatomic,strong) UIImageView * photoImageView;

@property (nonatomic,strong) UIView * inputView;
@property (nonatomic,strong) UITextView * inputText;
@property (nonatomic,strong) UIButton * conmmentButton;

- (void)handlePress;


@end
