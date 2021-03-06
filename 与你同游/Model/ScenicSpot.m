//
//  ScenicSpot.m
//  与你同游
//
//  Created by Zgmanhui on 16/3/26.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import "ScenicSpot.h"
#define APPID @"10650"
#define SIGN @"a038ca3eac044e818fafe3d659f36ec3"
#define APIURL(T,P) [NSString stringWithFormat:@"http://route.showapi.com/268-1?showapi_appid=%@&showapi_timestamp=%@&showapi_sign=%@&keyword=%@&proId=&cityId=&areaId=&", APPID, T, SIGN, P]

@interface ScenicSpot ()
@property (nonatomic, strong)NSMutableData *data;

@end

@implementation ScenicSpot

+ (void)addScenicSpotArray:(NSDictionary *)dic success:(void (^)(BOOL isSuccessful))success failure:(void (^)(NSError *error1))failure {
    BmobObject  *SSobj = [BmobObject objectWithClassName:@"Scenic_spot"];
    [SSobj setObject:dic forKey:@"dic"];
       //异步保存
    [SSobj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            success(isSuccessful);
        } else if (error){
            //发生错误后的动作
            NSLog(@"%@",error);
        } else {
            NSLog(@"Unknow error");
        }
    }];
}


+ (void)addSearchWords:(NSString *)words success:(void (^)(NSString* hotWordID))success failure:(void (^)(NSError *error1))failure {

    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"HotWord"];
    [bquery whereKey:@"hotWord" equalTo:words];
    //查找GameScore表的数据
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            BmobObject *hotWord  = array[0];
            NSLog(@"%@", [hotWord objectForKey:@"hotWord_Number"]);
            [hotWord incrementKey:@"hotWord_Number"];
            //异步保存
            [hotWord updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    success(hotWord.objectId);
                } else if (error){
                    //发生错误后的动作
                    NSLog(@"%@",error);
                } else {
                    NSLog(@"Unknow error");
                }
            }];
        }else {
            BmobObject *hotWord = [BmobObject objectWithClassName:@"HotWord"];
            [hotWord setObject:words forKey:@"hotWord"];
            [hotWord setObject:@(1) forKey:@"hotWord_Number"];
            //异步保存
            [hotWord saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    success(hotWord.objectId);
                } else if (error){
                    //发生错误后的动作
                    NSLog(@"%@",error);
                } else {
                    NSLog(@"Unknow error");
                }
            }];
        }

    }];
}


//查找热词
+ (void)getHotWordsSuccess:(void (^)(NSArray *horWords))success failure:(void (^)(NSError *error))failure {
    //关联对象表
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"HotWord"];
    bquery.limit = 10;
    [bquery orderByDescending:@"hotWord_Number"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            
        }else {
            success(array);
        }
    }];
}

//查找广告url
+ (void)getAdUrlsSuccess:(void (^)(NSArray *urls))success failure:(void (^)(NSError *error))failure {
    //关联对象表
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Ad_list"];
    bquery.limit = 6;
    [bquery includeKey:@"scenicSpot"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            
        }else {
            success(array);
        }
    }];
}


// 异步post
- (void)sendAsynchronizedPostRequest:(NSString *)keyword {
    //1.获取url
    NSString *timeString = [self CurrentTime];
    NSString *placeString = keyword;
    NSString *urlString = [NSString stringWithFormat:@"http://route.showapi.com/268-1"];
    NSURL *url = [NSURL URLWithString:urlString];
    //配置请求方式
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    //2.2配置请求方式
    request.HTTPMethod = @"POST";
    //2.3设置请求时长
    request.timeoutInterval = 20;
    //2.4配置请求body
    NSDictionary *dic = @{@"showapi_appid":@"10650",
                          @"showapi_sign":@"a038ca3eac044e818fafe3d659f36ec3",
                          @"showapi_timestamp":timeString,
                          @"keyword": placeString};
    request.HTTPBody = [self dataWitehDic:dic];
    
    
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
}




#pragma mark --NSURLConnectionDataDelegate
//已经收到数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //拼接数据
    [self.data appendData:data];
    
}
//已经结束加载
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //1.解析数据
    id obj = [self JSONWithData:self.data];
    //2.更新视图
    [self updataDataSourceWithObj:obj];
    //3.清空数据区
    self.data.length = 0;
}

//已经连接失败
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"连接失败");
}

- (void)updataDataSourceWithObj:(id)obj {
    if ([obj [@"error_code"] intValue] == 0) {
        //说明请求成功
        //        self.dataSource = obj[@"result"][@"data"];
        //
        //        //2.更新表格视图
        //        [self.tableView reloadData];
        
//        NSLog(@"obj = %@", obj);
        ScenicSpot *scenicSpot = [ScenicSpot yy_modelWithJSON:obj];
        //        NSLog(@"%@", self.scenicSpotSearchResults);
        if (_ssblock) {
            self.ssblock(scenicSpot);
        }
//        NSLog(@"%@", scenicSpot.showapi_res_body.pagebean.contentlist);
        
//        SSContentlist *content = scenicSpot.showapi_res_body.pagebean.contentlist[0];
//        SSPicList *pic = content.picList[0];
//    NSLog(@"%@    /n %@", pic.picUrlSmall, pic.picUrl);
    }
}
- (id) JSONWithData:(NSData *)data {
    NSError *error = nil;
    
    id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    //条件为假，崩溃
    NSAssert(!error, @"JSON解析失败，原因%@",[error localizedDescription]);
    return obj;
}






- (NSData * )dataWitehDic:(NSDictionary * )dic
{
    //1 创建可变字符串
    NSMutableString * string = [NSMutableString string];
    for (NSString * key in dic.allKeys) {
        [string appendFormat:@"%@=%@&",key,dic[key]];
        
    }
    //3 返回data（以utfb方式进行编码）
    return [string dataUsingEncoding:NSUTF8StringEncoding];
    
}
#pragma mark -- 获取当前时间
- (NSString *)CurrentTime {
    NSDate *  senddate = [NSDate date];
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *  locationString = [dateformatter stringFromDate:senddate];
    return locationString;
}

- (NSMutableData *)data {
    if (!_data) {
        _data = [NSMutableData data];
    }
    return _data;
}


@end


@implementation SSShowapi_res_body

@end

@implementation SSPagebean
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"contentlist":[SSContentlist class]
             };
}
@end

@implementation SSContentlist
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"picList":[SSPicList class],
             @"priceList":[SSPriceList class],
             };
}
@end

@implementation SSLocation

@end

@implementation SSPicList

@end

@implementation SSPriceList
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"entityList":[SSEntityList class],
             };
}
@end

@implementation SSEntityList

@end
