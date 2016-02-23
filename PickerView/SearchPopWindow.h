//
//  SearchPopWindow.h
//  DeepBreath
//
//  Created by rimi on 15/9/27.
//  Copyright (c) 2015年 rimi. All rights reserved.
//

#import "MyPopWindow.h"

@interface SearchPopWindow : MyPopWindow

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title  complect:(void(^) (NSString * str))complect;

@end
