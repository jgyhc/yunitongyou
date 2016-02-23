//
//  CalledCommentsNetWorking.m
//  BmobSDK网络测试
//
//  Created by rimi on 15/10/18.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "CalledCommentsNetWorking.h"
#import "CalledNetWorking.h"
#import "NetWorkingViewController.h"
#define APPLICAYION_ID @"ed38f5e8bc84d1b80a90beab61dbc07b"
@implementation CalledCommentsNetWorking
- (instancetype)init
{
    self = [super init];
    if (self) {
        [Bmob registerWithAppKey:APPLICAYION_ID];
    }
    return self;
}

- (void)CreateCalledCommentsWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password called_date:(NSString *)called_date creatorPhoneNumber:(NSString *)creatorPhoneNumber contents:(NSString *)contents successBlock:(void(^)(NSString *objectId))success failBlock:(void(^)(NSError * error))fail {
    CalledNetWorking *callNet = [[CalledNetWorking alloc] init];
    //找到那条发起
    [callNet queryCalledWithPhoneNumber:creatorPhoneNumber password:password called_date:called_date successBlock:^(BmobObject *object) {
        //新建评论 关联评论者
        [self CreateCalledCommentsWithPhoneNumber:phoneNumber Password:password contents:contents successBlock:^(BmobObject *calledObject) {
            //新建评论 关联发起
            BmobRelation *relation = [[BmobRelation alloc] init];
            [relation addObject:[BmobObject objectWithoutDatatWithClassName:@"called_comments" objectId:calledObject.objectId]];
            [object addRelation:relation forKey:@"comments"];
            //异步更新obj的数据
            [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    success(calledObject.objectId);
                }else{
                    NSLog(@"error %@",[error description]);
                }
            }];
            
            //新建回复给发起者
            NetWorkingViewController *netWork = [[NetWorkingViewController alloc] init];
            [netWork getWithPhoneNumber:creatorPhoneNumber password:nil successBlock:^(BmobObject *object) {
                BmobRelation *relation1 = [[BmobRelation alloc] init];
                [relation1 addObject:[BmobObject objectWithoutDatatWithClassName:@"called_comments" objectId:calledObject.objectId]];
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
                [calledObject addRelation:relation2 forKey:@"recipient"];
                //异步更新obj的数据
                [calledObject updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
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
#pragma mark -- 创建一条评论 并与 评论者关联
- (void)CreateCalledCommentsWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password contents:(NSString *)contents successBlock:(void(^)(BmobObject *calledObject))success failBlock:(void(^)(NSError * error))fail {
    NetWorkingViewController *netWorking = [[NetWorkingViewController alloc] init];
    //查找到用户
    [netWorking getWithPhoneNumber:phoneNumber password:password successBlock:^(BmobObject *object) {
        //给用户创建一条发起评论
        BmobObject *called_comments = [BmobObject objectWithClassName:@"called_comments"];
        [called_comments setObject:contents forKey:@"contents"];
        [called_comments setObject:[self CurrentTime] forKey:@"called_comments_time"];
        [called_comments saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error){
            if (isSuccessful) {
                //添加成功后的动作
                success(called_comments);
                
                //把发起评论放进用户表
                BmobRelation *relation = [[BmobRelation alloc] init];
                [relation addObject:[BmobObject objectWithoutDatatWithClassName:@"called_comments" objectId:called_comments.objectId]];
                [object addRelation:relation forKey:@"called_comments"];
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
                [called_comments addRelation:relation1 forKey:@"speaker"];
                //异步更新obj的数据
                [called_comments updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
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

- (void)findCalledCommentsWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password called_date:(NSString *)called_date successBlock:(void(^)(NSArray *commentsArray))success failBlock:(void(^)(NSError * error))fail {
    CalledNetWorking *netWorking = [[CalledNetWorking alloc] init];
    [netWorking queryCalledWithPhoneNumber:phoneNumber password:password called_date:called_date successBlock:^(BmobObject *object) {
        //关联对象表
        BmobQuery *called_comments = [BmobQuery queryWithClassName:@"called_comments"];
        //需要查询的列
        BmobObject *called = [BmobObject objectWithoutDatatWithClassName:@"called" objectId:object.objectId];
        [called_comments whereObjectKey:@"comments" relatedTo:called];
        [called_comments findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
            } else {
                success(array);
            }
        }];
        
    } failBlock:^(NSError *error) {
        
    }];



}

- (void)findCalledCommentWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password called_date:(NSString *)called_date called_comments_time:(NSString *)called_comments_time successBlock:(void(^)(BmobObject *comment))success failBlock:(void(^)(NSError * error))fail {
    [self findCalledCommentsWithPhoneNumber:phoneNumber Password:password called_date:called_date successBlock:^(NSArray *commentsArray) {
        
        BmobQuery   *bquery = [BmobQuery queryWithClassName:@"called_comments"];
        [bquery whereKey:@"called_comments_time" equalTo:called_comments_time];
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

- (void)CreateCalledCommentReplyWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password CTphoneNumber:(NSString *)CTphoneNumber called_date:(NSString *)called_date called_comments_time:(NSString *)called_comments_time replyContents:(NSString *)replyContents successBlock:(void(^)(NSString *replyContentsId))success failBlock:(void(^)(NSError * error))fail {
    
    [self findCalledCommentWithPhoneNumber:phoneNumber Password:password called_date:called_date called_comments_time:called_comments_time successBlock:^(BmobObject *comment) {
        //创建者创建一条回复（评论）并和创建者关联起来
        [self CreateCalledCommentsWithPhoneNumber:phoneNumber Password:password contents:replyContents successBlock:^(BmobObject *commentObject) {
            //把评论和评论关联
            //新建relation对象
            BmobRelation *relation = [[BmobRelation alloc] init];
            [relation addObject:[BmobObject objectWithoutDatatWithClassName:@"called_comments" objectId:commentObject.objectId]];
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
                [relation1 addObject:[BmobObject objectWithoutDatatWithClassName:@"called_comments" objectId:commentObject.objectId]];
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

- (void)CreateCalledReplyReplyWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password CTphoneNumber:(NSString *)CTphoneNumber Called_date:(NSString *)Called_date Called_comments_time:(NSString *)Called_comments_time replyContents:(NSString *)replyContents successBlock:(void(^)(NSString *replyContentsId))success failBlock:(void(^)(NSError * error))fail {
    //查找到那条发起
    [self findCalledCommentWithPhoneNumber:CTphoneNumber Password:nil called_date:Called_date called_comments_time:Called_comments_time successBlock:^(BmobObject *comment) {
        //创建者创建一条回复（评论）并和创建者关联起来
        [self CreateCalledCommentsWithPhoneNumber:phoneNumber Password:password contents:replyContents successBlock:^(BmobObject *commentObject) {
            
            //把评论和评论关联
            //新建relation对象
            BmobRelation *relation = [[BmobRelation alloc] init];
            [relation addObject:[BmobObject objectWithoutDatatWithClassName:@"called_comments" objectId:commentObject.objectId]];
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
                [relation1 addObject:[BmobObject objectWithoutDatatWithClassName:@"called_comments" objectId:commentObject.objectId]];
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
















#pragma mark -- 获取当前时间
- (NSString *)CurrentTime {
    NSDate *  senddate = [NSDate date];
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *  locationString = [dateformatter stringFromDate:senddate];
    return locationString;
}

@end
