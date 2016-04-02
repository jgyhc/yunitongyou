//
//  ScenicSpot.h
//  与你同游
//
//  Created by Zgmanhui on 16/3/26.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import <Foundation/Foundation.h>


@class  SSShowapi_res_body;

/**======= 景点 ========*/
@interface ScenicSpot : NSObject

/** 请求体 */
@property (nonatomic, strong) SSShowapi_res_body * showapi_res_body;

/** 错误信息 */
@property (nonatomic, copy) NSString* showapi_res_error;

/**  */
@property (nonatomic, assign) NSInteger  showapi_res_code;

/**
 *  保存景点信息
 *
 *  @param ScenicSpotID 景点id
 *  @param name         名字
 *  @param content      内容介绍
 *  @param lat          经度
 *  @param lon          纬度
 *  @param address      地址
 *  @param areaName     区域
 *  @param price        价格
 *  @param priceList    价格表
 *  @param picList      图片
 *  @param success
 *  @param failure
 */
+ (void)addScenicSpotArray:(NSDictionary *)dic success:(void (^)(BOOL isSuccessful))success failure:(void (^)(NSError *error1))failure;

/**
 *  热词统计
 *
 *  @param words   关键词
 *  @param success
 *  @param failure 
 */
+ (void)addSearchWords:(NSString *)words success:(void (^)(NSString* hotWordID))success failure:(void (^)(NSError *error1))failure;
/**
 *  热词列表
 *
 *  @param success
 *  @param failure 
 */
+ (void)getHotWordsSuccess:(void (^)(NSArray *horWords))success failure:(void (^)(NSError *error))failure;

/**
 *  获取广告
 *
 *  @param success
 *  @param failure
 */
+ (void)getAdUrlsSuccess:(void (^)(NSArray *urls))success failure:(void (^)(NSError *error))failure;

- (void)sendAsynchronizedPostRequest:(NSString *)keyword;
@property (nonatomic, strong) void (^ssblock)(ScenicSpot *scenicSpot);

@end


@class  SSPagebean;

/**======= 页数信息 ========*/
@interface SSShowapi_res_body : NSObject

/**  */
@property (nonatomic, strong) SSPagebean * pagebean;

/**  */
@property (nonatomic, assign) NSInteger  ret_code;

@end


@class  SSContentlist;

/**======= 内容 ========*/
@interface SSPagebean : NSObject

/** 总数 */
@property (nonatomic, assign) NSInteger  allNum;

/**  内容list*/
@property (nonatomic, strong) NSArray* contentlist;

/** 最大结果 */
@property (nonatomic, assign) NSInteger  maxResult;

@end


@class  SSLocation, SSPicList, SSPriceList;

/**======= 数据 ========*/
@interface SSContentlist : NSObject

/** 景点id */
@property (nonatomic, assign) long  Id;

/**  */
@property (nonatomic, copy) NSString* summary;

/** 区域ID */
@property (nonatomic, assign) NSInteger  areaId;

/** 星级 */
@property (nonatomic, copy) NSString* star;

/** 价格 */
@property (nonatomic, assign) CGFloat  price;

/** 地址 */
@property (nonatomic, copy) NSString* address;

/** 经纬度 */
@property (nonatomic, strong) SSLocation * location;

/** 区域名 */
@property (nonatomic, copy) NSString* areaName;

/**  */
@property (nonatomic, assign) NSInteger  proId;

/** 图片 */
@property (nonatomic, strong) NSArray* picList;

/** 价格表 */
@property (nonatomic, strong) NSArray* priceList;

/**  */
@property (nonatomic, copy) NSString* proName;

/** 城市Id */
@property (nonatomic, assign) NSInteger  cityId;

/** 景点名字 */
@property (nonatomic, copy) NSString* name;

/** 内容 */
@property (nonatomic, copy) NSString* content;

@end

/**======= 经纬度 ========*/
@interface SSLocation : NSObject

/** 经度 */
@property (nonatomic, assign) CGFloat  lat;

/** 纬度 */
@property (nonatomic, assign) CGFloat  lon;

@end

/**======= 图片 ========*/
@interface SSPicList : NSObject

/** 地址 */
@property (nonatomic, copy) NSString* picUrl;

/** 缩略图 */
@property (nonatomic, copy) NSString* picUrlSmall;

@end


@class  SSEntityList;

/**======= description ========*/
@interface SSPriceList : NSObject

/**  */
@property (nonatomic, strong) NSArray* entityList;

/**  */
@property (nonatomic, copy) NSString* type;

@end

/**======= 门票信息 ========*/
@interface SSEntityList : NSObject

/** 票 */
@property (nonatomic, copy) NSString* TicketName;

/**  */
@property (nonatomic, assign) NSInteger  Amount;

/**     */
@property (nonatomic, assign) NSInteger  AmountAdvice;



@end

