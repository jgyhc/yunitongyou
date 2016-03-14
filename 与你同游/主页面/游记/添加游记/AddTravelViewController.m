//
//  AddTravelViewController.m
//  与你同游
//
//  Created by rimi on 15/11/7.
//  Copyright © 2015年 LiuCong. All rights reserved.
//

#import "AddTravelViewController.h"
#import "UserModel.h"
#import "LoadingView.h"
#import "ChooseImageListCollectionViewCell.h"
#import "ChooseImageListViewController.h"
@import AssetsLibrary;
#define  BUTTON_TAG 200
static NSString * const kCollectionViewCellIndentifier = @"ChooseImageListViewCellIndentfier";

@interface AddTravelViewController ()<UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate,UIImagePickerControllerDelegate,ChooseImageListViewControllerDelegate, ChooseImageListCollectionViewCellDelegate>
@property (nonatomic, strong) UserModel *travel;
@property (nonatomic, strong) LoadingView *load;
@property (nonatomic, strong) UITextView *contentView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *popView;
@property (nonatomic, strong) UILabel * positionLabel;
@property (nonatomic, strong) UIButton * positionButton;
@property (nonatomic, assign) CGFloat collectionViewHight;
@property (nonatomic, assign) CGFloat collectionViewY;
@property (nonatomic, strong) NSMutableArray *indexPathArray;
@property (nonatomic, strong) NSMutableArray *selectedArrayUrl;
@end

@implementation AddTravelViewController

- (void)dealloc {
    [self.travel removeObserver:self forKeyPath:@"addTravelResult"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionViewY = 125;
    [self initUserDataSource];
    [self initializedApperance];
    [self.travel addObserver:self forKeyPath:@"addTravelResult" options:NSKeyValueObservingOptionNew context:nil];
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
  
}
#pragma mark -- 完成按钮事件
- (void)handleComplete {
    NSMutableArray *imageArray = [NSMutableArray array];
    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    if (self.selectedArrayUrl.count == 0) {
//        [self.travel addTravelWithObejectId:OBJECTID sightSpot:@[self.positionLabel.text] imagesArray:nil content:self.contentView.text];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        return;
    }
    for (int i = 0; i < self.selectedArrayUrl.count; i ++) {
        [assetLibrary assetForURL:self.selectedArrayUrl[i] resultBlock:^(ALAsset *asset) {
            UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            [imageArray addObject:image];
            if (i == self.selectedArrayUrl.count - 1) {
                NSLog(@"%@", OBJECTID);
//                [self.travel addTravelWithObejectId:OBJECTID sightSpot:@[self.positionLabel.text] imagesArray:imageArray content:self.contentView.text];
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            }
        } failureBlock:^(NSError *error) {
            NSLog(@"%@", error);
        }];
    }
}
#pragma mark --警告框里确定按钮的处理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    UITextField *tf=[alertView textFieldAtIndex:0];
    NSLog(@"%@", tf.text);
    if (buttonIndex == 0) {
        self.positionLabel.text = tf.text;
    }
}

#pragma mark -- KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"addTravelResult"]) {
//        if ([self.travel.addTravelResult isEqualToString:@"YES"]) {
//            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"发送成功！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
//        }
        
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
#pragma mark -- 弹出框按钮处理事件
- (void)handlePopEvent:(UIButton *)sender {
    if (sender.tag == BUTTON_TAG) {
        ChooseImageListViewController *CLVC = [[ChooseImageListViewController alloc] init];
        [self.navigationController pushViewController:CLVC animated:NO];
        CLVC.selectedIndex = self.indexPathArray;
        CLVC.delegate = self;
        [UIView animateWithDuration:0.5 animations:^{
            self.popView.frame = flexibleFrame(CGRectMake(10, 667, 355, 140), NO);
        }];
        [self.popView removeFromSuperview];
    }
    else if (sender.tag == BUTTON_TAG + 1){
         [self handleTakePhoto];

    }
    else{
        [UIView animateWithDuration:0.5 animations:^{
            self.popView.frame = flexibleFrame(CGRectMake(10, 667, 355, 140), NO);
        }];
        [self.popView removeFromSuperview];
    }
    
}

//照相机
- (void)handleTakePhoto{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:nil];
        
        
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"不可使用摄像功能"
                              message:@""
                              delegate:nil
                              cancelButtonTitle:@"OK!"
                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark --UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage * image;

    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        //保存到相册
        UIImageWriteToSavedPhotosAlbum(info[UIImagePickerControllerEditedImage], nil, nil, nil);
        //获取编辑后的图片
        image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    }
    
    if ( image )
    {
        //压缩图片
        //横屏
        CGFloat width=0.f;
        CGFloat height=0.f;
        if (image.size.width>200.0f)
        {
            width=200.0f;
        }
        else width=image.size.width;
        
        if (image.size.height>300.0f)
        {
            height=300.0f;
        }
        else height=image.size.height;
        
        image = [self imageWithImage:image scaledToSize:CGSizeMake(width, height)];
        [self.dataSource addObject:image];
        [self initUserDataSource];
        [self.collectionView reloadData];
        [UIView animateWithDuration:0.5 animations:^{
            self.popView.frame = flexibleFrame(CGRectMake(10, 667, 355, 140), NO);
        }];
        [self.popView removeFromSuperview];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [UIView animateWithDuration:0.5 animations:^{
        self.popView.frame = flexibleFrame(CGRectMake(10, 667, 355, 140), NO);
    }];
    [self.popView removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
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
#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource.count < 9) {
        if (indexPath.row == self.dataSource.count) {
            [self.view addSubview:self.popView];
            [UIView animateWithDuration:0.5 animations:^{
                self.popView.frame = flexibleFrame(CGRectMake(10, 527, 355,140), NO);
            }];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}
#pragma mark -- ChooseImageListViewControllerDelegate
- (void)CallbackPhotoArray:(NSMutableArray *)photoUrl thumbnailArray:(NSMutableArray *)thumbnailArray selectIndexArray:(NSMutableArray *)selectIndexArray {
    self.dataSource = thumbnailArray;
    self.indexPathArray = selectIndexArray;
    self.selectedArrayUrl = photoUrl;
    [self initUserDataSource];
    [self.collectionView reloadData];
    
}
#pragma mark -- 选择地点
- (void)handlePosition{

}

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

#pragma mark -- UITextViewDelegate 方法
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
- (UserModel *)travel {
    if (!_travel) {
        _travel = [[UserModel alloc] init];
    }
    return _travel;
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
        UIImageView * positionView = [[UIImageView alloc]initWithFrame:flexibleFrame(CGRectMake(5, 15, 20, 20), NO)];
        positionView.image = IMAGE_PATH(@"未定位.png");
        [_positionButton addSubview:positionView];
        
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

-(UIView *)popView {
    if (!_popView) {
        _popView = ({
            UIView * view = [[UIView alloc]initWithFrame:flexibleFrame(CGRectMake(10, 667, 355, 140), NO)];
            NSArray * array = @[@"从图库中选择",@"拍照",@"取消"];
            for (int i = 0; i < 3; i ++) {
                UIButton * button = [[UIButton alloc]initWithFrame:flexibleFrame(CGRectMake(0, i * 40, 355, 40), NO)];
                if (i == 2) {
                    button.frame = flexibleFrame(CGRectMake(0, 90, 355, 40), NO);
                }
                button.layer.cornerRadius = 5;
                button.backgroundColor = [UIColor colorWithRed:0.439 green:0.957 blue:0.788 alpha:1.000];
                button.tag = BUTTON_TAG + i;
                [button setTitle:array[i] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(handlePopEvent:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:button];
                
            }
            UIView * lineView = [[UIView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 40, 355, 0.5),NO)];
            lineView.backgroundColor = [UIColor whiteColor];
            [view addSubview:lineView];
            view.backgroundColor = [UIColor clearColor];
            view;
        });
    }
    return _popView;
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
