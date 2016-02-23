//
//  InitiateDetailFollowerView.m
//  与你同游
//
//  Created by rimi on 15/10/21.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "InitiateDetailFollowerView.h"
#import "InitiateDetailFollowerTableViewCell.h"

@interface InitiateDetailFollowerView ()<UITableViewDataSource>

@property (nonatomic, strong)UITableView *tabelView;

@end

@implementation InitiateDetailFollowerView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    [self addSubview:self.tabelView];
    CGRect frame = self.tabelView.frame;
    frame.size.height = [self.tabelView rectForSection:0].size.height;
    self.tabelView.frame = frame;
    self.frame = self.tabelView.frame;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 18;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    
    InitiateDetailFollowerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[InitiateDetailFollowerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userHeaderImageView.image = [UIImage imageNamed:@"qq"];
    cell.userIDLabel.text = @"张三";

    
//    tableView.frame = flexibleFrame(CGRectMake(0, self.contentImageView.frame.origin.y + self.contentImageView.bounds.size.height + 50, CGRectGetMaxX(self.frame), tableView.rowHeight * 5), NO);

    return cell;
}

- (UITableView *)tabelView {
    if (!_tabelView) {
        _tabelView = ({
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
            tableView.frame = flexibleFrame(CGRectMake(0, 0, WIDTH, HEIGHT / 2 + 115), NO);
            tableView.dataSource = self;
            tableView.rowHeight = flexibleHeight(50);
            tableView.scrollEnabled = NO;
            tableView.backgroundColor = [UIColor clearColor];
            tableView;
        });
    }
    return _tabelView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
