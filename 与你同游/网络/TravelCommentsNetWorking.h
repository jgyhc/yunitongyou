//
//  TravelCommentsNetWorking.h
//  BmobSDK网络测试
//
//  Created by rimi on 15/10/15.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>
@interface TravelCommentsNetWorking : NSObject

//- (void)ObtainATravelAllOfTheCommentsWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password travel_date:(NSString *)travel_date successBlock:(void(^)(NSArray *array))success failBlock:(void(^)(NSError * error))fail;
/**
 *  创一条游记评论
 *
 *  @param phoneNumber        评论者的电话
 *  @param password           评论者的密码
 *  @param travel_date        游记创建时间
 *  @param creatorPhoneNumber 创建者的电话号码
 *  @param contents           内容
 *  @param success            成功
 *  @param fail               失败
 */
- (void)createATravelReviewsWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password travel_date:(NSString *)travel_date creatorPhoneNumber:(NSString *)creatorPhoneNumber contents:(NSString *)contents successBlock:(void(^)(NSString *objectId))success failBlock:(void(^)(NSError * error))fail;

//- (void)CreateAtravelCommentToCommentWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password travel_date:(NSString *)travel_date creatorPhoneNumber:(NSString *)creatorPhoneNumber contents:(NSString *)contents successBlock:(void(^)(NSString *objectId))success failBlock:(void(^)(NSError * error))fail;



/**
 *  查找一个游记的评论列表
 *
 *  @param phoneNumber 电话
 *  @param password    密码
 *  @param travel_date 创建游记的时间
 *  @param success
 *  @param fail
 */
- (void)findTravelCommentsWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password travel_date:(NSString *)travel_date successBlock:(void(^)(NSArray *commentsArray))success failBlock:(void(^)(NSError * error))fail;

/**
 *  查找一条游记的一条评论  （通过评论创建时间）
 *
 *  @param phoneNumber          电话
 *  @param password             密码
 *  @param travel_date          游记创建时间
 *  @param travel_comments_time 评论时间
 *  @param success
 *  @param fail
 */
- (void)findTravelCommentWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password travel_date:(NSString *)travel_date travel_comments_time:(NSString *)travel_comments_time successBlock:(void(^)(BmobObject *comment))success failBlock:(void(^)(NSError * error))fail;
/**
 *  查找到评发送者
 *
 *  @param phoneNumber          电话
 *  @param password             密码
 *  @param travel_date          游记时间
 *  @param travel_comments_time 评论时间
 *  @param success
 *  @param fail
 */
- (void)findTravelCommentSpearkerWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password travel_date:(NSString *)travel_date travel_comments_time:(NSString *)travel_comments_time userType:(NSString *)userType successBlock:(void(^)(BmobObject *userObject))success failBlock:(void(^)(NSError * error))fail;
/**
 *  创建一条回复()  游记就是他本人的  回复别人的评论
 * 
 *  @param phoneNumber          回复创建者电话
 *  @param password             密码
 *  @param CTphoneNumber        评论创建者电话
 *  @param travel_date          游记日期
 *  @param travel_comments_time 评论时间
 *  @param replyContents        回复内容
 *  @param success              
 *  @param fail
 */
- (void)CreateTravelCommentReplyWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password CTphoneNumber:(NSString *)CTphoneNumber travel_date:(NSString *)travel_date travel_comments_time:(NSString *)travel_comments_time replyContents:(NSString *)replyContents successBlock:(void(^)(NSString *replyContentsId))success failBlock:(void(^)(NSError * error))fail;
/**
 *  创建一条回复的回复  游记不是他的  他评论了  游记创建者回复了 他回复他的回复的操作
 *
 *  @param phoneNumber          电话
 *  @param password             密码
 *  @param CTphoneNumber        游记创建者的电话
 *  @param travel_date          游记时间
 *  @param travel_comments_time 评论时间
 *  @param replyContents        回复的内容
 *  @param success
 *  @param fail
 */
- (void)CreateTravelReplyReplyWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password CTphoneNumber:(NSString *)CTphoneNumber travel_date:(NSString *)travel_date travel_comments_time:(NSString *)travel_comments_time replyContents:(NSString *)replyContents successBlock:(void(^)(NSString *replyContentsId))success failBlock:(void(^)(NSError * error))fail;
/**
 *  点赞
 *
 *  @param phoneNumber   电话（点赞人的）
 *  @param password      密码
 *  @param CTphoneNumber 游记主人的电话
 *  @param travel_date   游记时间
 *  @param success
 *  @param fail
 */
- (void)ThumbUpWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password CTphoneNumber:(NSString *)CTphoneNumber travel_date:(NSString *)travel_date successBlock:(void(^)(NSString *thumb_upResults))success failBlock:(void(^)(NSError * error))fail;
/**
 *  获取点赞数
 *
 *  @param phoneNumber 电话（游记主人）
 *  @param travel_date 游记时间
 *  @param success
 *  @param fail
 */
- (void)getThumUpWithPhoneNumber:(NSString *)phoneNumber travel_date:(NSString *)travel_date successBlock:(void(^)(int thumbupNumber))success failBlock:(void(^)(NSError * error))fail;

@end
