//
//  JoinInCell.h
//  与你同游
//
//  Created by Zgmanhui on 16/3/17.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JoinInCell : UITableViewCell
@property (nonatomic, strong) BmobObject *model;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) void (^replayBlock)(NSIndexPath *indexPath);
@property (nonatomic, assign) BOOL isMemeber;
@property (nonatomic, strong) void (^pDetailBlock)(BmobObject *user);
/**
 *  是否显示后面的同意按钮
 */
- (void)isText;
- (void)member;
- (void)deleteMemeber;
@end
