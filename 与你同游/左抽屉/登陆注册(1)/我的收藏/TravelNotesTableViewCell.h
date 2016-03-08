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

@property (nonatomic, strong)   UIImageView * dianzanImg;
@property (nonatomic, strong)   UIImageView * commentImg;
@property (nonatomic, strong)   UIImageView * shareImg;
@property (nonatomic, strong)   UILabel     * dianzanLabel;
@property (nonatomic, strong)   UILabel     * commentLabel;
@property (nonatomic, strong)   UILabel     * shareLabel;
@property (nonatomic, strong)   UIView      * vline1;
@property (nonatomic, strong)   UIView      * vline2;

@end
