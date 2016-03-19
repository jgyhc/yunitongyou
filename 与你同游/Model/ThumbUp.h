//
//  ThumbUp.h
//  与你同游
//
//  Created by mac on 16/3/19.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThumbUp : NSObject

+ (void)thumUpWithID:(NSString *)travelOrCalledId type:(int)type  success:(void (^)(NSString *commentID))success failure:(void (^)(NSError *error1))failure;


+ (void)getThumbUpInfo:(NSString *)travelOrCalledId success:(void (^)(int thumbNumber))success failure:(void (^)(NSError *error1))failure;
@end
