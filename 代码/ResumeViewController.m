//
//  ResumeViewController.m
//  i_就业
//
//  Created by 赵奎博 on 16/4/25.
//  Copyright © 2016年 赵奎博. All rights reserved.
//

#import "ResumeViewController.h"
#import "ResumeListViewController.h"
#import "SchComViewController.h"
#import "QGJXViewController.h"
@interface ResumeViewController ()

@end

@implementation ResumeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = DEF_RGB_COLOR(230, 230, 230);

    [self initUI];
}

-(void)initUI{
    NSArray * array = @[@"职位信息",@"校企合作",@"勤工俭学"];
    NSArray * array_image = @[@"tab2_menu1",@"tab2_menu2",@"tab2_menu3"];
    
    for (int i=0;i < 3; i++) {
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
            ResumeListViewController * rvc = [[ResumeListViewController alloc]init];
            [self.navigationController pushViewController:rvc animated:YES];
        }
            break;
        case 1:
        {
            SchComViewController * rvc = [[SchComViewController alloc]init];
            [self.navigationController pushViewController:rvc animated:YES];
        }
            break;
        case 2:
        {
            QGJXViewController * qvc = [[QGJXViewController alloc]init];
            [self.navigationController pushViewController:qvc animated:YES];
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
