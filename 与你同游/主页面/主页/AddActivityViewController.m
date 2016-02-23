//
//  AddActivityViewController.m
//  与你同游
//
//  Created by rimi on 15/10/19.
//  Copyright © 2015年 LiuCong. All rights reserved.
//

#import "AddActivityViewController.h"
#import "SharedView.h"
#import "SearchPopWindow.h"
#import "CalledModel.h"
#import "LoadingView.h"

#define BUTTON_TAG 200
#define TEXTFIELD_TAG  300

@interface AddActivityViewController ()<UITextFieldDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong ) UIView          * backView;//全部控件及视图加载此view上，便于做动画
@property (nonatomic, strong ) SharedView      * sharedView;
@property (nonatomic, assign ) CGFloat         keyboardHeight;//键盘高度
@property (nonatomic, assign ) NSTimeInterval  duration;//键盘出现时间
@property (nonatomic, strong ) UILabel         * label;
@property (nonatomic, strong ) SearchPopWindow * timePopWindow;//弹出日期选择
@property (nonatomic, strong ) CalledModel     *addActivities;
@property (nonatomic, strong) LoadingView *load;

@end

@implementation AddActivityViewController

- (void)dealloc{
    [self.addActivities removeObserver:self forKeyPath:@"addActivitiesResult"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   self.view.backgroundColor = [UIColor colorWithWhite:0.942 alpha:1.000];
   [self initializedApperance];
    
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

    [self.addActivities addObserver:self forKeyPath:@"addActivitiesResult" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)initializedApperance{
    [self initBackButton];
    [self initNavTitle:@"发起活动"];
    [self initRightButtonEvent:@selector(handleLaunch) title:@"发起"];
    
    [self.view insertSubview:self.backView belowSubview:self.navView];
    
    [self inithintName];
    [self initInputField];
    UITextField *destinationTextField = (UITextField *)[self.backView viewWithTag:TEXTFIELD_TAG + 1];
    destinationTextField.text = self.destinationString;
    //页面加载动画
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.2 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        
        self.backView.frame = flexibleFrame(CGRectMake(0, 64, 375, 613), NO);
        
    } completion:nil];
}

//添加图片及文字
- (void)inithintName{
    
    NSArray * ImageArray = @[@"lubiao.png",@"mubiao.png",@"shijian.png",@"ren2.png",@"biaoqian.png",@"jianjie.png"];
    NSArray * hintArray = @[@"出发地",@"目的地",@"起止时间",@"人数限制",@"标签(可选)",@"旅游简介"];
    
    for (int i = 0; i < ImageArray.count; i ++) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:flexibleFrame(CGRectMake(20, 10 + i * 80, 25, 25), NO)];
        imageView.image = IMAGE_PATH(ImageArray[i]);
        
        
        UILabel * label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(55, 15 + i * 80, 100, 20), NO)];
        label.text = hintArray[i];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:16];
        
        if (i == 0) {
            imageView.frame = flexibleFrame(CGRectMake(20, 10, 30, 30), NO);
            
        }
        
        [self.backView addSubview:imageView];
        [self.backView addSubview:label];
    }
    
}
//添加标签按钮和输入框
- (void)initInputField{
    NSArray * array = @[@"自驾",@"吃喝",@"山水",@"跟团"];
    NSArray * placeholderArray = @[@"请填写出发地",@"请填写目的地(可有多个)",@"出发时间",@"结束时间",@"请填写陪伴你的人数"];
    
    for (int i = 0; i < placeholderArray.count; i ++) {
        UITextField * textField = [[UITextField alloc]init];
        if (i > 1 && i < 4) {
           
            textField.frame = flexibleFrame(CGRectMake(15 + (i - 2) * 170, 200, 130, 40), NO);
//            textField.tag = TEXTFIELD_TAG + (i - 2);
            textField.delegate = self;
        }
        else if (i == placeholderArray.count - 1){
            textField.frame = flexibleFrame(CGRectMake(15, 40 + (i - 1) * 80, 300, 40), NO);
        }
        
        else{
            
            textField.frame = flexibleFrame(CGRectMake(15, 40 + i * 80, 300, 40), NO);

        }
        
        textField.backgroundColor = [UIColor whiteColor];
        textField.layer.cornerRadius = 5;
        textField.textColor = [UIColor colorWithWhite:0.147 alpha:1.000];
        textField.font = [UIFont systemFontOfSize:16];
        textField.placeholder = placeholderArray[i];
        textField.tag = TEXTFIELD_TAG + i;
        
        UIView * view = [[UIView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 10, 40), NO)];
        textField.leftView = view;
        textField.leftViewMode = UITextFieldViewModeAlways;
        [self.backView addSubview:textField];
        
    }
    for (int i = 0; i < array.count; i ++) {
        
        UIButton * button = [[UIButton alloc]initWithFrame:flexibleFrame(CGRectMake(15 + i * 90, 360, 70, 40), NO)];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithWhite:0.147 alpha:1.000] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        button.backgroundColor = [UIColor whiteColor];
        button.layer.cornerRadius = 10;
        button.selected = NO;
        [button addTarget:self action:@selector(handleLabel:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:button];
    }
    
    self.sharedView.textView.frame = flexibleFrame(CGRectMake(10, 440, 355, 100), NO);
    self.sharedView.textView.textColor = [UIColor colorWithWhite:0.147 alpha:1.000];
    self.sharedView.textView.layer.cornerRadius = 10;
    self.label = (UILabel *)self.sharedView.textView.subviews[1];
    self.label.text = @"谈谈你发起的旅游...";
    
    self.sharedView.textView.delegate = self;
    
    self.sharedView.importPhotoButton.frame = flexibleFrame(CGRectMake(20, 645, 60, 60), NO);
    [self.sharedView.importPhotoButton addTarget:self action:@selector(handleImport) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:self.sharedView.importPhotoButton];
    [self.backView addSubview:self.sharedView.textView];
    
    for (int i = 0; i < 3; i ++) {
        UIButton * button = (UIButton *)[self.sharedView viewWithTag:200 + i];
        [button addTarget:self action:@selector(handleSelecte:) forControlEvents:UIControlEventTouchUpInside];
    }

}
//标签选择事件
- (void)handleLabel:(UIButton *)sender{
    if (sender.selected == NO) {
        sender.backgroundColor = [UIColor colorWithRed:0.000 green:0.714 blue:0.000 alpha:1.000];
        sender.selected = YES;
    }
    else{
        sender.backgroundColor = [UIColor whiteColor];
        sender.selected = NO;
    }
}


#pragma mark --相片导入方法

- (void)handleImport{
    [self.view addSubview:self.sharedView.maskButton];
    [self.view addSubview:self.sharedView.selectView];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.sharedView.selectView.frame = flexibleFrame(CGRectMake(10, 527, 355, 140), NO);
    }];
}

//选择相片或拍照
- (void)handleSelecte:(UIButton *)sender{
    if (sender.tag == BUTTON_TAG) {
        
        UIImagePickerController * pickerController = [[UIImagePickerController alloc]init];
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerController.delegate = self;
        [self presentViewController:pickerController animated:YES completion:nil];
    }
    else if (sender.tag == BUTTON_TAG + 1){
        
        //        [self handleTakePhoto];
    }
    else{
        
        [self.sharedView handlePress];
        
    }
}


//照相机
- (void)handleTakePhoto{
    
    //先设定sourceType为照相机，判断照相机是否可用（ipod无相机,不可用则将sourceType设定为相片库
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //UIImagePickerControllerSourceTypePhotoLibrary为图片库，UIImagePickerControllerSourceTypeCamera为照相机， UIImagePickerControllerSourceTypeSavedPhotosAlbum为保存的相片
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    //    picker.delegate = self;
    picker.allowsEditing = YES;//设置可编辑
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];
    
}


#pragma mark --UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.sharedView.photoImageView.frame = flexibleFrame(CGRectMake(15, 599, 60, 60), NO);
    self.sharedView.photoImageView.image = info[UIImagePickerControllerOriginalImage];
    [self.view addSubview:self.sharedView.photoImageView];
    [self.sharedView handlePress];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.sharedView handlePress];
    [self dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark --键盘通知
- (void)keyboardWillShow:(NSNotification *)notif{
    CGRect keyboardRect = [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardHeight = keyboardRect.size.height;
    self.duration = [notif.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
}

#warning  --网络请求
- (void)handleLaunch{

    UITextField *originTextField = (UITextField *)[self.backView viewWithTag:TEXTFIELD_TAG];
    UITextField *destinationTextField = (UITextField *)[self.backView viewWithTag:TEXTFIELD_TAG + 1];
    UITextField *departureTimeTextField = (UITextField *)[self.backView viewWithTag:TEXTFIELD_TAG + 2];
    UITextField *arrivalTimeTextField = (UITextField *)[self.backView viewWithTag:TEXTFIELD_TAG + 3];
    UITextField *numberTextField = (UITextField *)[self.backView viewWithTag:TEXTFIELD_TAG + 4];
    
    NSData *imageData = UIImagePNGRepresentation(self.sharedView.photoImageView.image);
    NSNumber *number = [NSNumber numberWithInteger:[numberTextField.text intValue]];
    
    if ([originTextField.text  isEqual: @""] || [destinationTextField.text  isEqual: @""] || [departureTimeTextField.text  isEqual: @""] || [arrivalTimeTextField.text  isEqual: @""] || [number  isEqual: @""]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请填写必要的信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    [self.load show];
    [self.addActivities AddCalledWithPhoneNumber:PHONE_NUMBER password:PASSWORD title:nil origin:originTextField.text destination:destinationTextField.text departureTime:departureTimeTextField.text arrivalTime:arrivalTimeTextField.text NumberOfPeople:number content:self.sharedView.textView.text image:imageData];
    
    //提交数据
}

- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"addActivitiesResult"]) {
//        addActive
        if ([self.addActivities.addActivitiesResult isEqualToString:@"YES"]) {
            [self.navigationController popViewControllerAnimated:YES];
            [self.load hide];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"发送成功！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
    }
}




-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _timePopWindow = [[SearchPopWindow alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width * 0.75, [[UIScreen mainScreen] bounds].size.height * 0.6) title:@"请选择选择时间" complect:^(NSString *str) {
        textField.text = str;
    }];
    [_timePopWindow show];
    
    return NO;
}


- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.label.hidden = YES;
    CGFloat interval = self.backView.frame.size.height - (self.sharedView.textView.frame.origin.y + self.sharedView.textView.frame.size.height);
    if (self.keyboardHeight > interval) {
        
        [UIView animateWithDuration:self.duration animations:^{
            
            self.backView.frame = flexibleFrame(CGRectMake(0,64 - (self.keyboardHeight - interval) , 375, 613), NO);
            
        }];
    }

}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        self.label.hidden = NO;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.frame = flexibleFrame(CGRectMake(0,64, 375, 613), NO);
        
    }];
}


#pragma mark --lazy loading


- (SharedView *)sharedView{
    if (!_sharedView) {
        _sharedView = [SharedView new];
    }
    return _sharedView;
}


- (UIView *)backView{
    if (!_backView) {
        _backView = ({
            UIView * view = [[UIView alloc]initWithFrame:flexibleFrame(CGRectMake(750, 64, 375, 613), NO)];
            view.backgroundColor = [UIColor clearColor];
            view;
            
        });
    }
    return _backView;
}

- (CalledModel *)addActivities {
    if (!_addActivities) {
        _addActivities = [[CalledModel alloc]init];
    }
    return _addActivities;
}

- (LoadingView *)load {
    if (!_load) {
        _load = [[LoadingView alloc] init];
    }
    return _load;
}

@end
