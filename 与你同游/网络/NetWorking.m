//
//  NetWorking.m
//  与你同游
//
//  Created by Zgmanhui on 16/2/16.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import "NetWorking.h"

@implementation NetWorking

//添加一条数据(数据为NSString)
- (void)adddataWithTableName:(NSString *)tableName data:(NSString *)data listName:(NSString *)listName successBlock:(void(^)(BmobObject *object))success failBlock:(void(^)(NSError * error))fail {
    BmobObject *bmobObject = [BmobObject objectWithClassName:tableName];
    [bmobObject setObject:data forKey:listName];
    [bmobObject saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            success(bmobObject);
            NSLog(@"%@", bmobObject.objectId);
            NSLog(@"成功!");
        }else{
            fail(error);
            NSLog(@"%@", error);
        }
    }];
}

//批量添加数据
- (void)addDataWithTableName:(NSString *)tableName dic:(NSDictionary *)dic successBlock:(void(^)(BmobObject *object))success failBlock:(void(^)(NSError * error))fail {
    BmobObject *bmobObject = [BmobObject objectWithClassName:tableName];
    [bmobObject saveAllWithDictionary:dic];
    [bmobObject saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            success(bmobObject);
            NSLog(@"%@", bmobObject.objectId);
            NSLog(@"成功!");
            //创建成功后的动作
        } else if (error){
            //发生错误后的动作
            NSLog(@"%@",error);
        } else {
            NSLog(@"Unknow error");
        }
    }];
}



//更新一条数据(数据为NSString)
- (void)updateDataWithTableName:(NSString *)tableName data:(NSString *)data listName:(NSString *)listName successBlock:(void(^)(BmobObject *object))success failBlock:(void(^)(NSError * error))fail {
    BmobObject *bmobObject = [BmobObject objectWithClassName:tableName];
    [bmobObject setObject:data forKey:listName];
    [bmobObject updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"更新成功!");
            NSLog(@"%@",bmobObject);
        } else {
            NSLog(@"%@",error);
        }
    }];
}

//批量更新
- (void)updateDataWithTableName:(NSString *)tableName dic:(NSDictionary *)dic successBlock:(void(^)(BmobObject *object))success failBlock:(void(^)(NSError * error))fail {
    BmobObject *bmobObject = [BmobObject objectWithClassName:tableName];
    [bmobObject saveAllWithDictionary:dic];
    [bmobObject updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"更新成功");
            NSLog(@"%@",bmobObject);
        } else {
            NSLog(@"%@",error);
        }
    }];
}
//删除一条数据
- (void)delegateDataWithTableName:(NSString *)tableName objectId:(NSString *)objectId successBlock:(void(^)(BmobObject *object))success failBlock:(void(^)(NSError * error))fail {
    BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:tableName  objectId:objectId];
    [bmobObject deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //删除成功后的动作
            NSLog(@"successful");
        } else if (error){
            NSLog(@"%@",error);
        } else {
            NSLog(@"UnKnow error");
        }
    }];
}

//查询
- (void)queryDataWithTableName:(NSString *)tableName objectId:(NSString *)objectId successBlock:(void(^)(BmobObject *object))success failBlock:(void(^)(NSError * error))fail {
    BmobQuery *bquery = [BmobQuery queryWithClassName:tableName];
    [bquery getObjectInBackgroundWithId:objectId block:^(BmobObject *object,NSError *error){
        if (error){
            //进行错误处理
        }else{
            NSLog(@"%@", object);
        }
    }];
}
//查询多条数据
- (void)queryDataWithTableName:(NSString *)tableName objectIdArray:(NSArray *)objectIdArray successBlock:(void(^)(BmobObject *object))success failBlock:(void(^)(NSError * error))fail {
    BmobQuery   *bquery = [BmobQuery queryWithClassName:tableName];
    //查找GameScore表的数据
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            NSLog(@"%@", obj);
        }
    }];
}

//添加一对一关系Pointer  例子：用户写游记  user1 向called表中添加一条数据 并在called表中user列记录user1
- (void)masterTable:(NSString *)master masterObjectId:(NSString *)masterObjectId goalTable:(NSString *)goal goalList:(NSString *)goalList successBlock:(void(^)(BmobObject *object))success failBlock:(void(^)(NSError * error))fail {
    BmobObject  *goalObeject = [BmobObject objectWithClassName:goal];
    //设置帖子关联的作者记录
    BmobUser *masterObeject = [BmobUser objectWithoutDatatWithClassName:master objectId:masterObjectId];
    [goalObeject setObject:masterObeject forKey:goalList];
    //异步保存
    [goalObeject saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //创建成功，返回objectId，updatedAt，createdAt等信息
            //打印objectId
            NSLog(@"objectid :%@",goalObeject.objectId);
        }else{
            if (error) {
                NSLog(@"%@",error);
            }
        }
    }];
}


@end
