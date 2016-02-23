//
//  ChooseImageListViewController.m
//  与你同游
//
//  Created by rimi on 15/11/6.
//  Copyright © 2015年 LiuCong. All rights reserved.
//

#import "ChooseImageListViewController.h"
#import "ChooseImageListCollectionViewCell.h"
#import "ReloadImagesFromLibrary.h"
#import "ImageView.h"
@import AssetsLibrary;
static NSString * const kCollectionViewCellIndentifier = @"ChooseImageListViewCellIndentfier";
static NSString * const kCollectionViewHeaderIndentifier = @"ChooseImageListViewHeaderIndentfier";
static NSString * const kCollectionViewFooterIndentifier = @"ChooseImageListViewFooterIndentfier";
@interface ChooseImageListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, ChooseImageListCollectionViewCellDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, assign) NSInteger photoNumber;
@property (nonatomic, strong) NSMutableArray *selectedArrayUrl;
@property (nonatomic, strong) NSMutableArray *selectedthumbnail;

@end

@implementation ChooseImageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserDataSource];
    [self initUserInterface];
}
- (void)initUserDataSource {
    ReloadImagesFromLibrary *reloadImages = [[ReloadImagesFromLibrary alloc] init];
    [reloadImages reloadImagesFromLibrary:^(NSMutableArray *imagesArray, NSMutableArray *urlArray) {
        self.datasource = imagesArray;
        self.imagesArray = urlArray;
        for (int i = 0; i < self.selectedIndex.count; i ++) {
            NSIndexPath *indexPath = self.selectedIndex[i];
            [self.selectedArrayUrl addObject:self.imagesArray[indexPath.row]];
            [self.selectedthumbnail addObject:self.datasource[indexPath.row]];
        }
        self.photoNumber = self.selectedIndex.count;
        [self.collectionView reloadData];
    }];
    
    
    
}
- (void)initUserInterface {
    self.photoNumber = 0;
    [self initBackButton];
    [self initNavTitle:@"选择照片"];
    [self initRightButtonEvent:@selector(handleComplete) title:@"完成"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];

}
- (void)handleComplete {
    if (self.delegate && [self.delegate respondsToSelector:@selector(CallbackPhotoArray:thumbnailArray:selectIndexArray:)]) {
        [self.delegate CallbackPhotoArray:self.selectedArrayUrl thumbnailArray:self.selectedthumbnail selectIndexArray:self.selectedIndex];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasource.count;

}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //1 取出cell
    ChooseImageListCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIndentifier forIndexPath:indexPath];
    //数据关联
    cell.delegate = self;
    for (int i = 0; i < self.selectedIndex.count; i ++) {
        if (indexPath == self.selectedIndex[i]) {
            cell.selectedButton.selected = YES;
        }
    }
    cell.photoImageView.image = [UIImage imageWithData:self.datasource[indexPath.row]];
    cell.backgroundColor = [UIColor colorWithRed:1.000 green:0.625 blue:0.922 alpha:1.000];
    return cell;
}
#pragma mark --ChooseImageListCollectionViewCellDelegate
- (void)cell:(ChooseImageListCollectionViewCell *)cell clickButtonDidPressed:(UIButton *)sender {
    if (sender.selected == NO) {
        if (self.photoNumber >= 9) {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"最多选择九张" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alertController addAction:sureAction];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }
    }
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        self.photoNumber ++;
        [self.selectedArrayUrl addObject:self.imagesArray[indexPath.row]];
        [self.selectedthumbnail addObject:self.datasource[indexPath.row]];
        [self.selectedIndex addObject:indexPath];
    }else {
        self.photoNumber --;
        NSInteger count = self.selectedIndex.count;
        for (int i = 0; i < count; i ++) {
            NSIndexPath *indexPath1 = self.selectedIndex[i];
            if (indexPath1.row == indexPath.row) {
                [self.selectedArrayUrl removeObjectAtIndex:i];
                [self.selectedthumbnail removeObjectAtIndex:i];
                [self.selectedIndex removeObjectAtIndex:i];
                break;
            }
        }
        
    }

}
#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    [assetLibrary assetForURL:self.imagesArray[indexPath.row] resultBlock:^(ALAsset *asset) {
        ImageView *imageView = [[ImageView alloc] init];
        imageView.view.frame = flexibleFrame(CGRectMake(0, 0, WIDTH, HEIGHT), NO);
        UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [imageView ShowImage:image];
        [self presentViewController:imageView animated:NO completion:nil];
    } failureBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark -- getter 
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
            //配置头部尾部大小
            layout.headerReferenceSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 0);
            layout.footerReferenceSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 0);
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:flexibleFrame(CGRectMake(10, 64, 355, 564), NO) collectionViewLayout:layout];
            [collectionView registerClass:[ChooseImageListCollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellIndentifier];
            [collectionView registerClass:[ChooseImageListCollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionViewHeaderIndentifier];
            [collectionView registerClass:[ChooseImageListCollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter  withReuseIdentifier:kCollectionViewFooterIndentifier];
            collectionView.backgroundColor = [UIColor whiteColor];
            collectionView.showsVerticalScrollIndicator = NO;
            collectionView.delegate = self;
            collectionView.dataSource = self;
            collectionView;
        });
    }
    return _collectionView;
}

- (NSMutableArray *)imagesArray {
    if (!_imagesArray) {
        _imagesArray = [NSMutableArray array];
    }
    return _imagesArray;
}

- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (NSMutableArray *)selectedArrayUrl {
    if (!_selectedArrayUrl) {
        _selectedArrayUrl = [NSMutableArray array];
    }
    return _selectedArrayUrl;
}

- (NSMutableArray *)selectedthumbnail {
    if (!_selectedthumbnail) {
        _selectedthumbnail = [NSMutableArray array];
    }
    return _selectedthumbnail;

}

- (NSMutableArray *)selectedIndex {
    if (!_selectedIndex) {
        _selectedIndex  = [NSMutableArray array];
    }
    return _selectedIndex;
}
@end
