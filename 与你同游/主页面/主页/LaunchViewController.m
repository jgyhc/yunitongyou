//
//  LaunchViewController.m
//  viewController
//
//  Created by rimi on 15/10/12.
//  Copyright (c) 2015年 ouyang. All rights reserved.
//

#import "LaunchViewController.h"
#import "LaunchTableViewCell.h"
#import "LaunchViewScrollImage.h"
#import "LaunchCollectionViewCell.h"
#import "SearchViewController.h"
#import "SearchResultView.h"
#import "ScenicViewController.h"
#import "ScenicSpotmodei.h"
#import "LoadingView.h"
#import "CalledModel.h"
@interface LaunchViewController ()<UITableViewDelegate ,UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SearchResultDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LaunchViewScrollImage *scrollImageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) CalledModel *calledModel;
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
//    [self.scenic removeObserver:self forKeyPath:@"scenicSpotSearchResults"];
//    [self.calledModel removeObserver:self forKeyPath:@"calledArray"];
//    [self.calledModel removeObserver:self forKeyPath:@"userArray"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.addressArray = @[@"北京", @"上海", @"江苏" ,@"海南" ,@"四川" ,@"重庆" ,@"广西" ,@"云南"];
//    self.imageArray = @[@"北京.jpg", @"上海.jpg", @"江苏.jpg" ,@"海南.jpg" ,@"四川.jpg" ,@"重庆.jpg" ,@"广西.jpg" ,@"云南.jpg"];
//    
//    [self initPersonButton];
//    [self initRightButtonEvent:@selector(handleEventRightButton:) Image:[UIImage imageNamed:@"搜索_白色.png"]];
////    [self.rightButton setImage:[UIImage imageNamed:@"搜索_白色.png"] forState:UIControlStateNormal];
//    [self initNavTitle:@"发现"];
//    [self.view insertSubview:self.scrollView atIndex:0];
////    [self.scrollView addSubview:self.tableView];
//    [self.scrollView addSubview:self.scrollImageView];
//
//    self.view.backgroundColor = [UIColor colorWithWhite:0.950 alpha:1.000];
//
//    [self.scenic addObserver:self forKeyPath:@"scenicSpotSearchResults" options:NSKeyValueObservingOptionNew context:nil];
//    [self.calledModel addObserver:self forKeyPath:@"calledArray" options:NSKeyValueObservingOptionNew context:nil];
//    [self.calledModel addObserver:self forKeyPath:@"userArray" options:NSKeyValueObservingOptionNew context:nil];
//    
//
//    [self initUserInterface];
//    [self initCollectionView];
    
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
    label.text = @"热门旅游景点";
    label.center = flexibleCenter(CGPointMake(50, 215), NO);
    label.font = [UIFont boldSystemFontOfSize:(SCREEN_HEIGHT / 667.0) * 12];
    [self.scrollView addSubview:label];
    
    UILabel *senseLabel = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(22, 0, 80, 20), NO)];
//    CGRect frame = senseLabel.frame;
//    frame.origin.y = self.tableView.frame.origin.y + self.tableView.frame.size.height ;
//    senseLabel.frame = frame;
    senseLabel.text = @"热门旅游景点";
    senseLabel.font = [UIFont boldSystemFontOfSize:(SCREEN_HEIGHT / 667.0) * 12];
//    [self.scrollView addSubview:senseLabel];
    
}

- (void)initCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.headerReferenceSize = CGSizeMake(originWidth_, 0);
    self.collectionView = [[UICollectionView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 230, originWidth_, originHeight_ - 125), NO) collectionViewLayout:flowLayout];
//    CGRect frame = self.collectionView.frame;
//    frame.origin.y = self.tableView.frame.origin.y + self.tableView.frame.size.height + flexibleHeight(26);
//    self.collectionView.frame = frame;
    //代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    [self.scrollView insertSubview:self.collectionView atIndex:1];
    self.collectionView.scrollEnabled = NO;

    
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.collectionView registerClass:[LaunchCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    
    self.scrollView.contentSize = CGSizeMake(0, self.scrollImageView.frame.size.height + self.collectionView.frame.size.height + 40);
}
#pragma mark --搜索按钮点击事件
- (void)handleEventRightButton:(UIButton *)sender {
    SearchViewController *search = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];

}

#pragma mark --scrollView 相关
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_scrollImageView openTimer];
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_scrollImageView.totalNum > 1) {
        [_scrollImageView closeTimer];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_scrollImageView closeTimer];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (_scrollImageView.totalNum > 1) {
        [_scrollImageView openTimer];
    }
}

///////////////////////////////////////////////////////////////////////////////////

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
    
    if (!cell) {
    }
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




#pragma mark --tabelView delegete
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    
    LaunchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[LaunchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell initUserHeaderImage:IMAGE_PATH(@"拍照.png") userID:@"userID" userLV:@"userLV" launchTime:@"18:39" launchDate:@"2015.08.30"];
    [cell initDeparture:@"重庆" destination:@"涪陵" starting:@"08.31" reture:@"09.03" info:@"大家好,在此特意召唤小伙伴，喜欢有意的小伙伴踊跃跟团"];
    [cell initSave:@"0" comment:@"3" follower:@"3"];
//    tableView.rowHeight = flexibleHeight(225 + [self heightForString:@"大家好,在此特意召唤小伙伴，喜欢有意的小伙伴踊跃跟团" fontSize:14 andWidth:350]);
//    cell.infoLabel.frame = flexibleFrame(CGRectMake(10, 80, 335, [self heightForString:@"大家好,在此特意召唤小伙伴，喜欢有意的小伙伴踊跃跟团" fontSize:14 andWidth:335]), NO);
//    
//    cell.ContentButton.frame = CGRectMake(20, cell.infoLabel.frame.origin.y + cell.infoLabel.bounds.size.height + 10, flexibleHeight(70), flexibleHeight(70));
//    
//    
//    tableView.rowHeight = flexibleHeight(cell.saveButton.frame.size.height + cell.infoLabel.frame.size.height + cell.UserHeaderimageView.frame.origin.y + cell.ContentButton.frame.size.height);
//    
//    CGPoint center = cell.saveButton.center;
//    center.y = tableView.rowHeight - flexibleHeight(15);
//    cell.saveButton.center = center;
//    
//    center = cell.commentButton.center;
//    center.y = tableView.rowHeight - flexibleHeight(15);
//    cell.commentButton.center = center;
//    
//    center = cell.followerButton.center;
//    center.y = tableView.rowHeight - flexibleHeight(15);
//    cell.followerButton.center = center;
    [cell PositionTheReset];
    
    
    CGRect frame = tableView.frame;
    frame.size.height = tableView.rowHeight * 2 + 20;
    self.tableView.frame = frame;
    
    
    return cell;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = ({
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
            tableView.frame = flexibleFrame(CGRectMake(0, 0, WIDTH, 0), NO);
            CGRect frame = tableView.frame;
            frame.origin.y = self.scrollImageView.frame.origin.y + self.scrollImageView.frame.size.height + 30;
            frame.size.height = flexibleHeight(HEIGHT / 2 + 210);
            tableView.frame = frame;
            tableView.dataSource = self;
            tableView.delegate = self;
            tableView.rowHeight = (SCREEN_HEIGHT / 667.0) * 260;
            tableView.scrollEnabled = NO;
            tableView.backgroundColor = [UIColor colorWithWhite:0.900 alpha:1.000];
            tableView;
        });
    }
    return _tableView;
}

- (LaunchViewScrollImage *)scrollImageView {
    if (!_scrollImageView) {
        _scrollImageView = ({
            LaunchViewScrollImage *imageView = [[LaunchViewScrollImage alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, WIDTH, 200), NO) AddressArray:self.addressArray];
            imageView.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
            [imageView setArray:self.imageArray];
            imageView;
        });
    }
    return _scrollImageView;
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

- (CalledModel *)calledModel {
    if (!_calledModel) {
        _calledModel = [[CalledModel alloc] init];
    }
    return _calledModel;
}
@end
