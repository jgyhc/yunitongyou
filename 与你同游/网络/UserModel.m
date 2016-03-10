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
@property (nonatomic, strong) NSMutableArray *travelListArray;
@property (nonatomic, copy) NSString *addTravelResult;
@property (nonatomic, copy) NSString *travelContents;
@property (nonatomic, copy) NSString *travelTime;
@property (nonatomic, copy) NSString *travelSight_spot;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSMutableArray *travelUser;
@end

@implementation UserModel

- (void)getwithObjectId:(NSString *)ObjectId {
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"User"];
    [bquery getObjectInBackgroundWithId:ObjectId block:^(BmobObject *object, NSError *error) {
        if ([object objectForKey:@"head_portraits1"]) {
            NSString * URL =  [NSString stringWithFormat:@"%@?t=1&a=f008d46b406baaa7eff26eba98dccd54", [object objectForKey:@"head_portraits1"]];
            [object setObject:URL forKey:@"head_portraits1"];
        }else {
            [object setObject:nil forKey:@"head_portraits1"];
        }
        self.getUserData = object;
    }];

}


#pragma mark --获取用户信息
- (void)getWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password successBlock:(void(^)(BmobObject *object))success failBlock:(void(^)(NSError * error))fail {
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"User"];
    [bquery whereKey:@"phone_number" equalTo:phoneNumber];
    if (password) {
        [bquery whereKey:@"password" equalTo:password];
    }
    NSLog(@"%@", phoneNumber);
    
    
    
    
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error){
            NSLog(@"error");
            fail(error);
        }else{
            NSLog(@"array = %@", array);
            if (array.count == 0) {
                self.getUserData = nil;
                return;
            }
            BmobObject *object = array[0];
            NSLog(@"%@", object);
            if ([object objectForKey:@"head_portraits1"]) {
                NSString * URL =  [NSString stringWithFormat:@"%@?t=1&a=f008d46b406baaa7eff26eba98dccd54", [object objectForKey:@"head_portraits1"]];
                [object setObject:URL forKey:@"head_portraits1"];
            }else {
                [object setObject:nil forKey:@"head_portraits1"];
            }
            self.getUserData = object;
            NSLog(@"%@", self.getUserData);
        }
    }];
}

#pragma mark -- 注册
- (void)registeredWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password successBlock:(void(^)(NSString *objiectId))success failBlock:(void(^)(NSError * error))fail {
    BmobObject *bmobObject = [BmobObject objectWithClassName:@"User"];
    [bmobObject setObject:phoneNumber forKey:@"phoneNumber"];
    [bmobObject setObject:password forKey:@"password"];
    [bmobObject saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            success(bmobObject.objectId);
            NSLog(@"%@", bmobObject.objectId);
            NSLog(@"成功!");
        }else{
            fail(error);
            NSLog(@"%@", error);
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

- (void)ForgotPasswordWithPhone:(NSString *)phoneNumber newPassword:(NSString *)newPassword {
    [self getWithPhoneNumber:phoneNumber password:nil successBlock:^(BmobObject *object) {
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
    } failBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];

}
- (void)uploadLevelWithphoneNumber:(NSString *)phoneNumber password:(NSString *)password {
    [self.netWork uploadLevelWithphoneNumber:phoneNumber password:password successBlock:^(NSString *objiectId) {
    } failBlock:^(NSError *error) {
        
    }];
}

- (void)loginWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password {
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"User"];
    [bquery whereKey:@"phone_number" equalTo:phoneNumber];
    [bquery whereKey:@"password" equalTo:password];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error){
            NSLog(@"%@", error);
        }else {
            if (array.count == 0) {
                self.loginUserData = nil;
                return;
            }
            BmobObject *object = array[0];
            self.loginUserData = object;
        }
    }];
}

- (void)changeUserinfoWithObjectId:(NSString *)ObjectId userName:(NSString *)userName head_portraits:(NSData *)head_portraits sex:(NSString *)sex age:(NSNumber *)age IndividualitySignature:(NSString *)IndividualitySignature {
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"User"];
    [bquery getObjectInBackgroundWithId:ObjectId block:^(BmobObject *object, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }else {
            if (head_portraits) {
                UIImage * image = [[UIImage alloc] initWithData:head_portraits];
                CGSize imagesize = image.size;
                imagesize.height = image.size.height * (200 / image.size.width);
                imagesize.width = 200;
                image = [self imageWithImage:image scaledToSize:imagesize];
                NSData *data = UIImagePNGRepresentation(image);
                [self uploadImageFile:data successBlock:^(NSString *url) {
                    [object setObject:userName forKey:@"userName"];
                    [object setObject:sex forKey:@"sex"];
                    [object setObject:age forKey:@"age"];
                    [object setObject:url forKey:@"head_portraits1"];
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
                } failBlock:^(NSError *error) {
                    NSLog(@"%@",error);
                }];
            }else {
                [object setObject:userName forKey:@"userName"];
                [object setObject:sex forKey:@"sex"];
                [object setObject:age forKey:@"age"];
                NSString *nstring = [object objectForKey:@"head_portraits1"];
                NSArray *array = [nstring componentsSeparatedByString:@"?"];
                [object setObject:array[0] forKey:@"head_portraits1"];
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
#pragma mark --上传一条游记  多张图片的
- (void)addTravelWithObejectId:(NSString *)ObjectId sightSpot:(NSArray *)sightSpot imagesArray:(NSArray *)imagesArray content:(NSString *)content {
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"User"];
    [bquery getObjectInBackgroundWithId:ObjectId block:^(BmobObject *object, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }else {
            [self uploadImagesArray:[self thumbnailArray:imagesArray] successBlock:^(NSArray *urlArray) {
                [self uploadImagesArray:[self ImageToDic:imagesArray] successBlock:^(NSArray *thumbnailurlArray) {
                    BmobObject  *travel = [BmobObject objectWithClassName:@"travel"];
                    [travel setObject:sightSpot forKey:@"sight_spot"];
                    [travel setObject:[self CurrentTime] forKey:@"travel_date"];
                    [travel setObject:content forKey:@"content"];
                    [travel setObject:object.objectId forKey:@"userObjectid"];
                    [travel setObject:[NSNumber numberWithInt:0] forKey:@"number_of_thumb_up"];
                    [travel setObject:[NSNumber numberWithInt:0] forKey:@"comments_number"];
                    [travel setObject:urlArray forKey:@"images"];
                    [travel setObject:thumbnailurlArray forKey:@"thumbnailImages"];
                    [travel saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        if (isSuccessful) {
                            //将游记信息放在该用户表中
                            BmobObject *user1 = [BmobObject objectWithoutDatatWithClassName:@"User" objectId:object.objectId];
                            BmobRelation *relation = [[BmobRelation alloc] init];
                            [relation addObject:[BmobObject objectWithoutDatatWithClassName:@"travel" objectId:travel.objectId]];
                            [user1 addRelation:relation forKey:@"travels"];
                            [user1 updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                if (isSuccessful) {
                                    self.addTravelResult = @"YES";
                                }else{
                                    NSLog(@"error %@",[error description]);
                                }
                            }];
                        }
                    }];
                } progressBlock:^(NSUInteger index, CGFloat returnProgress) {
                    NSLog(@"第%ld张，进度：%f", index, returnProgress);
                } failBlock:^(NSError *error) {
                    NSLog(@"%@", error);
                }];
            } progressBlock:^(NSUInteger index, CGFloat returnProgress) {
                NSLog(@"%f", returnProgress);
            } failBlock:^(NSError *error) {
                NSLog(@"%@", error);
            }];
        }
    }];
}
- (NSMutableArray *)ImageToDic:(NSArray *)imageArray {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < imageArray.count; i ++) {
        NSData *data = UIImagePNGRepresentation(imageArray[i]);
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:data forKey:@"data"];
        [dic setObject:[NSString stringWithFormat:@"%d.jpg", i ] forKey:@"filename"];
        [array addObject:dic];
    }
    return array;
}

#pragma mark --上传一组图片
- (void)uploadImagesArray:(NSArray *)imagesArray successBlock:(void(^)(NSArray *urlArray))success progressBlock:(void(^)(NSUInteger index,CGFloat returnProgress))returnProgress failBlock:(void(^)(NSError * error))fail {
    if (imagesArray.count == 0) {
        success(nil);
        return;
    }else {
        [BmobProFile uploadFilesWithDatas:imagesArray resultBlock:^(NSArray *filenameArray, NSArray *urlArray, NSArray *bmobFileArray, NSError *error) {
            success(urlArray);
        } progress:^(NSUInteger index, CGFloat progress) {
            returnProgress(index, progress);
        }];
    }

}
#pragma mark -- 将一组图片压缩  返回压缩后的data和文件名的数组
- (NSMutableArray *)thumbnailArray:(NSArray *)thumbnails {
    NSMutableArray *thumailsArray = [NSMutableArray array];
    for (int i = 0; i < thumbnails.count; i ++) {
        UIImage * image = thumbnails[i];
        CGSize imagesize = image.size;
        if (imagesize.height >= imagesize.width) {
            imagesize.height = image.size.height * (110 / image.size.width);
            imagesize.width = 110;
        }else {
            imagesize.width = image.size.width * (110 / image.size.height);
            imagesize.height = 110;
        }
        image = [self imageWithImage:image scaledToSize:imagesize];
        NSData *data = UIImagePNGRepresentation(image);
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:data forKey:@"data"];
        [dic setObject:[NSString stringWithFormat:@"%d.jpg", i] forKey:@"filename"];
        [thumailsArray addObject:dic];
    }
    return thumailsArray;
}
#pragma mark --上传文件
- (void)uploadImageFile:(NSData *)data successBlock:(void(^)(NSString *url))success failBlock:(void(^)(NSError * error))fail {
    if (data == nil) {
        success(nil);
        return;
    }
    [BmobProFile uploadFileWithFilename:@"image.png" fileData:data block:^(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url,BmobFile *bmobFile) {
        if (isSuccessful) {
            success(url);
        } else {
            if (error) {
                NSLog(@"error %@",error);
            }
        }
    } progress:^(CGFloat progress) {
        //上传进度，此处可编写进度条逻辑
        NSLog(@"progress %f",progress);
    }];
}
- (void)queryTravelWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password {
    [self.netWork queryTravelWithPhoneNumber:phoneNumber password:password successBlock:^(NSMutableArray *array) {
        NSMutableArray *arr = self.travelListArray;
        [arr addObjectsFromArray:array];
        self.travelListArray = arr;
    } failBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}
- (void)queryTravelWithObejectId:(NSString *)ObjectId {
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"User"];
    [bquery getObjectInBackgroundWithId:ObjectId block:^(BmobObject *object, NSError *error) {
        BmobQuery *travel = [BmobQuery queryWithClassName:@"travel"];
        //需要查询的列
        BmobObject *user = [BmobObject objectWithoutDatatWithClassName:@"User" objectId:object.objectId];
        [travel whereObjectKey:@"travels" relatedTo:user];
        [travel findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
            } else {
                NSMutableArray *objectArray = [NSMutableArray array];
                for (int i = 0; i < array.count; i ++) {
                    BmobObject *travelObject = array[i];
                    if (![travelObject objectForKey:@"thumbnailImages"]) {
                        [travelObject setObject:nil forKey:@"thumbnailImages"];
                    }else {
                        NSMutableArray *array  = [travelObject objectForKey:@"thumbnailImages"];
                        for (int i = 0; i < array.count; i ++) {
                            NSString * URL = [NSString stringWithFormat:@"%@?t=1&a=f008d46b406baaa7eff26eba98dccd54", array[i]];
                            [array replaceObjectAtIndex:i withObject:URL];
                            NSLog(@"%@", URL);
                        }
                        [travelObject setObject:array forKey:@"thumbnailImages"];
                    }
                    [objectArray addObject:travelObject];
                }
                self.travelListArray = objectArray;
            }
        }];
    }];

}

- (void)queryTravelWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password travel_date:(NSString *)travel_date {
    [self.netWork queryTravelWithPhoneNumber:phoneNumber password:password travel_date:travel_date successBlock:^(BmobObject *object) {
        
    } failBlock:^(NSError *error) {
        
    }];
}

- (void)deleteTravelWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password travel_date:(NSString *)travel_date {
    [self.netWork deleteTravelWithPhoneNumber:phoneNumber password:password travel_date:travel_date successBlock:^(NSArray *array) {
        
    } failBlock:^(NSError *error) {
        
    }];
}

- (void)queryTheTravelListSkip:(NSInteger)skip {
    [self.netWork queryTheTravelListWithskip:skip SuccessBlock:^(NSMutableArray *objectArray) {
        NSMutableArray *arr = self.travelListArray;
        [arr addObjectsFromArray:objectArray];
        self.travelListArray = arr;
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:3];
        for (int i = 0; i < 3; i ++) {
            [array addObject:@0];
        }
        static int flag = 0;
        for (int i = 0; i < 3; i ++) {
            BmobObject *travelObject = objectArray[i];
            [self.netWork getWithPhoneNumber:[travelObject objectForKey:@"phone_number"] password:nil successBlock:^(BmobObject *object) {
                [array replaceObjectAtIndex:i withObject:object];
                flag ++;
                if (flag == self.travelListArray.count) {
                    NSMutableArray *arr1 = self.travelUser;
                    [arr1 addObjectsFromArray:array];
                    self.travelUser = arr1;
                }
               
            } failBlock:^(NSError *error) {
                
            }];
        }
        
    } failBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
    
}
#pragma mark --压缩图片
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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

- (NSMutableArray *)travelListArray {
    if (!_travelListArray) {
        _travelListArray = [[NSMutableArray alloc] init];
    }
    return _travelListArray;
}

- (NSMutableArray *)travelUser {
    if (!_travelUser) {
        _travelUser = [NSMutableArray array];
    }
    return _travelUser;
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
