//
//  CalledModel.h
//  BmobSDK网络测试
//
//  Created by rimi on 15/10/19.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalledModel : NSObject
@property (nonatomic, copy, readonly) NSString *addActivitiesResult;
@property (nonatomic, strong) NSMutableArray *calledArray;
@property (nonatomic, strong) NSMutableArray *userArray;
/**
 *  添加一个发起
 *
 *  @param phoneNumber    电话
 *  @param password       密码
 *  @param title          主题
 *  @param origin         起点
 *  @param destination    目的地
 *  @param departureTime  出发时间
 *  @param arrivalTime    到达时间
 *  @param NumberOfPeople 人数
 *  @param content        内容
 *  @param image          图片
 */
- (void)AddCalledWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password title:(NSString *)title origin:(NSString *)origin destination:(NSString *)destination departureTime:(NSString *)departureTime arrivalTime:(NSString *)arrivalTime NumberOfPeople:(NSNumber *)NumberOfPeople content:(NSString *)content image:(NSData *)image;

/**
 *  修改一条发起
 *
 *  @param phoneNumber    电话
 *  @param called_date    发起创建时间
 *  @param password       密码
 *  @param title          主题
 *  @param origin         起点
 *  @param destination    目的地
 *  @param departureTime  出发时间
 *  @param arrivalTime    到达时间
 *  @param NumberOfPeople 人数
 *  @param content        内容
 *  @param image          图片
 */
- (void)ChangeCalledWithPhoneNumber:(NSString *)phoneNumber called_date:(NSString *)called_date password:(NSString *)password title:(NSString *)title origin:(NSString *)origin destination:(NSString *)destination departureTime:(NSString *)departureTime arrivalTime:(NSString *)arrivalTime NumberOfPeople:(NSNumber *)NumberOfPeople content:(NSString *)content image:(NSData *)image;

/**
 *  查找一个用户的发起列表
 *
 *  @param phoneNumber 电话
 *  @param password    密码
 */
- (void)FindCalledWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password;

/**
 *  查找用户的一条发起、通过时间
 *
 *  @param phoneNumber 电话
 *  @param password    密码
 *  @param called_date 创建时间
 */
- (void)queryCalledWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password called_date:(NSString *)called_date;

/**
 *  删除一条发起
 *
 *  @param phoneNumber 电话
 *  @param password    密码
 *  @param called_date 创建时间
 */
- (void)DeleteCalledWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password called_date:(NSString *)called_date;

/**
 *  创建一条发起的评论
 *
 *  @param phoneNumber        电话（评论人）
 *  @param password           密码
 *  @param called_date        发起创建时间
 *  @param creatorPhoneNumber 发起  的电话
 *  @param contents           内容
 */
- (void)CreateCalledCommentsWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password called_date:(NSString *)called_date creatorPhoneNumber:(NSString *)creatorPhoneNumber contents:(NSString *)contents;

/**
 *  查询一个发起的评论列表
 *
 *  @param phoneNumber 电话
 *  @param password    密码
 *  @param called_date 发起时间
 */
- (void)findCalledCommentsWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password called_date:(NSString *)called_date;

/**
 *  查找一条发起的评论
 *
 *  @param phoneNumber          电话
 *  @param password             密码
 *  @param travel_date          发起时间
 *  @param travel_comments_time 评论时间
 */
- (void)findCalledCommentWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password called_date:(NSString *)called_date called_comments_time:(NSString *)called_comments_time;

/**
 *  创建一条回复（发起的就是他的）
 *
 *  @param phoneNumber          电话
 *  @param password             密码
 *  @param CTphoneNumber        电话（评论者）
 *  @param called_date          发起时间
 *  @param called_comments_time 发起评论的时间
 *  @param replyContents        回复内容
 */
- (void)CreateCalledCommentReplyWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password CTphoneNumber:(NSString *)CTphoneNumber called_date:(NSString *)called_date called_comments_time:(NSString *)called_comments_time replyContents:(NSString *)replyContents;

/**
 *  创建一条回复的回复
 *
 *  @param phoneNumber          电话
 *  @param password             密码
 *  @param CTphoneNumber        电话（发起者）
 *  @param Called_date          发起时间
 *  @param Called_comments_time 发起评论的时间
 *  @param replyContents        回复内容
 */
- (void)CreateCalledReplyReplyWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password CTphoneNumber:(NSString *)CTphoneNumber Called_date:(NSString *)Called_date Called_comments_time:(NSString *)Called_comments_time replyContents:(NSString *)replyContents;

- (void)queryTheCalledlList;


@end
