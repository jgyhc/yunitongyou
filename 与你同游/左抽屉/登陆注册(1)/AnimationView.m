//
//  AnimationView.m
//  与你同游
//
//  Created by rimi on 15/10/14.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "AnimationView.h"

@implementation AnimationView
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx1 = UIGraphicsGetCurrentContext();//获取当前ctx
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(ctx1, 2.0);  //线宽
    CGContextSetAllowsAntialiasing(ctx1, YES);
    CGContextSetRGBStrokeColor(ctx1, 0.611, 0.618, 0.611, 1.0);  //颜色
    CGContextBeginPath(ctx1);
    CGContextMoveToPoint(ctx1, (SCREEN_WIDTH / 375.0) * (375.0 / 2), 0);  //起点坐标
    CGContextAddLineToPoint(ctx1, (SCREEN_WIDTH / 375.0) * (76.0), (SCREEN_HEIGHT / 667.0) * 195.0);   //终点坐标
    CGContextStrokePath(ctx1);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();//获取当前ctx
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(ctx, 2.0);  //线宽
    CGContextSetAllowsAntialiasing(ctx, YES);
    CGContextSetRGBStrokeColor(ctx, 0.611, 0.618, 0.611, 1.0);  //颜色
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, (SCREEN_WIDTH / 375.0) * (375.0 / 2), 0);  //起点坐标
    CGContextAddLineToPoint(ctx, (SCREEN_WIDTH / 375.0) * (300), (SCREEN_HEIGHT / 667.0) * 195.0);   //终点坐标
    CGContextStrokePath(ctx);

}
@end
