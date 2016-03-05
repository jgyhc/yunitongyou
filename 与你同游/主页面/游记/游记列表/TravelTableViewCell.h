//
//  TravelTableViewCell.h
//  与你同游
//
//  Created by rimi on 15/10/22.
//  Copyright © 2015年 LiuCong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TravelCollectionView.h"

#define LABEL_TAG 200


@interface TravelTableViewCell : UITableViewCell


@property (nonatomic, strong) UIButton *userPortrait;//头像
@property (nonatomic, strong) UILabel *timeLabel;//时间
@property (nonatomic, strong) UILabel *contentLabel;//内容
@property (nonatomic, strong) UILabel *nameLabel;//名字
@property (nonatomic, strong) UILabel *placeLabel;//地点
@property (nonatomic, strong) UIButton *thumbUpButton;//点赞
@property (nonatomic, strong) UIButton *commentsButton;//评论
@property (nonatomic, strong) UIButton *shareButton;//分享
@property (nonatomic,strong) UIView * buttomView;//用来添加点赞、评论、分享按钮

@property (nonatomic,strong) TravelCollectionView * collectionView;
@property (nonatomic,strong) NSMutableArray * imageArray;

/**
 *  下部文字
 *
 *  @param save     收藏人数
 *  @param comment  评论人数
 *  @param follower 跟团人数
 */
- (void)initSave:(NSString *)save comment:(NSString *)comment follower:(NSString *)follower;



@end
