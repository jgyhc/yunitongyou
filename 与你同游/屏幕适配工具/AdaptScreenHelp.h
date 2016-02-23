//
//  AdaptScreenHelp.h
//  屏幕适配
//
//  Created by rimi on 15/10/14.
//  Copyright © 2015年 rimi. All rights reserved.
//

#ifndef AdaptScreenHelp_h
#define AdaptScreenHelp_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//内联函数（比宏定义快，比一般的函数更节约内存）

#define DH_INLINE static inline
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height



//静态全局变量,若用宏定义，则浪费空间,下划线用来与属性相区别
static const CGFloat originWidth_ = 375.f;//iphone6为基准
static const CGFloat originHeight_ = 667.f;
static const CGFloat MJDuration = 2.0;
static const int LoadingNumber = 2;
//内联函数
DH_INLINE CGFloat HotizontalRatio()
{
    return  SCREEN_WIDTH / originWidth_;//水平方向上的比率，value当前屏幕的值，return等比例适配后的值
    
}

DH_INLINE CGFloat VerticalRatio()
{
    return SCREEN_HEIGHT / originHeight_;//垂直方向上的比率
}
/**
 *  传一个位置大小得到转换后的center
 *
 *  @param frame 位置大小
 *
 *  @return 返回一个点
 */
DH_INLINE CGPoint centerFromFrame(CGRect frame)
{
    return CGPointMake(frame.origin.x + frame.size.width / 2, frame.origin.y + frame.size.height / 2);
}

/**
 *  传入大小  和 中心
 *
 *  @param size   大小
 *  @param center 中心位置
 *
 *  @return 返回一个位置大小
 */
DH_INLINE CGRect frameWithSizeAndCenter(CGSize size,CGPoint center)
{
    return CGRectMake(center.x - size.width / 2, center.y - size.height / 2, size.width, size.height);
}

DH_INLINE CGPoint flexibleCenter(CGPoint center, BOOL adjustWidth)//基准屏幕下的center
{
    if (adjustWidth) {
        CGFloat x = center.x * VerticalRatio();
        CGFloat y = center.y * VerticalRatio();
        return CGPointMake(x, y);
    }
    CGFloat x = center.x * HotizontalRatio();
    CGFloat y = center.y * VerticalRatio();
    return CGPointMake(x, y);//返回一个适配后的center
}



/**
 *  等比例适配size（iphone 4）
 *
 *  @param size        基准屏幕下的size
 *  @param adjustWidth 如果是yes,则返回size的宽高同时乘以高的比率
 *
 *  @return 适配后的size
 */

DH_INLINE CGSize flexibleSize(CGSize size,BOOL adjustWidth)
{
    if (adjustWidth) {
        return CGSizeMake(size.width * VerticalRatio(), size.height * VerticalRatio());
    }
    return CGSizeMake(size.width * HotizontalRatio(), size.height * VerticalRatio());
}



DH_INLINE CGRect flexibleFrame(CGRect frame,BOOL adjustWidth)
{
    //拿到frame的center,然后对x y等比例缩放
    CGPoint center = centerFromFrame(frame);
    center = flexibleCenter(center, adjustWidth);
    //对宽高等比例缩放，拿到一个CGSize
    CGSize size = flexibleSize(frame.size, adjustWidth);
    //用上面等比例缩放后的center和size组成一个frame返回
    return frameWithSizeAndCenter(size, center);
}

DH_INLINE CGFloat flexibleHeight(CGFloat height)
{
    return height * VerticalRatio();
}
DH_INLINE CGFloat flexibleWidth(CGFloat width)
{
    return width * HotizontalRatio();
}


#endif /* AdaptScreenHelp_h */
