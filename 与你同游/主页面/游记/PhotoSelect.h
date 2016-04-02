//
//  SharedView.h
//  与你同游
//
//  Created by rimi on 15/10/16.
//  Copyright © 2015年 LiuCong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoSelectDelegate <NSObject>

- (void)buttonClick:(UIButton *)sender;

@end

@interface PhotoSelect : UIView

@property (nonatomic,strong) UIButton * maskButton;

@property (nonatomic,strong) UIView * selectView;
@property (nonatomic,strong) UIView * firstSubView;

@property (nonatomic,strong) UITextView * textView;

@property (nonatomic, assign) id<PhotoSelectDelegate>delegate;

- (void)handlePress;


@end
