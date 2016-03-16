//
//  WGS84TOGCJ02.h
//  地图与定位
//
//  Created by mac on 16/3/15.
//  Copyright © 2016年 panhongying. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@interface WGS84TOGCJ02 : NSObject
//判断是否已经超过中国范围
+ (BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;
//转GCJ02

+(CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgs;

@end
