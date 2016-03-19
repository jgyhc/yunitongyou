//
//  TravelNotesTableViewCell.h
//  与你同游
//
//  Created by mac on 16/3/3.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^thumbUp)(void);//区别名
typedef void (^clickCancelButton)(void);

@interface TravelNotesTableViewCell : UITableViewCell

@property (nonatomic, strong) BmobObject * info;
@property (nonatomic, strong) NSNumber * thumbNumber;

- (void)buttonPress:(thumbUp)block;//回调方法

@end
