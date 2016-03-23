//
//  Called.m
//  与你同游
//
//  Created by Zgmanhui on 16/2/19.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import "Called.h"

@implementation Called


- (id)initWithClassName:(NSString *)className {
    self = [super initWithClassName:className];
    if (self) {
        
    }
    return self;
}

+ (void)AddCalledWithTitle:(NSString *)title origin:(NSString *)origin destination:(NSString *)destination departureTime:(NSString *)departureTime arrivalTime:(NSString *)arrivalTime NumberOfPeople:(NSNumber *)NumberOfPeople content:(NSString *)content Success:(void (^)(NSString *calledID))success failure:(void (^)(NSError *error))failure {
    //创建一个游记信息
    BmobObject  *called = [BmobObject objectWithClassName:@"Called"];
    [called setObject:title forKey:@"title"];
    [called setObject:origin forKey:@"point_of_departure"];
    [called setObject:destination forKey:@"destination"];
    [called setObject:[self CurrentTime] forKey:@"called_date"];
    [called setObject:departureTime forKey:@"departure_time"];
    [called setObject:arrivalTime forKey:@"arrival_time"];
    [called setObject:NumberOfPeople forKey:@"number_Of_people"];
    [called setObject:content forKey:@"content"];
    
    //把发表这条活动的作者 放在called表的user字段下（为了满足通过查找活动找到该条活动的作者）(这里的关系是Pointer)
    BmobObject *user = [BmobObject objectWithoutDatatWithClassName:@"User" objectId:UserID];
    [called setObject:user forKey:@"user"];
    
    //新建relation对象  (把这条活动放进User表下的calleds字段下)（方便通过这个人找到他所有的活动）（这里的关系是relation）
    BmobRelation *relation = [BmobRelation relation];
    [relation addObject:called];
    //添加关联关系到calleds列中
    [user addRelation:relation forKey:@"calleds"];
    [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"successful");
            success(user.objectId);
        }else{
            NSLog(@"error %@",[error description]);
        }
    }];

    //异步保存
    [called saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {

        } else if (error){
            //发生错误后的动作
            NSLog(@"%@",error);
        } else {
            NSLog(@"Unknow error");
        }
    }];
}

//查找一个用户表下所有的活动（未测试）
+ (void)getCalledsSuccess:(void (^)(NSArray *calleds))success failure:(void (^)(NSError *error))failure {
    //关联对象表
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Called"];
    //需要查询的列
    BmobObject *user = [BmobObject objectWithoutDatatWithClassName:@"User" objectId:UserID];
    [bquery whereObjectKey:@"calleds" relatedTo:user];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            success(array);
//            for (BmobObject *user in array) {
//                NSLog(@"%@",[user objectForKey:@"username"]);
//            }
        }
    }];
}

//通过一条活动找到这条活动对应的作者（未测试）
+ (void)getUserCalledID:(NSString *)calledID Success:(void (^)(BmobObject *user))success failure:(void (^)(NSError *error1))failure {
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Called"];
    [bquery includeKey:@"user"];//声明查询Called的时候  把表里面user字段的数据查出来
    [bquery getObjectInBackgroundWithId:calledID block:^(BmobObject *object, NSError *error) {
        if (error) {
            failure(error);
            NSLog(@"%@",error);
        }else {
            BmobObject *called = object;
            BmobObject *user = [called objectForKey:@"user"];
            success(user);
        }

    }];
}
//查询活动列表（包括user字段下包含的作者信息）（已测试）
+ (void)getcalledListWithLimit:(NSInteger)limit skip:(NSInteger)skip Success:(void (^)(NSArray *calleds))success failure:(void (^)(NSError *error1))failure {
    BmobQuery  *bquery = [BmobQuery queryWithClassName:@"Called"];
    [bquery includeKey:@"user"];////声明查询Called的时候  把表里面user字段的数据查出来
    bquery.limit = limit;
    bquery.skip = skip;
    //查找Called表的数据
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        success(array);
    }];
}

//查询一条发起的评论列表
+ (void)getCommentsWithLimit:(NSInteger)limit skip:(NSInteger)skip CalledsID:(NSString *)calledID Success:(void (^)(NSArray *commentArray))success failure:(void (^)(NSError *error1))failure {
    //关联对象表
    BmobQuery *bqueryCommont = [BmobQuery queryWithClassName:@"Comment"];
    bqueryCommont.limit = limit;
    bqueryCommont.skip = skip;
    [bqueryCommont includeKey:@"user"];
    //需要查询的列
    BmobObject *called = [BmobObject objectWithoutDatatWithClassName:@"Called" objectId:calledID];
    [bqueryCommont whereObjectKey:@"comments" relatedTo:called];
    [bqueryCommont findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            success(array);
        }
    }];
}



#pragma mark -- 获取当前时间
+ (NSString *)CurrentTime {
    NSDate *  senddate = [NSDate date];
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *  locationString = [dateformatter stringFromDate:senddate];
    return locationString;
}
@end
