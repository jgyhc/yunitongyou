//
//  LBottomView.h
//  与你同游
//
//  Created by Zgmanhui on 16/3/23.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LBottomViewDelegate <NSObject>

- (void)joinCalled;

- (void)commentCalled;

- (void)thumUpCalled;

@end

@interface LBottomView : UIView
- (void)updateImage:(NSString *)thumbImg;
@property (nonatomic, assign) id<LBottomViewDelegate> delegate;
@end
