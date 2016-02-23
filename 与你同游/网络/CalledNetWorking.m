//
//  CalledNetWorking.m
//  BmobSDK网络测试
//
//  Created by rimi on 15/10/14.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "CalledNetWorking.h"
#import <BmobSDK/BmobProFile.h>
#define APPLICAYION_ID @"ed38f5e8bc84d1b80a90beab61dbc07b"
@implementation CalledNetWorking

- (instancetype)init
{
    self = [super init];
    if (self) {
        [Bmob registerWithAppKey:APPLICAYION_ID];
    }
    return self;
}

- (void)AddCalledWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password title:(NSString *)title origin:(NSString *)origin destination:(NSString *)destination departureTime:(NSString *)departureTime arrivalTime:(NSString *)arrivalTime NumberOfPeople:(NSNumber *)NumberOfPeople content:(NSString *)content image:(NSData *)image successBlock:(void(^)(NSString *objiectId))success failBlock:(void(^)(NSError * error))fail {
    //找到用户的id
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"User"];
    [bquery whereKey:@"phone_number" equalTo:phoneNumber];
    [bquery whereKey:@"password" equalTo:password];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error){
            NSLog(@"error");
            fail(error);
        }else{
            
            BmobObject *object = array[0];
            if (![[object objectForKey:@"signFlag"] isEqualToString:@"in"]) {
                NSLog(@"请登录");
                return ;
            }
            
            [self uploadImageFile:image successBlock:^(NSString *url) {
                BmobObject *object = array[0];
                NSString *objectId = object.objectId;
                //创建一个游记信息
                BmobObject  *called = [BmobObject objectWithClassName:@"called"];
                [called setObject:title forKey:@"title"];
                [called setObject:origin forKey:@"point_of_departure"];
                [called setObject:destination forKey:@"destination"];
                [called setObject:[self CurrentTime] forKey:@"called_date"];
                [called setObject:departureTime forKey:@"departure_time"];
                [called setObject:arrivalTime forKey:@"arrival_time"];
                [called setObject:NumberOfPeople forKey:@"number_Of_people"];
                [called setObject:content forKey:@"content"];
                [called setObject:url forKey:@"image"];
                [called setObject:phoneNumber forKey:@"phone_number"];
                //异步保存
                [called saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        //打印objectId
                        //                    self.objectId = called.objectId;
                        NSLog(@"objectid :%@",called.objectId);
                        //将游记信息放在该用户表中
                        //获取要添加关联关系的User
                        BmobObject *user1 = [BmobObject objectWithoutDatatWithClassName:@"User" objectId:objectId];
                        
                        //新建relation对象
                        BmobRelation *relation = [[BmobRelation alloc] init];
                        [relation addObject:[BmobObject objectWithoutDatatWithClassName:@"travel" objectId:called.objectId]];
                        
                        //添加关联关系到calleds列中
                        [user1 addRelation:relation forKey:@"calleds"];
                        
                        [user1 updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                            if (isSuccessful) {
                                NSLog(@"successful");
                                success(called.objectId);
                            }else{
                                NSLog(@"error %@",[error description]);
                            }
                        }];
                        
                    } else if (error){
                        //发生错误后的动作
                        NSLog(@"%@",error);
                    } else {
                        NSLog(@"Unknow error");
                    }
                }];
            } failBlock:^(NSError *error) {
                
            }];
            
        }
    }];
}
#pragma mark --上传文件
- (void)uploadImageFile:(NSData *)data successBlock:(void(^)(NSString *url))success failBlock:(void(^)(NSError * error))fail {
    if (data == nil) {
        success(nil);
        return;
    }
    [BmobProFile uploadFileWithFilename:@"个人信息背景.png" fileData:data block:^(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url,BmobFile *bmobFile) {
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

#pragma mark -- 获取发起列表
- (void)FindCalledWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password successBlock:(void(^)(NSArray *array))success failBlock:(void(^)(NSError * error))fail {
    //找到用户的id
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"User"];
    [bquery whereKey:@"phone_number" equalTo:phoneNumber];
    [bquery whereKey:@"password" equalTo:password];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error){
            NSLog(@"error");
            fail(error);
        }else{
            BmobObject *object = array[0];
            NSString *objectId = object.objectId;
            //关联对象表
            BmobQuery *called = [BmobQuery queryWithClassName:@"called"];
            //需要查询的列
            BmobObject *user = [BmobObject objectWithoutDatatWithClassName:@"User" objectId:objectId];
            [called whereObjectKey:@"calleds" relatedTo:user];
            [called findObjectsInBackgroundWithBlock:^(NSArray *array1, NSError *error) {
                if (error) {
                    NSLog(@"%@",error);
                } else {
                    success(array1);
                }
            }];
        }
    }];
}

#pragma mark -- 查询一条发起
- (void)queryCalledWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password called_date:(NSString *)called_date successBlock:(void(^)(BmobObject *object))success failBlock:(void(^)(NSError * error))fail {
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"User"];
    [bquery whereKey:@"phone_number" equalTo:phoneNumber];
    [bquery whereKey:@"password" equalTo:password];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error){
            NSLog(@"error");
            fail(error);
        }else{
            BmobObject *object = array[0];
            NSString *objectId = object.objectId;
            //关联对象表
            BmobQuery *travel = [BmobQuery queryWithClassName:@"called"];
            //需要查询的列
            BmobObject *user = [BmobObject objectWithoutDatatWithClassName:@"User" objectId:objectId];
            [travel whereObjectKey:@"calleds" relatedTo:user];
            [travel findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                if (error) {
                    NSLog(@"%@",error);
                } else {
                    [self FindCalledWithPhoneNumber:phoneNumber password:password successBlock:^(NSArray *array) {
                        for (BmobObject *user in array) {
                            if ([called_date isEqualToString:[user objectForKey:@"called_date"]]) {
                                success(user);
                            }
                        }
                    } failBlock:^(NSError *error) {
                        
                    }];
                    
                }
            }];
        }
    }];


}
#pragma mark -- 修改一条发起
- (void)ChangeCalledWithPhoneNumber:(NSString *)phoneNumber called_date:(NSString *)called_date password:(NSString *)password title:(NSString *)title origin:(NSString *)origin destination:(NSString *)destination departureTime:(NSString *)departureTime arrivalTime:(NSString *)arrivalTime NumberOfPeople:(NSNumber *)NumberOfPeople content:(NSString *)content image:(NSData *)image successBlock:(void(^)(NSString *objiectId))success failBlock:(void(^)(NSError * error))fail {
    [self queryCalledWithPhoneNumber:phoneNumber password:password called_date:called_date successBlock:^(BmobObject *object) {
        if (object) {
        
            [self uploadImageFile:image successBlock:^(NSString *url) {
                BmobObject *called = [BmobObject objectWithoutDatatWithClassName:@"called"  objectId:object.objectId];
                [called setObject:title forKey:@"title"];
                [called setObject:origin forKey:@"point_of_departure"];
                [called setObject:destination forKey:@"destination"];
                [called setObject:called_date forKey:@"called_date"];
                [called setObject:departureTime forKey:@"departure_time"];
                [called setObject:arrivalTime forKey:@"arrival_time"];
                [called setObject:NumberOfPeople forKey:@"number_Of_people"];
                [called setObject:content forKey:@"content"];
                [called setObject:url forKey:@"image"];
                [called updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        //修改成功后的动作
                        success(object.objectId);
                    } else if (error){
                        NSLog(@"%@",error);
                    } else {
                        NSLog(@"UnKnow error");
                    }
                }];
            } failBlock:^(NSError *error) {
                
            }];
            
            
        }
    } failBlock:^(NSError *error) {
        
    }];


}

- (void)DeleteCalledWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password called_date:(NSString *)called_date successBlock:(void(^)(NSArray *array))success failBlock:(void(^)(NSError * error))fail {
    
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"User"];
    [bquery whereKey:@"phone_number" equalTo:phoneNumber];
    [bquery whereKey:@"password" equalTo:password];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error){
            NSLog(@"error");
            fail(error);
        }else{
            BmobObject *userObject = array[0];
            
            //关联对象表
            BmobQuery *called = [BmobQuery queryWithClassName:@"called"];
            [called whereObjectKey:@"travels" relatedTo:userObject];
            [called findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                if (error) {
                    NSLog(@"%@",error);
                } else {
                    [self queryCalledWithPhoneNumber:phoneNumber password:password called_date:called_date successBlock:^(BmobObject *object) {
                        //新建relation对象
                        BmobRelation *relation = [[BmobRelation alloc] init];
                        [relation removeObject:[BmobObject objectWithoutDatatWithClassName:@"called" objectId:object.objectId]];
                        
                        //添加关联关系到likes列中
                        [userObject addRelation:relation forKey:@"calleds"];
                        
                        //异步更新obj的数据
                        [userObject updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                            if (isSuccessful) {
                                NSLog(@"successful");
                                BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:@"called"  objectId:object.objectId];
                                [bmobObject deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                                    if (isSuccessful) {
                                        //删除成功后的动作
                                        NSLog(@"删除successful");
                                    } else if (error){
                                        NSLog(@"%@",error);
                                    } else {
                                        NSLog(@"UnKnow error");
                                    }
                                }];
                                
                                
                            }else{
                                NSLog(@"error %@",[error description]);
                            }
                        }];

                    } failBlock:^(NSError *error) {
                        
                    }];
                    
                    
                }
            }];
        }
    }];



}

- (void)queryTheCalledlListsuccessBlock:(void(^)(NSMutableArray *array))success failBlock:(void(^)(NSError * error))fail {
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"called"];
    bquery.limit = 5;
    //    bquery.skip = 3;d
    [bquery orderByDescending:@"called_date"];
    //查找travel表的数据
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        //        for (BmobObject *obj in array) {
        NSMutableArray *objectArray = [NSMutableArray array];
        for (int i = 0; i < array.count; i ++) {
            BmobObject *calledObject = array[i];
            if (![calledObject objectForKey:@"image"]) {
                [calledObject setObject:nil forKey:@"image"];
            }else {
                NSString * URL =  [NSString stringWithFormat:@"%@?t=1&a=f008d46b406baaa7eff26eba98dccd54", [calledObject objectForKey:@"image"]];
                [calledObject setObject:URL forKey:@"image"];
            }
            [objectArray addObject:calledObject];
        }
        success(objectArray);
    }];


}


#pragma mark -- 获取当前时间
- (NSString *)CurrentTime {
    NSDate *  senddate = [NSDate date];
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *  locationString = [dateformatter stringFromDate:senddate];
    return locationString;
}
@end
