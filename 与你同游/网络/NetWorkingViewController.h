//
//  NetWorkingViewController.h
//  BmobSDK网络测试
//
//  Created by rimi on 15/10/10.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>
@interface NetWorkingViewController : NSObject
/**
 *  注册
 *
 *  @param password 密码
 *  @param phoneNumber 电话号码
 *  @param success     成功
 *  @param fail        失败
 */
- (void)registeredWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password successBlock:(void(^)(NSString *objiectId))success failBlock:(void(^)(NSError * error))fail ;

/**
 *  登录
 *
 *  @param phoneNumber 电话
 *  @param password    密码 （必传）
 *  @param success
 *  @param fail
 */
- (void)loginWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password successBlock:(void(^)(BmobObject *object))success failBlock:(void(^)(NSError * error))fail;
/**
 *  上传个人信息
 *
 *  @param phoneNumber            电话
 *  @param password               密码
 *  @param head_portraits         头像
 *  @param sex                    性别
 *  @param age                    年龄
 *  @param userName               用户名
 *  @param IndividualitySignature 个性签名
 *  @param success
 *  @param fail           
 */

- (void)addUserinfoWithphoneNumber:(NSString *)phoneNumber password:(NSString *)password userName:(NSString *)userName head_portraits:(NSData *)head_portraits sex:(NSString *)sex age:(NSNumber *)age IndividualitySignature:(NSString *)IndividualitySignature successBlock:(void(^)(NSString *objiectId))success failBlock:(void(^)(NSError * error))fail;
/**
 *  更新等级
 *
 *  @param phoneNumber 电话
 *  @param password    密码
 *  @param success
 *  @param fail
 */
- (void)uploadLevelWithphoneNumber:(NSString *)phoneNumber password:(NSString *)password successBlock:(void(^)(NSString *objiectId))success failBlock:(void(^)(NSError * error))fail;

/**
 *  获取用户信息电话密码
 *
 *  @param phoneNumber 电话号码
 *  @param password    密码
 *  @param success     成功
 *  @param fail        失败
 */
- (void)getWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password successBlock:(void(^)(BmobObject *object))success failBlock:(void(^)(NSError * error))fail;
/**
 *  忘记密码
 *
 *  @param phoneNumber 电话
 *  @param password    密码
 *  @param success
 *  @param fail
 */
- (void)ForgotPasswordWithPhone:(NSString *)phoneNumber newPassword:(NSString *)newPassword successBlock:(void(^)(BmobObject *object))success failBlock:(void(^)(NSError * error))fail;
/**
 *  修改密码
 *
 *  @param phoneNumber 电话
 *  @param oldPassword 旧密码
 *  @param newPassword 新密码
 *  @param success
 *  @param fail
 */
- (void)ChangePasswordWithPhone:(NSString *)phoneNumber oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword successBlock:(void(^)(BmobObject *object))success failBlock:(void(^)(NSError * error))fail;
/**
 *  添加一个游记
 *
 *  @param phoneNumber 电话号码
 *  @param password    密码
 *  @param sightSpot   旅游景点
 *  @param images      图片
 *  @param content     内容
 *  @param success     成功
 *  @param fail        失败
 */

- (void)addTravelWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password sightSpot:(NSArray *)sightSpot images:(NSData *)images content:(NSString *)content successBlock:(void(^)(NSString *objiectId))success failBlock:(void(^)(NSError * error))fail;
/**
 *  查询一个用户的游记列表
 *
 *  @param phoneNumber 电话号码
 *  @param password    密码
 *  @param success     成功
 *  @param fail        失败
 */
- (void)queryTravelWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password successBlock:(void(^)(NSMutableArray *array))success failBlock:(void(^)(NSError * error))fail;

/**
 *  删除一条游记
 *
 *  @param phoneNumber 电话
 *  @param password    密码
 *  @param travel_date 游记发布时间
 *  @param success     成功
 *  @param fail        失败
 */
- (void)deleteTravelWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password travel_date:(NSString *)travel_date successBlock:(void(^)(NSArray *array))success failBlock:(void(^)(NSError * error))fail;
/**
 *  查询一条游记
 *
 *  @param phoneNumber 用户名
 *  @param password    密码
 *  @param travel_date 游记发布时间
 *  @param success     成功
 *  @param fail        失败
 */
- (void)queryTravelWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password travel_date:(NSString *)travel_date successBlock:(void(^)(BmobObject *object))success failBlock:(void(^)(NSError * error))fail;

/**
 *  获取游记列表
 *
 *  @param success
 *  @param fail
 */
- (void)queryTheTravelListWithskip:(NSInteger)skip SuccessBlock:(void(^)(NSMutableArray *objectArray))success failBlock:(void(^)(NSError * error))fail;
//- (void)queryTheTravelListWithtravel_date:(NSString *)travel_date SuccessBlock:(void (^)(NSMutableArray *))success failBlock:(void (^)(NSError *))fail

@end
