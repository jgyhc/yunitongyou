//
//  DetailTopView.h
//  与你同游
//
//  Created by mac on 16/3/24.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoView.h"

@interface DetailTopView : UIView

@property (nonatomic, strong) BmobObject * travelObject;

@property (nonatomic, strong) BmobObject * userObject;

@property (nonatomic, strong) PhotoView   * picContainerView;//图片

@end
