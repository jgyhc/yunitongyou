//
//  GetPhotosVC.h
//  ManJi
//
//  Created by Zgmanhui on 16/1/29.
//  Copyright © 2016年 Zgmanhui. All rights reserved.
//

#import "BaseViewController.h"

@protocol GetPhotosVCDelegate <NSObject>

- (void)popVC;

@end

@interface GetPhotosVC : BaseViewController
@property (nonatomic, assign) id<GetPhotosVCDelegate> delegate;
//@property (nonatomic, strong) NSMutableArray *indexArray;


@end
