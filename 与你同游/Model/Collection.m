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
 
    BmobObject * user = [BmobObject objectWithoutDatatWithClassName:@"User" objectId:OBJECTID];

    BmobObject * obj;
    if (type == 0) {
        obj = [BmobObject objectWithoutDatatWithClassName:@"Called" objectId:travelOrCalledId];
    }
    else if (type == 1){
        obj = [BmobObject objectWithoutDatatWithClassName:@"Travel" objectId:travelOrCalledId];
    }
    //添加数组中该点赞人id
    [obj addUniqueObjectsFromArray:@[OBJECTID] forKey:@"collectionArray"];
    
    [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            BmobRelation * relation = [BmobRelation relation];
            [relation addObject:obj];
            [user addRelation:relation forKey:@"collection"];
            [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    NSLog(@"successful");
                }else{
                    NSLog(@"error %@",[error description]);
                }
            }];
            
        }else{
            NSLog(@"error %@",[error description]);
        }
    }];
}

#pragma mark --取消收藏
+ (void)cancelCollectionWithID:(NSString *)travelOrCalledId  type:(int)type success:(void (^)(NSString *commentID))success failure:(void (^)(NSError *error1))failure{

    BmobObject * user = [BmobObject objectWithoutDatatWithClassName:@"User" objectId:OBJECTID];
    BmobRelation * relation = [[BmobRelation alloc]init];
   
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
            [relation removeObject:obj];
            [user addRelation:relation forKey:@"collection"];
            [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    success(@"success");
                }
                else{
                   NSLog(@"error %@",[error description]);
                }
            }];
        }else{
            NSLog(@"error %@",[error description]);
        }
    }];
    
    
}

+ (void)getCollectionSuccess:(void (^)(NSArray *collections))success  type:(int)type failure:(void (^)(NSError *error))failure {
    BmobQuery * bquery;
    if (type == 0) {
        bquery = [BmobQuery queryWithClassName:@"Called"];
    }
    else if (type == 1){
        bquery = [BmobQuery queryWithClassName:@"Travel"];
    }
    BmobObject * obj = [BmobObject objectWithoutDatatWithClassName:@"User" objectId:OBJECTID];
    [bquery whereObjectKey:@"collection" relatedTo:obj];
    [bquery includeKey:@"user"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            success(array);
//            for (BmobObject * obj in array) {
//                
//            }
        }
    }];

    //构造约束条件
//    BmobQuery * inQuery = [BmobQuery queryWithClassName:@"User"];
//    [inQuery whereKey:@"objectId" equalTo:OBJECTID];
//    //匹配查询
////    [bquery whereKey:@"userId" matchesQuery:inQuery];
//    [bquery orderByDescending:@"createdAt"];
////    [bquery includeKey:@"userId"];
//    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
//        if (error) {
//            NSLog(@"%@",error);
//        } else {
//            success(array);
//        }
//    }];
}


@end
