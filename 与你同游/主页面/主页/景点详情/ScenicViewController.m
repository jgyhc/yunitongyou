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

@interface ScenicViewController () <UIScrollViewDelegate, SDCycleScrollViewDelegate>

@property (nonatomic, strong) ScenicDetailView *contentView;

@property (nonatomic, strong) ScenicDetailView *priceView;

@property (nonatomic, strong) ScenicDetailView *openView;

@property (nonatomic, strong) ScenicDetailView *addressView;

@property (nonatomic, strong) ScenicDetailView *attentionView;



@end

@implementation ScenicViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUserInterface];
    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)initUserInterface {
    [self initBackButton];
    [self initNavTitle:@"白帝城"];
//    [self initRightButtonEvent:@selector(rightButtonEvent) Image:[UIImage imageNamed:@"添加游记"]];
    [self initRightButtonEvent:@selector(rightButtonEvent) Image:[UIImage imageNamed:@"添加游记"]];
    

    // 网络加载 --- 创建带标题的图片轮播器
    CGFloat w = self.view.bounds.size.width;
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 64, w, flexibleHeight(180)) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    NSArray *imagesURLStrings = @[
                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                  ];
    cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    [self.view addSubview:cycleScrollView];
}
- (void)rightButtonEvent {
    AddActivityViewController *addActive = [[AddActivityViewController alloc]init];
    addActive.destinationString = self.dataSource[@"name"];
    [self.navigationController pushViewController:addActive animated:YES];
}

- (void)setModel:(SSContentlist *)model {
    _model = model;
    if (model.content) {
        
    }
    
    
}

//- (void)SettingDatasource {
//    [self initNavTitle:self.dataSource[@"name"]];
//    
//    [self.imageScrollView setUrlArray:self.imageArray];
//    self.contentLabel.text = [NSString stringWithFormat:@"       %@", self.dataSource[@"content"]];
//    self.openTimeLabel.text = [NSString stringWithFormat:@"开放时间：%@", self.dataSource[@"opentime"]];
//    self.priceLabel.text = [NSString stringWithFormat:@"       价格：%@ \n       %@", self.dataSource[@"price"], self.dataSource[@"coupon"]];
//    self.attentionLabel.text = [NSString stringWithFormat:@"       提示：%@", self.dataSource[@"attention"]];
//    self.addressLabel.text = [NSString stringWithFormat:@"地址：%@", self.dataSource[@"address"]];
//}
//
//
//- (void)arrayMethod {
//        if (self.dataSource[@"picList"] != NULL) {
//            NSMutableArray *array = self.dataSource[@"picList"];
//            if (array.count != 0) {
//                [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                    if (idx < 10) {
//                        SDWebImageManager *manager = [SDWebImageManager sharedManager];
//                        [manager downloadImageWithURL:obj[@"picUrl"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                            if (image) {
//                                [self.imageArray addObject:image];
//                            }
//                            if (finished) {
//                                [self SettingDatasource];
//                                [self.load hide];
//                            }
//                        }];
//                    }
//            }];
//        }
//    }
//}

#pragma mark --contentlabel的开关
@end
