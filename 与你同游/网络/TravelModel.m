//
//  TravelModel.m
//  BmobSDK网络测试
//
//  Created by rimi on 15/10/19.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "TravelModel.h"
#import "TravelCommentsNetWorking.h"
#import "UserModel.h"
#import "ThumbUp.h"

@interface TravelModel ()

@property (nonatomic, strong) TravelCommentsNetWorking *travelCommentsNetWork;
@property (nonatomic, strong)  UserModel * userModel;
@property (nonatomic, assign) int thumbUpNumber;
@property (nonatomic, copy) NSString *thumb_upResults;
@property (nonatomic, strong) NSMutableArray *CommentsArray;
@property (nonatomic, strong) NSString *createTCommentResult;
@property (nonatomic, strong) BmobObject *userData;

@property (nonatomic, strong) NSMutableArray * userIdArray;
@end

@implementation TravelModel

#pragma mark --上传一条游记

- (void)addTravelNoteWithObejectId:(NSString *)ObjectId content:(NSString *)content imagesArray:(NSArray *)imagesArray location:(NSString *)location{
    
    BmobObject * travel = [BmobObject objectWithClassName:@"Travel"];
    
    [self uploadImagesArray:[self thumbnailArray:imagesArray] successBlock:^(NSArray *urlArray) {
        
        [travel setObject:location forKey:@"position"];
        [travel setObject:content forKey:@"content"];
        [travel setObject:urlArray forKey:@"urlArray"];
        [travel setObject:[NSNumber numberWithInt:0] forKey:@"number_of_thumb_up"];
        [travel setObject:[NSNumber numberWithInt:0] forKey:@"comments_number"];
        [travel addObjectsFromArray:self.userIdArray forKey:@"thumbArray"];
        //pointer关系
        BmobObject * user = [BmobObject objectWithoutDatatWithClassName:@"User" objectId:ObjectId];
        [travel setObject:user forKey:@"userId"];
        
        
        [travel saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                
                //relation关系
                BmobRelation * relation = [[BmobRelation alloc]init];
                [relation addObject:travel];
                [user addRelation:relation forKey:@"travels"];
                
                [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        self.addTravelResult = @"YES";
                    }else{
                        NSLog(@"error %@",[error description]);
                    }
                }];
                
            } else if (error){
                NSLog(@"%@",error);
            } else {
                NSLog(@"Unknow error");
            }
        }];
        
    } progressBlock:^(NSUInteger index, CGFloat returnProgress) {
        NSLog(@"第%ld张，进度：%f", index, returnProgress);
    } failBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark --上传图片
- (void)uploadImagesArray:(NSArray *)imagesArray successBlock:(void(^)(NSArray *urlArray))success progressBlock:(void(^)(NSUInteger index,CGFloat returnProgress))returnProgress failBlock:(void(^)(NSError * error))fail {
    if (imagesArray.count == 0) {
        success(nil);
        return;
    }else {
        
        [BmobProFile uploadFilesWithDatas:imagesArray resultBlock:^(NSArray *filenameArray, NSArray *urlArray, NSArray *bmobFileArray, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
            } else {
                
                NSMutableArray * TravelUrlArray = [NSMutableArray array];
                
                for (BmobFile* bmobFile in bmobFileArray ) {
                    [TravelUrlArray addObject:bmobFile.url];
                }
                success(TravelUrlArray);
            }
        } progress:^(NSUInteger index, CGFloat progress) {
            NSLog(@"index %lu progress %f",(unsigned long)index,progress);
            returnProgress(index, progress);
        }];
    }
    
}
#pragma mark -- 压缩封装图片
- (NSMutableArray *)thumbnailArray:(NSArray *)thumbnails {
    NSMutableArray *thumailsArray = [NSMutableArray array];
    for (int i = 0; i < thumbnails.count; i ++) {
        UIImage * image = thumbnails[i];
        CGSize imagesize = image.size;
        if (imagesize.height >= imagesize.width) {
            imagesize.height = image.size.height * (110 / image.size.width);
            imagesize.width = 110;
        }else {
            imagesize.width = image.size.width * (110 / image.size.height);
            imagesize.height = 110;
        }
        image = [self imageWithImage:image scaledToSize:imagesize];
        NSData *data = UIImagePNGRepresentation(image);
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:data forKey:@"data"];
        [dic setObject:[NSString stringWithFormat:@"%d.jpg", i] forKey:@"filename"];
        [thumailsArray addObject:dic];
    }
    return thumailsArray;
}

#pragma mark --查询所有游记
- (void) queryTheTravelListSuccessBlock:(void(^)(NSArray *objectArray))success failBlock:(void(^)(NSError * error))fail {
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Travel"];
    bquery.limit = 10;//每页10条
    //    bquery.skip = 3;//跳过查询的前多少条数据来实现分页查询的功能。
    [bquery orderByDescending:@"createdAt"];
    //声明该次查询需要将userId关联的对象信息一并查询出来
    [bquery includeKey:@"userId"];
    //查找travel表的数据
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"游记查询失败:%@",error);
        }
        else{
            success(array);
        }
    }];
    
}
#pragma mark -- 查询一个人发表的所有游记
- (void)getMyTravelNotesSuccess:(void (^)(NSArray *mytravels))success failure:(void (^)(NSError *error))failure{

    BmobQuery * bquery = [BmobQuery queryWithClassName:@"Travel"];
    //构造约束条件
    BmobQuery * inQuery = [BmobQuery queryWithClassName:@"User"];
    [inQuery whereKey:@"objectId" equalTo:OBJECTID];
    //匹配查询
    [bquery whereKey:@"userId" matchesQuery:inQuery];
    [bquery orderByDescending:@"createdAt"];
    [bquery includeKey:@"userId"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            success(array);
        }
    }];
}


- (void)queryTravelWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password travel_date:(NSString *)travel_date {
    [self.netWork queryTravelWithPhoneNumber:phoneNumber password:password travel_date:travel_date successBlock:^(BmobObject *object) {
        
    } failBlock:^(NSError *error) {
        
    }];
}

- (void)deleteTravelWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password travel_date:(NSString *)travel_date {
    [self.netWork deleteTravelWithPhoneNumber:phoneNumber password:password travel_date:travel_date successBlock:^(NSArray *array) {
        
    } failBlock:^(NSError *error) {
        
    }];
}



#pragma mark --压缩图片
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



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

- (NSMutableArray *)userIdArray {
    if (!_userIdArray) {
        _userIdArray = [[NSMutableArray alloc] init];
    }
    return _userIdArray;
}


- (UserModel *)userModel{
    if (!_userModel) {
        _userModel = [[UserModel alloc]init];
    }
    return _userModel;
}

- (NetWorkingViewController *)netWork {
    if (!_netWork) {
        _netWork = [[NetWorkingViewController alloc] init];
    }
    return _netWork;
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
