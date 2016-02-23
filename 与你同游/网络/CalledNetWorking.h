//
//  CalledNetWorking.h
//  BmobSDK网络测试
//
//  Created by rimi on 15/10/14.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>
@interface CalledNetWorking : NSObject

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
 *  @param success        成功
 *  @param fail           失败
 */
- (void)AddCalledWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password title:(NSString *)title origin:(NSString *)origin destination:(NSString *)destination departureTime:(NSString *)departureTime arrivalTime:(NSString *)arrivalTime NumberOfPeople:(NSNumber *)NumberOfPeople content:(NSString *)content image:(NSData *)image successBlock:(void(^)(NSString *objiectId))success failBlock:(void(^)(NSError * error))fail;

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
 *  @param success        成功
 *  @param fail           失败
 */
- (void)ChangeCalledWithPhoneNumber:(NSString *)phoneNumber called_date:(NSString *)called_date password:(NSString *)password title:(NSString *)title origin:(NSString *)origin destination:(NSString *)destination departureTime:(NSString *)departureTime arrivalTime:(NSString *)arrivalTime NumberOfPeople:(NSNumber *)NumberOfPeople content:(NSString *)content image:(NSData *)image successBlock:(void(^)(NSString *objiectId))success failBlock:(void(^)(NSError * error))fail;
/**
 *  查找一个用户的发起列表
 *
 *  @param phoneNumber 电话
 *  @param password    密码
 *  @param success     成功
 *  @param fail        失败
 */
- (void)FindCalledWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password successBlock:(void(^)(NSArray *array))success failBlock:(void(^)(NSError * error))fail;

/**
 *  查找用户的一条发起、通过时间
 *
 *  @param phoneNumber 电话
 *  @param password    密码
 *  @param called_date 创建时间
 *  @param success     成功
 *  @param fail        失败
 */
- (void)queryCalledWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password called_date:(NSString *)called_date successBlock:(void(^)(BmobObject *object))success failBlock:(void(^)(NSError * error))fail;
/**
 *  删除一条发起
 *
 *  @param phoneNumber 电话
 *  @param password    密码
 *  @param called_date 创建时间
 *  @param success     成功
 *  @param fail        失败
 */
- (void)DeleteCalledWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password called_date:(NSString *)called_date successBlock:(void(^)(NSArray *array))success failBlock:(void(^)(NSError * error))fail;

- (void)queryTheCalledlListsuccessBlock:(void(^)(NSMutableArray *array))success failBlock:(void(^)(NSError * error))fail;


@end
