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
@end
