//
//  User.m
//  与你同游
//
//  Created by Zgmanhui on 16/2/19.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import "User.h"

@implementation User

- (id)initWithClassName:(NSString *)className {
   self = [super initWithClassName:className];
    if (self) {
        self.className = @"User";
    }
    return self;
}


@end
