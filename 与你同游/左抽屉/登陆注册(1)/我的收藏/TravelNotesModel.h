//
//  TravelNotesModel.h
//  与你同游
//
//  Created by mac on 16/3/3.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TravelNotesModel : NSObject

@property (nonatomic, copy) NSString * iconName;//头像
@property (nonatomic, copy) NSString * name;//名字
@property (nonatomic, copy) NSString * localImage;
@property (nonatomic, copy) NSString * position;//地点
@property (nonatomic, copy) NSString * time;//时间
@property (nonatomic, copy) NSString * content;//内容
@property (nonatomic, strong) NSArray * picArray;//图片

@property (nonatomic, copy) NSString * dianzanImage;//点赞
@property (nonatomic, copy) NSString * dianzanNumber;
@property (nonatomic, copy) NSString * pinglunImage;//评论
@property (nonatomic, copy) NSString * pinglunNumber;
@property (nonatomic, copy) NSString * shareImage;//分享


@property (nonatomic, assign) BOOL isOpening;
@property (nonatomic,assign,readonly) BOOL shouldShowMoreButton;

@end
