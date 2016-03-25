//
//  User.m
//  BmobSDK网络测试
//
//  Created by rimi on 15/10/13.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "UserModel.h"
#import "NetWorkingViewController.h"
#import <BmobSDK/BmobProFile.h>
#import <SMS_SDK/SMSSDK.h>
@interface UserModel ()
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *VerificationCode;
@property (nonatomic, copy) NSString *VerificationCodeResult;
@property (nonatomic, copy) NSString *addUserinfoResult;
@property (nonatomic, strong) NetWorkingViewController *netWork;
@property (nonatomic, copy) NSString *registerResult;
@property (nonatomic, copy) NSString *forgetPasswordResult;

@end

@implementation UserModel
#pragma mark --获取用户信息
- (void)getwithObjectId:(NSString *)ObjectId  successBlock:(void(^)(BmobObject *object))success failBlock:(void(^)(NSError * error))fail {
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"User"];
    [bquery getObjectInBackgroundWithId:ObjectId block:^(BmobObject *object, NSError *error) {
        if (error){
            NSLog(@"error");
        }
        else{
            if ([ObjectId isEqual:OBJECTID]) {
                self.getUserData = object;
            }
            else{
                success(object);
            }
        }
        
       
    }];

}

#pragma mark --查询账号是否存在
- (void)getWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password successBlock:(void(^)(BmobObject *object))success failBlock:(void(^)(NSError * error))fail {
    
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"User"];
    [bquery whereKey:@"phoneNumber" equalTo:phoneNumber];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error){
            NSLog(@"error");
        }else{
            if (array.count == 0) {
                self.userData = nil;
                fail(error);
                return;
            }
            BmobObject *object = array[0];
            self.userData = object;
            success(object);
        }
    }];
}

#pragma mark -- 注册网络请求
- (void)registeredWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password successBlock:(void(^)(NSString *objiectId))success failBlock:(void(^)(NSError * error))fail {
    
    BmobObject *bmobObject = [BmobObject objectWithClassName:@"User"];
    [bmobObject setObject:phoneNumber forKey:@"phoneNumber"];
    [bmobObject setObject:password forKey:@"password"];
    [bmobObject setObject:@"还没取昵称哟！" forKey:@"username"];
    [bmobObject setObject:@"无" forKey:@"age"];
    [bmobObject setObject:@"无" forKey:@"sex"];
    [bmobObject setObject:@"快来写上您的个性签名吧！" forKey:@"IndividualitySignature"];
    [bmobObject saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            success(bmobObject.objectId);
            NSLog(@"Sign up successfully");
        }else{
            fail(error);
            NSLog(@"Sign up error:%@",error);
        }
    }];
    
}
#pragma mark --登录网路请求
- (void)loginWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password successBlock:(void(^)(BmobObject *object))success failBlock:(void(^)(NSError * error))fail {
    
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"User"];
    [bquery whereKey:@"phoneNumber" equalTo:phoneNumber];
    [bquery whereKey:@"password" equalTo:password];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error){
            NSLog(@"%@", error);
        }else {
            if (array.count == 0) {
                fail(error);
                return;
            }
            BmobObject *object = array[0];
            NSLog(@"登录成功返回的用户信息array[0] = %@",array[0]);
            self.loginUserData = object;
            success(object);
        }
    }];
}


- (void)VerificationCodeWithPhoneNumber:(NSString *)phoneNumber {
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
     //这个参数可以选择是通过发送验证码还是语言来获取验证码
                            phoneNumber:phoneNumber
                                   zone:@"86"
                       customIdentifier:nil //自定义短信模板标识
                                 result:^(NSError *error)
    {
        
        if (!error)
        {
            NSLog(@"block 获取验证码成功");
            self.VerificationCode = @"YES";
        }
        else
        {
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"codesenderrtitle", nil)
                                                            message:[NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"getVerificationCode"]]
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                                  otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    }];
    
    


}
- (void)VerificationCodeWithVerificationCode:(NSString *)VerificationCode phoneNumber:(NSString *)phoneNumber {
    [SMSSDK  commitVerificationCode:VerificationCode
     //传获取到的区号
                        phoneNumber:phoneNumber
                               zone:@"86"
                             result:^(NSError *error)
     {
         
         if (!error)
         {
             NSLog(@"验证成功");
            self.VerificationCodeResult = @"YES";
         }
         else
         {
             self.VerificationCodeResult = @"YES";
             NSLog(@"验证失败");
         }
         
     }];



}
#pragma mark --忘记密码
- (void)ForgotPasswordWithPhone:(NSString *)phoneNumber newPassword:(NSString *)newPassword {
    
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"User"];
    [bquery whereKey:@"phoneNumber" equalTo:phoneNumber];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error){

        }else {
            BmobObject *object = array[0];
            [object setObject:newPassword forKey:@"password"];
            [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    //修改成功后的动作
                    self.forgetPasswordResult = @"YES";
                } else if (error){
                    NSLog(@"%@",error);
                } else {
                    NSLog(@"UnKnow error");
                }
            }];
        }
  
        }];
}
- (void)uploadLevelWithphoneNumber:(NSString *)phoneNumber password:(NSString *)password {
    [self.netWork uploadLevelWithphoneNumber:phoneNumber password:password successBlock:^(NSString *objiectId) {
    } failBlock:^(NSError *error) {
        
    }];
}



- (void)changeUserinfoWithObjectId:(NSString *)ObjectId userName:(NSString *)userName head_portraits:(NSData *)head_portraits sex:(NSString *)sex age:(NSString *)age IndividualitySignature:(NSString *)IndividualitySignature {
    
#pragma mark --上传文件之前判断是否上传过头像，为了节约空间，我们应该删除原来的
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"User"];
    [bquery getObjectInBackgroundWithId:ObjectId block:^(BmobObject *object, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }else {
            
            if (head_portraits) {
                 [BmobProFile uploadFileWithFilename:@"headPortraint.png" fileData:head_portraits block:^(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url, BmobFile *file) {
                     if (isSuccessful) {
                         [object setObject:userName forKey:@"username"];
                         [object setObject:sex forKey:@"sex"];
                         [object setObject:age forKey:@"age"];
                         [object setObject:file.url forKey:@"head_portraits"];
                         NSLog(@"file.url = %@",file.url);
                         [object setObject:IndividualitySignature forKey:@"IndividualitySignature"];
                         
                         [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                             if (isSuccessful) {
                                 //修改成功后的动作
                                 self.addUserinfoResult = @"YES";
                             } else if (error){
                                 NSLog(@"%@",error);
                             } else {
                                 NSLog(@"UnKnow error");
                             }
                         }];
                         
                     }
                     else{
                         if(error){
                             NSLog(@"error%@",error);
                         }
                     }

                     
                 } progress:^(CGFloat progress) {
                     //上传进度，此处可编写进度条逻辑
                     NSLog(@"progress %f",progress);
                    }];
            
            
            }else {
                
                [object setObject:userName forKey:@"username"];
                [object setObject:sex forKey:@"sex"];
                [object setObject:age forKey:@"age"];
                [object setObject:IndividualitySignature forKey:@"IndividualitySignature"];
                
                [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        //修改成功后的动作
                        self.addUserinfoResult = @"YES";
                    } else if (error){
                        NSLog(@"%@",error);
                    } else {
                        NSLog(@"UnKnow error");
                    }
                }];
            }
        
        }
    }];
}

- (NetWorkingViewController *)netWork {
    if (!_netWork) {
        _netWork = [[NetWorkingViewController alloc]init];
    }
    return _netWork;
}

- (BmobObject *)userData {
    if (!_userData) {
        _userData = [[BmobObject alloc] init];
    }
    return _userData;
}
- (BmobObject *)loginUserData {
    if (!_loginUserData) {
        _loginUserData = [[BmobObject alloc] init];
    }
    return _loginUserData;
}

- (BmobObject *)getUserData {
    if (!_getUserData) {
        _getUserData = [[BmobObject alloc] init];
    }
    return _getUserData;
}



#pragma mark -- 获取当前时间
- (NSString *)CurrentTime {
    NSDate *  senddate = [NSDate date];
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *  locationString = [dateformatter stringFromDate:senddate];
    return locationString;
}



@end
