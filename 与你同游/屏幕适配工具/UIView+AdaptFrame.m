//
//  UIView+AdaptFrame.m
//  viewController
//
//  Created by rimi on 15/10/10.
//  Copyright (c) 2015年 ouyang. All rights reserved.
//

#import "UIView+AdaptFrame.h"
#import "Precentage.h"

@implementation UIView (AdaptFrame)

@dynamic adaptRect;
@dynamic adaptBounds;
@dynamic adaptCenter;

- (instancetype)initWithAdaptFrame:(CGRect)frame {
    self = [self initWithFrame:[[Precentage alloc] initWithRect:frame]];
    return self;
}

- (void)setAdaptRect:(CGRect)adaptRect {
    self.frame = [[Precentage alloc]initWithRect:adaptRect];
}

- (void)setAdaptBounds:(CGRect)adaptBounds {
    CGSize retioBounds = [[Precentage alloc]initWithSize:adaptBounds.size];
    self.bounds = CGRectMake(0, 0, retioBounds.width, retioBounds.height);
}

- (void)setAdaptCenter:(CGPoint)adaptCenter {
    self.center = [[Precentage alloc]initWithCenter:adaptCenter];
}

@end
