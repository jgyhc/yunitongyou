#import "MyCollectionViewController.h"
#import "TopSelectButtonView.h"
#import "TravelNotesTableViewCell.h"
#import "LaunchTableViewCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "Collection.h"
#import "MJRefresh.h"

@interface MyCollectionViewController ()<TopSelectButtonViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) TopSelectButtonView * selectButton;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, assign) int type;

@end

@implementation MyCollectionViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    [self getcollection:self.type];
}

- (void)initUserInterface {
    [self initBackButton];
    [self initNavTitle:@"我的关注"];
    self.type = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerClass:[TravelNotesTableViewCell class] forCellReuseIdentifier:NSStringFromClass([TravelNotesTableViewCell class])];
    [self.tableView registerClass:[LaunchTableViewCell class] forCellReuseIdentifier:NSStringFromClass([LaunchTableViewCell class])];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.selectButton];
    self.selectButton.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view, flexibleHeight(64)).heightIs(flexibleHeight(45));
    self.tableView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.selectButton, 0).bottomEqualToView(self.view);
     [self setupRefresh];
}

#pragma mark --刷新
- (void)setupRefresh
{
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getcollection:self.type];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
        });
    }];
}


- (void)getcollection:(int)type{
    [self.dataSource removeAllObjects];
    [Collection getCollectionSuccess:^(NSArray *collections) {
        [self.dataSource addObjectsFromArray:collections];
        [self.tableView reloadData];
  } type:type failure:^(NSError *error) {
      
  }];
}

- (void)clickButton:(UIButton *)sender{
    if (sender == self.selectButton.rightsideButton) {
        self.type =1;
        [self getcollection:self.type];
    }
    else{
        self.type = 0;
        [self getcollection:self.type];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Class currentClass = [TravelNotesTableViewCell class];
    TravelNotesTableViewCell * cell = nil;
    if (self.type == 1) {
        currentClass = [LaunchTableViewCell class];
    }
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([currentClass class])];
    BmobObject *model = self.dataSource[indexPath.row];
    cell.obj = model;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:[self cellContentViewWith] tableView:tableView];
}
- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}



#pragma mark --lazy loading
- (UITableView *)tableView {
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (NSMutableArray *)dataSource {
    if(_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (TopSelectButtonView *)selectButton{
    if (!_selectButton) {
        _selectButton = [[TopSelectButtonView alloc]initWithType:0];
        _selectButton.delegate = self;
    }
    return _selectButton;
}

@end
