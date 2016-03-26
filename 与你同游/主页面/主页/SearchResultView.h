//
//  SearchResultView.h
//  与你同游
//
//  Created by rimi on 15/10/22.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ScenicSpot.h"
@protocol SearchResultDelegate <NSObject>

- (void)pushToScenicDetailEvent:(SSContentlist *)list;


@end

@interface SearchResultView : UIView

@property (nonatomic, assign)id<SearchResultDelegate> delegate;
@property (nonatomic, strong) NSArray *list;
@end
