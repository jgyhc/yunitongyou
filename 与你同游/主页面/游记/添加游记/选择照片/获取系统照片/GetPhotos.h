//
//  GetPhotos.h
//  ManJi
//
//  Created by Zgmanhui on 16/1/29.
//  Copyright © 2016年 Zgmanhui. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^MyBlock)(NSArray *array);
@interface GetPhotos : NSObject
@property (nonatomic,strong)NSMutableArray *assetArray ;
@property (nonatomic,strong)MyBlock myBlock ;
/**
 *  根据asset获取照片
 *
 *  @param assets assets数组
 *  @param block  block
 */
- (void)getphotos:(NSArray *)assets imageBlock:(MyBlock)block;
- (void)getAllPhotos;
@end
