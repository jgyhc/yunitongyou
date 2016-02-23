//
//  AddActivityViewController.m
//  与你同游
//
//  Created by rimi on 15/10/19.
//  Copyright © 2015年 LiuCong. All rights reserved.
//

#import "AddActivityViewController.h"
#import "AddTravelNoteViewController.h"
#import "SharedView.h"

#define BUTTON_TAG 100

@interface AddActivityViewController ()<UITextFieldDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong) UIView * backView;//全部控件及视图加载此view上，便于做动画
@property (nonatomic,strong) AddTravelNoteViewController * addNoteVC;
@property (nonatomic,strong) SharedView * sharedView;
@property (nonatomic,strong) UIButton * importPhoto;//导入图片按钮
@property (nonatomic,assign) CGFloat keyboardHeight;
@property (nonatomic,assign) NSTimeInterval duration;
@property (nonatomic,strong) UILabel * label;

@end

@implementation AddActivityViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
   self.view.backgroundColor = [UIColor colorWithWhite:0.942 alpha:1.000];
   [self initializedApperance];
    
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

}

- (void)initializedApperance{
    [self initBackButton];
    [self initNavTitle:@"发起活动"];
    [self initRightButtonEvent:@selector(handleLaunch) title:@"发起"];
    
    [self.view insertSubview:self.backView belowSubview:self.navView];
    
    [self inithintName];
    [self initInputField];
    [self initImportPhotoView];

    //页面加载动画
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.2 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        
        self.backView.frame = flexibleFrame(CGRectMake(0, 54, 375, 613), NO);
        
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
    NSArray * placeholderArray = @[@"请填写出发地",@"请填写目的地(可有多个)",@"请填写旅行时间",@"请填写陪伴你的人数"];
    
    for (int i = 0; i < 4; i ++) {
        UITextField * textField = [[UITextField alloc]initWithFrame:flexibleFrame(CGRectMake(15, 40 + i * 80, 300, 40), NO)];
        textField.backgroundColor = [UIColor whiteColor];
        textField.layer.cornerRadius = 5;
        textField.textColor = [UIColor colorWithWhite:0.147 alpha:1.000];
        textField.font = [UIFont systemFontOfSize:16];
        textField.delegate = self;
        textField.placeholder = placeholderArray[i];
        
        UIView * view = [[UIView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 10, 40), NO)];
        textField.leftView = view;
        textField.leftViewMode = UITextFieldViewModeAlways;
        [self.backView addSubview:textField];
        
        UIButton * button = [[UIButton alloc]initWithFrame:flexibleFrame(CGRectMake(15 + i * 90, 360, 70, 40), NO)];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithWhite:0.147 alpha:1.000] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        button.backgroundColor = [UIColor whiteColor];
        button.layer.cornerRadius = 10;
        button.tag = BUTTON_TAG + i;
        button.selected = NO;
        [button addTarget:self action:@selector(handleLabel:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:button];
        
    }
    
    self.addNoteVC.textView.frame = flexibleFrame(CGRectMake(10, 440, 355, 100), NO);
    self.addNoteVC.textView.textColor = [UIColor colorWithWhite:0.147 alpha:1.000];
    self.addNoteVC.textView.layer.cornerRadius = 10;
    self.label = (UILabel *)self.addNoteVC.textView.subviews[1];
    self.label.text = @"谈谈你发起的旅游...";
    
    self.addNoteVC.textView.delegate = self;
    [self.backView addSubview:self.importPhoto];
    [self.backView addSubview:self.addNoteVC.textView];


}
//标签选择事件
- (void)handleLabel:(UIButton *)sender{
    if (sender.selected == NO) {
        sender.backgroundColor = [UIColor colorWithRed:0.000 green:0.714 blue:0.000 alpha:1.000];
        sender.selected = YES;
    }
    else{
        sender.backgroundColor = [UIColor colorWithWhite:0.942 alpha:1.000];
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
- (void)initImportPhotoView{
    NSArray * array = @[@"从图库中选择",@"拍照",@"取消"];
    for (int i = 0; i < 3; i ++) {
        
        UIButton * button = [[UIButton alloc]initWithFrame:flexibleFrame(CGRectMake(0, i * 40, 355, 40), NO)];
        if (i == 2) {
            button.frame = flexibleFrame(CGRectMake(0, 90, 355, 40), NO);
            button.backgroundColor = [UIColor colorWithRed:0.439 green:0.957 blue:0.788 alpha:1.000];
            button.layer.cornerRadius = 5;
        }
        button.tag = BUTTON_TAG + i;
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(handleSelecte:) forControlEvents:UIControlEventTouchUpInside];
        [self.sharedView.selectView addSubview:button];
        
    }
    UIView * lineView = [[UIView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 40, 355, 0.5),NO)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.sharedView.selectView addSubview:lineView];

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
    self.addNoteVC.imageView.frame = flexibleFrame(CGRectMake(15, 599, 60, 60), NO);
    self.addNoteVC.imageView.image = info[UIImagePickerControllerOriginalImage];
    [self.view addSubview:self.addNoteVC.imageView];
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

#pragma mark --网络请求
- (void)handleLaunch{
    //提交数据
    [self.navigationController popViewControllerAnimated:YES];
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
            UIView * view = [[UIView alloc]initWithFrame:flexibleFrame(CGRectMake(750, 54, 375, 613), NO)];
            view.backgroundColor = [UIColor clearColor];
            view;

        });
    }
    return _backView;
}

- (UIButton *)importPhoto{
    if (!_importPhoto) {
        _importPhoto = ({
            
            UIButton * button = [[UIButton alloc]initWithFrame:flexibleFrame(CGRectMake(15, 545, 60, 60), NO)];
            [button setBackgroundImage:IMAGE_PATH(@"添加相片.png") forState:UIControlStateNormal];
            button.backgroundColor = [UIColor whiteColor];
            [button addTarget:self action:@selector(handleImport) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _importPhoto;
}

- (AddTravelNoteViewController *)addNoteVC{
    if (!_addNoteVC) {
        _addNoteVC = [AddTravelNoteViewController new];
    }
    return _addNoteVC;
}


- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.label.hidden = YES;
    CGFloat interval = self.backView.frame.size.height - (self.addNoteVC.textView.frame.origin.y + self.addNoteVC.textView.frame.size.height);
    if (self.keyboardHeight > interval) {
        
        [UIView animateWithDuration:self.duration animations:^{
            
            self.backView.frame = flexibleFrame(CGRectMake(0,54 - (self.keyboardHeight - interval) , 375, 613), NO);
            
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
        self.backView.frame = flexibleFrame(CGRectMake(0,54, 375, 613), NO);
        
    }];

    
}


@end
