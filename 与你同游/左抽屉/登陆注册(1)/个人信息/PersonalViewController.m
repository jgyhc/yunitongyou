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

@property (nonatomic,strong) UILabel * nameLabel;
@property (nonatomic,strong) UIImageView * sexImageView;

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
//    [self.user removeObserver:self forKeyPath:@"getUserData"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [self.user addObserver:self forKeyPath:@"addUserinfoResult" options:NSKeyValueObservingOptionNew context:nil];
//      [self.user addObserver:self forKeyPath:@"getUserData" options:NSKeyValueObservingOptionNew context:nil];
//    [self.user getwithObjectId:OBJECTID];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initializedApperance];
       
}

- (void)initializedApperance{
    self.hintArray = @[@"昵称", @"性别", @"年龄", @"个性签名"];
//    NSString * nameStr;
//    NSString * sexStr;
//    NSString * ageStr;
//    NSString * signatureStr;
    NSString * ageStr = [NSString stringWithFormat:@"%@", [self.user.getUserData objectForKey:@"age"]];
//    if ([self.user.getUserData objectForKey:@"age"]) {
//        <#statements#>
//    }
    
    
    
    NSArray * array = @[[self.user.getUserData objectForKey:@"username"], [self.user.getUserData objectForKey:@"sex"], ageStr, [self.user.getUserData objectForKey:@"IndividualitySignature"]];
//    NSArray * array = @[@"提莫",@"女",@"21岁",@"岁月静好，我要你知道，在这个世界上，总有一个人是会永远等着你的。无论什么时候，无论在什么地方，总会有那么一个人。。。"];
    
    

    [self.view addSubview:self.backView];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.saveButton];
    [self.view addSubview:self.headPortrait];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.sexImageView];
    
    

  
    
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
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"修改成功！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        
        [alertController addAction:sureAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
//    if ([keyPath isEqualToString:@"getUserData"]) {
//        if ([self.user.getUserData objectForKey:@"username"]) {
//            [self.userName setTitle:[self.user.getUserData objectForKey:@"username"]  forState:UIControlStateNormal];
//            self.userName.userInteractionEnabled = NO;
//        }else {
//            [self.userName setTitle:[self.user.getUserData objectForKey:@"phoneNumber"]  forState:UIControlStateNormal];
//            self.userName.userInteractionEnabled = NO;
//        }
//        if ([self.user.getUserData objectForKey:@"head_portraits"]) {
//            //获取URL
//            NSURL * imageUrl = [NSURL URLWithString:[self.user.getUserData objectForKey:@"head_portraits"]];
//            [self.icon sd_setImageWithURL:imageUrl];
//            self.icon.clipsToBounds = YES;
//            
//        }
//    }

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
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        self.headPortrait.image = info[UIImagePickerControllerOriginalImage];
        self.topView.image = info[UIImagePickerControllerOriginalImage];
        self.saveButton.hidden = NO;
        [self.sharedView handlePress];
        [self dismissViewControllerAnimated:YES completion:nil];

    }
    else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        //保存到相册
        UIImageWriteToSavedPhotosAlbum(info[UIImagePickerControllerEditedImage], nil, nil, nil);
        //获取编辑后的图片
        self.headPortrait.image = info[UIImagePickerControllerEditedImage];
        self.topView.image = info[UIImagePickerControllerEditedImage];
        self.saveButton.hidden = NO;
        [self.sharedView handlePress];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.sharedView handlePress];
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)handleBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)handleSave{

    UITextView * username = (UITextView *)[self.backView viewWithTag:TEXTVIEW_TAG];
    UITextView * sex = (UITextView *)[self.backView viewWithTag:TEXTVIEW_TAG + 1];
    UITextView * age = (UITextView *)[self.backView viewWithTag:TEXTVIEW_TAG + 2];
    UITextView * signature = (UITextView *)[self.backView viewWithTag:TEXTVIEW_TAG + 3];
    NSNumber *ageNumber = [NSNumber numberWithInteger:[age.text integerValue]];
    NSData *imageData = UIImagePNGRepresentation(self.headPortrait.image);
    //提交修改数据
    [self.user changeUserinfoWithObjectId:OBJECTID userName:username.text head_portraits:imageData sex:sex.text age:ageNumber IndividualitySignature:signature.text];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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


- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = ({
          
            UILabel * nameLabel = [[UILabel alloc] initWithFrame:flexibleFrame(CGRectMake(138,190,20,20), NO) ];//这个frame是初设的，没关系，后面还会重新设置其size。
            nameLabel.textColor = [UIColor colorWithWhite:0.098 alpha:1.000];
            nameLabel.text = [self.user.userData objectForKey:@"userName"];
            nameLabel.font = [UIFont systemFontOfSize:16];
            nameLabel.textAlignment = NSTextAlignmentCenter;
            CGSize labelsize = [nameLabel.text  sizeWithAttributes:[NSDictionary dictionaryWithObject:nameLabel.font forKey:NSFontAttributeName]];
//            [nameLabel setFrame:flexibleFrame(CGRectMake(138,190, labelsize.width, 20), NO) ];
            nameLabel.bounds = flexibleFrame(CGRectMake(0, 0, labelsize.width, 20), NO);
            nameLabel.center = flexibleCenter(CGPointMake(WIDTH / 2, 200), NO);
            nameLabel;
        });
    }
    return _nameLabel;
}

- (UIImageView *)sexImageView{
    if (!_sexImageView) {
        _sexImageView = ({
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:flexibleFrame(CGRectMake(self.nameLabel.frame.origin.x + self.nameLabel.frame.size.width + 5, 185, 30, 30), NO)];
            
            imageView.image = IMAGE_PATH([[self.user.userData objectForKey:@"sex"] stringByAppendingString:@".png"] );
            imageView;
            
        });
    }
    return _sexImageView;
}



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
            imageView.clipsToBounds = YES;
            NSURL * imageUrl = [NSURL URLWithString:[self.user.getUserData objectForKey:@"head_portraits"]];
            [imageView sd_setImageWithURL:imageUrl];
//            imageView.image = IMAGE_PATH(@"测试头像1.png");
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
            customBackgournd.image = IMAGE_PATH(@"测试头像1.png");
        
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
