//
//  Collection.m
//  与你同游
//
//  Created by mac on 16/3/24.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import "Collection.h"

@implementation Collection

#pragma mark -- 收藏
+ (void)CollectionWithID:(NSString *)travelOrCalledId type:(int)type  success:(void (^)(NSString *commentID))success failure:(void (^)(NSError *error1))failure{
    //添加数据（若无表，则会自动建表）
    BmobObject * collection = [BmobObject objectWithClassName:@"Collection"];
    
    [collection setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    
    
    BmobObject * user = [BmobObject objectWithoutDatatWithClassName:@"User" objectId:OBJECTID];
    //该pointer跳到该条点赞的点赞人的user表
    [collection setObject:user forKey:@"user"];
    
    BmobObject * obj;
    if (type == 0) {
        obj = [BmobObject objectWithoutDatatWithClassName:@"Called" objectId:travelOrCalledId];
    }
    else if (type == 1){
        obj = [BmobObject objectWithoutDatatWithClassName:@"Travel" objectId:travelOrCalledId];
    }
    //该pointer跳到该条点赞的travel或则called表
    [collection setObject:obj forKey:@"obj"];
    //异步保存
    [collection saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            
            //添加relation关联关系到该用户的User表中的thumbUp列
            BmobRelation * relation = [BmobRelation relation];
            [relation addObject:collection];
            [user addRelation:relation forKey:@"collection"];
            [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    NSLog(@"successful");
                }else{
                    NSLog(@"error %@",[error description]);
                }
            }];
            
            //添加relation关联关系到该条游记或活动中的thumbUp列
            BmobRelation * relation1 = [BmobRelation relation];
            [relation1 addObject:collection];
            [obj addRelation:relation1 forKey:@"collection"];
            
            //添加数组中该点赞人id
            [obj addUniqueObjectsFromArray:@[OBJECTID] forKey:@"collectionArray"];
 
            [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    success(@"收藏成功");
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

#pragma mark --取消收藏
+ (void)cancelCollectionWithID:(NSString *)travelOrCalledId  type:(int)type success:(void (^)(NSString *commentID))success failure:(void (^)(NSError *error1))failure{
    
    BmobQuery * bquery = [BmobQuery queryWithClassName:@"Collection"];
    NSDictionary * condiction1  = @{@"user":@{@"__type":@"Pointer",@"className":@"User",@"objectId":OBJECTID}};
    
    NSDictionary *condiction2;
    
    if (type == 0) {
        condiction2= @{@"obj":@{@"__type":@"Pointer",@"className":@"Called",@"objectId":travelOrCalledId}};
    }
    else if (type == 1){
       condiction2= @{@"obj":@{@"__type":@"Pointer",@"className":@"Travel",@"objectId":travelOrCalledId}};
    }

    
    NSArray *condictionArray = @[condiction1,condiction2];
    [bquery addTheConstraintByAndOperationWithArray:condictionArray];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
        else{
            for (BmobObject * collectionObj in array) {
                [collectionObj deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                    
                    if (isSuccessful) {
                        //删除成功后的动作
                        success(@"取消点赞成功！");
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
        obj = [BmobObject objectWithoutDatatWithClassName:@"Called" objectId:travelOrCalledId];
    }
    else if (type == 1){
        obj = [BmobObject objectWithoutDatatWithClassName:@"Travel" objectId:travelOrCalledId];
    }

    //删除数组中该点赞人id
    [obj removeObjectsInArray:@[OBJECTID] forKey:@"collectionArray"];
    //异步更新obj的数据
    [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"successful");
        }else{
            NSLog(@"error %@",[error description]);
        }
    }];
}

+ (void)getCollectionSuccess:(void (^)(NSArray *collections))success failure:(void (^)(NSError *error))failure {
    //关联对象表
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Collection"];
    BmobQuery * inQuery = [BmobQuery queryWithClassName:@"User"];
    [inQuery whereKey:@"objectId" equalTo:OBJECTID];
    //匹配查询
    [bquery whereKey:@"user" matchesQuery:inQuery];
    [bquery orderByDescending:@"createdAt"];
    [bquery includeKey:@"user"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            success(array);
        }
    }];
}


@end
