//
//  CalledListModel.m
//  与你同游
//
//  Created by Zgmanhui on 16/3/9.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import "CalledListModel.h"

@implementation CalledListModel
+ (void)AddCalledWithUserID:(NSString *)userID title:(NSString *)title origin:(NSString *)origin destination:(NSString *)destination departureTime:(NSString *)departureTime arrivalTime:(NSString *)arrivalTime NumberOfPeople:(NSNumber *)NumberOfPeople content:(NSString *)content Success:(void (^)(NSString *calledID))success failure:(void (^)(NSError *error))failure {
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Called"];
    //查找Callde表的数据
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            //打印playerName
            NSLog(@"obj.objectId = %@", [obj objectId]);
        }
    }];


}
@end
