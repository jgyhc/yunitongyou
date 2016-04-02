//
//  ScenicSpotmodei.h
//  与你同游
//
//  Created by rimi on 15/10/21.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScenicSpotmodei : NSObject

@property (nonatomic, strong)NSMutableDictionary *scenicSpotSearchResults;

//- (void)sendAsynchronizedGetRequest;
// 异步post
- (void)sendAsynchronizedPostRequest:(NSString *)keyword;
@end
