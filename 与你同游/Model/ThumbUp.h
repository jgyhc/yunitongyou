//
//  ThumbUp.h
//  与你同游
//
//  Created by mac on 16/3/19.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThumbUp : NSObject
//点赞
+ (void)thumUpWithID:(NSString *)travelOrCalledId type:(int)type  success:(void (^)(NSString *commentID))success failure:(void (^)(NSError *error1))failure;


+ (void)getThumbUpInfo:(NSString *)travelOrCalledId success:(void (^)(NSArray * thumbArray))success failure:(void (^)(NSError *error1))failure;

//取消点赞
+ (void)cancelThumUpWithID:(NSString *)thumbUpId  type:(int)type success:(void (^)(NSString *commentID))success failure:(void (^)(NSError *error1))failure;
@end
