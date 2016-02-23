//
//  TravelCommentsNetWorking.m
//  BmobSDK网络测试
//
//  Created by rimi on 15/10/15.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "TravelCommentsNetWorking.h"
#import "NetWorkingViewController.h"
#define APPLICAYION_ID @"ed38f5e8bc84d1b80a90beab61dbc07b"
@implementation TravelCommentsNetWorking

- (instancetype)init
{
    self = [super init];
    if (self) {
        [Bmob registerWithAppKey:APPLICAYION_ID];
    }
    return self;
}

- (void)createATravelReviewsWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password travel_date:(NSString *)travel_date creatorPhoneNumber:(NSString *)creatorPhoneNumber contents:(NSString *)contents successBlock:(void(^)(NSString *objectId))success failBlock:(void(^)(NSError * error))fail {
    NetWorkingViewController *netWorking = [[NetWorkingViewController alloc] init];
    [netWorking queryTravelWithPhoneNumber:creatorPhoneNumber password:nil travel_date:travel_date successBlock:^(BmobObject *object) {
        if (![object objectForKey:@"comments_number"]) {
            [object setObject:[NSNumber numberWithInt:0] forKey:@"comments_number"];
        }else {
            [object setObject:[NSNumber numberWithInt:(int)[object objectForKey:@"comments_number"] + 1] forKey:@"comments_number"];
        }
        //把游记和评论关联
        [self CreateATravelReviewsWithPhoneNumber:phoneNumber Password:password contents:contents successBlock:^(BmobObject *commentObject) {
            //新建relation对象
            BmobRelation *relation = [[BmobRelation alloc] init];
            [relation addObject:[BmobObject objectWithoutDatatWithClassName:@"travel_comments" objectId:commentObject.objectId]];
            [object addRelation:relation forKey:@"comments"];
            //异步更新obj的数据
            [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    success(commentObject.objectId);
                }else{
                    NSLog(@"error %@",[error description]);
                }
            }];
            
            
            NetWorkingViewController *netWork = [[NetWorkingViewController alloc] init];
            [netWork getWithPhoneNumber:creatorPhoneNumber password:nil successBlock:^(BmobObject *object) {
                BmobRelation *relation1 = [[BmobRelation alloc] init];
                [relation1 addObject:[BmobObject objectWithoutDatatWithClassName:@"travel_comments" objectId:commentObject.objectId]];
                [object addRelation:relation1 forKey:@"replys"];
                //异步更新obj的数据
                [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        NSLog(@"创建回复成功");
                    }else{
                        NSLog(@"error %@",[error description]);
                    }
                }];
                
                //创建接受者 在评论表里
                BmobRelation *relation2 = [[BmobRelation alloc] init];
                [relation2 addObject:[BmobObject objectWithoutDatatWithClassName:@"User" objectId:object.objectId]];
                [commentObject addRelation:relation2 forKey:@"recipient"];
                //异步更新obj的数据
                [commentObject updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        NSLog(@"创建接受者成功");
                    }else{
                        NSLog(@"error %@",[error description]);
                    }
                }];
                
            } failBlock:^(NSError *error) {
                
            }];

        } failBlock:^(NSError *error) {
            
        }];
    } failBlock:^(NSError *error) {
        
    }];


}

- (void)findTravelCommentSpearkerWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password travel_date:(NSString *)travel_date travel_comments_time:(NSString *)travel_comments_time userType:(NSString *)userType successBlock:(void(^)(BmobObject *userObject))success failBlock:(void(^)(NSError * error))fail {
    
    [self findTravelCommentWithPhoneNumber:phoneNumber Password:password travel_date:travel_date travel_comments_time:travel_comments_time successBlock:^(BmobObject *comment) {
        //关联对象表
        BmobQuery *bquery = [BmobQuery queryWithClassName:@"User"];
        [bquery whereObjectKey:userType relatedTo:comment];
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
            } else {
                for (BmobObject *user in array) {
//                    NSLog(@"%@",[user objectForKey:@"userName"]);
                    success(user);
                }
            }
        }];
        
        
        
    } failBlock:^(NSError *error) {
        
    }];

}


#pragma mark -- 创建一条评论 并与 评论者关联
- (void)CreateATravelReviewsWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password contents:(NSString *)contents successBlock:(void(^)(BmobObject *commentObject))success failBlock:(void(^)(NSError * error))fail {
    NetWorkingViewController *netWorking = [[NetWorkingViewController alloc] init];
    //查找到用户
    [netWorking getWithPhoneNumber:phoneNumber password:password successBlock:^(BmobObject *object) {
        //给用户创建一条游记评论
        BmobObject *travel_comments = [BmobObject objectWithClassName:@"travel_comments"];
        [travel_comments setObject:contents forKey:@"contents"];
        [travel_comments setObject:[self CurrentTime] forKey:@"travel_comments_time"];
        [travel_comments saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error){
            if (isSuccessful) {
                //添加成功后的动作
                success(travel_comments);
                
                //把游记评论放进用户表
                BmobRelation *relation = [[BmobRelation alloc] init];
                [relation addObject:[BmobObject objectWithoutDatatWithClassName:@"travel_comments" objectId:travel_comments.objectId]];
                [object addRelation:relation forKey:@"travel_comments"];
                //异步更新obj的数据
                [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                    }else{
                        NSLog(@"error %@",[error description]);
                    }
                }];
                
                //把用户放进游记评论表的发言者里
                BmobRelation *relation1 = [[BmobRelation alloc] init];
                [relation1 addObject:[BmobObject objectWithoutDatatWithClassName:@"User" objectId:object.objectId]];
                [travel_comments addRelation:relation1 forKey:@"speaker"];
                //异步更新obj的数据
                [travel_comments updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
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
    
    }];

}
//查找一条游记的全部评论
- (void)findTravelCommentsWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password travel_date:(NSString *)travel_date successBlock:(void(^)(NSArray *commentsArray))success failBlock:(void(^)(NSError * error))fail {
    NetWorkingViewController *netWorking = [[NetWorkingViewController alloc] init];
    [netWorking queryTravelWithPhoneNumber:phoneNumber password:password travel_date:travel_date successBlock:^(BmobObject *object) {
        //关联对象表
        BmobQuery *travel_comments = [BmobQuery queryWithClassName:@"travel_comments"];
        //需要查询的列
        BmobObject *travel = [BmobObject objectWithoutDatatWithClassName:@"travel" objectId:object.objectId];
        [travel_comments whereObjectKey:@"comments" relatedTo:travel];
        [travel_comments findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
            } else {
                success(array);
            }
        }];

    } failBlock:^(NSError *error) {
        
    }];
}
//查找一条游记评论
- (void)findTravelCommentWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password travel_date:(NSString *)travel_date travel_comments_time:(NSString *)travel_comments_time successBlock:(void(^)(BmobObject *comment))success failBlock:(void(^)(NSError * error))fail {
    [self findTravelCommentsWithPhoneNumber:phoneNumber Password:password travel_date:travel_date successBlock:^(NSArray *commentsArray) {
        
        BmobQuery   *bquery = [BmobQuery queryWithClassName:@"travel_comments"];
        [bquery whereKey:@"travel_comments_time" equalTo:travel_comments_time];
        
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if (error){
                NSLog(@"error");
                fail(error);
            }else{
                BmobObject *object = array[0];
                success(object);
            }
        }];
        
    } failBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];


}

- (void)CreateTravelCommentReplyWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password CTphoneNumber:(NSString *)CTphoneNumber travel_date:(NSString *)travel_date travel_comments_time:(NSString *)travel_comments_time replyContents:(NSString *)replyContents successBlock:(void(^)(NSString *replyContentsId))success failBlock:(void(^)(NSError * error))fail; {
    [self findTravelCommentWithPhoneNumber:phoneNumber Password:password travel_date:travel_date travel_comments_time:travel_comments_time successBlock:^(BmobObject *comment) {
        //创建者创建一条回复（评论）并和创建者关联起来
        [self CreateATravelReviewsWithPhoneNumber:phoneNumber Password:password contents:replyContents successBlock:^(BmobObject *commentObject) {
            //把评论和评论关联
            //新建relation对象
            BmobRelation *relation = [[BmobRelation alloc] init];
            [relation addObject:[BmobObject objectWithoutDatatWithClassName:@"travel_comments" objectId:commentObject.objectId]];
            [comment addRelation:relation forKey:@"comments"];
            //异步更新obj的数据
            [comment updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    success(commentObject.objectId);
                }else{
                    NSLog(@"error %@",[error description]);
                }
            }];
            //获取评论者的信息  将其关联到回复的接受者  以及自身增加回复数量（提醒用户）
            NetWorkingViewController *netWork = [[NetWorkingViewController alloc] init];
            [netWork getWithPhoneNumber:CTphoneNumber password:nil successBlock:^(BmobObject *object) {
                
                BmobRelation *relation1 = [[BmobRelation alloc] init];
                [relation1 addObject:[BmobObject objectWithoutDatatWithClassName:@"travel_comments" objectId:commentObject.objectId]];
                [object addRelation:relation1 forKey:@"replys"];
                //异步更新obj的数据
                [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        NSLog(@"创建回复成功");
                    }else{
                        NSLog(@"error %@",[error description]);
                    }
                }];
                
                //创建接受者 在评论表里
                BmobRelation *relation2 = [[BmobRelation alloc] init];
                [relation2 addObject:[BmobObject objectWithoutDatatWithClassName:@"User" objectId:object.objectId]];
                [commentObject addRelation:relation2 forKey:@"recipient"];
                //异步更新obj的数据
                [commentObject updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        NSLog(@"创建接受者成功");
                    }else{
                        NSLog(@"error %@",[error description]);
                    }
                }];
            } failBlock:^(NSError *error) {
                
            }];
           
            } failBlock:^(NSError *error) {
            
        }];
    } failBlock:^(NSError *error) {
        
    }];


}

- (void)CreateTravelReplyReplyWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password CTphoneNumber:(NSString *)CTphoneNumber travel_date:(NSString *)travel_date travel_comments_time:(NSString *)travel_comments_time replyContents:(NSString *)replyContents successBlock:(void(^)(NSString *replyContentsId))success failBlock:(void(^)(NSError * error))fail {
    //查找到那条游记
    [self findTravelCommentWithPhoneNumber:CTphoneNumber Password:nil travel_date:travel_date travel_comments_time:travel_comments_time successBlock:^(BmobObject *comment) {
        //创建者创建一条回复（评论）并和创建者关联起来
        [self CreateATravelReviewsWithPhoneNumber:phoneNumber Password:password contents:replyContents successBlock:^(BmobObject *commentObject) {
            
            //把评论和评论关联
            //新建relation对象
            BmobRelation *relation = [[BmobRelation alloc] init];
            [relation addObject:[BmobObject objectWithoutDatatWithClassName:@"travel_comments" objectId:commentObject.objectId]];
            [comment addRelation:relation forKey:@"comments"];
            //异步更新obj的数据
            [comment updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    success(commentObject.objectId);
                }else{
                    NSLog(@"error %@",[error description]);
                }
            }];
            //获取游记创建者者的信息  将其关联到回复的接受者  以及自身增加回复数量（提醒用户）
            NetWorkingViewController *netWork = [[NetWorkingViewController alloc] init];
            [netWork getWithPhoneNumber:CTphoneNumber password:nil successBlock:^(BmobObject *object) {
                
                BmobRelation *relation1 = [[BmobRelation alloc] init];
                [relation1 addObject:[BmobObject objectWithoutDatatWithClassName:@"travel_comments" objectId:commentObject.objectId]];
                [object addRelation:relation1 forKey:@"replys"];
                //异步更新obj的数据
                [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        NSLog(@"创建回复成功");
                    }else{
                        NSLog(@"error %@",[error description]);
                    }
                }];
                
                //创建接受者 在评论表里
                BmobRelation *relation2 = [[BmobRelation alloc] init];
                [relation2 addObject:[BmobObject objectWithoutDatatWithClassName:@"User" objectId:object.objectId]];
                [commentObject addRelation:relation2 forKey:@"recipient"];
                //异步更新obj的数据
                [commentObject updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        NSLog(@"创建接受者成功");
                    }else{
                        NSLog(@"error %@",[error description]);
                    }
                }];
            } failBlock:^(NSError *error) {
                
            }];
        } failBlock:^(NSError *error) {
        }];
    } failBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];


}

- (void)ThumbUpWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password CTphoneNumber:(NSString *)CTphoneNumber travel_date:(NSString *)travel_date successBlock:(void(^)(NSString *thumb_upResults))success failBlock:(void(^)(NSError * error))fail {
    //找到那条游记
    NetWorkingViewController *network = [[NetWorkingViewController alloc] init];
    [network queryTravelWithPhoneNumber:CTphoneNumber password:nil travel_date:travel_date successBlock:^(BmobObject *object) {
        if (![object objectForKey:@"thumb_up"]) {
            [object setObject:[NSNumber numberWithInt:0] forKey:@"thumb_up"];
        }
        else {
            [object setObject:[NSNumber numberWithInt:(int)[object objectForKey:@"thumb_up"] + 1] forKey:@"thumb_up"];
        }
        //异步保存
        [object saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                //创建成功后会返回objectId，updatedAt，createdAt等信息
                //打印objectId
                success(@"YES");
                NSLog(@"objectid :%@",object.objectId);
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

- (void)getThumUpWithPhoneNumber:(NSString *)phoneNumber travel_date:(NSString *)travel_date successBlock:(void(^)(int thumbupNumber))success failBlock:(void(^)(NSError * error))fail {
    NetWorkingViewController *network = [[NetWorkingViewController alloc] init];
    [network queryTravelWithPhoneNumber:phoneNumber password:nil travel_date:travel_date successBlock:^(BmobObject *object) {
        if (![object objectForKey:@"thumb_up"]) {
            success(0);
        }
        success((int)[object objectForKey:@"thumb_up"]);
    } failBlock:^(NSError *error) {
        
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
