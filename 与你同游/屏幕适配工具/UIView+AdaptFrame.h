//
//  UIView+AdaptFrame.h
//  viewController
//
//  Created by rimi on 15/10/10.
//  Copyright (c) 2015年 ouyang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WIDTH 375.0
#define HEIGHT 667.0
#define THEMECOLOR [UIColor colorWithRed:0.211 green:0.921 blue:0.722 alpha:1.000]

@interface UIView (AdaptFrame)

- (instancetype)initWithAdaptFrame:(CGRect)frame;

@property (nonatomic, readwrite) CGRect  adaptRect;
@property (nonatomic, readwrite) CGRect  adaptBounds;
@property (nonatomic, readwrite) CGPoint adaptCenter;


@end
