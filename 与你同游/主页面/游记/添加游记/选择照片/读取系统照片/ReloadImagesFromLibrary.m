//
//  ReloadImagesFromLibrary.m
//  与你同游
//
//  Created by rimi on 15/11/7.
//  Copyright © 2015年 LiuCong. All rights reserved.
//

#import "ReloadImagesFromLibrary.h"
#import <UIKit/UIKit.h>
@import AssetsLibrary;
@implementation ReloadImagesFromLibrary

//获取相册的所有图片
- (void)reloadImagesFromLibrary:(void(^)(NSMutableArray *imagesArray, NSMutableArray *urlArray))imagesArray
{
    self.thumbnailImages = [[NSMutableArray alloc] init];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        @autoreleasepool {
            ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
                NSLog(@"相册访问失败 =%@", [myerror localizedDescription]);
                if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound) {
                    NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
                }else{
                    NSLog(@"相册访问失败.");
                }
            };
            ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index, BOOL *stop){
                if (result != NULL) {
                    
                    if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                        [self.imagesArray addObject:result.defaultRepresentation.url];
                        UIImage* thumbnailImage = [UIImage imageWithCGImage: result.thumbnail];
                        NSData *dataObj = UIImagePNGRepresentation(thumbnailImage);
                        [self.thumbnailImages addObject:dataObj];
                        if (self.thumbnailImages.count == self.number) {
                            imagesArray(self.thumbnailImages, self.imagesArray);
                        }
                    }
                }
            };
            
            

            
            ALAssetsLibraryGroupsEnumerationResultsBlock libraryGroupsEnumeration = ^(ALAssetsGroup* group, BOOL* stop){
                
                if (group == nil)
                {
                    
                }
                
                if (group!=nil) {
                    self.number = [group numberOfAssets];
                    NSString *g=[NSString stringWithFormat:@"%@", group];//获取相簿的组
//                    NSLog(@"gg:%ld", [group numberOfAssets]);//gg:ALAssetsGroup - Name:Camera Roll, Type:Saved Photos, Assets count:71
                    
                    NSString *g1=[g substringFromIndex:16 ] ;
                    NSArray *arr=[[NSArray alloc] init];
                    arr=[g1 componentsSeparatedByString:@","];
//                    NSString *g2=[[arr objectAtIndex:0] substringFromIndex:5];
//                    if ([g2 isEqualToString:@"Camera Roll"]) {
//                        g2=@"相机胶卷";
//                    }
//                    NSString *groupName = g2;//组的name
                
                    [group enumerateAssetsUsingBlock:groupEnumerAtion];
                }
                
            };
            
            ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
            [library enumerateGroupsWithTypes:ALAssetsGroupAll
                                   usingBlock:libraryGroupsEnumeration
                                 failureBlock:failureblock];
        }
        
    });
}
- (NSMutableArray *)imagesArray {
    if (!_imagesArray) {
        _imagesArray = [NSMutableArray array];
    }
    return _imagesArray;
}

@end
