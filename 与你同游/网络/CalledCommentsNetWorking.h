//
//  CalledCommentsNetWorking.h
//  BmobSDK网络测试
//
//  Created by rimi on 15/10/18.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>
@interface CalledCommentsNetWorking : NSObject
/**
 *  创建一条发起的评论
 *
 *  @param phoneNumber        电话（评论人）
 *  @param password           密码
 *  @param called_date        发起创建时间
 *  @param creatorPhoneNumber 发起  的电话
 *  @param contents           内容
 *  @param success            成功
 *  @param fail               失败
 */
- (void)CreateCalledCommentsWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password called_date:(NSString *)called_date creatorPhoneNumber:(NSString *)creatorPhoneNumber contents:(NSString *)contents successBlock:(void(^)(NSString *objectId))success failBlock:(void(^)(NSError * error))fail;
/**
 *  查询一个发起的评论列表
 *
 *  @param phoneNumber 电话
 *  @param password    密码
 *  @param called_date 发起时间
 *  @param success
 *  @param fail
 */
- (void)findCalledCommentsWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password called_date:(NSString *)called_date successBlock:(void(^)(NSArray *commentsArray))success failBlock:(void(^)(NSError * error))fail;

/**
 *  查找一条发起的评论
 *
 *  @param phoneNumber          电话
 *  @param password             密码
 *  @param travel_date          发起时间
 *  @param travel_comments_time 评论时间
 *  @param success
 *  @param fail
 */
- (void)findCalledCommentWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password called_date:(NSString *)called_date called_comments_time:(NSString *)called_comments_time successBlock:(void(^)(BmobObject *comment))success failBlock:(void(^)(NSError * error))fail;
/**
 *  创建一条回复（发起的就是他的）
 *
 *  @param phoneNumber          电话
 *  @param password             密码
 *  @param CTphoneNumber        电话（评论者）
 *  @param called_date          发起时间
 *  @param called_comments_time 发起评论的时间
 *  @param replyContents        回复内容
 *  @param success
 *  @param fail
 */
- (void)CreateCalledCommentReplyWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password CTphoneNumber:(NSString *)CTphoneNumber called_date:(NSString *)called_date called_comments_time:(NSString *)called_comments_time replyContents:(NSString *)replyContents successBlock:(void(^)(NSString *replyContentsId))success failBlock:(void(^)(NSError * error))fail;


/**
 *  创建一条回复的回复
 *
 *  @param phoneNumber          电话
 *  @param password             密码
 *  @param CTphoneNumber        电话（发起者）
 *  @param Called_date          发起时间
 *  @param Called_comments_time 发起评论的时间
 *  @param replyContents        回复内容
 *  @param success
 *  @param fail
 */
- (void)CreateCalledReplyReplyWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password CTphoneNumber:(NSString *)CTphoneNumber Called_date:(NSString *)Called_date Called_comments_time:(NSString *)Called_comments_time replyContents:(NSString *)replyContents successBlock:(void(^)(NSString *replyContentsId))success failBlock:(void(^)(NSError * error))fail;










@end
