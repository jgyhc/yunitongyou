//
//  Collection.h
//  与你同游
//
//  Created by mac on 16/3/24.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Collection : NSObject

//收藏
+ (void)CollectionWithID:(NSString *)travelOrCalledId type:(int)type  success:(void (^)(NSString *commentID))success failure:(void (^)(NSError *error1))failure;


//取消收藏
+ (void)cancelCollectionWithID:(NSString *)thumbUpId  type:(int)type success:(void (^)(NSString *commentID))success failure:(void (^)(NSError *error1))failure;

//查询某个用户的收藏
+ (void)getCollectionSuccess:(void (^)(NSArray *collections))success  type:(int)type failure:(void (^)(NSError *error))failure ;

@end
