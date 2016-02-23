//
//  Register.h
//  与你同游
//
//  Created by Zgmanhui on 16/2/16.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Register : NSObject
/**
 *  注册
 *
 *  @param phoneNumber 电话
 *  @param password    密码
 *  @param success     成功
 *  @param fail        失败
 */
- (void)registeredWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password successBlock:(void(^)(NSString *objiectId))success failBlock:(void(^)(NSError * error))fail;
@end
