//
//  Travel.h
//  与你同游
//
//  Created by Zgmanhui on 16/2/19.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
@interface Travel : NSObject
@property (nonatomic, strong) NSString *travelID;
@property (nonatomic, strong) User *master;//发表游记的人
@property (nonatomic, strong) NSString *content;//内容
@property (nonatomic, strong) NSString *sightSpot;//景点
@property (nonatomic, strong) NSString *travelTime;//发表游记的时间
@property (nonatomic, assign) long upNumber;//点赞人数
@property (nonatomic, strong) NSArray *commentsArray;//点赞人数
@property (nonatomic, assign) long commentsNumber;//评论人数
@property (nonatomic, strong) NSArray *imageArray;//游记图片
@end
