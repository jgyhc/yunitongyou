//
//  LaunchCollectionViewCell.h
//  viewController
//
//  Created by rimi on 15/10/14.
//  Copyright (c) 2015年 ouyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScenicSpot.h"
@interface LaunchCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UILabel *addressLabel;
@property (nonatomic, strong) SSContentlist *model;
@end
