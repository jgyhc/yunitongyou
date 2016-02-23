//
//  OtherInfoViewController.m
//  与你同游
//
//  Created by rimi on 15/10/24.
//  Copyright © 2015年 LiuCong. All rights reserved.
//

#import "OtherInfoViewController.h"
#import "UserModel.h"

@interface OtherInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIView * topView;
@property (nonatomic,strong) UIButton * backButton;
@property (nonatomic,strong) UIImageView * headPortrait;

@property (nonatomic,strong) UIView * buttomView;

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * infoDataSource;
@property (nonatomic,strong)  NSArray * hintArray;

@property (nonatomic,strong) UserModel * UserInfo;



@end

@implementation OtherInfoViewController

- (void)dealloc{
    [self.UserInfo removeObserver:self forKeyPath:@"userData"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.UserInfo addObserver:self forKeyPath:@"userData" options:NSKeyValueObservingOptionNew context:nil];
      [self initializeDataSource];
    
//     [self.UserInfo  getWithPhoneNumber:self.phone_number password:nil];
    [self.UserInfo getWithPhoneNumber:self.phone_number password:nil successBlock:nil failBlock:nil];
    
}

- (void)initializeDataSource{
    self.hintArray = @[@"昵称",@"性别",@"年龄",@"个性签名"];
     self.infoDataSource = [[NSMutableArray alloc]init];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"userData"]) {
        if ([self.UserInfo.userData objectForKey:@"userName"]) {
            
            [self.infoDataSource addObject:[self.UserInfo.userData objectForKey:@"userName"]];
            
        }else {
            [self.infoDataSource addObject:[self.UserInfo.userData objectForKey:@"phoneNumber"]];
        }
        NSString *strUrl = [self.UserInfo.userData objectForKey:@"head_portraits1"];
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:strUrl]];
        UIImage *image = [UIImage imageWithData:data];
        self.headPortrait.image = image;
        self.topView.backgroundColor = [UIColor colorWithPatternImage:image];
        
          [self.infoDataSource addObject:[self.UserInfo.userData objectForKey:@"sex"]];
        
        [self.infoDataSource addObject:[self.UserInfo.userData objectForKey:@"age"]];
  
        [self.infoDataSource addObject:[self.UserInfo.userData objectForKey:@"IndividualitySignature"]];
    }

    [self initializedApperance];
}

- (void)initializedApperance{
    [self.view addSubview:self.buttomView];
    [self.view addSubview:self.topView];

    [self.topView addSubview:self.backButton];
    [self.topView addSubview:self.headPortrait];
    [self.buttomView addSubview:self.tableView];
    [self initLabel];

}

#pragma mark --private methods
- (void)initLabel{
    
    UILabel * nameLabel = [[UILabel alloc] initWithFrame:flexibleFrame(CGRectMake(138,190,20,20), NO) ];//这个frame是初设的，没关系，后面还会重新设置其size。
    nameLabel.textColor = [UIColor colorWithWhite:0.098 alpha:1.000];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = self.infoDataSource[0];
    nameLabel.font = [UIFont systemFontOfSize:16];
    CGSize labelsize = [nameLabel.text  sizeWithAttributes:[NSDictionary dictionaryWithObject:nameLabel.font forKey:NSFontAttributeName]];
    [nameLabel setFrame:flexibleFrame(CGRectMake(138,190, labelsize.width, 20), NO) ];
    
    [self.topView addSubview:nameLabel];
    
    
    UIImageView * positionImageView = [[UIImageView alloc]initWithFrame:flexibleFrame(CGRectMake(nameLabel.frame.origin.x + nameLabel.frame.size.width + 5, 186, 30, 30), NO)];
    positionImageView.image = IMAGE_PATH([self.infoDataSource[1] stringByAppendingString:@".png"] );
    
    [self.topView addSubview:positionImageView];
    
}

- (void)handleBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --UITableViewDelegate,UITableViewDataSource
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 3;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section == 3) {
        return self.hintArray.count;
//    }
//    else{
//        return 1;
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * const indentifier = @"CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (indexPath.row != self.hintArray.count - 1) {
       UILabel * lable  = [[UILabel alloc] initWithFrame:flexibleFrame(CGRectMake(80, 25, 270, 30), NO)];
        
         NSString *string = [NSString stringWithFormat:@"%@", self.infoDataSource[indexPath.row]];
        lable.text = string;
        lable.font = [UIFont systemFontOfSize:16];
        
        lable.textColor = [UIColor colorWithWhite:0.498 alpha:1.000];
        
        [cell.contentView addSubview:lable];
        
        cell.textLabel.text = self.hintArray[indexPath.row];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.298 alpha:1.000];
        
    }
    else{
        UILabel * label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(10, 15, 80, 20), NO)];
        label.text = self.hintArray[self.hintArray.count - 1];
        label.textColor = [UIColor colorWithWhite:0.298 alpha:1.000];
        [cell.contentView addSubview:label];
    
        UITextView * textView = [[UITextView alloc] initWithFrame:flexibleFrame(CGRectMake(50,40, 270,60), NO)];
        textView.text = self.infoDataSource[indexPath.row];
        textView.font = [UIFont systemFontOfSize:16];
        
      
        textView.textColor = [UIColor colorWithWhite:0.498 alpha:1.000];
        textView.selectable = NO;
        textView.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:textView];
        
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.hintArray.count - 1) {
        return 180;
    }
    
    return 80;
    
    
}

#pragma mark --lazy loading

- (UIView *)topView{
    if (!_topView) {
        _topView = ({
            UIView * view = [[UIView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, 375, 250), NO)];
            view.backgroundColor = [UIColor colorWithPatternImage:IMAGE_PATH(@"个人信息壁纸.png")];
            
            UIVisualEffectView *visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
            visualEfView.frame = flexibleFrame(CGRectMake(0, 0, 375, 250), NO);
            visualEfView.alpha = 1;
            [view addSubview:visualEfView];
            view;
            
        });
    }
    return _topView;
}

- (UIView *)buttomView{
    if (!_buttomView) {
        _buttomView = ({
            UIView * view = [[UIView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 250, 375, 417), NO)];
            view.backgroundColor = [UIColor whiteColor];
            view;
            
        });
    }
    return _buttomView;
}

- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = ({
            UIButton * button = [[UIButton alloc]initWithFrame:flexibleFrame(CGRectMake(15, 30, 20, 20), NO)];
            [button setImage:IMAGE_PATH(@"xiangxia.png") forState:UIControlStateNormal];
            [button addTarget:self action:@selector(handleBack) forControlEvents:UIControlEventTouchUpInside];
            button;
            
        });
    }
    return _backButton;
}


- (UIImageView *)headPortrait{
    if (!_headPortrait) {
        _headPortrait = ({
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:flexibleFrame(CGRectMake(147.5, 100, 80, 80), NO)];
            imageView.image = IMAGE_PATH(@"单人头像.png");
            imageView.layer.cornerRadius = 40;
            imageView.clipsToBounds = YES;
            imageView;
        });
    }
    return _headPortrait;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = ({
            
            UITableView * tableView = [[UITableView alloc]init];
            tableView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.290];
            tableView.rowHeight = 50;
            tableView.separatorColor = [UIColor colorWithWhite:0.796 alpha:1.000];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.frame = flexibleFrame(CGRectMake(0,0, 375, 160 + 80 * self.hintArray.count - 2), NO);
            tableView;
        });
    }
    return _tableView;
}

- (UserModel *)UserInfo{
    if (!_UserInfo) {
        _UserInfo = [UserModel alloc];
    }
    return _UserInfo;
}

@end
