//
//  LaunchTableViewCell.h
//  viewController
//
//  Created by rimi on 15/10/12.
//  Copyright (c) 2015年 ouyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BmobSDK/Bmob.h>
typedef void (^collection)(int type);
@interface LaunchTableViewCell : UITableViewCell
@property (nonatomic, strong) BmobObject *obj;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)buttonCollection:(collection)collectionBlock;
@end
