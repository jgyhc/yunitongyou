//
//  ScenicSpotmodei.m
//  与你同游
//
//  Created by rimi on 15/10/21.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "ScenicSpotmodei.h"
#define APPID @"10650"
#define SIGN @"a038ca3eac044e818fafe3d659f36ec3"
#define APIURL(T,P) [NSString stringWithFormat:@"http://route.showapi.com/268-1?showapi_appid=%@&showapi_timestamp=%@&showapi_sign=%@&keyword=%@&proId=&cityId=&areaId=&", APPID, T, SIGN, P]

@interface ScenicSpotmodei ()
@property (nonatomic, strong)NSMutableData *data;

@end

@implementation ScenicSpotmodei


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
    NSLog(@"%@", connection);
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

- (void) updataDataSourceWithObj:(id)obj {
    if ([obj [@"error_code"] intValue] == 0) {
        //说明请求成功
        //        self.dataSource = obj[@"result"][@"data"];
        //
        //        //2.更新表格视图
        //        [self.tableView reloadData];
        
        NSLog(@"obj = %@", obj);
        self.scenicSpotSearchResults = obj;
//        NSLog(@"%@", self.scenicSpotSearchResults);
        
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

