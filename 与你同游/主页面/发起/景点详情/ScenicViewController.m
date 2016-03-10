//
//  ScenicViewController.m
//  与你同游
//
//  Created by rimi on 15/10/22.
//  Copyright (c) 2015年 LiuCong. All rights reserved.
//

#import "ScenicViewController.h"
#import "LaunchViewScrollImage.h"
#import "SDWebImage/SDWebImageManager.h"
#import "LoadingView.h"
#import "InsetsLabel.h"
#import "AddActivityViewController.h"
#define SIZEHEIGHT frame.size.height

@interface ScenicViewController () <UIScrollViewDelegate>

@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)LaunchViewScrollImage *imageScrollView;

@property (nonatomic, strong)InsetsLabel *contentLabel;
@property (nonatomic, strong)UIButton *contentButton;

@property (nonatomic, strong)InsetsLabel *priceLabel;
@property (nonatomic, strong)UIButton *priceButton;

@property (nonatomic, strong)InsetsLabel *openTimeLabel;

@property (nonatomic, strong)InsetsLabel *addressLabel;

@property (nonatomic, strong)InsetsLabel *attentionLabel;
@property (nonatomic, strong)UIButton *attentionButton;

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) LoadingView *load;

@property (nonatomic, strong) NSMutableArray *userArray;
@property (nonatomic, strong) NSMutableArray *calledArray;
@end

@implementation ScenicViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUserInterface];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.load show];
}

- (void)initUserInterface {
    [self initBackButton];
    [self initNavTitle:@"白帝城"];
//    [self initRightButtonEvent:@selector(rightButtonEvent) Image:[UIImage imageNamed:@"添加游记"]];
    [self initRightButtonEvent:@selector(rightButtonEvent) Image:[UIImage imageNamed:@"添加游记"]];
    [self.view insertSubview:self.scrollView atIndex:0];
    
    [self.scrollView addSubview:self.imageScrollView];
    [self.scrollView addSubview:self.contentLabel];
    [self.scrollView addSubview:self.contentButton];
    
    [self.scrollView addSubview:self.priceLabel];
    [self.scrollView addSubview:self.priceButton];
    
    [self.scrollView addSubview:self.openTimeLabel];
    
    [self.scrollView addSubview:self.addressLabel];
    [self.scrollView addSubview:self.attentionLabel];
    [self.scrollView addSubview:self.attentionButton];
    
    
    UITapGestureRecognizer *contentTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentButtonEvent)];
    [self.contentLabel addGestureRecognizer:contentTapGesture];
    
    UITapGestureRecognizer *priceTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(priceButtonEvent)];
    [self.priceLabel addGestureRecognizer:priceTapGesture];
    
    UITapGestureRecognizer *attentionTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(attentionLabelEvent)];
    [self.attentionLabel addGestureRecognizer:attentionTapGesture];
    
    self.scrollView.contentSize = CGSizeMake(0, self.imageScrollView.SIZEHEIGHT + self.contentLabel.SIZEHEIGHT + self.priceLabel.SIZEHEIGHT + self.openTimeLabel.SIZEHEIGHT + self.addressLabel.SIZEHEIGHT + self.attentionButton.SIZEHEIGHT);
    
    [self arrayMethod];
    
}
- (void)rightButtonEvent {
    AddActivityViewController *addActive = [[AddActivityViewController alloc]init];
    addActive.destinationString = self.dataSource[@"name"];
    [self.navigationController pushViewController:addActive animated:YES];
}

- (void)SettingDatasource {
    [self initNavTitle:self.dataSource[@"name"]];
    
    [self.imageScrollView setUrlArray:self.imageArray];
    self.contentLabel.text = [NSString stringWithFormat:@"       %@", self.dataSource[@"content"]];
    self.openTimeLabel.text = [NSString stringWithFormat:@"开放时间：%@", self.dataSource[@"opentime"]];
    self.priceLabel.text = [NSString stringWithFormat:@"       价格：%@ \n       %@", self.dataSource[@"price"], self.dataSource[@"coupon"]];
    self.attentionLabel.text = [NSString stringWithFormat:@"       提示：%@", self.dataSource[@"attention"]];
    self.addressLabel.text = [NSString stringWithFormat:@"地址：%@", self.dataSource[@"address"]];
}


- (void)arrayMethod {
        if (self.dataSource[@"picList"] != NULL) {
            NSMutableArray *array = self.dataSource[@"picList"];
            if (array.count != 0) {
                [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if (idx < 10) {
                        SDWebImageManager *manager = [SDWebImageManager sharedManager];
                        [manager downloadImageWithURL:obj[@"picUrl"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if (image) {
                                [self.imageArray addObject:image];
                            }
                            if (finished) {
                                [self SettingDatasource];
                                [self.load hide];
                            }
                        }];
                    }
            }];
        }
    }
}

#pragma mark --contentlabel的开关

- (void)contentButtonEvent {
    if (_contentButton.selected == NO) {
        [self contentLabelOpen];
    }else {
        [self contentLabelOff];
    }
}

- (void)contentLabelOpen {
    _contentButton.selected = YES;
    CGRect frame = _contentLabel.frame;
    frame.size.height = flexibleHeight([self heightForString:_contentLabel.text fontSize:14 andWidth:flexibleHeight(340)]);
    _contentLabel.frame = frame;
    
    [self contentLabelSetting];

}

- (void)contentLabelSetting {
    _contentButton.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - flexibleHeight(15), CGRectGetMaxY(self.contentLabel.frame) - flexibleHeight(25), 10, 10);
    
    CGRect priceFrame = _priceLabel.frame;
    priceFrame.origin.y = _contentLabel.frame.origin.y + _contentLabel.frame.size.height;
    _priceLabel.frame = priceFrame;
    
    _priceButton.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - flexibleHeight(15), CGRectGetMaxY(self.priceLabel.frame) - flexibleHeight(25), 10, 10);
    
    _openTimeLabel.frame = CGRectMake(-1, _priceLabel.frame.origin.y + _priceLabel.frame.size.height, CGRectGetMaxX(self.view.frame) + 2, flexibleHeight(50));
    
    _addressLabel.frame = CGRectMake(-1, _openTimeLabel.frame.origin.y + _openTimeLabel.frame.size.height, CGRectGetMaxX(self.view.frame) + 2, flexibleHeight(50));
    
    CGRect attentionFrame = _attentionLabel.frame;
    attentionFrame.origin.y = _addressLabel.frame.origin.y + _addressLabel.frame.size.height;
    _attentionLabel.frame = attentionFrame;
    
    _attentionButton.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - flexibleHeight(15), CGRectGetMaxY(self.attentionLabel.frame) - flexibleHeight(25), 10, 10);
    
    self.scrollView.contentSize = CGSizeMake(0, self.imageScrollView.SIZEHEIGHT + self.contentLabel.SIZEHEIGHT + self.priceLabel.SIZEHEIGHT + self.openTimeLabel.SIZEHEIGHT + self.addressLabel.SIZEHEIGHT + self.attentionLabel.SIZEHEIGHT);
}


- (void)contentLabelOff {
    _contentButton.selected = NO;
    CGRect frame = _contentLabel.frame;
    frame.size.height = flexibleHeight(100);
    _contentLabel.frame = frame;
    
    [self contentLabelSetting];
    
    
}

#pragma priceLabel开关
- (void)priceButtonEvent {
    if (_priceButton.selected == NO) {
        [self priceLabelOpen];
    }else {
        [self priceLabelOff];
    }
}

- (void)priceLabelOpen {
    _priceButton.selected = YES;
    CGRect frame = _priceLabel.frame;
    frame.size.height = flexibleHeight([self heightForString:_priceLabel.text fontSize:14 andWidth:flexibleHeight(310)]);
    _priceLabel.frame = frame;
    
    [self contentLabelSetting];
    
}

- (void)priceLabelOff {
    _priceButton.selected = NO;
    CGRect frame = _priceLabel.frame;
    frame.size.height = flexibleHeight(50);
    _priceLabel.frame = frame;

    [self contentLabelSetting];
}

#pragma mark --attentionLabel开关

- (void)attentionLabelEvent {
    if (_attentionButton.selected == NO) {
        [self attentionLabelOpen];
    }else {
        [self attentionLabelOff];
    }
}

- (void)attentionLabelOpen {
    _attentionButton.selected = YES;
    CGRect frame = _attentionLabel.frame;
    frame.size.height = flexibleHeight([self heightForString:_attentionLabel.text fontSize:14 andWidth:flexibleHeight(340)]);
    _attentionLabel.frame = frame;
    
   _attentionButton.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - flexibleHeight(15), CGRectGetMaxY(self.attentionLabel.frame) - flexibleHeight(25), 10, 10);

    self.scrollView.contentSize = CGSizeMake(0, self.imageScrollView.SIZEHEIGHT + self.contentLabel.SIZEHEIGHT + self.priceLabel.SIZEHEIGHT + self.openTimeLabel.SIZEHEIGHT + self.addressLabel.SIZEHEIGHT + self.attentionLabel.SIZEHEIGHT);
}

- (void)attentionLabelOff {
    _attentionButton.selected = NO;
    CGRect frame = _attentionLabel.frame;
    frame.size.height = flexibleHeight(100);
    _attentionLabel.frame = frame;
    
    _attentionButton.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - flexibleHeight(15), CGRectGetMaxY(self.attentionLabel.frame) - flexibleHeight(25), 10, 10);
    
    self.scrollView.contentSize = CGSizeMake(0, self.imageScrollView.SIZEHEIGHT + self.contentLabel.SIZEHEIGHT + self.priceLabel.SIZEHEIGHT + self.openTimeLabel.SIZEHEIGHT + self.addressLabel.SIZEHEIGHT + self.attentionLabel.SIZEHEIGHT);
    
}

#pragma mark --scrollView 相关
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_imageScrollView openTimer];
    });
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_imageScrollView.totalNum > 1) {
        [_imageScrollView closeTimer];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_imageScrollView closeTimer];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (_imageScrollView.totalNum > 1) {
        [_imageScrollView openTimer];
    }
}

#pragma mark --scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat alpha = 1 - scrollView.contentOffset.y / 250;
    self.navView.alpha = alpha;
    self.leftButton.alpha = alpha;
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

#pragma mark --Url获取图片
- (UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = ({
            UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:flexibleFrame(CGRectMake(0, 22, WIDTH, HEIGHT - 22), NO)];
            scrollView.delegate = self;
            scrollView;
        });
    }
    return _scrollView;
}

- (LaunchViewScrollImage *)imageScrollView {
    if (!_imageScrollView) {
        _imageScrollView = ({
//            NSArray *addressArray = [NSArray arrayWithObjects:@"重庆" ,@"成都" ,@"北京" ,@"上海" , nil];
            LaunchViewScrollImage *imageView = [[LaunchViewScrollImage alloc]initWithFrame:flexibleFrame(CGRectMake(0, 0, WIDTH, 200), NO) AddressArray:nil];
            
            imageView.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
//            NSArray *imageArray = [NSArray arrayWithObjects:@"壁纸.jpg", @"壁纸2.jpg" ,@"壁纸3.jpg", @"", nil];
//            [imageView setArray:imageArray];
            imageView;
        });
    }
    return _imageScrollView;
}

- (InsetsLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = ({
            InsetsLabel *label = [[InsetsLabel alloc]init];
            label.textAlignment = NSTextAlignmentLeft;
            label.numberOfLines = 0;
            label.font = [UIFont boldSystemFontOfSize:14];
            label.textColor = [UIColor colorWithWhite:0.601 alpha:1.000];
            NSString *string = @"       奉节白帝城位于长江北岸，距奉节城东约15华里，掩映在郁郁葱葱的绿树丛中，是三峡的西口，入川的门户。由于地势险峻，古往今来，常为兵家必争之地。白帝城全景瞿塘峡夔门白帝城也是三峡游览胜地。西汉末年公孙述据蜀，在山上筑城，因城中一井常冒白气，宛如白龙，他便借此自号白帝，并名此城为白帝城。公孙述死后，当地人在山上建庙立公孙述像，称白帝庙。白帝城庙门刘备托孤白帝城三面环水，一面傍山，孤独峙，气象萧森，在雄伟险峻的夔门山水中，显得格外秀丽。从山脚下拾级而上，要攀登近千级石阶，才到达山顶的白帝庙门前。在这里可观赏夔门的雄壮气势。绕至庙后，可见蜿蜒秀丽的草堂河从白帝山下入江。风雨廊桥（夕阳）入城仪式活动白帝庙内有明良殿、武侯祠、观星亭等明清建筑。明良殿为嘉靖十二年建，系庙内主要建筑，内有刘备、关羽、张飞塑像。武侯祠内供诸葛亮祖孙三代像。祠前的观星亭，传说是诸葛亮夜观星象的地方。明良殿和武侯祠左右两侧藏有各代名碑。庙内还有文物陈列室、诗史堂，陈列着新石器时代以来的出土文物和古今名家的书画。新观星亭白帝城古炮台";
            label.text = string;
            label.layer.masksToBounds = YES;
            label.layer.borderColor = [UIColor colorWithWhite:0.800 alpha:1.000].CGColor;
            label.layer.borderWidth = 0.7;
            label.userInteractionEnabled = YES;
//                        label.backgroundColor = [UIColor redColor];
            label.backgroundColor = [UIColor colorWithWhite:1 alpha:1.000];
            label.frame = CGRectMake(-1, _imageScrollView.frame.origin.y + _imageScrollView.frame.size.height, CGRectGetMaxX(self.view.frame) + 2, flexibleHeight(100));
            [label setInsets:UIEdgeInsetsMake(flexibleHeight(12), flexibleHeight(7), flexibleHeight(12), flexibleHeight(10))];
            label;
        });
    }
    return _contentLabel;
}

- (UIButton *)contentButton {
    if (!_contentButton) {
        _contentButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"朝下箭头"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"朝上箭头"] forState:UIControlStateSelected];
            button.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - flexibleHeight(15), CGRectGetMaxY(self.contentLabel.frame) - flexibleHeight(25), 10, 10);
            button;
        });
    }
    return _contentButton;
}

- (InsetsLabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = ({
            InsetsLabel *label = [[InsetsLabel alloc]init];
            label.textAlignment = NSTextAlignmentLeft;
            label.numberOfLines = 0;
            label.font = [UIFont boldSystemFontOfSize:14];
            label.textColor = [UIColor colorWithWhite:0.601 alpha:1.000];
            NSString *string = @"       价格：92元\nA.免费政策：儿童身高 1.2米(不含)以下，残疾证、军残证免票。\nA.优惠政策：儿童票身高1.2(含)-1.4米(不含)之间，身高1.4米以上学生持学生证，70岁以上持老年证或身份证，军官证（现役军人）、记者证均可享受优惠票。（具体优惠以当地售票窗口为准）";
            label.text = string;
            label.layer.masksToBounds = YES;
            label.layer.borderColor = [UIColor colorWithWhite:0.800 alpha:1.000].CGColor;
            label.layer.borderWidth = 0.7;
            label.userInteractionEnabled = YES;
            //                        label.backgroundColor = [UIColor redColor];
            label.backgroundColor = [UIColor colorWithWhite:1 alpha:1.000];
            label.frame = CGRectMake(-1, _contentLabel.frame.origin.y + _contentLabel.frame.size.height, CGRectGetMaxX(self.view.frame) + 2, flexibleHeight(50));
            [label setInsets:UIEdgeInsetsMake(flexibleHeight(12), flexibleHeight(7), flexibleHeight(12), flexibleHeight(10))];
            label;
        });
    }
    return _priceLabel;
}

- (UIButton *)priceButton {
    if (!_priceButton) {
        _priceButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"朝下箭头"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"朝上箭头"] forState:UIControlStateSelected];
            button.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - flexibleHeight(15), CGRectGetMaxY(self.priceLabel.frame) - flexibleHeight(25), 10, 10);
            button;
        });
    }
    return _priceButton;
}

- (InsetsLabel *)openTimeLabel {
    if (!_openTimeLabel) {
        _openTimeLabel = ({
            InsetsLabel *label = [[InsetsLabel alloc]init];
            label.textAlignment = NSTextAlignmentLeft;
            label.numberOfLines = 0;
            label.font = [UIFont boldSystemFontOfSize:14];
            label.textColor = [UIColor colorWithWhite:0.601 alpha:1.000];
            NSString *string = @"开放时间：6:30—18:00";
            label.text = string;
            label.layer.masksToBounds = YES;
            label.layer.borderColor = [UIColor colorWithWhite:0.800 alpha:1.000].CGColor;
            label.layer.borderWidth = 0.7;
            label.userInteractionEnabled = YES;
            //                        label.backgroundColor = [UIColor redColor];
            label.backgroundColor = [UIColor whiteColor];
            label.frame = CGRectMake(-1, _priceLabel.frame.origin.y + _priceLabel.frame.size.height, CGRectGetMaxX(self.view.frame) + 2, flexibleHeight(50));
            [label setInsets:UIEdgeInsetsMake(flexibleHeight(12), flexibleHeight(36), flexibleHeight(12), flexibleHeight(10))];
            label;
        });
    }
    return _openTimeLabel;
}

- (InsetsLabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = ({
            InsetsLabel *label = [[InsetsLabel alloc]init];
            label.textAlignment = NSTextAlignmentLeft;
            label.numberOfLines = 0;
            label.font = [UIFont boldSystemFontOfSize:14];
            label.textColor = [UIColor colorWithWhite:0.601 alpha:1.000];
            NSString *string = @"地址：重庆市奉节县宝塔坪瞿塘峡口长江北岸";
            label.text = string;
            label.layer.masksToBounds = YES;
            label.layer.borderColor = [UIColor colorWithWhite:0.800 alpha:1.000].CGColor;
            label.layer.borderWidth = 0.7;
            label.userInteractionEnabled = YES;
            //                        label.backgroundColor = [UIColor redColor];
            label.backgroundColor = [UIColor whiteColor];
            label.frame = CGRectMake(-1, _openTimeLabel.frame.origin.y + _openTimeLabel.frame.size.height, CGRectGetMaxX(self.view.frame) + 2, flexibleHeight(50));
            [label setInsets:UIEdgeInsetsMake(flexibleHeight(12), flexibleHeight(36), flexibleHeight(12), flexibleHeight(10))];
            label;
        });
    }
    return _addressLabel;
}

- (InsetsLabel *)attentionLabel {
    if (!_attentionLabel) {
        _attentionLabel = ({
            InsetsLabel *label = [[InsetsLabel alloc]init];
            label.textAlignment = NSTextAlignmentLeft;
            label.numberOfLines = 0;
            label.font = [UIFont boldSystemFontOfSize:14];
            label.textColor = [UIColor colorWithWhite:0.601 alpha:1.000];
            NSString *string = @"        提示：a．旺季：3月1日—10月底；淡季：11月1日—2月底。\nb．门票当天有效，出园需入园，需再次购票，预订时请填写准确的出游日期。\nc．门票说明：门票仅包含奉节白帝城景区门票（含古象馆门票、渡船）不含画舫游船。渡船：景区内的项目，8:00—17:30，每半小时一班船，因天气等其他原因影响，如有变动需根据景区安排。详情参见景区通告！\nd．为保证取票、入园顺利，预订时请务必填写真实姓名、手机号码等信息。\n【画舫游船】①游船发班时间随时，全程游览约一个小时。②儿童身高1.2米以下免船票。③由于景区要求，为保证您取票顺利，请带上身份证（一张订单一个手机号码对应一张身份证）。④门票当天有效，出园需入园，需再次购票，预订时请填写准确的出游日期。⑤为保证取票、入园顺利，预订时请务必填写真实姓名、手机号码等信息。";
            label.text = string;
            label.layer.masksToBounds = YES;
            label.layer.borderColor = [UIColor colorWithWhite:0.800 alpha:1.000].CGColor;
            label.layer.borderWidth = 0.7;
            label.userInteractionEnabled = YES;
            //                        label.backgroundColor = [UIColor redColor];
            label.backgroundColor = [UIColor whiteColor];
            label.frame = CGRectMake(-1, _addressLabel.frame.origin.y + _addressLabel.frame.size.height, CGRectGetMaxX(self.view.frame) + 2, flexibleHeight(100));
            [label setInsets:UIEdgeInsetsMake(flexibleHeight(12), flexibleHeight(7), flexibleHeight(12), flexibleHeight(10))];
            label;
        });
    }
    return _attentionLabel;
}

- (UIButton *)attentionButton {
    if (!_attentionButton) {
        _attentionButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"朝下箭头"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"朝上箭头"] forState:UIControlStateSelected];
            button.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - flexibleHeight(15), CGRectGetMaxY(self.attentionLabel.frame) - flexibleHeight(25), 10, 10);
            button;
        });
    }
    return _attentionButton;
}

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc]init];
    }
    return _imageArray;
}

- (LoadingView *)load {
    if (!_load) {
        _load = [[LoadingView alloc]init];
    }
    return _load;
}

- (NSMutableArray *)userArray {
    if (!_userArray) {
        _userArray = [NSMutableArray array];
    }
    return _userArray;
}

- (NSMutableArray *)calledArray {
    if (!_calledArray) {
        _calledArray = [NSMutableArray array];
    }
    return _calledArray;
}
@end
