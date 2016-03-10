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
@property (nonatomic, strong, readonly) NSMutableArray *travelListArray;
@property (nonatomic, copy, readonly) NSString *addTravelResult;
@property (nonatomic, copy, readonly) NSString *travelContents;
@property (nonatomic, copy, readonly) NSString *travelTime;
@property (nonatomic, copy, readonly) NSString *travelSight_spot;
@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, strong, readonly) NSMutableArray *travelUser;


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
- (void)getwithObjectId:(NSString *)ObjectId;

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
- (void)changeUserinfoWithObjectId:(NSString *)ObjectId userName:(NSString *)userName head_portraits:(NSData *)head_portraits sex:(NSString *)sex age:(NSNumber *)age IndividualitySignature:(NSString *)IndividualitySignature;
/**
 *  忘记密码
 *
 *  @param phoneNumber 电话
 *  @param newPassword 密码
 */
- (void)ForgotPasswordWithPhone:(NSString *)phoneNumber newPassword:(NSString *)newPassword;
/**
 *  添加一个游记
 *
 *  @param ObjectId  id
 *  @param sightSpot 景点
 *  @param images    图片
 *  @param content   内容
 */

- (void)addTravelWithObejectId:(NSString *)ObjectId sightSpot:(NSArray *)sightSpot imagesArray:(NSArray *)imagesArray content:(NSString *)content;

/**
 *  查询一个用户的游记列表
 *
 *  @param phoneNumber 电话号码
 *  @param password    密码
 */
- (void)queryTravelWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password;
- (void)queryTravelWithObejectId:(NSString *)ObjectId;
/**
 *  查询一条游记
 *
 *  @param phoneNumber 用户名
 *  @param password    密码
 *  @param travel_date 游记发布时间
 */
- (void)queryTravelWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password travel_date:(NSString *)travel_date;

/**
 *  删除一条游记
 *
 *  @param phoneNumber 电话
 *  @param password    密码
 *  @param travel_date 游记发布时间
 */
- (void)deleteTravelWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password travel_date:(NSString *)travel_date;

/**
 *  获取游记列表
 *
 *  @param success
 *  @param fail
 */
- (void)queryTheTravelListSkip:(NSInteger)skip;



@end
