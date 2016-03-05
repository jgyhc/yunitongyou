//
//  MyTravelsViewController.m
//  与你同游
//
//  Created by rimi on 15/10/15.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "MyTravelsViewController.h"
#import "RecordDetailViewController.h"
#import "AddTravelViewController.h"
#import "PersonalViewController.h"

//#import "MyTravelNotesTableViewCell.h"
//#import "MyTravelNoteModel.h"
#import "UITableView+SDAutoTableViewCellHeight.h"

#import <BmobSDK/Bmob.h>
#import "TravelModel.h"
#import "TravelTableViewCell.h"
#import "MJRefresh.h"
#import <MJRefresh.h>
#import "CommentViewController.h"
#define BUTTON_TAG 100
#define LABEL_TAG 200
#define IMAGE_TAG 300


static NSString * const identifier = @"CELL";
@interface MyTravelsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *modelsArray;

@end



@implementation MyTravelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
  
    
    [self initalizedInterface];
}

- (void)initalizedInterface{
    
    [self initNavTitle:@"我的游记"];
    [self initBackButton];
    self.view.backgroundColor = [UIColor colorWithWhite:0.929 alpha:1.000];
    [self initRightButtonEvent:@selector(handleTravelNotes:) Image:[UIImage imageNamed:@"添加游记"]];
    [self.view addSubview:self.tableView];
//       [self creatModelsWithCount:10];
//     [self setupRefresh];

}
//
//- (void)setupRefresh
//{
//    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//    header.stateLabel.font = [UIFont systemFontOfSize:flexibleHeight(12)];
//    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:flexibleHeight(12)];
//    self.tableView.mj_header = header;
//}
//
//- (void)loadNewData {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self creatModelsWithCount:10];
//        [self.tableView reloadData];
//        [self.tableView.mj_header endRefreshing];
//    });
//    
//}
//
//- (void)creatModelsWithCount:(NSInteger)count{
//    if (!_modelsArray) {
//        _modelsArray = [NSMutableArray new];
//    }
//    NSArray *iconImageNamesArray = @[@"portraint0.png",
//                                     @"portraint1.png",
//                                     @"portraint2.png",
//                                     @"portraint3.png",
//                                     @"portraint4.png",
//                                     ];
//    
//    NSArray *namesArray = @[@"提莫",
//                            @"风口上的猪",
//                            @"当今世界网名都不好起了",
//                            @"么么哒",
//                            @"犯二的女神"];
//    
//    NSArray *textArray = @[@"游一处风景，寻一处特色；见一处特色，悟一片心得。江南的绮丽，塞北的广漠，能唤起咱们对大自然的尊重和敬畏，如果你能和此地人沟通结识，赋美景以人文，还自然以性命，你会觉得，还有比自然景观更深刻的领悟??不一样的水土养不一样的人，都具有各自的优势和特点。真是一花一世界，万花装扮春。",
//                           @"旅行的乐趣就在于它存在变数。不必须全都完美，但只要是你身体和情感都在体验，事后想起来，都觉得可爱，这就是旅行最让人着迷的地方。",
//                           @"人必须要旅行，尤其是女孩子。一个女孩子见识很重要，你见的多了，自然就会心胸豁达，视野宽广，会影响到你对很多事情的看法。旅行让人见多识广，对女孩子来说更是如此，它会让自我更有信心，不会在物质世界里迷失方向。",
//                           @"人生的旅途中不只是感情为最大的收获，得到知音更加珍重。伯牙鼓琴林中，遇钟子期，知其志在登高山，志在流水，而惺惺相惜。因此琴声悠扬，为知己者而鸣。得到志同道合者甚幸，能携手登高山，同舟荡江河。我在旅途中以前遇到过气味相投人，畅谈一场，痛快淋漓，却都以挥手告别而结束。得到高人启发，如遇仙人庆幸。钟爱思想的人。几乎都苦于难遇知音，因此是世上最孤独的人。",
//                           @"我要继续我的旅游，心灵的旅游，去从自然中得到启示，去从旅途中遇见志同道合者或听众。"
//                           ];
//    
//    NSArray *picImageNamesArray = @[ @"11.jpg",
//                                     @"13.jpg",
//                                     @"14.jpg",
//                                     @"15.jpg",
//                                     @"上海.jpg",
//                                     @"广西.jpg",
//                                     @"江苏.jpg",
//                                     @"海南.jpg",
//                                     @"云南.jpg"
//                                     ];
//    for (int i = 0; i < count; i++) {
//        int iconRandomIndex = arc4random_uniform(5);
//        int nameRandomIndex = arc4random_uniform(5);
//        int contentRandomIndex = arc4random_uniform(5);
//        
//        MyTravelNoteModel *model = [MyTravelNoteModel new];
//        model.iconName = iconImageNamesArray[iconRandomIndex];
//        model.name = namesArray[nameRandomIndex];
//        model.content = textArray[contentRandomIndex];
//        
//        
//        // 模拟“随机图片”
//        int random = arc4random_uniform(10);
//        
//        NSMutableArray *temp = [NSMutableArray new];
//        for (int i = 0; i < random; i++) {
//            int randomIndex = arc4random_uniform(9);
//            [temp addObject:picImageNamesArray[randomIndex]];
//        }
//        if (temp.count) {
//            model.picArray = [temp copy];
//        }
//        
//        [self.modelsArray addObject:model];
//    }
//    
//    
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.modelsArray.count;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    MyTravelNotesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
////    if (!cell) {
////        cell = [[MyTravelNotesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
////    }
//
//    cell.indexPath = indexPath;
//    if (!cell.moreButtonClickedBlock) {
//        [cell setMoreButtonClickedBlock:^(NSIndexPath * indexPath) {
//            MyTravelNoteModel * model = self.modelsArray[indexPath.row];
//            model.isOpening = !model.isOpening;
//            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        }];
//    }
//    
//    cell.model = self.modelsArray[indexPath.row];
//    
//    
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
//    id model = self.modelsArray[indexPath.row];
//    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[MyTravelNoteModel class] contentViewWidth:[self cellContentViewWith]];
//}
//
//
//
//
//- (CGFloat)cellContentViewWith
//{
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    
//    // 适配ios7
//    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
//        width = [UIScreen mainScreen].bounds.size.height;
//    }
//    return width;
//}
//
//
//- (UITableView *)tableView{
//    if (!_tableView) {
//        _tableView = ({
//            UITableView * tableView = [[UITableView alloc]initWithFrame:flexibleFrame(CGRectMake(10, 64, 355, 603), NO)];
//            tableView.backgroundColor = [UIColor colorWithWhite:0.929 alpha:1.000];
////            tableView.rowHeight = 400;
//            tableView.showsVerticalScrollIndicator = NO;
//            tableView.delegate = self;
//            tableView.dataSource = self;
//            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//            tableView;
//            
//        });
//    }
//    return _tableView;
//}


@end