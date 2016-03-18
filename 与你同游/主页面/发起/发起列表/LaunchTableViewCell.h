//
//  LaunchTableViewCell.h
//  viewController
//
//  Created by rimi on 15/10/12.
//  Copyright (c) 2015年 ouyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BmobSDK/Bmob.h>
@interface LaunchTableViewCell : UITableViewCell
@property (nonatomic, strong) BmobObject *obj;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) void (^ThumbUpBlock)(NSIndexPath *indexPath);
@end
