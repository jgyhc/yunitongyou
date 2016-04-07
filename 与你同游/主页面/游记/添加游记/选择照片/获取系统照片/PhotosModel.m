//
//  PhotosModel.m
//  ManJi
//
//  Created by Zgmanhui on 16/1/29.
//  Copyright © 2016年 Zgmanhui. All rights reserved.
//

#import "PhotosModel.h"

@implementation PhotosModel
static PhotosModel* photosModel = nil;
+ (PhotosModel *)sharedPhotosModel
{
    static PhotosModel *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (NSMutableArray *)indexArray {
    if(_indexArray == nil) {
        _indexArray = [[NSMutableArray alloc] init];
    }
    return _indexArray;
}

- (NSMutableArray *)photosArray {
    if(_photosArray == nil) {
        _photosArray = [[NSMutableArray alloc] init];
    }
    return _photosArray;
}

@end
