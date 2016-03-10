//
//  SearchViewController.m
//  与你同游
//
//  Created by rimi on 15/10/20.
//  Copyright © 2015年 LiuCong. All rights reserved.
//

#import "SearchViewController.h"
#import "ScenicSpotmodei.h"
#import "SearchResultView.h"
#import "LoadingView.h"
#import "ScenicViewController.h"
#import "AddActivityViewController.h"
#define BUTTON_TAG 100

@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate ,SearchResultDelegate>

@property (nonatomic,strong) UITextField * textField;
@property (nonatomic,strong) UIView * topView;
@property (nonatomic,strong) UIView * subTopView;
@property (nonatomic,strong) NSArray * colorArray;

@property (nonatomic,strong) NSMutableArray * topArray;

@property (nonatomic,strong) UITableView * tableView;


@property (nonatomic,strong) UIView * buttomView;
@property (nonatomic,strong) NSMutableArray * buttomArray;
@property (nonatomic, strong) ScenicSpotmodei *scenic;

@property (nonatomic, strong) SearchResultView *resultView;

@property (nonatomic, assign) NSInteger openFLag;
@property (nonatomic, strong) LoadingView *load;


@end

@implementation SearchViewController
- (void)dealloc {
    [self.scenic removeObserver:self forKeyPath:@"scenicSpotSearchResults"];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initAllDataSource];
    [self initializedApperance];
    [self.scenic addObserver:self forKeyPath:@"scenicSpotSearchResults" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark -- KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"scenicSpotSearchResults"]) {
//        NSLog(@"data = %@", self.scenic.scenicSpotSearchResults[@"showapi_res_body"][@"pagebean"][@"contentlist"]);
        self.dataSource = self.scenic.scenicSpotSearchResults[@"showapi_res_body"][@"pagebean"][@"contentlist"];
//        NSLog(@"%@", self.dataSource);
        [[NSUserDefaults standardUserDefaults]setObject:self.dataSource forKey:@"searchResult"];
//        NSLog(@"%ld", self.dataSource.count);
        [self.view addSubview:self.resultView];
        [UIView animateWithDuration:0.7 animations:^{
            CGRect frame = _resultView.frame;
            frame.origin.y = flexibleHeight(64);
            _resultView.frame = frame;
        }];
        [self.rightButton removeTarget:self action:@selector(handleSearch) forControlEvents:UIControlEventTouchUpInside];
        [self initRightButtonEvent:@selector(cancelEvent) title:@"取消"];
        [self.load hide];
    }
}

- (void)initAllDataSource{
    
    
   self.colorArray = @[[UIColor colorWithRed:0.025 green:0.720 blue:1.000 alpha:1.000],[UIColor colorWithRed:1.000 green:0.612 blue:0.314 alpha:1.000],[UIColor colorWithRed:0.414 green:0.746 blue:0.429 alpha:1.000],[UIColor colorWithRed:1.000 green:0.527 blue:0.976 alpha:1.000], [UIColor colorWithRed:0.788 green:0.374 blue:0.438 alpha:1.000],[UIColor colorWithRed:0.820 green:0.715 blue:0.106 alpha:1.000]];
    
    //热门搜索申请网络数据
    self.topArray = [NSMutableArray arrayWithObjects:@"大木花谷",@"云海",@"杭州西湖",@"乌鲁木齐",@"普吉岛",@"丽江束河古镇",@"百里峡",@"山西五台山", nil];
    
    //tableView历史记录
    self.buttomArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"history"] mutableCopy];
    
}

- (void)initializedApperance{
    
    [self initBackButton];
    [self initRightButtonEvent:@selector(handleSearch) title:@"搜索"];
    
    [self.view addSubview:self.topView];
    
    [self.topView addSubview:self.subTopView];
    [self initializedTopView];
    [self initSearch];
    
    [self.buttomView addSubview:self.tableView];
    
    if (self.topArray.count != 0) {
        [self.view addSubview:self.topView];
    }
    
    if (self.buttomArray.count != 0) {
        [self.view addSubview:self.buttomView];
        
        self.tableView.frame = flexibleFrame(CGRectMake(0, 45, 375, self.tableView.rowHeight * self.buttomArray.count), NO);
    }
    
}

#warning --搜索事件
- (void)handleSearch{
    if (self.textField.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请填写地点" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    [self.load show];
    self.openFLag = 1;
    if (self.openFLag == 1) {
        [self textFieldShouldReturn:self.textField];
    }
    [self.scenic sendAsynchronizedPostRequest:self.textField.text];
    
}
- (void)quickSearch:(UIButton *)sender{
    [self.load show];
    self.openFLag = 1;
    if (self.openFLag == 1){
        [self.scenic sendAsynchronizedPostRequest:_topArray[sender.tag - BUTTON_TAG - 10]];
    }
}
#warning --取消事件
- (void)cancelEvent {
    self.openFLag = 0;
    
    [UIView animateWithDuration:0.7 animations:^{
        CGRect frame = _resultView.frame;
        frame.origin.y = flexibleHeight(HEIGHT);
        _resultView.frame = frame;
    } completion:^(BOOL finished) {
        [self.resultView removeFromSuperview];
    }];
    [self.rightButton removeTarget:self action:@selector(cancelEvent) forControlEvents:UIControlEventTouchUpInside];
    [self initRightButtonEvent:@selector(handleSearch) title:@"搜索"];
    
}



- (void)initializedTopView{
  
    CGFloat sumOfWidth = 0.0;
    int count = 0;
    int row = 0;
    for (int i = 0; i < self.topArray.count; i ++) {
        UIButton * button = [[UIButton alloc]initWithFrame:flexibleFrame(CGRectMake(10 + 100 * i,10, 80, 30), NO)];
        button.backgroundColor = self.colorArray[arc4random() % self.colorArray.count];
        [button setTitle:self.topArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.tag = BUTTON_TAG + 10 + i;
        [button addTarget:self action:@selector(quickSearch:) forControlEvents:UIControlEventTouchUpInside];
        CGSize butttonSize = [button.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObject:button.titleLabel.font forKey:NSFontAttributeName]];
        button.frame = flexibleFrame(CGRectMake(10 + i * 20 + sumOfWidth, 10, butttonSize.width + 20, 30), NO);
        if ((button.frame.origin.x + button.frame.size.width)  >  flexibleWidth(375)) {
            
            count = i;
            sumOfWidth = 0;
            row ++;
        }
        
        button.frame = flexibleFrame(CGRectMake(10 + (i - count) * 20 + sumOfWidth, 10 + row * 50, butttonSize.width + 20, 30), NO);
        sumOfWidth = sumOfWidth + button.frame.size.width;
//        NSLog(@"%@",NSStringFromCGRect(button.frame));
        
        button.layer.cornerRadius =  10 ;
        [self.subTopView addSubview:button];
    }
}

- (void)initSearch{

    UIImageView * imageView = [[UIImageView alloc]initWithFrame:flexibleFrame(CGRectMake(58, 28,260, 30), NO)];
    imageView.userInteractionEnabled = YES;
    imageView.layer.cornerRadius = 10;
    imageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imageView];
    
    UIImageView * searchView = [[UIImageView alloc]initWithFrame:flexibleFrame(CGRectMake(10, 10, 15, 15), NO)];
    searchView.image = IMAGE_PATH(@"放大镜.png");
    
    [imageView addSubview:searchView];
    
    UIButton * cancelButton = [[UIButton alloc]initWithFrame:flexibleFrame(CGRectMake(235,7, 20, 20), NO)];
    [cancelButton setBackgroundImage:IMAGE_PATH(@"shanchu.png") forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(handleClear) forControlEvents:UIControlEventTouchUpInside];
    
    [imageView addSubview:cancelButton];
    
    self.textField = [[UITextField alloc]initWithFrame:flexibleFrame(CGRectMake(28, 7,200, 20), NO)];
    self.textField.textColor = [UIColor lightGrayColor];
    self.textField.placeholder = @"搜索想去的地方";
    self.textField.font = [UIFont systemFontOfSize:15];
    self.textField.delegate = self;
    [imageView addSubview:self.textField];
}
- (void)handleClear{
    self.textField.text = @"";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];

    
    
    //存入本地搜索历史记录
    self.buttomArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"history"] mutableCopy];
    
        NSIndexPath * selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    NSMutableArray * array = [NSMutableArray arrayWithObjects:textField.text, nil];
    
    
    if (self.buttomArray.count != 0) {
        
        [array addObjectsFromArray:self.buttomArray];
        self.buttomArray = [array mutableCopy];
        [self.tableView insertRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationTop];
        
        self.tableView.frame = flexibleFrame(CGRectMake(0, 45, 375, self.tableView.rowHeight * self.buttomArray.count ), NO);
    }
    else{
       
        [array addObject:@"清除所有搜索历史"];
        self.buttomArray = [array mutableCopy];
          self.tableView.frame = flexibleFrame(CGRectMake(0, 45, 375, self.tableView.rowHeight * self.buttomArray.count ), NO);
         [self.view addSubview:self.buttomView];

    }

    [[NSUserDefaults standardUserDefaults] setObject:self.buttomArray forKey:@"history"];

    return YES;
}


#pragma mark --UITabelViewDelegate,UITabelViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.buttomArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * const identifer = @"CELL";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    NSInteger index = indexPath.row;
    if (index == self.buttomArray.count - 1) {
        
        [self clearAll:self.buttomArray[self.buttomArray.count - 1] cell:cell];
    
    }
    else{
       [self initFirstImage:@"放大镜.png" index:index deleteImage:@"shanchu.png" cell:cell];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == self.buttomArray.count - 1) {
        [self alertControllerShow:@"是否清除所有搜索历史？"];
    }
    else{
        //进入景点介绍
    }
}

- (void)sureAction{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"history"];
    
    [self.buttomView removeFromSuperview];
    
}


#pragma mark --cell ContentView

- (void)initFirstImage:(NSString *)imageString index:(NSInteger)index deleteImage:(NSString *)deleteString  cell:(UITableViewCell *)cell{
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:flexibleFrame(CGRectMake(10, 10, 20, 20), NO)];
    imageView.image = IMAGE_PATH(imageString);
    [cell.contentView addSubview:imageView];
    
    UILabel * label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(40, 10, 300, 20), NO)];
    label.textColor = [UIColor colorWithRed:0.369 green:0.361 blue:0.388 alpha:1.000];
    label.font = [UIFont systemFontOfSize:15 ];
    label.text = self.buttomArray[index];
    [cell.contentView addSubview:label];
    
    UIButton * deleteButton = [[UIButton alloc]initWithFrame:flexibleFrame(CGRectMake(320, 10, 25, 25), NO)];
    [deleteButton setBackgroundImage:IMAGE_PATH(deleteString) forState:UIControlStateNormal];
    deleteButton.tag = BUTTON_TAG + index;
    [deleteButton addTarget:self action:@selector(handleDelete:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.contentView addSubview:deleteButton];
}

- (void)clearAll:(NSString *)string cell:(UITableViewCell *)cell{
    
    UILabel * label = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(37.5, 10, 300, 20), NO)];
    label.textColor = [UIColor colorWithRed:0.233 green:0.528 blue:0.126 alpha:1.000];
    label.font = [UIFont systemFontOfSize:16 ];
    label.text = string;
    label.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:label];
}

- (void)handleDelete:(UIButton *)sender{
    
    
    NSInteger selectedIndex = sender.tag - BUTTON_TAG;
    

    [self.buttomArray removeObjectAtIndex:selectedIndex];
    
    NSIndexPath * selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    
    [self.tableView deleteRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    if (self.buttomArray.count == 1) {
        [self.buttomArray removeAllObjects];
        [self.buttomView removeFromSuperview];
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.buttomArray forKey:@"history"];
    self.tableView.frame = flexibleFrame(CGRectMake(0, 45, 375, self.tableView.rowHeight * self.buttomArray.count ), NO);

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}

#pragma mark --SearchResultDelegate 
- (void)pushToScenicDetailEvent:(NSMutableDictionary *)dic {
    ScenicViewController *scenic = [[ScenicViewController alloc]init];
    [self.navigationController pushViewController:scenic animated:YES];
    scenic.dataSource = dic;
}

#pragma mark --lazy loading
- (UIView *)topView{
    if (!_topView) {
        _topView = ({
           
            UIView * view = [[UIView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 64, 375, 240), NO)];
            view.backgroundColor = [UIColor clearColor];
            
            UILabel * titlelabel = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(0,0, 375, 60), NO)];
            titlelabel.text = @"       热门景点搜索";
            titlelabel.backgroundColor = [UIColor clearColor];
            titlelabel.textColor = [UIColor grayColor];
            titlelabel.font = [UIFont systemFontOfSize:16];
            [view addSubview:titlelabel];

            view;
        });
    }
    return _topView;
}

- (UIView *)subTopView{
    if (!_subTopView) {
        _subTopView = ({
            UIView * view = [[UIView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 50, 375, 190), NO)];
            view.backgroundColor = [UIColor clearColor];
            
            view;
        });
    }
    return _subTopView;
}

- (UIView *)buttomView{
    if (!_buttomView) {
        _buttomView = ({
            
            UIView * view = [[UIView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 260, 375, 407), NO)];
            view.backgroundColor = [UIColor clearColor];
            UILabel * titlelabel = [[UILabel alloc]initWithFrame:flexibleFrame(CGRectMake(0,0, 375, 60), NO)];
            titlelabel.text = @"       搜索历史记录";
            titlelabel.textColor = [UIColor grayColor];
            titlelabel.font = [UIFont systemFontOfSize:16];
            [view addSubview:titlelabel];

            view;
        });
    }
    return _buttomView;
}

- (NSMutableArray *)buttomArray{
    if (!_buttomArray) {
        _buttomArray = [[NSMutableArray alloc]init];
    }
    return _buttomArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = ({
            
           UITableView * table = [[UITableView alloc]init];
            table.backgroundColor = [UIColor clearColor];
            table.rowHeight = 40;
            table.delegate = self;
            table.dataSource = self;
            table;
        });
        
    }
    return _tableView;
}

- (ScenicSpotmodei *)scenic {
    if (!_scenic) {
        _scenic = [[ScenicSpotmodei alloc] init];
    }
    return _scenic;
}

- (SearchResultView *)resultView {
//    if (!_resultView) {
        _resultView = [[SearchResultView alloc]init];
        _resultView.delegate = self;
        CGRect frame = _resultView.frame;
        frame.origin.y = flexibleHeight(HEIGHT);
        _resultView.frame = frame;
//    }
    return _resultView;
}

- (LoadingView *)load {
    if (!_load) {
        _load = [[LoadingView alloc]init];
    }
    return _load;
}
@end
