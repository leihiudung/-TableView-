//
//  UsedViewContentViewController.m
//  000-tableview滚动遮住顶部按钮
//
//  Created by Tom-Li on 2019/4/29.
//  Copyright © 2019 litong. All rights reserved.
//

#import "UsedViewContentViewController.h"
#import "LingScrollView/LingScrollView.h"

@interface UsedViewContentViewController ()

@property (nonatomic, strong) LingScrollView *lingScrollView;

@property (nonatomic, assign) NavBlock navBlock;
@end

@implementation UsedViewContentViewController

- (void)loadView {
    [super loadView];
    
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    __block typeof(self) weakSelf = self;
    self.navBlock = ^(CGFloat alphaValue) {
//        [weakSelf doexec];
        NSLog(@"alpha 值 %f", alphaValue);
    };
    self.lingScrollView = [[LingScrollView alloc]initWithFrame:self.view.bounds withBlock:self.navBlock];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doexec:) name:@"LingViewNotification" object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:_lingScrollView];
}

- (void)doexec:(NSNotification *)notification {
    CGFloat alphaValue = [notification.userInfo[@"alphaValue"] floatValue];
    [self.navigationController.navigationBar setAlpha:alphaValue];
}

@end
