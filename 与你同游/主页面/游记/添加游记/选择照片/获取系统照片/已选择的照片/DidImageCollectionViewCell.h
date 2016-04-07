//
//  DidImageCollectionViewCell.h
//  ManJi
//
//  Created by Zgmanhui on 16/1/19.
//  Copyright © 2016年 Zgmanhui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DidImageCollectionViewCell;

@protocol DidImageCollectionViewCellDelegate <NSObject>

- (void)handleSelectEvent:(UIButton *)sender Cell:(DidImageCollectionViewCell *)Cell;

@end

@interface DidImageCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, assign) id<DidImageCollectionViewCellDelegate> delegate;

@end
