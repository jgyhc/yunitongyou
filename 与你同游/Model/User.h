//
//  User.h
//  与你同游
//
//  Created by Zgmanhui on 16/2/19.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : BmobObject
@property (nonatomic, strong) NSString *phoneNumber;//电话号码
@property (nonatomic, strong) NSString *password;//密码
@property (nonatomic, assign) NSInteger *age;//年龄
@property (nonatomic, strong) NSString *sex;//性别
@property (nonatomic, strong) NSString *nickName;//昵称
@property (nonatomic, strong) NSString *headPortraits;//头像url
@property (nonatomic, strong) NSString *Signature;//个性签名

@end
