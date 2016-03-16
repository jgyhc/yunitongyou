//
//  AddTravelViewController.m
//  与你同游
//
//  Created by rimi on 15/11/7.
//  Copyright © 2015年 LiuCong. All rights reserved.
//

#import "AddTravelViewController.h"
#import "TravelModel.h"
#import "LoadingView.h"
#import "ChooseImageListCollectionViewCell.h"
#import "ChooseImageListViewController.h"
#import "WGS84TOGCJ02.h"//精确定位
@import AssetsLibrary;
@import CoreLocation;//导入框架

#define  BUTTON_TAG 200
static NSString * const kCollectionViewCellIndentifier = @"ChooseImageListViewCellIndentfier";

@interface AddTravelViewController ()<UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, ChooseImageListViewControllerDelegate, ChooseImageListCollectionViewCellDelegate,CLLocationManagerDelegate>
// 管理定位
@property (nonatomic, strong) CLLocationManager * manager;


@property (nonatomic, strong) TravelModel *travelModel;
@property (nonatomic, strong) LoadingView *load;
@property (nonatomic, strong) UITextView *contentView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel * positionLabel;
@property (nonatomic, strong) UIButton * positionButton;
@property (nonatomic, assign) CGFloat collectionViewHight;
@property (nonatomic, assign) CGFloat collectionViewY;
@property (nonatomic, strong) NSMutableArray *indexPathArray;
@property (nonatomic, strong) NSMutableArray *selectedArrayUrl;
@property (nonatomic, strong)  UIImageView * positionView;
@end

@implementation AddTravelViewController

- (void)dealloc {
    [self.travelModel removeObserver:self forKeyPath:@"addTravelResult"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionViewY = 125;
    [self initUserDataSource];
    [self initializedApperance];
    [self.travelModel addObserver:self forKeyPath:@"addTravelResult" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)initUserDataSource {
    if (self.dataSource.count < 3) {
        self.collectionViewHight = 120;
    }else if(self.dataSource.count > 2 && self.dataSource.count < 6) {
        self.collectionViewHight = 240;
    }else {
        self.collectionViewHight = 360;
    }
}

- (void)initializedApperance{
    
    [self initBackButton];
    [self initNavTitle:@"发游记"];
    [self initRightButtonEvent:@selector(handleComplete) title:@"完成"];
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.label];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.positionButton];
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"请开启定位服务");
        return;
    }
    // 1. 配置定位
    self.manager = [[CLLocationManager alloc] init];
    
    // 2. 设置属性
    // 2.1 定位的精确度
    self.manager.desiredAccuracy = kCLLocationAccuracyBest; // 最精准的（越精准越销毁cpu，越耗电）
    // 2.2 设置移动10米更新
    self.manager.distanceFilter = 10;
    // 2.3 开启定位的方式 (一直开启或用时开启)
    [self.manager requestAlwaysAuthorization];
    // 4. 设置代理
    self.manager.delegate = self;

  
}
#pragma mark -- KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"addTravelResult"]) {
       if ([self.travelModel.addTravelResult isEqualToString:@"YES"]) {
           [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"游记发表成功！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
       else{
           [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
           UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"游记发表失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
           [alertView show];
       }
        
    }
}
#pragma mark -- 网络请求
- (void)handleComplete {
    NSMutableArray *imageArray = [NSMutableArray array];
    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    
    if (self.selectedArrayUrl.count == 0) {
        [self.travelModel addTravelNoteWithObejectId:OBJECTID content:self.contentView.text imagesArray:nil location:self.positionLabel.text];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        return;
    }
    for (int i = 0; i < self.selectedArrayUrl.count; i ++) {
        
        [assetLibrary assetForURL:self.selectedArrayUrl[i] resultBlock:^(ALAsset *asset) {
            UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            [imageArray addObject:image];
            if (i == self.selectedArrayUrl.count - 1) {
             
                [self.travelModel addTravelNoteWithObejectId:OBJECTID content:self.contentView.text imagesArray:imageArray location:self.positionLabel.text];
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            }
        }
    failureBlock:^(NSError *error) {
            NSLog(@"%@", error);
        }];
    }
}



#pragma mark -- ChooseImageListCollectionViewCellDelegate
- (void)cell:(ChooseImageListCollectionViewCell *)cell clickButtonDidPressed:(UIButton *)sender {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    [self.selectedArrayUrl removeObjectAtIndex:indexPath.row];
    [self.indexPathArray removeObjectAtIndex:indexPath.row];
    [self.dataSource removeObjectAtIndex:indexPath.row];
    [self initUserDataSource];
    [self.collectionView reloadData];
}

#pragma mark -- ChooseImageListViewControllerDelegate
- (void)CallbackPhotoArray:(NSMutableArray *)photoUrl thumbnailArray:(NSMutableArray *)thumbnailArray selectIndexArray:(NSMutableArray *)selectIndexArray {
    self.dataSource = thumbnailArray;
    self.indexPathArray = selectIndexArray;
    self.selectedArrayUrl = photoUrl;
    [self initUserDataSource];
    [self.collectionView reloadData];
    
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataSource.count == 9) {
        return 9;
    }else {
        return self.dataSource.count + 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChooseImageListCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIndentifier forIndexPath:indexPath];
    cell.delegate = self;
    if (indexPath.row == self.dataSource.count) {
        cell.photoImageView.image = IMAGE_PATH(@"添加相片.png");
        [cell.selectedButton removeFromSuperview];
    }else {
        [cell.contentView addSubview:cell.selectedButton];
        cell.photoImageView.image = [UIImage imageWithData:self.dataSource[indexPath.row]];
        [cell.selectedButton setBackgroundImage:IMAGE_PATH(@"删除照片.png") forState:UIControlStateNormal];
    }
    collectionView.frame = flexibleFrame(CGRectMake(10, self.collectionViewY, 355, self.collectionViewHight), NO);
    self.positionButton.frame = flexibleFrame(CGRectMake(10, self.collectionView.frame.origin.y + self.collectionView.frame.size.height, 356, 50), NO);
    return cell;
}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource.count < 9) {
        if (indexPath.row == self.dataSource.count) {
            ChooseImageListViewController *CLVC = [[ChooseImageListViewController alloc] init];
            [self.navigationController pushViewController:CLVC animated:NO];
            CLVC.selectedIndex = self.indexPathArray;
            CLVC.delegate = self;
        }
    }
}

#pragma mark --压缩图片
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}

#pragma mark -- 选择地点
- (void)handlePosition{

    if (self.positionButton.selected) {
        self.positionLabel.textColor = [UIColor colorWithWhite:0.828 alpha:1.000];
        self.positionView.image = IMAGE_PATH(@"未定位.png");
    }
    else{
       [self.manager startUpdatingLocation];
    }
    self.positionButton.selected = !self.positionButton.selected;
}

#pragma mark - 委托方法 CLLocationManagerDelegate
// 在更新位置时调用
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // 获取最近一次定位（即数组最后一个元素）
    CLLocation * location = [locations lastObject];
    
    CLLocationCoordinate2D coordinate;
    
    // 获取坐标（经度加纬度）
    if (![WGS84TOGCJ02 isLocationOutOfChina:[location coordinate]]) {
        coordinate = [WGS84TOGCJ02 transformFromWGSToGCJ:[location coordinate]];
    }
    else{
        coordinate = location.coordinate;
    }
    // 停止定位（导航时不需要，停止是为了省电）
    [self.manager stopUpdatingLocation];
    
    CLGeocoder * gecoder = [[CLGeocoder alloc] init];
    // 2. 进行反编码
    [gecoder reverseGeocodeLocation:self.manager.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"error = %@",error);
        }
        else{
            // CLPlacemark 这个类包含了所有的定位信息
            CLPlacemark * placeMark = placemarks[0];
            if ([placeMark.addressDictionary[@"State"] isEqual:placeMark.addressDictionary[@"City"]]) {
                self.positionLabel.text = [NSString stringWithFormat:@"%@%@%@",placeMark.addressDictionary[@"State"],placeMark.addressDictionary[@"SubLocality"],placeMark.addressDictionary[@"Thoroughfare"]];
            }
            else{
                self.positionLabel.text = [NSString stringWithFormat:@"%@%@%@%@",placeMark.addressDictionary[@"State"],placeMark.addressDictionary[@"City"],placeMark.addressDictionary[@"SubLocality"],placeMark.addressDictionary[@"Thoroughfare"]];
            }
            self.positionLabel.textColor = [UIColor blackColor];
            self.positionView.image = IMAGE_PATH(@"已定位.png");
            
        }
        }]; // 编码会在后台进行（因为比较费时），完成时回调
    
}

// 定位失败时
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error:%@",error);
}





#pragma mark -- UITextViewDelegate 方法
#pragma mark --文本自适应
- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    UILabel *detailTextView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont boldSystemFontOfSize:fontSize];
    detailTextView.text = value;
    detailTextView.numberOfLines = 0;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize.height;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.label.hidden = YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    float height = [self heightForString:textView.text fontSize:14 andWidth:355];
    if (height > 50) {
         self.collectionViewY = height + 110;
           [textView setFrame:flexibleFrame(CGRectMake(10,65, 355,height + 20), NO)];
        self.collectionView.frame = flexibleFrame(CGRectMake(10,  self.collectionViewY, 355, self.collectionViewHight), NO);
        self.positionButton.frame = flexibleFrame(CGRectMake(10, self.collectionView.frame.origin.y + self.collectionView.frame.size.height, 356, 50), NO);
        textView.scrollEnabled = YES;
       
    }else {
         self.collectionViewY = 125;
          [textView setFrame:flexibleFrame(CGRectMake(10,65, 355,50), NO)];
        self.collectionView.frame = flexibleFrame(CGRectMake(10, self.collectionViewY, 355, self.collectionViewHight), NO);
        self.positionButton.frame = flexibleFrame(CGRectMake(10, self.collectionView.frame.origin.y + self.collectionView.frame.size.height, 356, 50), NO);
        textView.scrollEnabled = NO;
       
    }
    if (textView.text.length >= 140) {
        textView.text = [textView.text substringToIndex:140];
    }
}
//return键回收键盘
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        self.label.hidden = NO;
    }
}


#pragma mark -- getter
- (TravelModel *)travelModel {
    if (!_travelModel) {
        _travelModel = [[TravelModel alloc] init];
    }
    return _travelModel;
}

- (LoadingView *)load {
    if (!_load) {
        _load = [[LoadingView alloc] init];
    }
    return _load;
}
- (UIButton *)positionButton{
    if (!_positionButton) {
        _positionButton = [[UIButton alloc]initWithFrame:flexibleFrame(CGRectMake(10, self.collectionView.frame.origin.y + self.collectionView.frame.size.height, 356, 50), NO)];
        [_positionButton addTarget:self action:@selector(handlePosition) forControlEvents:UIControlEventTouchUpInside];
        _positionButton.selected = NO;
        
        self.positionView = [[UIImageView alloc]initWithFrame:flexibleFrame(CGRectMake(5, 15, 20, 20), NO)];
        self.positionView.image = IMAGE_PATH(@"未定位.png");
        
        [_positionButton addSubview:self.positionView];
        
        UILabel * positionLabel = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(30, 15,300, 20), NO)];
        positionLabel.text = @"定位";
        self.positionLabel = positionLabel;
        positionLabel.font = [UIFont systemFontOfSize:14];
        positionLabel.textColor = [UIColor colorWithWhite:0.828 alpha:1.000];
        [_positionButton addSubview:positionLabel];
        
        _positionButton.backgroundColor = [UIColor whiteColor];
        
    }
    return _positionButton;
    
}
- (UITextView *)contentView {
    if (!_contentView) {
        _contentView = ({
            UITextView *textView = [[UITextView alloc] init];
            textView.frame = flexibleFrame(CGRectMake(10,65, 355,50), NO);
            textView.showsVerticalScrollIndicator = NO;
            textView.textColor = [UIColor grayColor];
            textView.font = [UIFont systemFontOfSize:14];
            textView.delegate = self;
            textView.backgroundColor = [UIColor clearColor];
            textView;
        });
    }
    return _contentView;
}

- (UILabel *)label {
    if (!_label) {
        _label = ({
            UILabel *label = [[UILabel alloc] init];
            label.text = @"哟，发一条游记吧！";
            label.textColor = [UIColor colorWithWhite:0.828 alpha:1.000];
            label.frame = flexibleFrame(CGRectMake(5, 10, 260, 20), NO);
            label.font = [UIFont systemFontOfSize:14];
            label;
        });
    }
    return _label;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = ({
            //1.创建layout
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            //配置属性
            //配置最小的行距
            layout.minimumLineSpacing = 10;
            //配置最小间距
            layout.minimumInteritemSpacing = 10;
            //cell大小
            layout.itemSize = CGSizeMake(110, 110);
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:flexibleFrame(CGRectMake(10, self.collectionViewY, 355, self.collectionViewHight), NO) collectionViewLayout:layout];
            [collectionView registerClass:[ChooseImageListCollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellIndentifier];
            collectionView.backgroundColor = [UIColor whiteColor];
            collectionView.delegate = self;
            collectionView.dataSource = self;
            collectionView;
        });

    }
    return _collectionView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (NSMutableArray *)indexPathArray {
    if (!_indexPathArray) {
        _indexPathArray = [NSMutableArray array];
    }
    return _indexPathArray;
}

- (NSMutableArray *)selectedArrayUrl {
    if (!_selectedArrayUrl) {
        _selectedArrayUrl = [NSMutableArray array];
    }
    return _selectedArrayUrl;
}

@end
