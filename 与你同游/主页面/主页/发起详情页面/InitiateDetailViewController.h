//
//  InitiateDetailViewController.h
//  与你同游
//
//  Created by rimi on 15/10/20.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "BaseViewController.h"
#import <BmobSDK/Bmob.h>
@interface InitiateDetailViewController : BaseViewController
@property (nonatomic, strong) BmobObject *userObject;
@property (nonatomic, strong) BmobObject *calledObject;
@end
