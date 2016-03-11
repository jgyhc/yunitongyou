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

@interface TravelModel ()

@property (nonatomic, strong) TravelCommentsNetWorking *travelCommentsNetWork;
@property (nonatomic, strong)  UserModel * userModel;
@property (nonatomic, assign) int thumbUpNumber;
@property (nonatomic, copy) NSString *thumb_upResults;
@property (nonatomic, strong) NSMutableArray *CommentsArray;
@property (nonatomic, strong) NSString *createTCommentResult;
@property (nonatomic, strong) BmobObject *userData;
@end

@implementation TravelModel

#pragma mark --上传一条游记  多张图片的
- (void)addTravelWithObejectId:(NSString *)ObjectId sightSpot:(NSArray *)sightSpot imagesArray:(NSArray *)imagesArray content:(NSString *)content {
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"User"];
    [bquery getObjectInBackgroundWithId:ObjectId block:^(BmobObject *object, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }else {
            [self uploadImagesArray:[self thumbnailArray:imagesArray] successBlock:^(NSArray *urlArray) {
                [self uploadImagesArray:[self ImageToDic:imagesArray] successBlock:^(NSArray *thumbnailurlArray) {
                    BmobObject  *travel = [BmobObject objectWithClassName:@"travel"];
                    [travel setObject:sightSpot forKey:@"sight_spot"];
                    [travel setObject:content forKey:@"content"];
                    [travel setObject:object.objectId forKey:@"userObjectid"];
                    [travel setObject:[NSNumber numberWithInt:0] forKey:@"number_of_thumb_up"];
                    [travel setObject:[NSNumber numberWithInt:0] forKey:@"comments_number"];
                    [travel setObject:urlArray forKey:@"images"];
                    [travel setObject:thumbnailurlArray forKey:@"thumbnailImages"];
                    [travel saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        if (isSuccessful) {
                            //将游记信息放在该用户表中
                            BmobObject *user1 = [BmobObject objectWithoutDatatWithClassName:@"User" objectId:object.objectId];
                            BmobRelation *relation = [[BmobRelation alloc] init];
                            [relation addObject:[BmobObject objectWithoutDatatWithClassName:@"travel" objectId:travel.objectId]];
                            [user1 addRelation:relation forKey:@"travels"];
                            [user1 updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                if (isSuccessful) {
                                    self.addTravelResult = @"YES";
                                }else{
                                    NSLog(@"error %@",[error description]);
                                }
                            }];
                        }
                    }];
                } progressBlock:^(NSUInteger index, CGFloat returnProgress) {
                    NSLog(@"第%ld张，进度：%f", index, returnProgress);
                } failBlock:^(NSError *error) {
                    NSLog(@"%@", error);
                }];
            } progressBlock:^(NSUInteger index, CGFloat returnProgress) {
                NSLog(@"%f", returnProgress);
            } failBlock:^(NSError *error) {
                NSLog(@"%@", error);
            }];
        }
    }];
}
- (NSMutableArray *)ImageToDic:(NSArray *)imageArray {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < imageArray.count; i ++) {
        NSData *data = UIImagePNGRepresentation(imageArray[i]);
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:data forKey:@"data"];
        [dic setObject:[NSString stringWithFormat:@"%d.jpg", i ] forKey:@"filename"];
        [array addObject:dic];
    }
    return array;
}

#pragma mark --上传一组图片
- (void)uploadImagesArray:(NSArray *)imagesArray successBlock:(void(^)(NSArray *urlArray))success progressBlock:(void(^)(NSUInteger index,CGFloat returnProgress))returnProgress failBlock:(void(^)(NSError * error))fail {
    if (imagesArray.count == 0) {
        success(nil);
        return;
    }else {
        [BmobProFile uploadFilesWithDatas:imagesArray resultBlock:^(NSArray *filenameArray, NSArray *urlArray, NSArray *bmobFileArray, NSError *error) {
            success(urlArray);
        } progress:^(NSUInteger index, CGFloat progress) {
            returnProgress(index, progress);
        }];
    }
    
}
#pragma mark -- 将一组图片压缩  返回压缩后的data和文件名的数组
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
#pragma mark --上传文件
- (void)uploadImageFile:(NSData *)data successBlock:(void(^)(NSString *url))success failBlock:(void(^)(NSError * error))fail {
    if (data == nil) {
        success(nil);
        return;
    }
    [BmobProFile uploadFileWithFilename:@"image.png" fileData:data block:^(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url,BmobFile *bmobFile) {
        if (isSuccessful) {
            success(url);
        } else {
            if (error) {
                NSLog(@"error %@",error);
            }
        }
    } progress:^(CGFloat progress) {
        //上传进度，此处可编写进度条逻辑
        NSLog(@"progress %f",progress);
    }];
}

- (void)queryTravelWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password {
    [self.netWork queryTravelWithPhoneNumber:phoneNumber password:password successBlock:^(NSMutableArray *array) {
        NSMutableArray *arr = self.travelListArray;
        [arr addObjectsFromArray:array];
        self.travelListArray = arr;
    } failBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}
- (void)queryTravelWithObejectId:(NSString *)ObjectId {
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"User"];
    [bquery getObjectInBackgroundWithId:ObjectId block:^(BmobObject *object, NSError *error) {
        BmobQuery *travel = [BmobQuery queryWithClassName:@"travel"];
        //需要查询的列
        BmobObject *user = [BmobObject objectWithoutDatatWithClassName:@"User" objectId:object.objectId];
        [travel whereObjectKey:@"travels" relatedTo:user];
        [travel findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
            } else {
                NSMutableArray *objectArray = [NSMutableArray array];
                for (int i = 0; i < array.count; i ++) {
                    BmobObject *travelObject = array[i];
                    if (![travelObject objectForKey:@"thumbnailImages"]) {
                        [travelObject setObject:nil forKey:@"thumbnailImages"];
                    }else {
                        NSMutableArray *array  = [travelObject objectForKey:@"thumbnailImages"];
                        for (int i = 0; i < array.count; i ++) {
                            NSString * URL = [NSString stringWithFormat:@"%@?t=1&a=f008d46b406baaa7eff26eba98dccd54", array[i]];
                            [array replaceObjectAtIndex:i withObject:URL];
                            NSLog(@"%@", URL);
                        }
                        [travelObject setObject:array forKey:@"thumbnailImages"];
                    }
                    [objectArray addObject:travelObject];
                }
                self.travelListArray = objectArray;
            }
        }];
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

#pragma mark --查询所有游记
- (void)queryTheTravelListSkip:(NSInteger)skip {
    [self.netWork queryTheTravelListWithskip:skip SuccessBlock:^(NSMutableArray *objectArray) {
        
        self.travelListArray = [objectArray mutableCopy];
        
        for (int i = 0; i < objectArray.count; i ++) {
            
            BmobObject *travelObject = objectArray[i];
            [self.userModel getwithObjectId:[travelObject objectForKey:@"userID"] successBlock:^(BmobObject *object) {
                [self.travelUser addObject:object];
            } failBlock:^(NSError *error) {
                
            }];
        }
        
    } failBlock:^(NSError *error) {
        NSLog(@"%@", error);
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

- (NSMutableArray *)travelListArray {
    if (!_travelListArray) {
        _travelListArray = [[NSMutableArray alloc] init];
    }
    return _travelListArray;
}

- (NSMutableArray *)travelUser {
    if (!_travelUser) {
        _travelUser = [NSMutableArray array];
    }
    return _travelUser;
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
