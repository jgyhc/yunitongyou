//
//  CalledModel.m
//  BmobSDK网络测试
//
//  Created by rimi on 15/10/19.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "CalledModel.h"
#import "CalledNetWorking.h"
#import "CalledCommentsNetWorking.h"
#import "NetWorkingViewController.h"
@interface CalledModel ()

@property (nonatomic, strong) CalledNetWorking *calledNetWork;
@property (nonatomic, strong) CalledCommentsNetWorking *calledCommentsNetWork;
@property (nonatomic, copy) NSString *addActivitiesResult;
@property (nonatomic, strong) NetWorkingViewController *network;
@end

@implementation CalledModel

- (void)AddCalledWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password title:(NSString *)title origin:(NSString *)origin destination:(NSString *)destination departureTime:(NSString *)departureTime arrivalTime:(NSString *)arrivalTime NumberOfPeople:(NSNumber *)NumberOfPeople content:(NSString *)content image:(NSData *)image {
    
    __weak CalledModel *weakSelf = self;
    [self.calledNetWork AddCalledWithPhoneNumber:phoneNumber password:password title:title origin:origin destination:destination departureTime:departureTime arrivalTime:arrivalTime NumberOfPeople:NumberOfPeople content:content image:image successBlock:^(NSString *objiectId) {
        weakSelf.addActivitiesResult = @"YES";
    } failBlock:^(NSError *error) {
        
    }];
}

- (void)ChangeCalledWithPhoneNumber:(NSString *)phoneNumber called_date:(NSString *)called_date password:(NSString *)password title:(NSString *)title origin:(NSString *)origin destination:(NSString *)destination departureTime:(NSString *)departureTime arrivalTime:(NSString *)arrivalTime NumberOfPeople:(NSNumber *)NumberOfPeople content:(NSString *)content image:(NSData *)image {
    [self.calledNetWork ChangeCalledWithPhoneNumber:phoneNumber called_date:called_date password:password title:title origin:origin destination:destination departureTime:departureTime arrivalTime:arrivalTime NumberOfPeople:NumberOfPeople content:content image:image successBlock:^(NSString *objiectId) {
        
    } failBlock:^(NSError *error) {
        
    }];
}

- (void)FindCalledWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password{
    [self.calledNetWork FindCalledWithPhoneNumber:phoneNumber password:password successBlock:^(NSArray *array) {
        
    } failBlock:^(NSError *error) {
        
    }];
}

- (void)queryCalledWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password called_date:(NSString *)called_date{
    [self.calledNetWork queryCalledWithPhoneNumber:phoneNumber password:password called_date:called_date successBlock:^(BmobObject *object) {
        
    } failBlock:^(NSError *error) {
        
    }];
}


- (void)DeleteCalledWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password called_date:(NSString *)called_date{
    [self.calledNetWork DeleteCalledWithPhoneNumber:phoneNumber password:password called_date:called_date successBlock:^(NSArray *array) {
        
    } failBlock:^(NSError *error) {
        
    }];
}

- (void)CreateCalledCommentsWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password called_date:(NSString *)called_date creatorPhoneNumber:(NSString *)creatorPhoneNumber contents:(NSString *)contents {
    [self.calledCommentsNetWork CreateCalledCommentsWithPhoneNumber:phoneNumber Password:password called_date:called_date creatorPhoneNumber:creatorPhoneNumber contents:contents successBlock:^(NSString *objectId) {
        
    } failBlock:^(NSError *error) {
        
    }];
}

- (void)findCalledCommentsWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password called_date:(NSString *)called_date{
    [self.calledCommentsNetWork findCalledCommentsWithPhoneNumber:phoneNumber Password:password called_date:called_date successBlock:^(NSArray *commentsArray) {
        
    } failBlock:^(NSError *error) {
        
    }];
}

- (void)findCalledCommentWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password called_date:(NSString *)called_date called_comments_time:(NSString *)called_comments_time {
    [self.calledCommentsNetWork findCalledCommentWithPhoneNumber:phoneNumber Password:password called_date:called_date called_comments_time:called_comments_time successBlock:^(BmobObject *comment) {
        
    } failBlock:^(NSError *error) {
        
    }];
}

- (void)CreateCalledCommentReplyWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password CTphoneNumber:(NSString *)CTphoneNumber called_date:(NSString *)called_date called_comments_time:(NSString *)called_comments_time replyContents:(NSString *)replyContents {
    [self.calledCommentsNetWork CreateCalledCommentReplyWithPhoneNumber:phoneNumber Password:password CTphoneNumber:CTphoneNumber called_date:called_date called_comments_time:called_comments_time replyContents:replyContents successBlock:^(NSString *replyContentsId) {
        
    } failBlock:^(NSError *error) {
        
    }];
}

- (void)CreateCalledReplyReplyWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password CTphoneNumber:(NSString *)cTphoneNumber Called_date:(NSString *)called_date Called_comments_time:(NSString *)Called_comments_time replyContents:(NSString *)replyContents {
    [self.calledCommentsNetWork CreateCalledReplyReplyWithPhoneNumber:phoneNumber Password:password CTphoneNumber:cTphoneNumber Called_date:called_date Called_comments_time:Called_comments_time replyContents:replyContents successBlock:^(NSString *replyContentsId) {
        
    } failBlock:^(NSError *error) {
        
    }];
}

- (void)queryTheCalledlList {
    [self.calledNetWork queryTheCalledlListsuccessBlock:^(NSMutableArray *array) {
        self.calledArray = array;
        NSMutableArray *calledarray = [NSMutableArray arrayWithCapacity:self.calledArray.count];
        for (int i = 0; i < array.count; i ++) {
            [calledarray addObject:@0];
        }
        static int flag = 0;
        for (int i = 0; i < self.calledArray.count; i ++) {
            BmobObject *calledObject = array[i];
            
            [self.network getWithPhoneNumber:[calledObject objectForKey:@"phone_number"] password:nil successBlock:^(BmobObject *object) {
                [calledarray replaceObjectAtIndex:i withObject:object];
                flag ++;
                if (flag == self.calledArray.count) {
                    self.userArray = calledarray;
                }
            } failBlock:^(NSError *error) {
                
            }];
        }
    } failBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];
   
}

- (CalledNetWorking *)calledNetWork {
    if (!_calledNetWork) {
        _calledNetWork = [[CalledNetWorking alloc]init];
    }
    return _calledNetWork;
}
- (CalledCommentsNetWorking *)calledCommentsNetWork {
    if (!_calledCommentsNetWork) {
        _calledCommentsNetWork = [[CalledCommentsNetWorking alloc]init];
    }
    return _calledCommentsNetWork;
}

- (NetWorkingViewController *)network {
    if (!_network) {
        _network = [[NetWorkingViewController alloc] init];
    }
    return _network;
}
- (NSMutableArray *)calledArray {
    if (!_calledArray) {
        _calledArray = [NSMutableArray array];
    }
    return _calledArray;
}
- (NSMutableArray *)userArray {
    if (!_userArray) {
        _userArray = [NSMutableArray array];
    }
    return _userArray;
}
@end
