//
//  ViewController.m
//  RAYBannerScrollView
//
//  Created by richerpay on 15/6/2.
//  Copyright (c) 2015年 richerpay. All rights reserved.
//

#import "ViewController.h"
#import "RAYBannerScrollView.h"
#import "RAYScrollView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    RAYBannerScrollView *bannerScrollView = [[RAYBannerScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height*2/5)];
//    
//    [bannerScrollView initImageWithArray:@[@"1.jpg",@"2.jpg",@"3.jpg",
//                                           @"4.jpg"]];
//    
//    
//    [self.view addSubview:bannerScrollView];//
    
    RAYScrollView *scrollView = [[RAYScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height*2/5)];
    [self.view addSubview:scrollView];

    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height*2/5, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height*3/5) style:UITableViewStylePlain];
    
    //[[UITableView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height*2/5, [UIScreen mainScreen].bounds.size.width, [[UIScreen mainScreen].bounds.size.height*3/5) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
