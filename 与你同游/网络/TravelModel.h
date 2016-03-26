
#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobProFile.h>
#import "NetWorkingViewController.h"
@interface TravelModel : NSObject

@property (nonatomic, strong) NetWorkingViewController *netWork;

@property (nonatomic, copy) NSString *addTravelResult;
@property (nonatomic, copy) NSString *travelContents;
@property (nonatomic, copy) NSString *travelTime;
@property (nonatomic, copy) NSString *travelSight_spot;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong, readonly) NSString *createTCommentResult;
@property (nonatomic, strong) NSArray *travelCommentArray;
@property (nonatomic, strong) NSMutableArray *speakerArray;
@property (nonatomic, strong) NSMutableArray *recipientArray;
@property (nonatomic, strong) BmobObject *speaker;
@property (nonatomic, strong) BmobObject *recipient;



/**
 *  添加游记
 *
 *  @param ObjectId    用户唯一标识
 *  @param content     游记内容
 *  @param imagesArray 游记图片
 *  @param location    定位
 */
- (void)addTravelNoteWithObejectId:(NSString *)ObjectId content:(NSString *)content imagesArray:(NSArray *)imagesArray location:(NSString *)location;

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




/**
 *  删除一条游记
 *
 *  @param phoneNumber 电话
 *  @param password    密码
 *  @param travel_date 游记发布时间
 */
- (void)deleteTravelWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password travel_date:(NSString *)travel_date;





/**
 *  创一条游记评论
 *
 *  @param phoneNumber        评论者的电话
 *  @param password           评论者的密码
 *  @param travel_date        游记创建时间
 *  @param creatorPhoneNumber 创建者的电话号码
 *  @param contents           内容
 */
- (void)createATravelReviewsWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password travel_date:(NSString *)travel_date creatorPhoneNumber:(NSString *)creatorPhoneNumber contents:(NSString *)contents;

/**
 *  查找一个游记的评论列表
 *
 *  @param phoneNumber 电话
 *  @param password    密码
 *  @param travel_date 创建游记的时间
 */
- (void)findTravelCommentsWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password travel_date:(NSString *)travel_date;

/**
 *  查找一条游记的一条评论  （通过评论创建时间）
 *
 *  @param phoneNumber          电话
 *  @param password             密码
 *  @param travel_date          游记创建时间
 *  @param travel_comments_time 评论时间
 */
- (void)findTravelCommentWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password travel_date:(NSString *)travel_date travel_comments_time:(NSString *)travel_comments_time;
/**
 *  查找到评发送者
 *
 *  @param phoneNumber          电话
 *  @param password             密码
 *  @param travel_date          游记时间
 *  @param travel_comments_time 评论时间
 *  @param success
 *  @param fail
 */
- (void)findTravelCommentSpearkerWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password travel_date:(NSString *)travel_date travel_comments_time:(NSString *)travel_comments_time userType:(NSString *)userType index:(NSInteger)index;
/**
 *  创建一条回复()  游记就是他本人的  回复别人的评论
 *
 *  @param phoneNumber          回复创建者电话
 *  @param password             密码
 *  @param CTphoneNumber        评论创建者电话
 *  @param travel_date          游记日期
 *  @param travel_comments_time 评论时间
 *  @param replyContents        回复内容
 */
- (void)CreateTravelCommentReplyWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password CTphoneNumber:(NSString *)CTphoneNumber travel_date:(NSString *)travel_date travel_comments_time:(NSString *)travel_comments_time replyContents:(NSString *)replyContents;

/**
 *  创建一条回复的回复  游记不是他的  他评论了  游记创建者回复了 他回复他的回复的操作
 *
 *  @param phoneNumber          电话
 *  @param password             密码
 *  @param CTphoneNumber        游记创建者的电话
 *  @param travel_date          游记时间
 *  @param travel_comments_time 评论时间
 *  @param replyContents        回复的内容
 */
- (void)CreateTravelReplyReplyWithPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password CTphoneNumber:(NSString *)CTphoneNumber travel_date:(NSString *)travel_date travel_comments_time:(NSString *)travel_comments_time replyContents:(NSString *)replyContents;



@end
