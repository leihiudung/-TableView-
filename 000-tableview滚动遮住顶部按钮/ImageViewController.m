//
//  ImageViewController.m
//  000-tableview滚动遮住顶部按钮
//
//  Created by Tom-Li on 2019/4/25.
//  Copyright © 2019 litong. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shenzhen"]];
//    [self.view addSubview:self.imageView];
    

    self.scrollView = [[UIScrollView alloc]initWithFrame:UIScreen.mainScreen.bounds];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(1600, 900)];
    
    [self.scrollView setContentInset:UIEdgeInsetsMake(10, 0, 60, 20)];
    
}


@end
















