//
//  ChooseImageListViewController.h
//  与你同游
//
//  Created by rimi on 15/11/6.
//  Copyright © 2015年 LiuCong. All rights reserved.
//

#import "BaseViewController.h"


@protocol ChooseImageListViewControllerDelegate <NSObject>

- (void)CallbackPhotoArray:(NSMutableArray *)photoUrl thumbnailArray:(NSMutableArray *)thumbnailArray selectIndexArray:(NSMutableArray *)selectIndexArray;
@end
@interface ChooseImageListViewController : BaseViewController
@property (nonatomic, assign) id<ChooseImageListViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *selectedIndex;
@end
