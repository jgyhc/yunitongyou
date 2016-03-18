//
//  BottomButtonsView.h
//  与你同游
//
//  Created by Zgmanhui on 16/2/22.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BottomButtonsViewDelegate <NSObject>

- (void)handldTapEvent:(UITapGestureRecognizer *)sender;

@end

@interface BottomButtonsView : UIView
- (void)updateImage:(NSArray *)imageArray label:(NSArray *)lableString;
@property (nonatomic, assign) id <BottomButtonsViewDelegate>delegate;
@end
