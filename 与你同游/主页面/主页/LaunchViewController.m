//
//  LaunchViewController.m
//  viewController
//
//  Created by rimi on 15/10/12.
//  Copyright (c) 2015年 ouyang. All rights reserved.
//

#import "LaunchViewController.h"
#import "LaunchTableViewCell.h"
#import "LaunchCollectionViewCell.h"
#import "SearchViewController.h"
#import "SearchResultView.h"
#import "ScenicViewController.h"
#import "ScenicSpotmodei.h"
#import "LoadingView.h"
#import "SDCycleScrollView.h"
@interface LaunchViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SearchResultDelegate, SDCycleScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ScenicSpotmodei *scenic;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *scenicArray;

@property (nonatomic, strong) NSArray *addressArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) SearchResultView *resultView;
@property (nonatomic, strong) NSArray *collectionData;
@property (nonatomic, strong) LoadingView *load;
@end

@implementation LaunchViewController

- (void)dealloc {
    [self.scenic removeObserver:self forKeyPath:@"scenicSpotSearchResults"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.addressArray = @[@"北京", @"上海", @"江苏" ,@"海南" ,@"四川" ,@"重庆" ,@"广西" ,@"云南"];
    self.imageArray = @[@"北京.jpg", @"上海.jpg", @"江苏.jpg" ,@"海南.jpg" ,@"四川.jpg" ,@"重庆.jpg" ,@"广西.jpg" ,@"云南.jpg"];
    
    [self initPersonButton];
    [self initRightButtonEvent:@selector(handleEventRightButton:) Image:[UIImage imageNamed:@"搜索_白色.png"]];
    [self.rightButton setImage:[UIImage imageNamed:@"搜索_白色.png"] forState:UIControlStateNormal];
    [self initNavTitle:@"发现"];
    [self.view insertSubview:self.scrollView atIndex:0];
//    [self.scrollView addSubview:self.tableView];


    self.view.backgroundColor = [UIColor colorWithWhite:0.950 alpha:1.000];

    [self.scenic addObserver:self forKeyPath:@"scenicSpotSearchResults" options:NSKeyValueObservingOptionNew context:nil];

    [self initUserInterface];
    [self initCollectionView];
    
    CGFloat w = self.view.bounds.size.width;
    
    NSArray *imagesURLStrings = @[
                                  @"http://pic3.40017.cn/scenery/destination/2015/04/19/12/yP904h.jpg",
                                  @"http://pic3.40017.cn/scenery/destination/2015/04/18/18/DKMh1m.jpg",
                                  @"http://pic3.40017.cn/scenery/destination/2015/04/19/00/af8g1x.jpg",
                                  @"http://pic3.40017.cn/scenery/destination/2015/04/23/20/qozukp.jpg",
                                  @"http://pic3.40017.cn/scenery/destination/2015/04/18/20/tPj6Id.jpg"
                                  ];
    NSArray *titles = @[@"大木花谷 ",
                        @"仙女山",
                        @"丰都鬼城",
                        @"黄山",
                        @"张家界"
                        ];
    
    // 网络加载 --- 创建带标题的图片轮播器
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, w, 180) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView2.titlesGroup = titles;
    cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    [self.scrollView addSubview:cycleScrollView2];
    cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
    
    
    
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    
    [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
}

#pragma mark -- KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"scenicSpotSearchResults"]) {
        NSLog(@"%@", self.scenic.scenicSpotSearchResults);
        
        self.collectionData = self.scenic.scenicSpotSearchResults[@"showapi_res_body"][@"pagebean"][@"contentlist"];
//        //        NSLog(@"%@", self.dataSource);
        [[NSUserDefaults standardUserDefaults]setObject:self.collectionData forKey:@"searchResult"];
//        //        NSLog(@"%ld", self.dataSource.count);
        [self.parentViewController.view addSubview:self.resultView];
        [UIView animateWithDuration:0.7 animations:^{
            CGRect frame = _resultView.frame;
            frame.origin.y = flexibleHeight(64);
            _resultView.frame = frame;
        }];
        [self.rightButton removeTarget:self action:@selector(handleEventRightButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightButton setImage:nil forState:UIControlStateNormal];
        [self initRightButtonEvent:@selector(cancelEvent) title:@"取消"];
        [self.load hide];
    }
}

- (void)initUserInterface {
    UILabel *label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 80, 20), NO)];
    label.text = @"热门旅游城市";
    label.center = flexibleCenter(CGPointMake(50, 215), NO);
    label.font = [UIFont boldSystemFontOfSize:(SCREEN_HEIGHT / 667.0) * 12];
    [self.scrollView addSubview:label];
    
    UILabel *senseLabel = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(22, 0, 80, 20), NO)];
//    CGRect frame = senseLabel.frame;
//    frame.origin.y = self.tableView.frame.origin.y + self.tableView.frame.size.height ;
//    senseLabel.frame = frame;
    senseLabel.text = @"热门旅游城市";
    senseLabel.font = [UIFont boldSystemFontOfSize:(SCREEN_HEIGHT / 667.0) * 12];
//    [self.scrollView addSubview:senseLabel];
    
}

- (void)initCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.headerReferenceSize = CGSizeMake(originWidth_, 0);
    self.collectionView = [[UICollectionView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 230, originWidth_, originHeight_ - 125), NO) collectionViewLayout:flowLayout];
    //代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    [self.scrollView insertSubview:self.collectionView atIndex:1];
    self.collectionView.scrollEnabled = NO;

    
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.collectionView registerClass:[LaunchCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    
    [self.scrollView setupAutoContentSizeWithBottomView:self.collectionView bottomMargin:0];
}
#pragma mark --搜索按钮点击事件
- (void)handleEventRightButton:(UIButton *)sender {
    SearchViewController *search = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];

}


#pragma mark --UICollectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"cell";
    LaunchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifer forIndexPath:indexPath];
    [cell sizeToFit];
    UIImage *image = IMAGE_PATH(self.imageArray[indexPath.row]);
    cell.imageView.image = image;
    cell.addressLabel.text = self.addressArray[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView" forIndexPath:indexPath];
//    [headerView addSubview:_scrollImageView];
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return flexibleSize(CGSizeMake(originWidth_ / 2 - 10, 100), NO);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 5, 5, 5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark --UICollectionDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"选择%ld", indexPath.row);
//    ScenicViewController *scenicVC = [[ScenicViewController alloc]init];
//    [self.navigationController pushViewController:scenicVC animated:YES];
    [self.load show];
    [self.scenic sendAsynchronizedPostRequest:self.addressArray[indexPath.row]];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont boldSystemFontOfSize:fontSize];
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize.height;
}

#pragma mark --resultDelegate
- (void)pushToScenicDetailEvent:(NSMutableDictionary *)dic {
    ScenicViewController *scenic = [[ScenicViewController alloc]init];
    [self.navigationController pushViewController:scenic animated:YES];
    scenic.dataSource = dic;
}

- (void)cancelEvent {
    [UIView animateWithDuration:0.7 animations:^{
        CGRect frame = _resultView.frame;
        frame.origin.y = flexibleHeight(HEIGHT);
        _resultView.frame = frame;
    } completion:^(BOOL finished) {
        [self.resultView removeFromSuperview];
    }];
    [self.rightButton removeTarget:self action:@selector(cancelEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setTitle:@"" forState:UIControlStateNormal];
    [self initRightButtonEvent:@selector(handleEventRightButton:) Image:[UIImage imageNamed:@"搜索_白色.png"]];
}



- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = ({
            UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 64, WIDTH, HEIGHT ), NO)];
            scrollView;
        });
    }
    return _scrollView;
}

- (ScenicSpotmodei *)scenic {
    if (!_scenic) {
        _scenic = [[ScenicSpotmodei alloc] init];
    }
    return _scenic;
}

- (SearchResultView *)resultView {
    _resultView = [[SearchResultView alloc]init];
    _resultView.delegate = self;
    CGRect frame = _resultView.frame;
    frame.origin.y = flexibleHeight(HEIGHT);
    _resultView.frame = frame;
    return _resultView;
}

- (LoadingView *)load {
    if (!_load) {
        _load = [[LoadingView alloc]init];
    }
    return _load;
}

@end
