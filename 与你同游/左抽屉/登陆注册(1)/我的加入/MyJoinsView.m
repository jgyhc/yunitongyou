//
//  MyJoinsView.m
//  与你同游
//
//  Created by rimi on 15/10/23.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "MyJoinsView.h"
#import "LaunchTableViewCell.h"

@interface MyJoinsView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic ,strong) UITableView *tableView;

@end

@implementation MyJoinsView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self  initUserInterface];
    }
    return self;
}


- (void)initUserInterface {
    [self addSubview:self.tableView];
    self.frame = self.tableView.frame;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"cell";
    LaunchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[LaunchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *str = @"大家好,在此特意召唤小伙伴，喜欢有意的小伙伴踊跃跟团意召唤小伙伴，喜欢有意的小伙伴踊跃跟团意召唤小伙伴，喜欢有意的小伙伴踊跃跟团意召唤小伙伴，喜欢有意的小伙伴踊跃跟团大家好,在此特意召唤小伙伴，喜欢有意的小伙伴踊跃跟团意召唤小伙伴，喜欢有意的小伙伴踊跃跟团意召唤小伙伴，喜欢有意的小伙伴踊跃跟团意召唤小伙伴，喜欢有意的小伙伴踊跃跟团大家好,在此特意召唤小伙伴，喜欢有意的小伙伴踊跃跟团意召唤小伙伴，喜欢有意的小伙伴踊跃跟团意召唤小伙伴，喜欢有意的小伙伴踊跃跟团意召唤小伙伴，喜欢有意";
//    [cell initUserHeaderImage:[UIImage imageNamed:@"qq.png"] userID:@"userID" userLV:@"userLV" launchTime:@"18:39" launchDate:@"2015.08.30"];
//    [cell initDeparture:@"重庆" destination:@"涪陵" starting:@"2015.08.30 08:31" reture:@"2015.08.30 09:03" info:str];
//    
//    cell.infoLabel.frame = flexibleFrame(CGRectMake(10, 80, 335, [self heightForString:str fontSize:14 andWidth:335]), NO);
//    [cell initSave:@"0" comment:@"3" follower:@"3"];
//    [cell.ContentButton setImage:[UIImage imageNamed:@"头像"] forState:UIControlStateNormal];
//    cell.ContentButton.frame = CGRectMake(20, cell.infoLabel.frame.origin.y + cell.infoLabel.bounds.size.height + 10, flexibleHeight(70), flexibleHeight(70));
//    
//    tableView.rowHeight = cell.saveButton.frame.size.height + cell.infoLabel.frame.size.height + cell.UserHeaderimageView.frame.size.height + cell.ContentButton.frame.size.height + 60;
//    CGPoint center = cell.saveButton.center;
//    center.y = tableView.rowHeight - flexibleHeight(15);
//    cell.saveButton.center = center;
//    
//    center = cell.commentButton.center;
//    center.y = tableView.rowHeight - flexibleHeight(15);
//    cell.commentButton.center = center;
//    
//    center = cell.followerButton.center;
//    center.y = tableView.rowHeight - flexibleHeight(15);
//    cell.followerButton.center = center;
    
    [cell PositionTheReset];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld", indexPath.row);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
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


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = ({
            UITableView *tableView = [[UITableView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, WIDTH, 571), NO) style:UITableViewStyleGrouped];
            tableView.dataSource = self;
            tableView.delegate = self;
            tableView.scrollEnabled = YES;
            tableView.userInteractionEnabled = YES;
            tableView;
        });
    }
    return _tableView;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
