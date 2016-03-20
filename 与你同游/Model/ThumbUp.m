//
//  ThumbUp.m
//  与你同游
//
//  Created by mac on 16/3/19.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import "ThumbUp.h"

@implementation ThumbUp

#pragma mark -- 点赞
+ (void)thumUpWithID:(NSString *)travelOrCalledId type:(int)type  success:(void (^)(NSString *commentID))success failure:(void (^)(NSError *error1))failure{
    //添加数据（若无表，则会自动建表）
    BmobObject * thumb = [BmobObject objectWithClassName:@"ThumbUp"];

    [thumb setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    
    
    BmobObject * user = [BmobObject objectWithoutDatatWithClassName:@"User" objectId:OBJECTID];
    //该pointer跳到该条点赞的点赞人的user表
    [thumb setObject:user forKey:@"user"];
    
    BmobObject * obj;
    if (type == 0) {
        obj = [BmobObject objectWithClassName:@"Called"];
    }
    else if (type == 1){
        obj = [BmobObject objectWithClassName:@"Travel"];
    }
    
    obj.objectId = travelOrCalledId;
    //添加点赞数量
    int  number = [(NSNumber *)[obj objectForKey:@"number_of_thumb_up"] intValue];
    [obj setObject:@(number++) forKey:@"number_of_thumb_up"];
    //该pointer跳到该条点赞的travel或则called表
    [thumb setObject:obj forKey:@"obj"];
    //异步保存
    [thumb saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            
            //添加relation关联关系到该用户的User表中的thumbUp列
            BmobRelation * relation = [BmobRelation relation];
            [relation addObject:thumb];
            [user addRelation:relation forKey:@"thumbUp"];
            [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    NSLog(@"successful");
                }else{
                    NSLog(@"error %@",[error description]);
                }
            }];
            
             //添加relation关联关系到该条游记或活动中的thumbUp列
            BmobRelation * relation1 = [BmobRelation relation];
            [relation1 addObject:thumb];
            [obj addRelation:relation1 forKey:@"thumbUp"];
            [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    NSLog(@"successful");
                }else{
                    NSLog(@"error %@",[error description]);
                }
            }];
            
        }else if (error){
            //发生错误后的动作
            NSLog(@"%@",error);
        } else {
            NSLog(@"Unknow error");
        }

        
    }];
}

#pragma mark --取消点赞
+ (void)cancelThumUpWithID:(NSString *)thumbUpId  type:(int)type success:(void (^)(NSString *commentID))success failure:(void (^)(NSError *error1))failure{

    BmobQuery * bquery = [BmobQuery queryWithClassName:@"ThumbUp"];
    NSDictionary * condiction1 = @{@"user":@{@"__type":@"Pointer",@"className":@"User",@"objectId":OBJECTID}};
   NSDictionary *condiction2= @{@"obj":@{@"__type":@"Pointer",@"className":@"Travel",@"objectId":thumbUpId}};
    
    NSArray *condictionArray = @[condiction1,condiction2];
    [bquery addTheConstraintByAndOperationWithArray:condictionArray];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
        else{
            for (BmobObject * thumbObj in array) {
                [thumbObj deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                    
                    if (isSuccessful) {
                        //删除成功后的动作
                        NSLog(@"取消点赞成功！");
                    } else if (error){
                        NSLog(@"%@",error);
                    } else {
                        NSLog(@"UnKnow error");
                    }
                }];
            }
        }
        
        
    }];
    BmobObject * obj;
    if (type == 0) {
        obj = [BmobObject objectWithoutDatatWithClassName:@"Called" objectId:thumbUpId];
    }
    else if (type == 1){
        obj = [BmobObject objectWithoutDatatWithClassName:@"Travel" objectId:thumbUpId];
    }
    int  number = [(NSNumber *)[obj objectForKey:@"number_of_thumb_up"] intValue];
    [obj setObject:@(number--) forKey:@"number_of_thumb_up"];
//
//    BmobRelation *relation = [[BmobRelation alloc] init];
//    [relation removeObject:[BmobObject objectWithoutDatatWithClassName:@"ThumbUp" objectId:OBJECTID]];
//    
//    //添加关联关系到thumbUp列中
//    [obj addRelation:relation forKey:@"thumbUp"];
//    
//    BmobObject * userObj = [BmobObject objectWithoutDatatWithClassName:@"User" objectId:OBJECTID];
//    [userObj addRelation:relation forKey:@"thumbUp"];
//    
//    //异步更新obj的数据
    [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"successful");
        }else{
            NSLog(@"error %@",[error description]);
        }
    }];
//
//    [userObj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//        if (isSuccessful) {
//            NSLog(@"successful");
//        }else{
//            NSLog(@"error %@",[error description]);
//        }
//    }];

}

#pragma mark --获取点赞信息

+ (void)getThumbUpInfo:(NSString *)travelOrCalledId success:(void (^)(NSArray * thumbArray))success failure:(void (^)(NSError *error1))failure{
    BmobQuery * bqurey = [BmobQuery queryWithClassName:@"ThumbUp"];
    
    BmobObject * obj = [BmobObject objectWithoutDatatWithClassName:@"Travel" objectId:travelOrCalledId];
    
    [bqurey whereObjectKey:@"thumbUp" relatedTo:obj];

    [bqurey findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            success(array);
        }
        
    }];
}

@end
