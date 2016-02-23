//
//  CalledComments.h
//  与你同游
//
//  Created by Zgmanhui on 16/2/19.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Called.h"
@class CalledComments;
@interface CalledComments : NSObject
@property (nonatomic, strong) User *master;//评论者
@property (nonatomic, strong) Called *called;//被评论发起
@property (nonatomic, strong) NSString *contents;//内容
@property (nonatomic, strong) NSString *commentsTime;//评论时间
@property (nonatomic, strong) CalledComments *reply;//回复
@end
