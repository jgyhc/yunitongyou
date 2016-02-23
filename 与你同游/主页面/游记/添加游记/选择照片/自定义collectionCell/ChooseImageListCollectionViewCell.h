//
//  ChooseImageListCollectionViewCell.h
//  与你同游
//
//  Created by rimi on 15/11/6.
//  Copyright © 2015年 LiuCong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChooseImageListCollectionViewCell;
@protocol ChooseImageListCollectionViewCellDelegate <NSObject>
- (void)cell:(ChooseImageListCollectionViewCell *)cell clickButtonDidPressed:(UIButton *)sender;
@end

@interface ChooseImageListCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, assign) id<ChooseImageListCollectionViewCellDelegate> delegate;
@end
