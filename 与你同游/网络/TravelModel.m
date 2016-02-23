//
//  TravelModel.m
//  BmobSDK网络测试
//
//  Created by rimi on 15/10/19.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "TravelModel.h"
#import "TravelCommentsNetWorking.h"

@interface TravelModel ()

@property (nonatomic, strong) TravelCommentsNetWorking *travelCommentsNetWork;
@property (nonatomic, assign) int thumbUpNumber;
@property (nonatomic, copy) NSString *thumb_upResults;
@property (nonatomic, strong) NSMutableArray *CommentsArray;
@property (nonatomic, strong) NSString *createTCommentResult;
@property (nonatomic, strong) BmobObject *userData;
@end

@implementation TravelModel




- (void)createATravelReviewsWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password travel_date:(NSString *)travel_date creatorPhoneNumber:(NSString *)creatorPhoneNumber contents:(NSString *)contents{
    [self.travelCommentsNetWork createATravelReviewsWithPhoneNumber:phoneNumber Password:password travel_date:travel_date creatorPhoneNumber:creatorPhoneNumber contents:contents successBlock:^(NSString *objectId) {
        self.createTCommentResult = @"YES";
    } failBlock:^(NSError *error) {
        
    }];
}

- (void)findTravelCommentsWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password travel_date:(NSString *)travel_date{
    
    [self.travelCommentsNetWork findTravelCommentsWithPhoneNumber:phoneNumber Password:password travel_date:travel_date successBlock:^(NSArray *commentsArray) {
        
        self.travelCommentArray = commentsArray;
        
    } failBlock:^(NSError *error) {
        
    }];
}

- (void)findTravelCommentSpearkerWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password travel_date:(NSString *)travel_date travel_comments_time:(NSString *)travel_comments_time userType:(NSString *)userType index:(NSInteger)index {
    [self.travelCommentsNetWork findTravelCommentSpearkerWithPhoneNumber:phoneNumber Password:password travel_date:travel_date travel_comments_time:travel_comments_time userType:userType successBlock:^(BmobObject *userObject) {

        if (![[userObject objectForKey:@"head_portraits1"] isEqualToString:@""]) {
            NSString * URL =  [NSString stringWithFormat:@"%@?t=1&a=f008d46b406baaa7eff26eba98dccd54", [userObject objectForKey:@"head_portraits1"]];
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:URL]];
            UIImage *image = [UIImage imageWithData:data];
            [userObject setObject:image forKey:@"head_portraits1"];
        }else {
            [userObject setObject:IMAGE_PATH(@"qq.png") forKey:@"head_portraits1"];
        }
        
        if ([userType isEqualToString:@"speaker"]) {
            self.speaker = userObject;
        }else {
            self.recipient = userObject;
        }
    } failBlock:^(NSError *error) {
        
    }];
}

- (void)findTravelCommentWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password travel_date:(NSString *)travel_date travel_comments_time:(NSString *)travel_comments_time{
    [self.travelCommentsNetWork findTravelCommentWithPhoneNumber:phoneNumber Password:password travel_date:travel_date travel_comments_time:travel_comments_time successBlock:^(BmobObject *comment) {
        
    } failBlock:^(NSError *error) {
        
    }];
}

- (void)CreateTravelCommentReplyWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password CTphoneNumber:(NSString *)CTphoneNumber travel_date:(NSString *)travel_date travel_comments_time:(NSString *)travel_comments_time replyContents:(NSString *)replyContents {
    [self.travelCommentsNetWork CreateTravelCommentReplyWithPhoneNumber:phoneNumber Password:password CTphoneNumber:CTphoneNumber travel_date:travel_date travel_comments_time:travel_comments_time replyContents:replyContents successBlock:^(NSString *replyContentsId) {
        
    } failBlock:^(NSError *error) {
        
    }];
}

- (void)CreateTravelReplyReplyWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password CTphoneNumber:(NSString *)CTphoneNumber travel_date:(NSString *)travel_date travel_comments_time:(NSString *)travel_comments_time replyContents:(NSString *)replyContents{
    [self.travelCommentsNetWork CreateTravelReplyReplyWithPhoneNumber:phoneNumber Password:password CTphoneNumber:CTphoneNumber travel_date:travel_date travel_comments_time:travel_comments_time replyContents:replyContents successBlock:^(NSString *replyContentsId) {
        
    } failBlock:^(NSError *error) {
        
    }];
}
- (void)ThumbUpWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password CTphoneNumber:(NSString *)CTphoneNumber travel_date:(NSString *)travel_date {
    [self.travelCommentsNetWork ThumbUpWithPhoneNumber:phoneNumber password:password CTphoneNumber:CTphoneNumber travel_date:travel_date successBlock:^(NSString *thumb_upResults) {
        self.thumb_upResults = thumb_upResults;
    } failBlock:^(NSError *error) {
        
    }];
}
- (void)getThumUpWithPhoneNumber:(NSString *)phoneNumber travel_date:(NSString *)travel_date {
    [self.travelCommentsNetWork getThumUpWithPhoneNumber:phoneNumber travel_date:travel_date successBlock:^(int thumbupNumber) {
        self.thumbUpNumber = thumbupNumber;
    } failBlock:^(NSError *error) {
        
    }];

}

- (TravelCommentsNetWorking *)travelCommentsNetWork {
    if (!_travelCommentsNetWork) {
        _travelCommentsNetWork = [[TravelCommentsNetWorking alloc]init];
    }
    return _travelCommentsNetWork;
}

- (NSArray *)travelCommentArray {
    if (!_travelCommentArray) {
        _travelCommentArray = [NSArray array];
    }
    return _travelCommentArray;
}
- (NSMutableArray *)speakerArray {
    if (!_speakerArray) {
        _speakerArray = [NSMutableArray array];
    }
    return _speakerArray;
}
- (NSMutableArray *)recipientArray {
    if (!_recipientArray) {
        _recipientArray = [NSMutableArray array];
    }
    return _recipientArray;
}

@end
