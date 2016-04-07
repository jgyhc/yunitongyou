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
#import "ScenicSpot.h"
#import "ScenicViewController.h"
#import <YYModel.h>
@interface LaunchViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SearchResultDelegate, SDCycleScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ScenicSpotmodei *scenic;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *scenicArray;

@property (nonatomic, strong) NSArray *addressArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) SearchResultView *resultView;
@property (nonatomic, strong) LoadingView *load;

@property (nonatomic, strong) NSArray *urls;
@property (nonatomic, strong) ScenicSpot *scenicSpot;
@end

@implementation LaunchViewController



- (void)addAD {
    CGFloat w = self.view.bounds.size.width;
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, w, 180) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    [self.scrollView addSubview:cycleScrollView2];
    NSMutableArray *uslArray = [NSMutableArray array];
    NSMutableArray *titleArray = [NSMutableArray array];
    [ScenicSpot getAdUrlsSuccess:^(NSArray *urls) {
        for (BmobObject *obj in urls) {
            [uslArray addObject:[(NSArray *)[obj objectForKey:@"url"] objectAtIndex:0]];
            [titleArray addObject:[obj objectForKey:@"spotName"]];
        }
        cycleScrollView2.imageURLStringsGroup = uslArray;
        cycleScrollView2.titlesGroup = titleArray;
        _urls = urls;
    } failure:^(NSError *error) {
        
    }];


}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addAD];
    self.addressArray = @[@"北京", @"上海", @"江苏" ,@"海南" ,@"四川" ,@"重庆" ,@"广西" ,@"云南"];
    self.imageArray = @[@"北京.jpg", @"上海.jpg", @"江苏.jpg" ,@"海南.jpg" ,@"四川.jpg" ,@"重庆.jpg" ,@"广西.jpg" ,@"云南.jpg"];
    
    [self initPersonButton];
    [self initRightButtonEvent:@selector(handleEventRightButton:) Image:[UIImage imageNamed:@"搜索_白色.png"]];
    [self.rightButton setImage:[UIImage imageNamed:@"搜索_白色.png"] forState:UIControlStateNormal];
    [self initNavTitle:@"发现"];
    [self.view insertSubview:self.scrollView atIndex:0];
//    [self.scrollView addSubview:self.tableView];


    self.view.backgroundColor = [UIColor colorWithWhite:0.950 alpha:1.000];

    [self initUserInterface];
    [self initCollectionView];
    
    
    
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    BmobObject *obj = [_urls[index] objectForKey:@"scenicSpot"];
    NSDictionary *dic = [obj objectForKey:@"dic"];
    SSContentlist *list = [SSContentlist yy_modelWithJSON:dic];
    ScenicViewController *SVc = [[ScenicViewController alloc] init];
    SVc.model = list;
    [self.navigationController pushViewController:SVc animated:YES];
}



- (void)initUserInterface {
    UILabel *label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 80, 20), NO)];
    label.text = @"热门旅游城市";
    label.center = flexibleCenter(CGPointMake(50, 185), NO);
    label.font = [UIFont boldSystemFontOfSize:(SCREEN_HEIGHT / 667.0) * 12];
    [self.scrollView addSubview:label];
    
    UILabel *senseLabel = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(22, 0, 80, 20), NO)];
    senseLabel.text = @"热门旅游城市";
    senseLabel.font = [UIFont boldSystemFontOfSize:(SCREEN_HEIGHT / 667.0) * 12];
    
}

- (void)initCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.headerReferenceSize = CGSizeMake(originWidth_, 0);
    self.collectionView = [[UICollectionView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 200, originWidth_, originHeight_ - 125), NO) collectionViewLayout:flowLayout];
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
    __weak typeof(self) weakSelf = self;
    [self.scenicSpot setSsblock:^(ScenicSpot * scenicSpot) {
        weakSelf.resultView.list = scenicSpot.showapi_res_body.pagebean.contentlist;
        [weakSelf.parentViewController.view addSubview:weakSelf.resultView];
        if (weakSelf.resultView.list.count  == 0) {
            [weakSelf message:@"对不起，没有找到该景点的数据！"];
            [weakSelf.load hide];
        }else {
            [UIView animateWithDuration:0.7 animations:^{
                CGRect frame = weakSelf.resultView.frame;
                frame.origin.y = flexibleHeight(64);
                weakSelf.resultView.frame = frame;
            }];
            [weakSelf.rightButton removeTarget:weakSelf action:@selector(handleEventRightButton:) forControlEvents:UIControlEventTouchUpInside];
            [weakSelf.rightButton setImage:nil forState:UIControlStateNormal];
            [weakSelf initRightButtonEvent:@selector(cancelEvent) title:@"取消"];
            [weakSelf.load hide];
        }
    }];

    [self.load show];
    [self.scenicSpot sendAsynchronizedPostRequest:self.addressArray[indexPath.row]];
//    [self.scenic sendAsynchronizedPostRequest:self.addressArray[indexPath.row]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       [self.load hide];
    });
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

#pragma mark --SearchResultDelegate
- (void)pushToScenicDetailEvent:(SSContentlist *)list {
    ScenicViewController *scenic = [[ScenicViewController alloc]init];
    scenic.model = list;
    [self.navigationController pushViewController:scenic animated:YES];
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
    if (!_resultView) {
        _resultView = [[SearchResultView alloc]init];
        _resultView.delegate = self;
        CGRect frame = _resultView.frame;
        frame.origin.y = flexibleHeight(HEIGHT);
        _resultView.frame = frame;
    }
    return _resultView;
}

- (LoadingView *)load {
    if (!_load) {
        _load = [[LoadingView alloc]init];
    }
    return _load;
}

- (ScenicSpot *)scenicSpot {
	if(_scenicSpot == nil) {
		_scenicSpot = [[ScenicSpot alloc] init];
	}
	return _scenicSpot;
}

@end
