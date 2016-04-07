#import "MyCollectionViewController.h"
#import "TopSelectButtonView.h"
#import "TravelNotesTableViewCell.h"
#import "LaunchTableViewCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "Collection.h"
#import "MJRefresh.h"
#import "RecordDetailViewController.h"
#import "InitiateDetailViewController.h"
#import "ThumbUp.h"
#import "Collection.h"
#import "CommentViewController.h"
#import "ShareView.h"
#import "PersonalViewController.h"
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
    [self initNavTitle:@"我的收藏"];
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
    return 1;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BmobObject *model = self.dataSource[indexPath.section];
    if (self.type == 1) {
        TravelNotesTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TravelNotesTableViewCell class])];
         cell.obj = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
#pragma mark --点赞
        [cell buttonthumbUp:^(int type) {
            if (type == 1) {
                //点赞
                [ThumbUp thumUpWithID:model.objectId type:1 success:^(NSString *commentID) {
                } failure:^(NSError *error1) {
                    
                }];
            }
            else if (type == 0){
                //取消点赞
                [ThumbUp cancelThumUpWithID:model.objectId type:1 success:^(NSString *commentID) {
                } failure:^(NSError *error1) {
                    
                }];
            }
            
        }];
        
#pragma mark --评论
        [cell buttoncomment:^{
            CommentViewController * commentVC = [[CommentViewController alloc]init];
            commentVC.objId = model.objectId ;
            commentVC.type = 1;
            [self.navigationController pushViewController:commentVC animated:YES];
        }];
        
#pragma mark --分享
        [cell buttonshared:^{
            //分享
            NSArray * imageArray;
            if ([model objectForKey:@"urlArray"]) {
                imageArray = [model objectForKey:@"urlArray"];
            }
            else{
                imageArray = nil;
            }
            [ShareView sharedWithImages:imageArray content:[model objectForKey:@"content"]];
        }];
        
#pragma mark --查看个人信息
        [cell tapPresent:^{
            PersonalViewController *PVC = [[PersonalViewController alloc] init];
            PVC.userInfo = [model objectForKey:@"user"];
            PVC.type = 1;
            [self presentViewController:PVC animated:YES completion:nil];
        }];

        return cell;

    }
    else{
        LaunchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LaunchTableViewCell class])];
        cell.obj = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell buttonCollection:^(NSInteger type) {
            if (type == 1) {
                
                [Collection CollectionWithID:model.objectId type:0 success:^(NSString *commentID) {
                    
                } failure:^(NSError *error1) {
                    
                }];
            }
            else if (type == 0){
                [Collection cancelCollectionWithID:model.objectId type:0 success:^(NSString *commentID) {
                    
                } failure:^(NSError *error1) {
                    
                }];
            }
        }];
        [cell buttonthumb:^(int type) {
            if (type == 1) {
                //点赞
                [ThumbUp thumUpWithID:model.objectId type:0 success:^(NSString *commentID) {
                } failure:^(NSError *error1) {
                    
                }];
            }
            else if (type == 0){
                //取消点赞
                [ThumbUp cancelThumUpWithID:model.objectId type:0 success:^(NSString *commentID) {
                } failure:^(NSError *error1) {
                    
                }];
            }
        }];

        return cell;
    }


   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BmobObject *obj = self.dataSource[indexPath.section];
     BmobObject * user = [obj objectForKey:@"user"];
    if (self.type == 1) {
        RecordDetailViewController * detail = [[RecordDetailViewController alloc]init];
        detail.travelObject = obj;
        detail.userObject = user;
        [self.navigationController pushViewController:detail animated:YES];
    }
    else{
        InitiateDetailViewController *IVC = [[InitiateDetailViewController alloc] init];
        IVC.calledID = obj.objectId;
        IVC.userObject = user;
        IVC.calledObject = obj;
        [self.navigationController pushViewController:IVC animated:YES];
    }
   
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
