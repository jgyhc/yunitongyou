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

+ (void)AddCalledWithUserID:(NSString *)userID title:(NSString *)title origin:(NSString *)origin destination:(NSString *)destination departureTime:(NSString *)departureTime arrivalTime:(NSString *)arrivalTime NumberOfPeople:(NSNumber *)NumberOfPeople content:(NSString *)content Success:(void (^)(NSString *calledID))success failure:(void (^)(NSError *error))failure {
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
    //异步保存
    [called saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //打印objectId
            //                    self.objectId = called.objectId;
            NSLog(@"objectid :%@",called.objectId);
            //将游记信息放在该用户表中
            //获取要添加关联关系的User
            BmobObject *user1 = [BmobObject objectWithoutDatatWithClassName:@"User" objectId:userID];
            
            //新建relation对象
            BmobRelation *relation = [[BmobRelation alloc] init];
            [relation addObject:[BmobObject objectWithoutDatatWithClassName:@"Called" objectId:called.objectId]];
            
            //添加关联关系到calleds列中
            [user1 addRelation:relation forKey:@"calleds"];
            
            [user1 updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    NSLog(@"successful");
                    success(called.objectId);
                }else{
                    NSLog(@"error %@",[error description]);
                }
            }];
            
        } else if (error){
            //发生错误后的动作
            NSLog(@"%@",error);
        } else {
            NSLog(@"Unknow error");
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
