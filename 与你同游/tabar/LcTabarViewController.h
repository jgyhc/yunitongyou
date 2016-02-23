//
//  LcTabarViewController.h
//  Deep_Breath
//
//  Created by rimi on 15/9/15.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LcTabarViewController : UIViewController

@property (nonatomic, assign)NSInteger selectedIndex;
/**
 *  初始化
 *
 *  @param viewControllers viewControllers
 *  @param baritemImages   barItemImages//所有标签的图片
 *
 *  @return self
 */

- (instancetype)initWithViewControllers:(NSArray *)viewControllers barItemImages:(NSArray *)baritemImages;
- (instancetype)initWithViewControllers:(NSArray *)viewControllers;
@end
