//
//  ContentController.m
//  000-tableview滚动遮住顶部按钮
//
//  Created by Tom-Li on 2019/4/25.
//  Copyright © 2019 litong. All rights reserved.
//

#import "ContentController.h"

@interface ContentController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIButton *tempBtn;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIView *zipHeaderView;

@end

@implementation ContentController

- (void)loadView {
    [super loadView];

    // 设置navigationBar为不透明时,view不会下移
    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIView *adView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 305)];
    [adView setBackgroundColor:[UIColor yellowColor]];
    [self.view addSubview:adView];
    self.headerView = adView;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.headerView.frame.size.height, UIScreen.mainScreen.bounds.size.width, self.view.bounds.size.height - 305)];
    [self.view addSubview:self.tableView];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
    
    UIView *zipHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 88)];
    [zipHeaderView setBackgroundColor:[UIColor blueColor]];
    [zipHeaderView setAlpha:0.0];
    self.zipHeaderView = zipHeaderView;
    [self.view addSubview:zipHeaderView];
    
    UIButton *tempBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 205, 60, 40)];
    [tempBtn setBackgroundColor:[UIColor redColor]];
    [self.headerView addSubview:tempBtn];
    self.tempBtn = tempBtn;
    
    UITextField *tempField = [[UITextField alloc]initWithFrame:CGRectMake(10, 255, 60, 20)];
    [tempField setText:@"Hello"];
    [self.headerView addSubview:tempField];
    self.textField = tempField;
    
    // scrollview滚动条的位置
//    [self.tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]initWithFrame:CGRectMake(0, 0, 0, 60)];
    [refreshControl setContentMode:UIViewContentModeCenter];
    [self.tableView setRefreshControl:refreshControl];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"done %f", offsetY);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat topY = scrollView.contentInset.bottom;
    NSLog(@"scrollViewDidScroll %f - %f", offsetY, topY);
    
    self.headerView.frame = CGRectMake(0, offsetY * -1, UIScreen.mainScreen.bounds.size.width, 305);
    
    
//    self.tableView.contentOffset = CGPointMake(0, offsetY);
    
    if (offsetY <= 0) {
//        [self.navigationController.navigationBar setAlpha:1];
    } else if (offsetY > 0 && offsetY <= 88) {
        
        
        [self.zipHeaderView setAlpha:(offsetY / 88)];
        [self.navigationController.navigationBar setAlpha:(1 - offsetY / 88)];

        [self changeAlphaOfThoseView:offsetY];
        
        NSLog(@"%f==%f", offsetY * -1, self.headerView.frame.size.height - offsetY);
    } else if (offsetY > 88) {
        [self.zipHeaderView setAlpha:1];
        [self.navigationController.navigationBar setAlpha:0];
        
    }
    
    if (offsetY <= (self.headerView.frame.size.height - 88) && offsetY > 0) {
        CGRect originTableFrame = self.tableView.frame;
        originTableFrame.origin.y = self.headerView.frame.size.height - offsetY;
        originTableFrame.size.height = self.view.bounds.size.height - 83 - 305 +offsetY;
        
        NSLog(@"这是高度值:%f", self.view.bounds.size.height - 88 - 83 - 305 +offsetY);
        self.tableView.frame = originTableFrame;
    }
    
}

- (void)changeAlphaOfThoseView:(CGFloat)offset {
    
    CGRect textRect = self.textField.frame;
    textRect.origin.y = (255 - offset * 0.6);
    self.textField.frame = textRect;
    self.textField.alpha = 1 - offset / 88;
    
    CGRect btnRect = self.tempBtn.frame;
    btnRect.origin.y = (205 - offset * 0.6);
    self.tempBtn.frame = btnRect;
    self.tempBtn.alpha = 1 - offset / 88;
    
    NSLog(@"嫦娥%f", offset);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    cell.textLabel.text = @"Hi";
    
    return cell;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.headerView.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 305);
}
@end
