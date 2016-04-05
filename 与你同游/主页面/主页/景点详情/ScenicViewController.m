//
//  ScenicViewController.m
//  与你同游
//
//  Created by rimi on 15/10/22.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "ScenicViewController.h"
#import "SDCycleScrollView.h"
#import "LoadingView.h"
#import "AddActivityViewController.h"
#import "ScenicDetailView.h"
#import "MLPhotoBrowserViewController.h"
#import "ScenicSpot.h"
@interface ScenicViewController () <UIScrollViewDelegate, SDCycleScrollViewDelegate, MLPhotoBrowserViewControllerDataSource,MLPhotoBrowserViewControllerDelegate, SDCycleScrollViewDelegate>

@property (nonatomic, strong) ScenicDetailView *contentView;

@property (nonatomic, strong) ScenicDetailView *priceView;//价格

@property (nonatomic, strong) ScenicDetailView *addressView;

@property (nonatomic, strong) ScenicDetailView *attentionView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *ViewArray;

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@property (nonatomic, strong) NSMutableArray *url;
@end

@implementation ScenicViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scrollView];
    self.scrollView.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).topSpaceToView(self.navView, 0).bottomSpaceToView(self.view, 0);
    [self initUserInterface];
    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)initUserInterface {
    [self initBackButton];
    [self initRightButtonEvent:@selector(rightButtonEvent) Image:[UIImage imageNamed:@"添加游记"]];
}

- (void)rightButtonEvent {
    AddActivityViewController *addActive = [[AddActivityViewController alloc]init];
    addActive.destinationString = _model.name;
    [self.navigationController pushViewController:addActive animated:YES];
}

- (void)setModel:(SSContentlist *)model {
    _model = model;

    NSData *data = [model yy_modelToJSONData];
    NSDictionary *dic = [self JSONWithData:data];
    [ScenicSpot addScenicSpotArray:dic success:^(BOOL isSuccessful) {
        
    } failure:^(NSError *error1) {
        
    }];
    
    [self initNavTitle:model.name];
    [self.scrollView addSubview:self.contentView];
    self.contentView.sd_layout.leftSpaceToView(self.scrollView, 0).rightSpaceToView(self.scrollView, 0).topSpaceToView(self.scrollView, flexibleHeight(180));
    self.contentView.model = model.content;
    
    [self.scrollView addSubview:self.addressView];
    self.addressView.sd_layout.leftSpaceToView(self.scrollView, 0).rightSpaceToView(self.scrollView, 0).topSpaceToView(self.contentView, flexibleHeight(0));
    self.addressView.model = model.address;

    
    [self.scrollView addSubview:self.priceView];
    self.priceView.sd_layout.leftSpaceToView(self.scrollView, 0).rightSpaceToView(self.scrollView, 0).topSpaceToView(self.addressView, flexibleHeight(0));
    self.priceView.model = [NSString stringWithFormat:@"票价：%f", model.price];

    
    [self.scrollView addSubview:self.attentionView];
    self.attentionView.sd_layout.leftSpaceToView(self.scrollView, 0).rightSpaceToView(self.scrollView, 0).topSpaceToView(self.priceView, flexibleHeight(0));
    self.attentionView.model = model.summary;

    
    
    
    [self.scrollView setupAutoContentSizeWithBottomView:self.attentionView bottomMargin:flexibleHeight(10)];
    NSMutableArray *url = [NSMutableArray array];
    for (int i = 0 ; i< (model.picList.count>10?10:model.picList.count); i ++) {
        SSPicList *pic = model.picList[i];
        [url addObject:pic.picUrl];
    }
    _url = url;
    self.cycleScrollView.imageURLStringsGroup = url;
    [self.scrollView addSubview:self.cycleScrollView];
    
    
}
- (id) JSONWithData:(NSData *)data {
    NSError *error = nil;
    
    id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    //条件为假，崩溃
    NSAssert(!error, @"JSON解析失败，原因%@",[error localizedDescription]);
    return obj;
}



#pragma mark -- SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    MLPhotoBrowserViewController *photoBrowser = [[MLPhotoBrowserViewController alloc] init];
    photoBrowser.status = UIViewAnimationAnimationStatusFade;
    photoBrowser.delegate = self;
    photoBrowser.dataSource = self;
    photoBrowser.currentIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [photoBrowser showPickerVc:self];

}

#pragma mark - <MLPhotoBrowserViewControllerDataSource>
- (NSInteger)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return self.url.count;
}

#pragma mark - 每个组展示什么图片,需要包装下MLPhotoBrowserPhoto
- (MLPhotoBrowserPhoto *) photoBrowser:(MLPhotoBrowserViewController *)browser photoAtIndexPath:(NSIndexPath *)indexPath{
    // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
    MLPhotoBrowserPhoto *photo = [[MLPhotoBrowserPhoto alloc] init];
    photo.photoObj = [self.url objectAtIndex:indexPath.row];
    // 缩略图
    //    UIImage *image = [UIImage imageWithData:self.datasource[indexPath.row]];
    photo.thumbImage =  nil;
    
    return photo;
}

- (UIScrollView *)scrollView {
	if(_scrollView == nil) {
		_scrollView = [[UIScrollView alloc] init];
	}
	return _scrollView;
}

- (ScenicDetailView *)contentView {
	if(_contentView == nil) {
		_contentView = [[ScenicDetailView alloc] init];
	}
	return _contentView;
}

- (ScenicDetailView *)priceView {
	if(_priceView == nil) {
		_priceView = [[ScenicDetailView alloc] init];
	}
	return _priceView;
}

- (ScenicDetailView *)addressView {
	if(_addressView == nil) {
		_addressView = [[ScenicDetailView alloc] init];
	}
	return _addressView;
}

- (ScenicDetailView *)attentionView {
	if(_attentionView == nil) {
		_attentionView = [[ScenicDetailView alloc] init];
	}
	return _attentionView;
}

- (NSMutableArray *)ViewArray {
	if(_ViewArray == nil) {
		_ViewArray = [[NSMutableArray alloc] init];
	}
	return _ViewArray;
}

- (SDCycleScrollView *)cycleScrollView {
	if(_cycleScrollView == nil) {
		_cycleScrollView = [[SDCycleScrollView alloc] init];
        CGFloat w = self.view.bounds.size.width;
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, w, flexibleHeight(180)) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _cycleScrollView.delegate = self;
	}
	return _cycleScrollView;
}

@end
