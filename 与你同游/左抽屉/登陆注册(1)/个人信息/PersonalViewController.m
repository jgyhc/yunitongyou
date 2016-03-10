//
//  TestViewController.m
//  与你同游
//
//  Created by rimi on 15/10/24.
//  Copyright © 2015年 LiuCong. All rights reserved.
//

#import "PersonalViewController.h"
#import "SharedView.h"

#import "LoadingView.h"
#import "UIImageView+WebCache.h"

#define TEXTVIEW_TAG 100
#define BUTTON_TAG 200


@interface PersonalViewController ()<UITextFieldDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIButton * backButton;//返回按钮
@property (nonatomic, strong) UIButton * saveButton;//保存按钮
@property (nonatomic, strong) NSArray * hintArray;//提示文字

@property (nonatomic,strong) UIImageView * topView;
@property (nonatomic,strong) UIView * backView;

@property (nonatomic, assign) CGFloat keyboardHeight;//键盘高度
@property (nonatomic, assign) NSTimeInterval duration;//键盘出现时间
@property (nonatomic, strong) SharedView * sharedView;
@property (nonatomic, strong) LoadingView *load;


@end

@implementation PersonalViewController

- (void)dealloc{
    [self.user removeObserver:self forKeyPath:@"addUserinfoResult"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [self.user addObserver:self forKeyPath:@"addUserinfoResult" options:NSKeyValueObservingOptionNew context:nil];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initializedApperance];
       
}

- (void)initializedApperance{
    self.hintArray = @[@"昵称", @"性别", @"年龄", @"个性签名"];
    NSArray * array = @[[self.user.getUserData objectForKey:@"username"], [self.user.getUserData objectForKey:@"sex"],[self.user.getUserData objectForKey:@"age"], [self.user.getUserData objectForKey:@"IndividualitySignature"]];


    [self.view addSubview:self.backView];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.saveButton];
    [self.view addSubview:self.headPortrait];
    
    for (int i = 0; i < self.hintArray.count; i ++) {
        
        UILabel * label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(20, 20 + i * 60, 80, 20), NO)];
        label.text = self.hintArray[i];
        label.textColor = [UIColor colorWithWhite:0.298 alpha:1.000];
        [self.backView addSubview:label];
        
        
        UITextView * textView = [[UITextView alloc]init];
        if (i < self.hintArray.count - 1) {
            textView.frame = flexibleFrame(CGRectMake(100,12 + i * 60, 275, 30), NO);
            
        }
        else{
            textView.frame = flexibleFrame(CGRectMake(50,230,290,160), NO);
        }
        textView.font = [UIFont systemFontOfSize:16];
        textView.delegate = self;
        textView.textColor = [UIColor colorWithWhite:0.498 alpha:1.000];
        textView.text = array[i];
        textView.tag = TEXTVIEW_TAG + i;
        textView.backgroundColor = [UIColor clearColor];
        [self.backView addSubview:textView];
    }

    for (int i = 0; i < 3; i ++) {
        UIButton * button = (UIButton *)[self.sharedView viewWithTag:200 + i];
        [button addTarget:self action:@selector(handleSelecte:) forControlEvents:UIControlEventTouchUpInside];
    }


}
#pragma mark -- KVO 
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"addUserinfoResult"]) {
//        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"修改成功！" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//            
//        }];
//        
//        [alertController addAction:sureAction];
//        
//        [self presentViewController:alertController animated:YES completion:nil];
//        [self dismissViewControllerAnimated:YES completion:nil];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}


#pragma mark --相片导入方法

- (void)handleGesture{
    [self.view addSubview:self.sharedView.maskButton];
    [self.view addSubview:self.sharedView.selectView];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.sharedView.selectView.frame = flexibleFrame(CGRectMake(10, 527, 355, 140), NO);
    }];
}

//选择相片或拍照
- (void)handleSelecte:(UIButton *)sender{
    if (sender.tag == BUTTON_TAG) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"访问图片库错误"
                                  message:@""
                                  delegate:nil
                                  cancelButtonTitle:@"OK!"
                                  otherButtonTitles:nil];
            [alert show];
        }
    

    }
    else if (sender.tag == BUTTON_TAG + 1){
        [self handleTakePhoto];
    }
    else{
        
        [self.sharedView handlePress];
        
    }
}


//照相机
- (void)handleTakePhoto{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        //前置摄像头
        //    picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        //拍照模式
//        picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        picker.delegate = self;
        picker.allowsEditing = YES;//设置可编辑
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
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
    else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
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
        self.headPortrait.image = image;
        self.topView.image = image;
        self.saveButton.hidden = NO;
        [self.sharedView handlePress];
        [self dismissViewControllerAnimated:YES completion:nil];
     }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.sharedView handlePress];
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

- (void)handleBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)handleSave{
    UITextView * username = (UITextView *)[self.backView viewWithTag:TEXTVIEW_TAG];
    UITextView * sex = (UITextView *)[self.backView viewWithTag:TEXTVIEW_TAG + 1];
    UITextView * age = (UITextView *)[self.backView viewWithTag:TEXTVIEW_TAG + 2];
    UITextView * signature = (UITextView *)[self.backView viewWithTag:TEXTVIEW_TAG + 3];

    //提交修改数据
    [self.user changeUserinfoWithObjectId:OBJECTID userName:username.text head_portraits: UIImagePNGRepresentation(self.headPortrait.image) sex:sex.text age:age.text IndividualitySignature:signature.text];

}

#pragma mark --键盘通知
- (void)keyboardWillShow:(NSNotification *)notif{
    CGRect keyboardRect = [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardHeight = keyboardRect.size.height;
    self.duration = [notif.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
}

#pragma mark --UITextFieldDelegate,UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    CGFloat interval = flexibleHeight(HEIGHT) - 250 -(textView.frame.origin.y + textView.frame.size.height);
    if (self.keyboardHeight > interval) {
        [UIView animateWithDuration:self.duration animations:^{
            self.backView.frame = flexibleFrame(CGRectMake(0, 250 - (self.keyboardHeight - interval),WIDTH,HEIGHT - 250 ), NO);
        }];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    [UIView animateWithDuration:self.duration animations:^{
        self.backView.frame = flexibleFrame(CGRectMake(0,250,WIDTH,HEIGHT - 250), NO);
    }];
}

- (void)textViewDidChange:(UITextView *)textView{
    self.saveButton.hidden = NO;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


#pragma mark --lazy loading

- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = ({
            UIButton * button = [[UIButton alloc]initWithFrame:flexibleFrame(CGRectMake(15, 30, 20, 20), NO)];
            [button setImage:IMAGE_PATH(@"向下箭头.png") forState:UIControlStateNormal];
            [button addTarget:self action:@selector(handleBack) forControlEvents:UIControlEventTouchUpInside];
            button;
            
        });
    }
    return _backButton;
}

- (UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton = ({
            UIButton * button = [[UIButton alloc]initWithFrame:flexibleFrame(CGRectMake(320, 30, 40, 20), NO)];
            
            [button setTitle:@"保存" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(handleSave) forControlEvents:UIControlEventTouchUpInside];
            button.hidden = YES;
            button;
            
        });
    }
    return _saveButton;
}

- (UIImageView *)headPortrait{
    if (!_headPortrait) {
        _headPortrait = ({
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:flexibleFrame(CGRectMake(147.5, 100, 80, 80), NO)];
            
            imageView.layer.cornerRadius = 0.5 * CGRectGetWidth(imageView.bounds);
            
            NSString * imageString =[self.user.getUserData objectForKey:@"head_portraits"];
            if (imageString.length > 0) {
                NSURL * imageUrl = [NSURL URLWithString:[self.user.getUserData objectForKey:@"head_portraits"]];
                [imageView sd_setImageWithURL:imageUrl];
            }
            else{
                imageView.image = IMAGE_PATH(@"测试头像1.png");
            }
            imageView.clipsToBounds = YES;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture)];
            [imageView addGestureRecognizer:tap];
            imageView.userInteractionEnabled = YES;
            imageView;
        });
    }
    return _headPortrait;
}



- (SharedView *)sharedView{
    if (!_sharedView) {
        _sharedView = [SharedView new];
    }
    return _sharedView;
}

- (UserModel *)user {
    if (!_user) {
        _user = [UserModel alloc];
    }
    return _user;
}

- (UIImageView *)topView {
    if (!_topView) {
        _topView = ({
            UIImageView *customBackgournd = [[UIImageView alloc] initWithFrame:flexibleFrame(CGRectMake(0, 0, 375, 250), NO)];
            NSString * imageString =[self.user.getUserData objectForKey:@"head_portraits"];
            if (imageString.length > 0) {
                NSURL * imageUrl = [NSURL URLWithString:[self.user.getUserData objectForKey:@"head_portraits"]];
                [customBackgournd sd_setImageWithURL:imageUrl];
            }
            else{
                customBackgournd.image = IMAGE_PATH(@"测试头像1.png");
            }
            UIVisualEffectView *visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
            visualEfView.frame = flexibleFrame(CGRectMake(0, 0, 375, 250), NO);
            visualEfView.alpha = 0.9;
            [customBackgournd addSubview:visualEfView];
            customBackgournd;
        });
    }
    return _topView;
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 250, WIDTH, HEIGHT - 250), NO)];
        _backView.backgroundColor = [UIColor clearColor];
    }
    return _backView;
}

@end
