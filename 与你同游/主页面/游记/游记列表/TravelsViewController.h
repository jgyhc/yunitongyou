//
//  TravelsViewController.h
//  与你同游
//
//  Created by rimi on 15/10/12.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "BaseViewController.h"
#import "SharedView.h"
#import "RecordDetailViewController.h"
#import "AddTravelViewController.h"
#import "UserModel.h"
@interface TravelsViewController : BaseViewController

@property (nonatomic, strong) NSMutableArray *notesData;//数据
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) SharedView *sharedView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;//
@property (nonatomic, strong) UserModel *travel;
@end
