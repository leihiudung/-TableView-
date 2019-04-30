//
//  LingScrollView.m
//  000-tableview滚动遮住顶部按钮
//
//  Created by Tom-Li on 2019/4/29.
//  Copyright © 2019 litong. All rights reserved.
//

#import "LingScrollView.h"

//static const NSInteger ScreenWidth = UIScreen.mainScreen.bounds.size.width;

#define ScreenWidth UIScreen.mainScreen.bounds.size.width

@interface LingScrollView() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UITextField *textField1;
@property (nonatomic, strong) UIView *zipHeaderView;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NavBlock navBlock;

@property (nonatomic, strong) UIButton *revertBtn;
@end
@implementation LingScrollView

- (instancetype)initWithFrame:(CGRect)frame withBlock:(NavBlock)navBlock {
    
    if (self = [super initWithFrame:frame]) {
        [self initView];
        self.navBlock = navBlock;
        self.navBlock(1);
    }
    return self;
}

- (void)initView {
    
    UIView *adView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 305)];
    [adView setBackgroundColor:[UIColor yellowColor]];
    [self addSubview:adView];
    self.headerView = adView;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, self.bounds.size.height - 305 - 88)];

    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView setScrollEnabled:NO];
    [self.tableView setUserInteractionEnabled:NO];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.headerView.frame.size.height, UIScreen.mainScreen.bounds.size.width, self.bounds.size.height - 305)];
    [scrollView setBounces:NO];
    [scrollView setContentSize:CGSizeMake(UIScreen.mainScreen.bounds.size.width, self.bounds.size.height - 305 + 180)];
    [scrollView setBackgroundColor:[UIColor purpleColor]];
    [scrollView setDelegate:self];
    self.scrollView = scrollView;
    
    [scrollView addSubview:self.tableView];
    [self addSubview:scrollView];
    
    UIView *zipHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, [[UIApplication sharedApplication] statusBarFrame].size.height + 44)];
    [zipHeaderView setBackgroundColor:[UIColor blueColor]];
    [zipHeaderView setAlpha:0.0];
    self.zipHeaderView = zipHeaderView;
    [self addSubview:zipHeaderView];
    
    UIButton *tempBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 205, 60, 40)];
    [tempBtn setBackgroundColor:[UIColor redColor]];
    [self.headerView addSubview:tempBtn];
    self.btn1 = tempBtn;
    
    UITextField *tempField = [[UITextField alloc]initWithFrame:CGRectMake(10, 255, 60, 20)];
    [tempField setText:@"Hello"];
    [self.headerView addSubview:tempField];
    self.textField1 = tempField;
    
    UIButton *revertBtn = [[UIButton alloc]initWithFrame:CGRectMake((ScreenWidth - ScreenWidth * 0.5) / 2, CGRectGetMaxY(tempField.frame), ScreenWidth * 0.5, 44)];
    [revertBtn setTitle:@"回到起点" forState:UIControlStateNormal];//  = @"回到起点";
    [revertBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [revertBtn setAlpha:0.0];
    [self.headerView addSubview:revertBtn];
    self.revertBtn = revertBtn;
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat offsetY = scrollView.contentOffset.y;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat topY = scrollView.contentInset.bottom;
    NSLog(@"scrollViewDidScroll %f - %f", offsetY, topY);
    
    self.headerView.frame = CGRectMake(0, offsetY * -1, UIScreen.mainScreen.bounds.size.width, 305);
    
    if (offsetY <= 0) {

    } else if (offsetY > 0 && offsetY <= 88) {
        
        [self.zipHeaderView setAlpha:(offsetY / 88)];
        if (self.navBlock != nil) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LingViewNotification" object:nil userInfo:@{@"alphaValue": @(1 - offsetY / 88)}];
        }
        
        [self changeAlphaOfThoseView:offsetY];
        
    } else if (offsetY > 88) {
        [self.zipHeaderView setAlpha:1];
        
        self.textField1.alpha = 0;
        self.btn1.alpha = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LingViewNotification" object:nil userInfo:@{@"alphaValue": @0}];
    }

    if (offsetY <= self.headerView.frame.size.height && offsetY > 0) {
        if ([scrollView isKindOfClass:[UIScrollView class]]) {
            CGRect originTableFrame = self.tableView.frame;
            originTableFrame.origin.y = offsetY;
            originTableFrame.size.height = self.bounds.size.height - 88 - 305 + offsetY;
            
            self.tableView.frame = originTableFrame;
        }

        CGRect originScrollFrame = self.scrollView.frame;
        originScrollFrame.origin.y = self.headerView.frame.size.height - offsetY;
        self.scrollView.frame = originScrollFrame;
    }
    
}

- (void)changeAlphaOfThoseView:(CGFloat)offset {
    
    CGRect textRect = self.textField1.frame;
    textRect.origin.y = (255 + offset * 0.4);
    self.textField1.frame = textRect;
    self.textField1.alpha = 1 - offset / 88;
    
    CGRect btnRect = self.btn1.frame;
    btnRect.origin.y = (205 + offset * 0.4);
    self.btn1.frame = btnRect;
    self.btn1.alpha = 1 - offset / 88;
    
    CGRect revertRect = self.revertBtn.frame;
    self.revertBtn.alpha = offset / 88;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"Hi %ld", indexPath.row];
    return cell;
}

@end
