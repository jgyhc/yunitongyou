//
//  TravelNotesTableViewCell.h
//  与你同游
//
//  Created by mac on 16/3/3.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^thumbUp)(int type);//区别名
typedef void (^share)(void);
typedef void (^comment)(void);
typedef void (^personalInfo)(void);

@interface TravelNotesTableViewCell : UITableViewCell

@property (nonatomic, strong) BmobObject * obj;


- (void)buttonthumbUp:(thumbUp)firstblock;//回调方法


- (void)buttoncomment:(comment)secondblock;

- (void)buttonshared:(share)thirdblock;

- (void)tapPresent:(personalInfo)fourthblock;


@end
