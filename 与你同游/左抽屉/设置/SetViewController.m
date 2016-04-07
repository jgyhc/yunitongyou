//
//  SetViewController.m
//  与你同游
//
//  Created by rimi on 15/10/15.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "SetViewController.h"
#import "ChangePwViewController.h"
#import "SuggestionViewController.h"
@interface SetViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIButton *ExitButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSMutableArray *dataSouce;
@end


@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUserInterface];
    [self initUserDatasouce];
}
- (void)initUserInterface {
    [self initBackButton];
    [self initNavTitle:@"设置"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.ExitButton];
    [self.view addSubview:self.tableView];
}


- (void)initUserDatasouce {
    self.array =  @[@"修改密码", @"意见反馈"];
    
}
#pragma mark --UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indentifier = @"CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    UIView *line = [[UIView alloc] initWithFrame:flexibleFrame(CGRectMake(0, 58, 375, 0.7), NO)];
    line.backgroundColor = [UIColor colorWithWhite:0.845 alpha:1.000];
    [cell.contentView addSubview:line];
    
    
    cell.textLabel.text = self.array[indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithWhite:0.402 alpha:1.000];
    return cell;
    
}
- (void)ExitButtonAction: (UIButton *)sender {
//    NSString * appDomain = [[NSBundle mainBundle]bundleIdentifier];
//    [[NSUserDefaults standardUserDefaults]removePersistentDomainForName:appDomain];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"phoneNumber"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"objectId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginState"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userID"];
    [self.navigationController popToRootViewControllerAnimated:YES];

}
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ChangePwViewController *changVC = [[ChangePwViewController alloc] init];
        [self.navigationController pushViewController:changVC animated:YES];
    }
    if (indexPath.row == 1) {
        [self.navigationController pushViewController:[SuggestionViewController new] animated:YES];
    }
    }

#pragma mark -- getter

- (UIButton *)ExitButton {
    if (!_ExitButton) {
        _ExitButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = flexibleFrame(CGRectMake(0, 0, 310, 50), NO);
            button.center = flexibleCenter(CGPointMake(375 / 2, 600), NO);
            button.layer.cornerRadius = 5;
            [button setTitle:@"退出登录" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.backgroundColor = THEMECOLOR;
            [button addTarget:self action:@selector(ExitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button;

        
        });
        
    }
    return _ExitButton;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:flexibleFrame(CGRectMake(0, 64, 375, 300), NO) style:UITableViewStylePlain];
            tableView.dataSource = self;
            tableView.delegate = self;
            tableView.rowHeight = 60;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView;
        });
        
    }
    return _tableView;
    
}
- (NSArray *)array {
    if (!_array) {
        _array = [NSArray array];
    }
    return _array;
}
- (NSMutableArray *)dataSouce {
    if (!_dataSouce) {
        _dataSouce = [NSMutableArray array];
    }
    return _dataSouce;
}

















@end
