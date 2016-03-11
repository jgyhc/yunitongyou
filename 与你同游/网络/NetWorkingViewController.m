//
//  NetWorkingViewController.m
//  BmobSDK网络测试
//
//  Created by rimi on 15/10/10.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//
#define APPLICAYION_ID @"ed38f5e8bc84d1b80a90beab61dbc07b"
#import "NetWorkingViewController.h"
#import <BmobSDK/BmobProFile.h>

@interface NetWorkingViewController ()

@property (nonatomic, strong)NSString *objectId;
@property (nonatomic, strong)BmobObject *user;

@end

@implementation NetWorkingViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [Bmob registerWithAppKey:APPLICAYION_ID];
    }
    return self;
}

#pragma mark -- 注册
- (void)registeredWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password successBlock:(void(^)(NSString *objiectId))success failBlock:(void(^)(NSError * error))fail {
    BmobObject  *user = [BmobObject objectWithClassName:@"User"];
    
    [user setObject:password forKey:@"password"];
    [user setObject:phoneNumber forKey:@"phone_number"];
    
    //异步保存
    [user saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //创建成功后会返回objectId，updatedAt，createdAt等信息
            //打印objectId
            NSLog(@"objectid :%@",user.objectId);
            if (success) {
                success(user.objectId);
            }
        } else if (error){
            //发生错误后的动作
            NSLog(@"%@",error);
            if (fail) {
                fail(error);
            }
        } else {
            NSLog(@"Unknow error");
        }
    }];
}

- (void)ForgotPasswordWithPhone:(NSString *)phoneNumber newPassword:(NSString *)newPassword successBlock:(void(^)(BmobObject *object))success failBlock:(void(^)(NSError * error))fail {
    [self getWithPhoneNumber:phoneNumber password:nil successBlock:^(BmobObject *object) {
        [object setObject:newPassword forKey:@"password"];
        [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                //修改成功后的动作
                success(object);
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

- (void)ChangePasswordWithPhone:(NSString *)phoneNumber oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword successBlock:(void(^)(BmobObject *object))success failBlock:(void(^)(NSError * error))fail {
    [self getWithPhoneNumber:phoneNumber password:oldPassword successBlock:^(BmobObject *object) {
        [object setObject:newPassword forKey:@"password"];
        [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                //修改成功后的动作
                success(object);
            } else if (error){
                NSLog(@"%@",error);
            } else {
                NSLog(@"UnKnow error");
            }
        }];
    } failBlock:^(NSError *error) {
        
    }];
    
    
}


- (void)uploadLevelWithphoneNumber:(NSString *)phoneNumber password:(NSString *)password successBlock:(void(^)(NSString *objiectId))success failBlock:(void(^)(NSError * error))fail {
    [self getWithPhoneNumber:phoneNumber password:password successBlock:^(BmobObject *object) {
        if (![[object objectForKey:@"signFlag"] isEqualToString:@"in"]) {
            NSLog(@"请登录");
            return;
        }
    } failBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];

}

- (void)loginWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password successBlock:(void(^)(BmobObject *object))success failBlock:(void(^)(NSError * error))fail {
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"User"];
    [bquery whereKey:@"phone_number" equalTo:phoneNumber];
    [bquery whereKey:@"password" equalTo:password];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error){
            NSLog(@"%@", error);
            fail(error);
        }else{
            if (array.count == 0) {
                success(nil);
                NSLog(@"用户名或者密码错误！");
                return;
            }
            BmobObject *object = array[0];
            success(object);
//            NSString *signFlag = @"in";
//            [object setObject:signFlag forKey:@"signFlag"];
//            //异步保存
//            [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//                if (isSuccessful) {
//                    NSLog(@"objectid :%@",object.objectId);
//                    if (success) {
//                    }
//                } else if (error){
//                    //发生错误后的动作
//                    NSLog(@"%@",error);
//                    if (fail) {
//                        fail(error);
//                    }
//                } else {
//                    NSLog(@"Unknow error");
//                }
//            }];

            
        }
    }];
}

#pragma mark -- 上传个人信息

- (void)addUserinfoWithphoneNumber:(NSString *)phoneNumber password:(NSString *)password userName:(NSString *)userName head_portraits:(NSData *)head_portraits sex:(NSString *)sex age:(NSNumber *)age IndividualitySignature:(NSString *)IndividualitySignature successBlock:(void(^)(NSString *objiectId))success failBlock:(void(^)(NSError * error))fail {
    [self getWithPhoneNumber:phoneNumber password:password successBlock:^(BmobObject *object) {
        UIImage * image = [[UIImage alloc] initWithData:head_portraits];
        CGSize imagesize = image.size;
        imagesize.height = image.size.height * (200 / image.size.width);
        imagesize.width = 200;
        image = [self imageWithImage:image scaledToSize:imagesize];
        NSData *data = UIImagePNGRepresentation(image);
        if (head_portraits) {
            [self uploadImageFile:data successBlock:^(NSString *url) {
                [object setObject:userName forKey:@"userName"];
                [object setObject:sex forKey:@"sex"];
                [object setObject:age forKey:@"age"];
                [object setObject:url forKey:@"head_portraits1"];
                [object setObject:IndividualitySignature forKey:@"IndividualitySignature"];
                [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
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
                    success(object.objectId);
                } else if (error){
                    NSLog(@"%@",error);
                } else {
                    NSLog(@"UnKnow error");
                }
            }];
        }
        
        
        
    } failBlock:^(NSError *error) {
        
    }];



}
#pragma mark --上传文件
- (void)uploadImageFile:(NSData *)data successBlock:(void(^)(NSString *url))success failBlock:(void(^)(NSError * error))fail{
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

#pragma mark --获取用户信息
- (void)getWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password successBlock:(void(^)(BmobObject *object))success failBlock:(void(^)(NSError * error))fail {
    
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"User"];
    [bquery whereKey:@"phoneNumber" equalTo:phoneNumber];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error){
            NSLog(@"error");
            fail(error);
        }else{
            if (array.count == 0) {
                return;
            }
            BmobObject *object = array[0];
            success(object);
        }
    }];
}

#pragma mark -- 获取用户信息  然后创建 一个游记 再添加关系

- (void)addTravelWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password sightSpot:(NSArray *)sightSpot images:(NSData *)images content:(NSString *)content successBlock:(void(^)(NSString *objiectId))success failBlock:(void(^)(NSError * error))fail{
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
            NSLog(@"%@", array);
            NSString *objectId = object.objectId;
//上传图片 获取url
            if (images) {
                [self uploadImageFile:images successBlock:^(NSString *url) {
                    //创建一个游记信息
                    BmobObject  *travel = [BmobObject objectWithClassName:@"travel"];
                    [travel setObject:sightSpot forKey:@"sight_spot"];
                    [travel setObject:content forKey:@"content"];
                    [travel setObject:url forKey:@"image"];
                    [travel setObject:[object objectForKey:@"phone_number"] forKey:@"phone_number"];
                    [travel setObject:[NSNumber numberWithInt:0] forKey:@"number_of_thumb_up"];
                    [travel setObject:[NSNumber numberWithInt:0] forKey:@"comments_number"];
                    //异步保存
                    [travel saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        if (isSuccessful) {
                            //打印objectId
                            self.objectId = travel.objectId;
                            NSLog(@"objectid :%@",travel.objectId);
                            //将游记信息放在该用户表中
                            //获取要添加关联关系的User
                            BmobObject *user1 = [BmobObject objectWithoutDatatWithClassName:@"User" objectId:objectId];
                            
                            //新建relation对象
                            BmobRelation *relation = [[BmobRelation alloc] init];
                            [relation addObject:[BmobObject objectWithoutDatatWithClassName:@"travel" objectId:travel.objectId]];
                            
                            //添加关联关系到travels列中
                            [user1 addRelation:relation forKey:@"travels"];
                            
                            [user1 updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                if (isSuccessful) {
                                    success(travel.objectId);
                                }else{
                                    NSLog(@"error %@",[error description]);
                                }
                            }];
                            
                            //将用户放在游记表的user表里
                            
                            //新建relation对象
                            BmobRelation *relation1 = [[BmobRelation alloc] init];
                            [relation1 addObject:[BmobObject objectWithoutDatatWithClassName:@"User" objectId:objectId]];
                            //添加关联关系到travels列中
                            [travel addRelation:relation1 forKey:@"user"];
                            [travel updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                if (isSuccessful) {
                                    
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
                    NSLog(@"%@", error);
                }];
                
            }else {
                //创建一个游记信息
                BmobObject  *travel = [BmobObject objectWithClassName:@"travel"];
                [travel setObject:sightSpot forKey:@"sight_spot"];
                [travel setObject:content forKey:@"content"];
                
                [travel setObject:[object objectForKey:@"phone_number"] forKey:@"phone_number"];
                //异步保存
                [travel saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        //打印objectId
                        self.objectId = travel.objectId;
                        NSLog(@"objectid :%@",travel.objectId);
                        //将游记信息放在该用户表中
                        //获取要添加关联关系的User
                        BmobObject *user1 = [BmobObject objectWithoutDatatWithClassName:@"User" objectId:objectId];
                        
                        //新建relation对象
                        BmobRelation *relation = [[BmobRelation alloc] init];
                        [relation addObject:[BmobObject objectWithoutDatatWithClassName:@"travel" objectId:travel.objectId]];
                        
                        //添加关联关系到travels列中
                        [user1 addRelation:relation forKey:@"travels"];
                        
                        [user1 updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                            if (isSuccessful) {
                                success(travel.objectId);
                            }else{
                                NSLog(@"error %@",[error description]);
                            }
                        }];
                        
                        //将用户放在游记表的user表里
                        
                        //新建relation对象
                        BmobRelation *relation1 = [[BmobRelation alloc] init];
                        [relation1 addObject:[BmobObject objectWithoutDatatWithClassName:@"User" objectId:objectId]];
                        //添加关联关系到travels列中
                        [travel addRelation:relation1 forKey:@"user"];
                        [travel updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                            if (isSuccessful) {
                                
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
            
            }
        }
    }];
}
#pragma mark --查询用户的所有游记
- (void)queryTravelWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password successBlock:(void(^)(NSMutableArray *array))success  failBlock:(void(^)(NSError * error))fail {
    //找到用户的id
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"User"];
    [bquery whereKey:@"phone_number" equalTo:phoneNumber];
    [bquery whereKey:@"password" equalTo:password];
//    bquery.skip =;
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"error");
            fail(error);
        }else{
            BmobObject *object = array[0];
            NSString *objectId = object.objectId;
            //关联对象表
            
            
            
            BmobQuery *travel = [BmobQuery queryWithClassName:@"travel"];
            //需要查询的列
            BmobObject *user = [BmobObject objectWithoutDatatWithClassName:@"User" objectId:objectId];
            [travel whereObjectKey:@"travels" relatedTo:user];
            [travel findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                if (error) {
                    NSLog(@"%@",error);
                } else {
                    NSMutableArray *objectArray = [NSMutableArray array];
                    for (int i = 0; i < array.count; i ++) {
                        BmobObject *travelObject = array[i];
                        if (![travelObject objectForKey:@"image"]) {
                            [travelObject setObject:nil forKey:@"image"];
                        }else {
                            
                            NSString * URL =  [NSString stringWithFormat:@"%@?t=1&a=f008d46b406baaa7eff26eba98dccd54", [travelObject objectForKey:@"image"]];
                            [travelObject setObject:URL forKey:@"image"];
                        }
                        
                        [objectArray addObject:travelObject];
                    }
                    success(objectArray);
                }
            }];
        }
    }];
}
#pragma mark --查询用户的一条游记
- (void)queryTravelWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password travel_date:(NSString *)travel_date successBlock:(void(^)(BmobObject *object))success failBlock:(void(^)(NSError * error))fail {
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"User"];
    [bquery whereKey:@"phone_number" equalTo:phoneNumber];
    if (password) {
        [bquery whereKey:@"password" equalTo:password];
    }
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error){
            NSLog(@"error");
            fail(error);
        }else{
            BmobObject *object = array[0];
            NSString *objectId = object.objectId;
            //关联对象表
            BmobQuery *travel = [BmobQuery queryWithClassName:@"travel"];
            //需要查询的列
            BmobObject *user = [BmobObject objectWithoutDatatWithClassName:@"User" objectId:objectId];
            [travel whereObjectKey:@"travels" relatedTo:user];
            [travel findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                if (error) {
                    NSLog(@"%@",error);
                } else {
                    [self queryTravelWithPhoneNumber:phoneNumber password:password successBlock:^(NSArray *array) {
                        for (BmobObject *user in array) {
                            if ([travel_date isEqualToString:[user objectForKey:@"travel_date"]]) {
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
#pragma mark -- 删除一条游记
- (void)deleteTravelWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password travel_date:(NSString *)travel_date successBlock:(void(^)(NSArray *array))success failBlock:(void(^)(NSError * error))fail {
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
            BmobQuery *travel = [BmobQuery queryWithClassName:@"travel"];
            NSLog(@"objectId = %@",objectId);
            //需要查询的列
            BmobObject *user = [BmobObject objectWithoutDatatWithClassName:@"User" objectId:objectId];
            [travel whereObjectKey:@"travels" relatedTo:user];
            [travel findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                if (error) {
                    NSLog(@"%@",error);
                } else {
                    [self queryTravelWithPhoneNumber:phoneNumber password:password successBlock:^(NSArray *array) {
                        for (BmobObject *user in array) {
                            if ([travel_date isEqualToString:[user objectForKey:@"travel_date"]]) {
                                BmobObject *object = array[0];
                                NSString *travelObjectId = object.objectId;
                                BmobObject *user = [BmobObject objectWithoutDatatWithClassName:@"User" objectId:objectId];
                                
                                //新建relation对象
                                BmobRelation *relation = [[BmobRelation alloc] init];
                                [relation removeObject:[BmobObject objectWithoutDatatWithClassName:@"travel" objectId:travelObjectId]];
                                
                                //添加关联关系到travels列中
                                [user addRelation:relation forKey:@"travels"];
                                
                                //异步更新obj的数据
                                [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                    if (isSuccessful) {
                                        NSLog(@"successful");
                                        BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:@"travel"  objectId:travelObjectId];
                                        [bmobObject deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                                            if (isSuccessful) {
                                                //删除成功后的动作
                                                NSLog(@"successful");
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
                            }
                        }
                    }
                        failBlock:^(NSError *error) {
                    }];
                }
            }];
        }
    }];
}

#pragma mark --查询所有游记
- (void)queryTheTravelListWithskip:(NSInteger)skip SuccessBlock:(void(^)(NSMutableArray *objectArray))success failBlock:(void(^)(NSError * error))fail {
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Travel"];
    bquery.limit = 3;//每页3条
    bquery.skip = skip;//跳过查询的前多少条数据来实现分页查询的功能。
    [bquery orderByDescending:@"createdAt"];
    //查找travel表的数据
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"游记查询失败:%@",error);
        }
        else{
            
            NSMutableArray *objectArray = [NSMutableArray array];
            for (int i = 0; i < array.count; i ++) {
                BmobObject *travelObject = array[i];
                [objectArray addObject:travelObject];
            }
            success(objectArray);
        }
    }];
        
}

#pragma mark --压缩图片
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}


@end
