//
//  MeViewController.m
//  i_就业
//
//  Created by 赵奎博 on 16/4/25.
//  Copyright © 2016年 赵奎博. All rights reserved.
//

#import "MeViewController.h"
#import "AccountSetViewController.h"
#import "PositionViewController.h"
#import "ApplyViewController.h"
#import "DetailViewController.h"
@interface MeViewController ()

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = DEF_RGB_COLOR(230, 230, 230);
    
    [self initUI];
}

-(void)initUI{//,@"留言板",@"tab4_menu4"
    NSArray * array = @[@"账号设置",@"个人简历",@"申请记录",@"报名记录"];
    NSArray * array_image = @[@"tab4_menu1",@"tab4_menu2",@"tab4_menu3",@"tab4_menu4"];
    
    for (int i=0;i < array.count; i++) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 80 + i * 70, DEF_SCREEN_WIDTH, 50)];
        view.backgroundColor = [UIColor whiteColor];
        view.userInteractionEnabled = YES;
        view.tag = i;
        [self.view addSubview:view];
        
        UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 30, 30)];
        image.contentMode = UIViewContentModeScaleAspectFit;
        image.image = [UIImage imageNamed:array_image[i]];
        image.userInteractionEnabled = YES;
        [view addSubview:image];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(DEF_RIGHT(image) + 10, 0, DEF_SCREEN_WIDTH - DEF_X(image) - 60, 50)];
        [self Eleven_Set_label:label text:array[i] textColor:[UIColor blackColor] fontSize:16 fontAlpha:1 textAlignment:1];
        label.userInteractionEnabled = YES;
        [view addSubview:label];
        
        UIImageView * imag = [[UIImageView alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH - 30, 10, 20, 30)];
        imag.contentMode = UIViewContentModeScaleAspectFit;
        imag.image = [UIImage imageNamed:@"arrow_right_dbdbdb"];
        imag.userInteractionEnabled = YES;
        [view addSubview:imag];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tabAction:)];
        [view addGestureRecognizer:tap];
    }
}

-(void)tabAction:(UITapGestureRecognizer *)tap{
    switch (tap.view.tag) {
        case 0:
        {
            AccountSetViewController * avc = [[AccountSetViewController alloc]init];
            [self.navigationController pushViewController:avc animated:YES];
        }
            break;
        case 1:
        {
            DetailViewController * dvc = [[DetailViewController alloc]init];
            dvc.myurl = [NSString stringWithFormat:@"http://www.shminde.com:9090/smly/resume/index.php?u=%@",[self.userDefaults objectForKey:@"code"]];
            dvc.type = @"3";
            [self.navigationController pushViewController:dvc animated:YES];
            
        }
            break;
        case 2:
        {
            PositionViewController * pvc = [[PositionViewController alloc]init];
            [self.navigationController pushViewController:pvc animated:YES];
        }
            break;
            
        case 3:
        {
            ApplyViewController * avc = [[ApplyViewController alloc]init];
            [self.navigationController pushViewController:avc animated:YES];
        }
            break;
            
        case 4:
        {
            
        }
            break;
            
        default:
            break;
    }
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
