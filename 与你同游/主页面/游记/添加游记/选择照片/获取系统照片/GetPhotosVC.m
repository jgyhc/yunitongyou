//
//  GetPhotosVC.m
//  ManJi
//
//  Created by Zgmanhui on 16/1/29.
//  Copyright © 2016年 Zgmanhui. All rights reserved.
//

#import "GetPhotosVC.h"
#import "GetPhotos.h"
#import "MLPhotoBrowserAssets.h"
#import "MLPhotoBrowserViewController.h"
#import "DidImageCollectionViewCell.h"
#import "PhotosModel.h"

static NSString * const didImageCollectionViewCellIndentifier = @"DidImageCollectionViewCellIndentfier";
#define MAX_Number 9
@interface GetPhotosVC ()<UICollectionViewDelegate, UICollectionViewDataSource, DidImageCollectionViewCellDelegate, MLPhotoBrowserViewControllerDelegate, MLPhotoBrowserViewControllerDataSource>
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) GetPhotos *getPhotos;
@property (nonatomic, strong) NSArray *photosArray;
@property (nonatomic, assign) NSInteger number;
//@property (nonatomic, strong) NSMutableArray *assetArray;
@property (nonatomic, strong) PhotosModel *photosModels;
@end

@implementation GetPhotosVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavTitle:@"选择照片"];
    [self initBackButton];
    _number = self.photosModels.photosArray.count;
    [self.view addSubview:self.collectionView];
    [self.navView addSubview:self.sureButton];
    __weak typeof(self) weakSelf = self;
    self.getPhotos.myBlock = ^(NSArray *photos) {
        weakSelf.photosArray = photos;
        [weakSelf.collectionView reloadData];
    };
    [self.getPhotos getAllPhotos];
}



//确认按钮
- (void)handleSureEvent {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(popVC)]) {
        [self.delegate popVC];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleSelectEvent:(UIButton *)sender Cell:(DidImageCollectionViewCell *)Cell {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:Cell];
    if (sender.selected == NO) {
        if (_number < MAX_Number) {
            sender.selected = YES;
            [self.photosModels.photosArray addObject:self.photosArray[indexPath.row]];
            [self.photosModels.indexArray addObject:indexPath];
            _number ++;
            return;
        }
        [self message:[NSString stringWithFormat:@"照片不能超过%d张", MAX_Number]];
    }else {
        sender.selected = NO;
        for (int i = 0; i < self.photosModels.indexArray.count; i ++) {
            NSIndexPath *index = self.photosModels.indexArray[i];
            if (index.row == indexPath.row) {
                [self.photosModels.photosArray removeObjectAtIndex:i];
            }
        }
        [self.photosModels.indexArray removeObject:indexPath];
        _number --;
    }

}


#pragma mark --UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photosArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DidImageCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:didImageCollectionViewCellIndentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.photoImageView.image = self.photosArray[indexPath.row];

    for (int i = 0; i < self.photosModels.indexArray.count; i ++) {
        NSIndexPath *index = self.photosModels.indexArray[i];
        if (indexPath.row == index.row) {
            cell.selectedButton.selected = YES;
        }
    }
    
    
    return cell;
}
#pragma mark --UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
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

#pragma mark - <MLPhotoBrowserViewControllerDataSource>
- (NSInteger)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return self.photosArray.count;
}

#pragma mark - 每个组展示什么图片,需要包装下MLPhotoBrowserPhoto
- (MLPhotoBrowserPhoto *) photoBrowser:(MLPhotoBrowserViewController *)browser photoAtIndexPath:(NSIndexPath *)indexPath{
    // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
    MLPhotoBrowserPhoto *photo = [[MLPhotoBrowserPhoto alloc] init];
    photo.photoObj = [self.photosArray objectAtIndex:indexPath.row];
    // 缩略图
    //    UIImage *image = [UIImage imageWithData:self.datasource[indexPath.row]];
    photo.thumbImage =  nil;
    
    return photo;
}


#pragma mark -- getter
- (UICollectionView *)collectionView {
    if(_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = flexibleHeight(7);
        layout.minimumInteritemSpacing = flexibleHeight(7);
        layout.itemSize = flexibleSize(CGSizeMake(100, 100), YES);
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:flexibleFrame(CGRectMake(15, 64, 345, 667 - 64), NO) collectionViewLayout:layout];
        [collectionView registerClass:[DidImageCollectionViewCell class] forCellWithReuseIdentifier:didImageCollectionViewCellIndentifier];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        _collectionView = collectionView;
    }
    return _collectionView;
}
- (UIButton *)sureButton {
    if(_sureButton == nil) {
        _sureButton = [[UIButton alloc] init];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(handleSureEvent) forControlEvents:UIControlEventTouchUpInside];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:flexibleHeight(14)];
        _sureButton.frame = flexibleFrame(CGRectMake(310, 35, 65, 15), NO);
    }
    return _sureButton;
}

- (GetPhotos *)getPhotos {
	if(_getPhotos == nil) {
		_getPhotos = [[GetPhotos alloc] init];
	}
	return _getPhotos;
}
- (NSArray *)photosArray {
	if(_photosArray == nil) {
		_photosArray = [[NSArray alloc] init];
	}
	return _photosArray;
}

- (PhotosModel *)photosModels {
	if(_photosModels == nil) {
		_photosModels = [PhotosModel sharedPhotosModel];
	}
	return _photosModels;
}

@end
