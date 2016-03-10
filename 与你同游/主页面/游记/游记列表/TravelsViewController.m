//
//  TravelsViewController.m
//  与你同游
//
//  Created by rimi on 15/10/12.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "TravelsViewController.h"
#import "OtherInfoViewController.h"
#import <BmobSDK/Bmob.h>
#import "TravelModel.h"
#import "MJRefresh.h"

#import "MJRefresh.h"

#import "CommentViewController.h"
#import "TravelNotesTabelVC.h"
#define BUTTON_TAG 100
#define LABEL_TAG 200
#define IMAGE_TAG 300


static NSString * const identifier = @"CELL";

@interface TravelsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UILabel *nameLabel;//昵称
@property (nonatomic, strong) TravelModel *travelCT;
@property (nonatomic, strong) UserModel *userModel;
@property (nonatomic, strong) NSMutableArray *userArray;
@property (nonatomic, strong) BmobObject *userObject;

//@property (nonatomic,strong) TravelCollectionViewController * collectionVC;
@end

@implementation TravelsViewController
- (void)dealloc {
    [self.travel removeObserver:self forKeyPath:@"travelListArray"];
    [self.travel removeObserver:self forKeyPath:@"travelUser"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initalizedInterface];
    [self.travel addObserver:self forKeyPath:@"travelListArray" options:NSKeyValueObservingOptionNew context:nil];
    [self.travel addObserver:self forKeyPath:@"travelUser" options:NSKeyValueObservingOptionNew context:nil];
}
#pragma mark -- KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"travelListArray"]) {
        self.notesData = self.travel.travelListArray;
        for (int i = (int)self.userArray.count; i < self.notesData.count; i ++) {
            if ([self.notesData[i] objectForKey:@"image"]) {
                NSString *strUrl = [self.notesData[i] objectForKey:@"image"];
                NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:strUrl]];
                UIImage *image = [UIImage imageWithData:data];
                [self.notesData[i] setObject:image forKey:@"image"];
            }else {
                [self.notesData[i] setObject:IMAGE_PATH(@"个人信息背景2.png") forKey:@"image"];
            }
        }
    }
    if ([keyPath isEqualToString:@"travelUser"]) {
        for (int i = (int)self.userArray.count; i < self.notesData.count; i ++) {
            BmobObject *ob = self.travel.travelUser[i];
            if ([ob objectForKey:@"head_portraits1"]) {
                NSString *strUrl = [ob objectForKey:@"head_portraits1"];
                NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:strUrl]];
                 UIImage *image = [UIImage imageWithData:data];
                [ob setObject:image forKey:@"head_portraits1"];
                [self.userArray addObject:ob];
            }else {
                [ob setObject:IMAGE_PATH(@"qq.png") forKey:@"head_portraits1"];
                [self.userArray addObject:ob];
            }
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }
    
    
}
- (void)initalizedInterface{
    
    [self initNavTitle:@"游记"];
    [self initPersonButton];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initRightButtonEvent:@selector(handleTravelNotes:) Image:[UIImage imageNamed:@"添加游记"]];
    TravelNotesTabelVC * travelVC = [[TravelNotesTabelVC alloc]init];
    CGRect frame = travelVC.tableView.frame;
    frame = flexibleFrame(CGRectMake(0, flexibleHeight(64), WIDTH, HEIGHT - flexibleHeight(64)), NO);
    travelVC.tableView.frame = frame;
    [self addChildViewController:travelVC];
    [self.view addSubview:travelVC.tableView];

}

- (void)handleTravelNotes:(UIButton *)sender {
    AddTravelViewController * addVC = [[AddTravelViewController alloc]init];
    [self.navigationController pushViewController:addVC animated:YES];
}



@end
