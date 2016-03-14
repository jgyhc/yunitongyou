//
//  Called.h
//  与你同游
//
//  Created by Zgmanhui on 16/2/19.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
@interface Called : BmobObject
@property (nonatomic, strong) NSString *calledId;
@property (nonatomic, strong) NSString *point_departure;//起点
@property (nonatomic, strong) NSString *destination;//终点
@property (nonatomic, strong) NSString *content;//内容
@property (nonatomic, strong) NSString *title;//主题
@property (nonatomic, strong) User *master;//发起者
@property (nonatomic, strong) NSArray *memberArray;//成员  User
@property (nonatomic, strong) NSArray *signUpArray;//报名的人 User
@property (nonatomic, assign) NSInteger numberFollower;//跟团人数
@property (nonatomic, strong) NSString *startTime;//出发时间
@property (nonatomic, strong) NSString *endTime;//到达时间
@property (nonatomic, strong) NSArray *imageArray;//发起的图片数组
@property (nonatomic, strong) NSString *phoneNumber;//联系电话
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
+ (void)getcalledListSuccess:(void (^)(NSArray *calleds))success failure:(void (^)(NSError *error1))failure;
@end
