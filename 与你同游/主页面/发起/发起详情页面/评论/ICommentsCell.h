//
//  ICommentsCell.h
//  与你同游
//
//  Created by Zgmanhui on 16/3/17.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICommentsCell : UITableViewCell
@property (nonatomic, strong) BmobObject *model;

@property (nonatomic, strong) void (^replayBlock)(NSIndexPath *indexPath);
@property (nonatomic, strong) NSIndexPath *indexPath;
@end
