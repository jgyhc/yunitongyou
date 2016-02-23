//
//  DrawerViewController.h
//  Deep_Breath
//
//  Created by rimi on 15/9/15.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawerViewController : UIViewController
/**
 *  页面加载
 *
 *  @param mainViewController 主视图
 *  @param leftViewController 左视图
 *
 *  @return 
 */
- (instancetype)initWithMainViewControlle:(UIViewController *)mainViewController leftViewController:(UIViewController *) leftViewController;
- (void)openLeftViewController;
- (void)closeLeftViewController;
@end
