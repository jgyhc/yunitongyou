//
//  TopSelectButtonView.h
//  与你同游
//
//  Created by mac on 16/4/2.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopSelectButtonViewDelegate <NSObject>

- (void)clickButton:(UIButton *)sender;

@end

@interface TopSelectButtonView : UIView

@property (nonatomic, strong)UIButton *leftsideButton;
@property (nonatomic, strong)UIButton *rightsideButton;
- (instancetype)initWithType:(int)type;
@property (nonatomic, assign) id<TopSelectButtonViewDelegate> delegate;

@end
