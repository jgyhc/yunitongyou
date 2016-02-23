//
//  gradientView.m
//  与你同游
//
//  Created by rimi on 15/10/14.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "gradientView.h"

@implementation gradientView
- (void)drawRect:(CGRect)rect {
    //渐变的图像
    //颜色
    CGColorRef startColor = [UIColor colorWithRed:0.165 green:0.925 blue:0.659 alpha:1.000].CGColor;
    CGColorRef endColor = [UIColor colorWithRed:0.714 green:0.965 blue:1.000 alpha:1.000].CGColor;
    //获取数组
    const CGFloat *startComponents = CGColorGetComponents(startColor);
    const CGFloat *endComponents = CGColorGetComponents(endColor);
    //获取数量
    //    size_t count = CGColorGetNumberOfComponents(startColor);
    //设置颜色的数组
    CGFloat colorComponents[] = {
        startComponents[0],
        startComponents[1],
        startComponents[2],
        startComponents[3],
        endComponents[0],
        endComponents[1],
        endComponents[2],
        endComponents[3],
    };
    //设置颜色的位置
    CGFloat colorLocations[] = {0, 1};
    //获取RGB
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //创建CGGradientRef
    CGGradientRef gradientRef = CGGradientCreateWithColorComponents(colorSpace, colorComponents, colorLocations, 2);
    //获取图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //绘制
    CGContextDrawLinearGradient(context, gradientRef, CGPointMake(CGRectGetMidX(self.bounds), 0), CGPointMake(CGRectGetMidX(self.bounds), self.bounds.size.height), 0);
    //释放
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradientRef);
    
    
    
}

@end
