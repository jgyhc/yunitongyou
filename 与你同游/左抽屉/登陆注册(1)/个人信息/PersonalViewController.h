//
//  TestViewController.h
//  与你同游
//
//  Created by rimi on 15/10/24.
//  Copyright © 2015年 LiuCong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserModel.h"
@interface PersonalViewController : UIViewController

@property (nonatomic, strong) UserModel *user;

@property (nonatomic, strong) UIImageView * headPortrait;//头像
@end
