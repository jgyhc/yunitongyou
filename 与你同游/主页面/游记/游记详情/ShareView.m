//
//  ShareView.m
//  与你同游
//
//  Created by mac on 16/3/24.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import "ShareView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>


@implementation ShareView
+ (void)sharedWithImages:(NSArray *)imageArray content:(NSString *)content{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    [shareParams SSDKSetupShareParamsByText:content
                                     images:imageArray
                                        url:[NSURL URLWithString:@"http://mob.com"]
                                      title:@"与你同游，一款小型的旅游app"
                                       type:SSDKContentTypeAuto];
#pragma mark -- 跳过分享的编辑界面
    SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:nil
                                                                     items:nil
                                                               shareParams:shareParams
                                                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                                           switch (state) {
                                                               case SSDKResponseStateSuccess:
                                                                   NSLog(@"分享成功!");
                                                                   break;
                                                               case SSDKResponseStateFail:
                                                                   NSLog(@"分享失败%@",error);
                                                                   break;
                                                               case SSDKResponseStateCancel:
                                                                   NSLog(@"分享已取消");
                                                                   break;
                                                               default:
                                                                   break;
                                                           }
                                                       }];
    [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];

}

@end
