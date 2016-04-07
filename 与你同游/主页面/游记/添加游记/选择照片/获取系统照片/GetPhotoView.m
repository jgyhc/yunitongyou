//
//  GetPhotoView.m
//  ManJi
//
//  Created by Zgmanhui on 16/1/29.
//  Copyright © 2016年 Zgmanhui. All rights reserved.
//

#import "GetPhotoView.h"
#import "DidImageCollectionViewCell.h"
#import "GetPhotos.h"
#import "PhotosModel.h"


static NSString * const didImageCollectionViewCellIndentifier = @"DidImageCollectionViewCellIndentfier";
@interface GetPhotoView ()<UICollectionViewDataSource, UICollectionViewDelegate, DidImageCollectionViewCellDelegate>

@property (nonatomic, strong) GetPhotos *getPhotos;
@property (nonatomic, strong) PhotosModel *photosModel;
@end

@implementation GetPhotoView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.imageCollectionView];
    }
    return self;
}


#pragma mark -- DidImageCollectionViewCellDelegate
- (void)handleSelectEvent:(UIButton *)sender Cell:(DidImageCollectionViewCell *)Cell {
    NSIndexPath *indexPath = [self.imageCollectionView indexPathForCell:Cell];
    [self.photosModel.photosArray removeObjectAtIndex:indexPath.row];
    [self.photosModel.indexArray removeObjectAtIndex:indexPath.row];
    [self.imageCollectionView reloadData];
}
#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.photosModel.photosArray.count == 9) {
        return 9;
    }else {
        return self.photosModel.photosArray.count + 1;
    };
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DidImageCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:didImageCollectionViewCellIndentifier forIndexPath:indexPath];
    cell.delegate = self;
    if (indexPath.row == self.photosModel.photosArray.count) {
        cell.photoImageView.image = [UIImage imageNamed:@"添加相片"];
//        cell.photoImageView.contentMode = UIViewContentModeCenter;
        [cell.selectedButton removeFromSuperview];
        cell.contentView.layer.cornerRadius = flexibleHeight(5);
    }else {
        [cell.contentView addSubview:cell.selectedButton];
        cell.photoImageView.contentMode = UIViewContentModeScaleToFill;
        cell.photoImageView.image = self.photosModel.photosArray[indexPath.row];
        [cell.selectedButton setBackgroundImage:[UIImage imageNamed:@"删除照片"] forState:UIControlStateNormal];
    }
    
    return cell;


}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.photosModel.photosArray.count) {
//        ChoosePhotosView *CPView = [[ChoosePhotosView alloc] init];
//        CPView.nameArray = @[@"从相册选择", @"拍照"];
//        CPView.Cdelegate = self;
//        [CPView show];
        if (self.delegate &&[self.delegate respondsToSelector:@selector(ActionSheetInView:)]) {
            [self.delegate ActionSheetInView:indexPath];
        }
    }else {
        if (self.delegate &&[self.delegate respondsToSelector:@selector(showImgBrowser:)]) {
            [self.delegate showImgBrowser:indexPath];
        }
    }
}


#pragma mark -- getter
- (UICollectionView *)imageCollectionView
{
    if (!_imageCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //配置属性
        //配置最小的行距
        layout.minimumLineSpacing = flexibleHeight(7);
        //配置最小间距
        layout.minimumInteritemSpacing = flexibleHeight(7);
        //cell大小
        layout.itemSize = flexibleSize(CGSizeMake(100, 100), YES);
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:flexibleFrame(CGRectMake(15, 5, 345, 345), NO) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.265];
        [collectionView registerClass:[DidImageCollectionViewCell class] forCellWithReuseIdentifier:didImageCollectionViewCellIndentifier];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        _imageCollectionView = collectionView;
    }
    return _imageCollectionView;
}


- (GetPhotos *)getPhotos {
	if(_getPhotos == nil) {
		_getPhotos = [[GetPhotos alloc] init];
	}
	return _getPhotos;
}

- (PhotosModel *)photosModel {
	if(_photosModel == nil) {
		_photosModel = [PhotosModel sharedPhotosModel];
	}
	return _photosModel;
}

@end
