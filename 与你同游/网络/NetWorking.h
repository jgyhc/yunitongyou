//
//  NetWorking.h
//  与你同游
//
//  Created by Zgmanhui on 16/2/16.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NetWorking : NSObject
/**
 *  添加一条数据
 *
 *  @param tableName 表名
 *  @param data      数据
 *  @param listName  列明
 *  @param success
 *  @param fail
 */
- (void)adddataWithTableName:(NSString *)tableName data:(NSString *)data listName:(NSString *)listName successBlock:(void(^)(BmobObject *object))success failBlock:(void(^)(NSError * error))fail;

/**
 *  添加很多数据
 *
 *  @param tableName 表名
 *  @param dic       字典
 *  @param success
 *  @param fail
 */
- (void)addDataWithTableName:(NSString *)tableName dic:(NSDictionary *)dic successBlock:(void(^)(BmobObject *object))success failBlock:(void(^)(NSError * error))fail;
/**
 *  更新数据
 *
 *  @param tableName 表名
 *  @param data      数据
 *  @param listName  列
 *  @param success
 *  @param fail
 */
- (void)updateDataWithTableName:(NSString *)tableName data:(NSString *)data listName:(NSString *)listName successBlock:(void(^)(BmobObject *object))success failBlock:(void(^)(NSError * error))fail;

/**
 *  更新很多数据
 *
 *  @param tableName 表
 *  @param dic       字典
 *  @param success
 *  @param fail
 */
- (void)updateDataWithTableName:(NSString *)tableName dic:(NSDictionary *)dic successBlock:(void(^)(BmobObject *object))success failBlock:(void(^)(NSError * error))fail;

/**
 *  删除一条数据
 *
 *  @param tableName 表名
 *  @param objectId  id
 *  @param success
 *  @param fail
 */
- (void)delegateDataWithTableName:(NSString *)tableName objectId:(NSString *)objectId successBlock:(void(^)(BmobObject *object))success failBlock:(void(^)(NSError * error))fail;
/**
 *  查询一条数据
 *
 *  @param tableName 表名
 *  @param objectId  id
 *  @param success
 *  @param fail
 */
- (void)queryDataWithTableName:(NSString *)tableName objectId:(NSString *)objectId successBlock:(void(^)(BmobObject *object))success failBlock:(void(^)(NSError * error))fail;
/**
 *  批量查询
 *
 *  @param tableName     表名
 *  @param objectIdArray 数组
 *  @param success       
 *  @param fail
 */
- (void)queryDataWithTableName:(NSString *)tableName objectIdArray:(NSArray *)objectIdArray successBlock:(void(^)(BmobObject *object))success failBlock:(void(^)(NSError * error))fail;


/**
 *  添加一对一 关系 例子：用户写游记  user1 向called表中添加一条数据 并在called表中user列记录user1
 *   一条游记是谁的？只能对应一个用户！
 *  @param master         宿主（用户表）
 *  @param masterObjectId 找到这个（用户id）
 *  @param goal           目标表 （游记表）
 *  @param goalList       目标列（存放关系的列）
 *  @param success
 *  @param fail
 */
- (void)masterTable:(NSString *)master masterObjectId:(NSString *)masterObjectId goalTable:(NSString *)goal goalList:(NSString *)goalList successBlock:(void(^)(BmobObject *object))success failBlock:(void(^)(NSError * error))fail;
@end
