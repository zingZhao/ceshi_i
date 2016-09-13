//
//  HTmlViewController.m
//  i_就业
//
//  Created by 赵奎博 on 16/8/15.
//  Copyright © 2016年 赵奎博. All rights reserved.
//

#import "HTmlViewController.h"

@interface HTmlViewController ()

@end

@implementation HTmlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"图片详情";
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 23, 25, 25)];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:[UIImage imageNamed:@"arrow_left_fff"] forState:0];
    [leftBtn setImage:[UIImage imageNamed:@"arrow_left_fff"] forState:UIControlStateSelected];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = item;

//    [self addWebView:self.url_my and:CGRectMake(0, 64, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT - 64)];
    
    UIImageView * image_ima = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT - 64)];
    image_ima.contentMode = UIViewContentModeScaleAspectFit;
    [image_ima sd_setImageWithURL:[NSURL URLWithString:self.url_my]];
    [self.view addSubview:image_ima];

}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
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
