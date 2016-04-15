//
//  CalledComments.h
//  与你同游
//
//  Created by Zgmanhui on 16/2/19.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Called.h"
@class Comments;
@interface Comments : NSObject
@property (nonatomic, strong) Called *called;//被评论发起
@property (nonatomic, strong) NSString *contents;//内容
@property (nonatomic, strong) NSString *commentsTime;//评论时间
@property (nonatomic, strong) Comments *reply;//回复

+ (void)addComentWithContent:(NSString *)content userID:(NSString *)userID type:(long)type objID:(NSString *)objID success:(void (^)(NSString *commentID))success failure:(void (^)(NSError *error1))failure;

#pragma mark 查找评论
+ (void)serachCommentSuccessBlock:(void(^)(NSArray * commentArray))success failureBlock:(void(^)())failure;

@end
