//
//  InitiateDetailCommentView.m
//  与你同游
//
//  Created by rimi on 15/10/21.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "InitiateDetailCommentView.h"
#import "RecordDetailTableViewCell.h"

@interface InitiateDetailCommentView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UITableView *tabelView;

@end

@implementation InitiateDetailCommentView

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
}

- (void)updateFrame
{
    CGRect frame = self.tabelView.frame;
    frame.size.height = [self.tabelView rectForSection:0].size.height;
    self.tabelView.frame = frame;
    self.frame = self.tabelView.frame;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = self.tabelView.frame;
    frame.size.height += cell.bounds.size.height;
    self.tabelView.frame = frame;
    
    CGRect selfFrame = self.frame;
    selfFrame.size.height += cell.bounds.size.height;
    
    self.frame = selfFrame;
     [[NSNotificationCenter defaultCenter] postNotificationName:@"content" object:nil];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    RecordDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[RecordDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.speakerLabel.text = @"ai";
    cell.receiverLabel.text = [NSString stringWithFormat:@"回复 %@：", @"逗比"];
    cell.receiverLabel.frame = flexibleFrame(CGRectMake(46 + [self widthForString:cell.speakerLabel.text fontSize:14], 13, 355, 20), NO);
    cell.userHeaderImageView.image = [UIImage imageNamed:@"头像"];
    cell.timeLabel.text = @"2015-10-12 11:02:15";
    cell.contensLabel.text = @"NSTextAlignmentLefSTextAlignmentLefSTextAlignmentLefSTextAlignmentLefSTextAlignmentLefSTextAlignmentLefSTextAlignmentLefSTextAlignmentLefSTextAlignmentLefSTextAlignmentLefSTextAlignmentLef";
    cell.contensLabel.frame = flexibleFrame(CGRectMake(15, 38, 345, [self heightForString:cell.contensLabel.text fontSize:13 andWidth:345]), NO);
    tableView.rowHeight = flexibleHeight([self heightForString:cell.contensLabel.text fontSize:13 andWidth:345] + 50);

//    self.scrollView.contentSize = CGSizeMake(0, 50 + self.contentImageView.frame.origin.y + self.contentImageView.bounds.size.height + 5 * self.tableView.rowHeight);
    
    return cell;
}

#pragma mark --文本自适应
- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont boldSystemFontOfSize:fontSize];
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize.height;
}

- (float) widthForString:(NSString *)value fontSize:(float)fontSize
{
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 40)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(CGFLOAT_MAX,40)];
    
    return deSize.width;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UITableView *)tabelView {
    if (!_tabelView) {
        _tabelView = ({
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
            tableView.frame = flexibleFrame(CGRectMake(0, 0, WIDTH, HEIGHT / 2 + 115), NO);
            tableView.dataSource = self;
            tableView.delegate = self;
//            tableView.rowHeight = flexibleHeight(50);
            tableView.scrollEnabled = NO;
            tableView.backgroundColor = [UIColor clearColor];
            tableView;
        });
    }
    return _tabelView;
}

@end
