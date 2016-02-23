//
//  Register.m
//  与你同游
//
//  Created by Zgmanhui on 16/2/16.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import "Register.h"

@implementation Register
- (void)registeredWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password successBlock:(void(^)(NSString *objiectId))success failBlock:(void(^)(NSError * error))fail {
    BmobUser *bUser = [[BmobUser alloc] init];
    bUser.username = phoneNumber;
    [bUser setPassword:password];
    [bUser signUpInBackgroundWithBlock:^ (BOOL isSuccessful, NSError *error){
        if (isSuccessful){
            NSLog(@"Sign up successfully");
        } else {
            NSLog(@"%@",error);
        }
    }];
}
@end
