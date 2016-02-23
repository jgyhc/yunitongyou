//
//  Called.h
//  与你同游
//
//  Created by Zgmanhui on 16/2/19.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
@interface Called : NSObject
@property (nonatomic, strong) NSString *calledId;
@property (nonatomic, strong) NSString *point_departure;//起点
@property (nonatomic, strong) NSString *destination;//终点
@property (nonatomic, strong) NSString *content;//内容
@property (nonatomic, strong) NSString *title;//主题
@property (nonatomic, strong) User *master;//发起者
@property (nonatomic, strong) NSArray *memberArray;//成员  User
@property (nonatomic, strong) NSArray *signUpArray;//报名的人 User
@property (nonatomic, assign) NSInteger numberFollower;//跟团人数
@property (nonatomic, strong) NSString *startTime;//出发时间
@property (nonatomic, strong) NSString *endTime;//到达时间
@property (nonatomic, strong) NSArray *imageArray;//发起的图片数组
@property (nonatomic, strong) NSString *phoneNumber;//联系电话



@end
