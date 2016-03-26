//
//  CalledComments.m
//  与你同游
//
//  Created by Zgmanhui on 16/2/19.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import "Comments.h"

@implementation Comments
//添加一条评论（已测试）如果是回复的话  userID就放回复对象的ID  不是回复就传nil
+ (void)addComentWithContent:(NSString *)content userID:(NSString *)userID type:(long)type objID:(NSString *)objID success:(void (^)(NSString *commentID))success failure:(void (^)(NSError *error1))failure {
    NSLog(@"%@%@%ld%@", content, userID, type, objID);
    BmobObject  *comment = [BmobObject objectWithClassName:@"Comment"];
    [comment setObject:content forKey:@"content"];
    [comment setObject:[self CurrentTime] forKey:@"called_date"];
    [comment setObject:[NSNumber numberWithLong:type] forKey:@"type"];
    BmobObject *user = [BmobObject objectWithoutDatatWithClassName:@"User" objectId:UserID];
    [comment setObject:user forKey:@"user"];
    BmobObject *obj = [BmobObject new];//两种类型 对应两个表
    switch (type) {
        case 0:{
        obj.className = @"Called";
        obj.objectId = objID;
        [comment setObject:obj forKey:@"obj"];
        }
            break;
        case 1:{
        obj.className = @"Travel";
        obj.objectId = objID;
        [comment setObject:obj forKey:@"travelObj"];
        }
            break;
        default:
            break;
    }
    

    if (userID) {
        BmobObject *replyUser = [BmobObject objectWithoutDatatWithClassName:@"User" objectId:userID];
        [comment setObject:replyUser forKey:@"Ruser"];
    }
    //异步保存
    [comment saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            success(comment.objectId);
            //如果是回复添加关系
            if (userID) {
                BmobRelation *relation = [BmobRelation relation];
                [relation addObject:comment];
                BmobObject *replyUser = [BmobObject objectWithoutDatatWithClassName:@"User" objectId:userID];
                [comment setObject:replyUser forKey:@"Ruser"];
                [replyUser addRelation:relation forKey:@"replys"];
                [replyUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        NSLog(@"successful");
                    }else{
                        NSLog(@"error %@",[error description]);
                    }
                }];
            }
            //在user表里添加评论字段
            BmobRelation *relation1 = [BmobRelation relation];
            [relation1 addObject:comment];
            //添加关联关系到comments列中
            [user addRelation:relation1 forKey:@"comments"];
            [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    NSLog(@"successful");
                }else{
                    NSLog(@"error %@",[error description]);
                }
            }];
            
            BmobRelation *relation2 = [BmobRelation relation];
            [relation2 addObject:comment];
            //添加关联关系到 对应的obj表中（可能是游记、活动）
            //添加关联关系到comments列中
            [obj addRelation:relation2 forKey:@"comments"];
            
            [obj incrementKey:@"comments_number"];
            [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    NSLog(@"successful");
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






#pragma mark -- 获取当前时间
+ (NSString *)CurrentTime {
    NSDate *  senddate = [NSDate date];
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *  locationString = [dateformatter stringFromDate:senddate];
    return locationString;
}

@end
