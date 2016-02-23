//
//  ControllerManager.h
//  Deep_Breath
//
//  Created by rimi on 15/9/16.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "DrawerViewController.h"
#import "LcTabarViewController.h"
#import "LeftViewController.h"
@interface ControllerManager : NSObject
@property (nonatomic ,strong)UINavigationController *rootViewController;
@property (nonatomic, strong)LcTabarViewController *mainViewController;
@property (nonatomic, strong)DrawerViewController *drawerViewController;
+ (ControllerManager *)shareControllerManager;
@end
