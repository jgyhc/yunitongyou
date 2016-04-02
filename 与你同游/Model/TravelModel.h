
#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobProFile.h>
@interface TravelModel : NSObject
/**
 *  添加游记
 *
 *  @param ObjectId    用户唯一标识
 *  @param content     游记内容
 *  @param imagesArray 游记图片
 *  @param location    定位
 */
- (void)addTravelNoteWithObejectId:(NSString *)ObjectId content:(NSString *)content imagesArray:(NSArray *)imagesArray location:(NSString *)location successBlock:(void(^)())success;

/**
 *  获取游记列表
 *
 *  @param success 成功获得游记信息
 *  @param fail    失败原因
 */
- (void) queryTheTravelListSuccessBlock:(void(^)(NSArray *objectArray))success skip:(NSInteger)skip failBlock:(void(^)(NSError * error))fail ;

/**
 *  查询一个人发表的所有游记
 *
 *  @param success  成功获得游记信息
 *  @param failure 失败原因
 */
- (void)getMyTravelNotesSuccess:(void (^)(NSArray * mytravels))success failure:(void (^)(NSError *error))failure;


@end
