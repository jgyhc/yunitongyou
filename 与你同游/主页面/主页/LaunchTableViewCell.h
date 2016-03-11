//
//  LaunchTableViewCell.h
//  viewController
//
//  Created by rimi on 15/10/12.
//  Copyright (c) 2015年 ouyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaunchTableViewCell : UITableViewCell

- (void)PositionTheReset;
/**
 *  上部文字
 *
 *  @param image      头像
 *  @param userID     用户ID
 *  @param userLV     用户等级
 *  @param launchTime 发起时间
 *  @param launchDate 发起日期
 */
- (void)initUserHeaderImage:(UIImage *)image userID:(NSString *)userID userLV:(NSString *)userLV launchTime:(NSString *)launchTime launchDate:(NSString *)launchDate;

/**
 *  中部文字
 *
 *  @param departure   出发地
 *  @param destination 目的地
 *  @param starting    出发时间
 *  @param reture      返程时间
 *  @param info        简介
 */
- (void)initDeparture:(NSString *)departure destination:(NSString *)destination starting:(NSString *)starting reture:(NSString *)reture info:(NSString *)info;

/**
 *  下部文字
 *
 *  @param save     收藏人数
 *  @param comment  评论人数
 *  @param follower 跟团人数
 */
- (void)initSave:(NSString *)save comment:(NSString *)comment follower:(NSString *)follower;


@end
