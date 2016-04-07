//
//  AddTravelVC.m
//  与你同游
//
//  Created by Zgmanhui on 16/4/7.
//  Copyright © 2016年 LiuCong. All rights reserved.
//

#import "AddTravelVC.h"
#import "TravelModel.h"
#import "LoadingView.h"
#import "PhotoSelect.h"
#import "ChooseImageListCollectionViewCell.h"
#import "ChooseImageListViewController.h"
#import "WTImagePickerController.h"
#import "SSTextView.h"
#import "WGS84TOGCJ02.h"//精确定位
#import "GetPhotoView.h"
#import "UIAlertController+Blocks.h"
#import "GetPhotosVC.h"
#import "PhotosModel.h"
#import "XHToast.h"
#import "MLPhotoBrowserViewController.h"
@import AssetsLibrary;
@import CoreLocation;//导入框架
@interface AddTravelVC ()<CLLocationManagerDelegate, GetPhotoViewDelegate, GetPhotosVCDelegate, WTImagePickerControllerDelegate, MLPhotoBrowserViewControllerDelegate,
MLPhotoBrowserViewControllerDataSource, UINavigationControllerDelegate, UITextViewDelegate>
@property (nonatomic, strong) SSTextView *contentView;
// 管理定位
@property (nonatomic, strong) CLLocationManager * manager;
@property (nonatomic, strong) UIButton * positionButton;
@property (nonatomic, strong) TravelModel *travelModel;
@property (nonatomic, strong) LoadingView *load;

@property (nonatomic, strong)  UIImageView * positionView;
@property (nonatomic, strong) UILabel * positionLabel;
@property (nonatomic, strong) GetPhotoView *photoView;
@property (nonatomic, strong) PhotosModel *photosModel;

@end

@implementation AddTravelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initBackButton];
    [self initNavTitle:@"发游记"];
    [self initRightButtonEvent:@selector(handleComplete) title:@"完成"];
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.positionButton];
    [self.view addSubview:self.photoView];
    
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
    
    self.contentView.sd_layout.leftSpaceToView(self.view, flexibleWidth(15)).rightSpaceToView(self.view, flexibleWidth(15)).topSpaceToView(self.navView, flexibleHeight(15)).heightIs(flexibleHeight(100));
    
    self.positionButton.sd_layout.leftSpaceToView(self.view, flexibleWidth(15)).widthIs(flexibleWidth(356)).heightIs(flexibleHeight(50)).topSpaceToView(self.contentView, flexibleHeight(30));
    
    self.photoView.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).topSpaceToView(self.positionButton, flexibleHeight(10)).heightIs(flexibleWidth(345));

    
}
- (void)handleComplete {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(CallbackPhotoArray:thumbnailArray:selectIndexArray:)]) {
//        [self.delegate CallbackPhotoArray:self.selectedArrayUrl thumbnailArray:self.selectedthumbnail selectIndexArray:self.selectedIndex];
//    }
    __weak typeof(self) weakself = self;
    [self.load show];
    [self.travelModel addTravelNoteWithObejectId:OBJECTID content:self.contentView.text imagesArray:self.photosModel.photosArray.count>0?self.photosModel.photosArray:nil location:self.positionLabel.text successBlock:^{
        [XHToast showCenterWithText:@"游记发表成功"];
        [weakself.load hide];
        [weakself.navigationController popViewControllerAnimated:YES];
    }];
    
    
}

- (void)popVC {
    [self.photoView.imageCollectionView reloadData];
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

- (void)pushVC:(UIViewController *)VC {

}
- (void)showImgBrowser:(NSIndexPath *)indexPath {
    // 图片游览器
    MLPhotoBrowserViewController *photoBrowser = [[MLPhotoBrowserViewController alloc] init];
    // 淡入淡出效果
    photoBrowser.status = UIViewAnimationAnimationStatusFade;
    // 数据源/delegate
    photoBrowser.delegate = self;
    photoBrowser.dataSource = self;
    // 当前选中的值
    photoBrowser.currentIndexPath = [NSIndexPath indexPathForItem:indexPath.row inSection:0];
    // 展示控制器
    [photoBrowser showPickerVc:self];
}
- (void)ActionSheetInView:(NSIndexPath *)indexPath {
    [UIAlertController showActionSheetInViewController:self withTitle:nil message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"从相册选择", @"拍照"] popoverPresentationControllerBlock:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == 2) {
            GetPhotosVC *getPhotoVC = [[GetPhotosVC alloc] init];
            getPhotoVC.delegate = self;
            [self.navigationController pushViewController:getPhotoVC animated:YES];
        }
        if (buttonIndex == 3) {
            WTImagePickerController *vc = [[WTImagePickerController alloc] init];
            vc.delegate = self;
            [self presentViewController:vc animated:YES completion:nil];
        }
    }];

}

#pragma mark - <MLPhotoBrowserViewControllerDataSource>
- (NSInteger)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return self.photosModel.photosArray.count;
}

#pragma mark - 每个组展示什么图片,需要包装下MLPhotoBrowserPhoto
- (MLPhotoBrowserPhoto *) photoBrowser:(MLPhotoBrowserViewController *)browser photoAtIndexPath:(NSIndexPath *)indexPath{
    // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
    MLPhotoBrowserPhoto *photo = [[MLPhotoBrowserPhoto alloc] init];
    photo.photoObj = [self.photosModel.photosArray objectAtIndex:indexPath.row];
    // 缩略图
    //    UIImage *image = [UIImage imageWithData:self.datasource[indexPath.row]];
    photo.thumbImage =  nil;
    return photo;
}
#pragma mark - WTImagePickerControllerDelegate
- (void)wtimagePickerController:(WTImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[@"image"];
    [self.photosModel.photosArray addObject:image];
    [self.photosModel.indexArray addObject:[NSIndexPath indexPathForRow:-1 inSection:0]];//传一个-1占位
    [self.photoView.imageCollectionView reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)wtimagePickerControllerDidCancel:(WTImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
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


- (SSTextView *)contentView {
	if(_contentView == nil) {
		_contentView = [[SSTextView alloc] init];
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.textColor = [UIColor grayColor];
        _contentView.font = [UIFont systemFontOfSize:14];
        _contentView.placeholder = @"哟， 发一条游记吧";
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.delegate = self;
	}
	return _contentView;
}

- (UIButton *)positionButton{
    if (!_positionButton) {
        _positionButton = [[UIButton alloc]init];
        [_positionButton addTarget:self action:@selector(handlePosition) forControlEvents:UIControlEventTouchUpInside];
        _positionButton.selected = NO;
        
        self.positionView = [[UIImageView alloc]initWithFrame:flexibleFrame(CGRectMake(5, 15, 20, 20), NO)];
        self.positionView.image = IMAGE_PATH(@"未定位.png");
        
        [_positionButton addSubview:self.positionView];
        
        UILabel * positionLabel = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(30, 15,300, 20), NO)];
        positionLabel.text = @"未定位";
        self.positionLabel = positionLabel;
        positionLabel.font = [UIFont systemFontOfSize:14];
        positionLabel.textColor = [UIColor colorWithWhite:0.828 alpha:1.000];
        [_positionButton addSubview:positionLabel];
        
        _positionButton.backgroundColor = [UIColor whiteColor];
        
    }
    return _positionButton;
    
}

- (GetPhotoView *)photoView {
	if(_photoView == nil) {
		_photoView = [[GetPhotoView alloc] init];
        _photoView.delegate = self;
	}
	return _photoView;
}

- (PhotosModel *)photosModel {
    if(_photosModel == nil) {
        _photosModel = [PhotosModel sharedPhotosModel];
    }
    return _photosModel;
}

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
@end
