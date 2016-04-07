//
//  PhotosModel.h
//  ManJi
//
//  Created by Zgmanhui on 16/1/29.
//  Copyright © 2016年 Zgmanhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotosModel : NSObject
@property (nonatomic,strong) NSMutableArray *photosArray;
@property (nonatomic, strong) NSMutableArray *indexArray;
+ (PhotosModel *)sharedPhotosModel;
@end
