//
//  TravelNotesTableViewCell.h
//  与你同游
//
//  Created by mac on 16/3/3.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TravelNotesModel;

@interface TravelNotesTableViewCell : UITableViewCell
@property (nonatomic, strong) TravelNotesModel * model;
@property (nonatomic,strong) NSIndexPath * indexPath;

@property (nonatomic, copy) void (^moreButtonClickedBlock)(NSIndexPath *indexPath);

@end
