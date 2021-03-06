//
//  Called.h
//  与你同游
//
//  Created by Zgmanhui on 16/2/19.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Called : BmobObject

/**
 *  添加一个发起
 *
 *  @param userID         用户ID
 *  @param title          主题
 *  @param origin         起点
 *  @param destination    目的地
 *  @param departureTime  出发时间
 *  @param arrivalTime    到达时间
 *  @param NumberOfPeople 人数
 *  @param content        内容
 *  @param image          图片
 */
+ (void)AddCalledWithTitle:(NSString *)title origin:(NSString *)origin destination:(NSString *)destination departureTime:(NSString *)departureTime arrivalTime:(NSString *)arrivalTime NumberOfPeople:(NSNumber *)NumberOfPeople content:(NSString *)content Success:(void (^)(NSString *calledID))success failure:(void (^)(NSError *error))failure;

//查询活动列表（包括user字段下包含的作者信息）（未测试）
+ (void)getcalledListWithLimit:(NSInteger)limit skip:(NSInteger)skip Success:(void (^)(NSArray *calleds))success failure:(void (^)(NSError *error1))failure;


/**
 *  所有活动
 *
 *  @param limit
 *  @param skip
 *  @param success
 *  @param failure
 */
+ (void)getCalledsLimit:(NSInteger)limit skip:(NSInteger)skip Success:(void (^)(NSArray *calleds))success failure:(void (^)(NSError *error))failure;

/**
 *  查询一条发起的所有评论
 *
 *  @param limit    最大条数
 *  @param skip     跳到多少条
 *  @param calledID id
 *  @param success
 *  @param failure  
 */
+ (void)getCommentsWithLimit:(NSInteger)limit skip:(NSInteger)skip type:(int)type CalledsID:(NSString *)calledID Success:(void (^)(NSArray *commentArray))success failure:(void (^)(NSError *error1))failure;

/**
 *  参加一条发起
 *
 *  @param calledID 发起ID
 *  @param success
 *  @param failure
 */
+ (void)joinInCalledWithCalledID:(NSString *)calledID Success:(void (^)(BOOL isSuccess))success failure:(void (^)(NSError *error))failure;

/**
 *  查询一条发起报名的人
 *
 *  @param limit    最大条数
 *  @param skip     跳到多少条
 *  @param calledID id
 *  @param success
 *  @param failure  
 */
+ (void)getJoinWithLimit:(NSInteger)limit skip:(NSInteger)skip CalledsID:(NSString *)calledID Success:(void (^)(NSArray *commentArray))success failure:(void (^)(NSError *error1))failure ;

/**
 *  查询用户的发起
 *
 *  @param limit   条数
 *  @param skip    跳到多少条
 *  @param success
 *  @param failure
 */
+ (void)queryCalledsLimit:(NSInteger)limit skip:(NSInteger)skip Success:(void (^)(NSArray* calleds))success failure:(void (^)(NSError *error))failure ;

/**
 *  邀请以为报名真加入
 *
 *  @param userID   被邀请者的ID
 *  @param calledID 发起ID
 *  @param success
 *  @param failure  
 */
+ (void)inviteJoinUserId:(NSString *)userID calledID:(NSString *)calledID Success:(void (^)(BOOL isSuccess))success failure:(void (^)(NSError *error))failure;

/**
 *  删除一个成员
 *
 *  @param userID   userID
 *  @param calledID 发起id
 *  @param success
 *  @param failure  
 */
+ (void)deleteJoinUserID:(NSString *)userID calledID:(NSString *)calledID Success:(void (^)(BOOL isSuccess))success failure:(void (^)(NSError *error))failure;
/**
 *  查询一条发起的成员列表
 *
 *  @param limit
 *  @param skip
 *  @param calledID
 *  @param success
 *  @param failure  
 */
+ (void)getMemeberWithCalledsID:(NSString *)calledID Success:(void (^)(NSArray *commentArray))success failure:(void (^)(NSError *error1))failure;

@end
