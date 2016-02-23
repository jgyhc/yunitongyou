//
//  RecordDetailScrollImageView.h
//  viewController
//
//  Created by rimi on 15/10/16.
//  Copyright (c) 2015年 ouyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordDetailScrollImageView : UIView

/**
 *  图片
 *
 *  @param imgArray 图片集
 */
- (void)setArray:(NSArray *)imgArray;

/**
 *  图片数量
 */
@property (nonatomic, assign) NSInteger totalNum;

/**
 *  开启计时
 */
- (void)openTimer;

/**
 *  关闭计时
 */
- (void)closeTimer;

/**
 *  初始化方法
 *
 *  @param frame        设置尺寸
 *  @param addressArray 设置标题
 *
 *  @return
 */
- (instancetype)initWithFrame:(CGRect)frame;


@end
