//
//  ReloadImagesFromLibrary.h
//  与你同游
//
//  Created by rimi on 15/11/7.
//  Copyright © 2015年 LiuCong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReloadImagesFromLibrary : NSObject
- (void)reloadImagesFromLibrary:(void(^)(NSMutableArray *imagesArray, NSMutableArray *urlArray))imagesArray;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) NSMutableArray *thumbnailImages;
@end
