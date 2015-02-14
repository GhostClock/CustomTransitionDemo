//
//  FirstViewController.m
//  CustomTransitionDemo
//
//  Created by YingshanDeng on 15/2/14.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "SwipeToPop.h"

@interface FirstViewController ()

@property (nonatomic, strong) SwipeToPop *naviDelegate;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"FirstVC";
    
    // navigation delegate
    self.naviDelegate = [[SwipeToPop alloc] initWithNavigationController:self.navigationController];
    self.navigationController.delegate = self.naviDelegate;
    
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.layer.bounds = CGRectMake(0, 0, 100, 50);
    btn.layer.position = CGPointMake(rect.size.width / 2, rect.size.height / 2);
    [btn setTitle:@"Click -- Push" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}


- (void)btnPressed:(UIButton *)btn
{
    SecondViewController *secondVC = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:secondVC animated:YES];
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

@end
