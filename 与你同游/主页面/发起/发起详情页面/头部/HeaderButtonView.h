//
//  HeaderButtonView.h
//  与你同游
//
//  Created by Zgmanhui on 16/3/21.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeaderButtonViewDelegate <NSObject>

- (void)buttonClickEvent:(UIButton *)sender;
@end

@interface HeaderButtonView : UIView
@property (nonatomic, strong)UIButton *leftsideButton;
@property (nonatomic, strong)UIButton *rightsideButton;
- (instancetype)initWithType:(int)type;
@property (nonatomic, assign) id<HeaderButtonViewDelegate> delegate;
@end
