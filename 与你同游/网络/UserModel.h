//
//  User.h
//  BmobSDK网络测试
//
//  Created by rimi on 15/10/13.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>
@interface UserModel : NSObject
@property (nonatomic, strong) BmobObject *userData;
@property (nonatomic, strong) BmobObject *getUserData;
@property (nonatomic, strong) BmobObject *loginUserData;
@property (nonatomic, copy, readonly) NSString *userName;
@property (nonatomic, copy, readonly) NSString *password;
@property (nonatomic, copy, readonly) NSString *phoneNumber;
@property (nonatomic, copy, readonly) NSString *VerificationCode;
@property (nonatomic, copy, readonly) NSString *VerificationCodeResult;
@property (nonatomic, copy, readonly) NSString *registerResult;
@property (nonatomic, copy, readonly) NSString *forgetPasswordResult;




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
 *  通过id查找用户
 *
 *  @param ObjectId id
 */
- (void)getwithObjectId:(NSString *)ObjectId  successBlock:(void(^)(BmobObject *object))success failBlock:(void(^)(NSError * error))fail ;
- (void)getInfowithObjectId:(NSString *)ObjectId  successBlock:(void(^)(BmobObject *object))success failBlock:(void(^)(NSError * error))fail ;

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
 *  验证码
 *
 *  @param phoneNumber 电话
 */
- (void)VerificationCodeWithPhoneNumber:(NSString *)phoneNumber;
/**
 *  验证码
 *
 *  @param VerificationCode 验证码
 *  @param phoneNumber      电话号码
 */
- (void)VerificationCodeWithVerificationCode:(NSString *)VerificationCode phoneNumber:(NSString *)phoneNumber;
/**
 *  更新等级
 *
 *  @param phoneNumber 电话
 *  @param password    密码
 */
- (void)uploadLevelWithphoneNumber:(NSString *)phoneNumber password:(NSString *)password;

/**
 *  登录
 *
 *  @param phoneNumber 电话
 *  @param password    密码 （必传）
 */
- (void)loginWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password successBlock:(void(^)(BmobObject *object))success failBlock:(void(^)(NSError * error))fail;

/**
 *  上传个人信息
 *
 *  @param ObjectId       id
 *  @param head_portraits 头像
 *  @param sex            性别
 *  @param age            年龄
 *  @param userName       用户名
 */
- (void)changeUserinfoWithObjectId:(NSString *)ObjectId userName:(NSString *)userName head_portraits:(NSData *)head_portraits sex:(NSString *)sex age:(NSString *)age IndividualitySignature:(NSString *)IndividualitySignature;
/**
 *  忘记密码
 *
 *  @param phoneNumber 电话
 *  @param newPassword 密码
 */
- (void)ForgotPasswordWithPhone:(NSString *)phoneNumber newPassword:(NSString *)newPassword;
@end
