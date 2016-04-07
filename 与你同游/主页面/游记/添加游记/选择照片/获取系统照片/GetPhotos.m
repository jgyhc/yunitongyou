//
//  GetPhotos.m
//  ManJi
//
//  Created by Zgmanhui on 16/1/29.
//  Copyright © 2016年 Zgmanhui. All rights reserved.
//

#import "GetPhotos.h"
#import <Photos/Photos.h>

@implementation GetPhotos
- (void)getAllPhotos {
        // 获取所有资源的集合，并按资源的创建时间排序
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
        PHImageManager *imageManager = [[PHImageManager alloc]init];
    
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
        option.synchronous = YES ;
        option.resizeMode = PHImageRequestOptionsResizeModeExact ;
        option.version = PHImageRequestOptionsVersionCurrent ;
        option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat ;
        NSMutableArray *array = [[NSMutableArray alloc] init];
        // 这时 assetsFetchResults 中包含的，应该就是各个资源（PHAsset）
    
    dispatch_queue_t mainQue = dispatch_get_main_queue() ;
    dispatch_async(mainQue, ^{
        for (NSInteger i = 0; i < assetsFetchResults.count; i++) {
            // 获取一个资源（PHAsset）
            PHAsset *asset = assetsFetchResults[i];
            [self.assetArray addObject:asset];
            [imageManager requestImageForAsset:asset targetSize:CGSizeMake(500, 500) contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                [array addObject:result];
                if (i == assetsFetchResults.count - 1) {
                    self.myBlock(array);
                }
            }];
        }
    
    });
    
}

- (void)getphotos:(NSArray *)assets imageBlock:(MyBlock)block {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
    option.synchronous = YES ;
    option.resizeMode = PHImageRequestOptionsResizeModeExact ;
    option.version = PHImageRequestOptionsVersionCurrent ;
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat ;
    PHImageManager *imageManager = [[PHImageManager alloc]init];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    dispatch_queue_t mainQue = dispatch_get_main_queue() ;
    dispatch_async(mainQue, ^{
        for (int i = 0; i < assets.count; i ++) {
            PHAsset *asset = assets[i];
            NSLog(@"%@", assets);
            [imageManager requestImageForAsset:asset targetSize:CGSizeMake(1000, 1000) contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                [array addObject:result];
                if (i == assets.count - 1) {
                    block(array);
                }
            }];
        }
    });
}


- (NSMutableArray *)assetArray  {
    if(_assetArray  == nil) {
        _assetArray  = [[NSMutableArray alloc] init];
    }
    return _assetArray ;
}
@end
