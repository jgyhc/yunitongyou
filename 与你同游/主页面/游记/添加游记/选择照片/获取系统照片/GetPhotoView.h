//
//  GetPhotoView.h
//  ManJi
//
//  Created by Zgmanhui on 16/1/29.
//  Copyright © 2016年 Zgmanhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GetPhotoViewDelegate <NSObject>

- (void)pushVC:(UIViewController *)VC;
@optional
- (void)showImgBrowser:(NSIndexPath *)indexPath;
- (void)ActionSheetInView:(NSIndexPath *)indexPath;
@end
@interface GetPhotoView : UIView
@property (nonatomic, strong) UICollectionView *imageCollectionView;
@property (nonatomic, assign) id<GetPhotoViewDelegate> delegate;
@end
