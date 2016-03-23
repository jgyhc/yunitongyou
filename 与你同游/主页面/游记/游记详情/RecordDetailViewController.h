//
//  RecordDetailViewController.h
//  viewController
//
//  Created by rimi on 15/10/16.
//  Copyright (c) 2015年 ouyang. All rights reserved.
//

#import "BaseViewController.h"
#import <BmobSDK/Bmob.h>
@interface RecordDetailViewController : BaseViewController

@property (nonatomic, strong) BmobObject * travelObject;

@property (nonatomic, strong) BmobObject * userObject;

@end
