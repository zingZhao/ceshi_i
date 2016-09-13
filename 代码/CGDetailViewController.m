//
//  CGDetailViewController.m
//  i_就业
//
//  Created by 赵奎博 on 16/7/11.
//  Copyright © 2016年 赵奎博. All rights reserved.
//

#import "CGDetailViewController.h"
#import "HTmlViewController.h"
@interface CGDetailViewController ()

@end

@implementation CGDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    //左按钮
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 23, 25, 25)];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:[UIImage imageNamed:@"arrow_left_fff"] forState:0];
    [leftBtn setImage:[UIImage imageNamed:@"arrow_left_fff"] forState:UIControlStateSelected];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = item;
    if([self.type isEqualToString:@"5"]){
        self.title = @"升学指导详情";
    }
    else if([self.type isEqualToString:@"4"])
    {
        self.title = @"就业指导详情";
    }
    else
    {
        self.title = @"详情";
    }
    
    [self initUI];

}

-(void)initUI{
    UIImageView * image_top = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, DEF_SCREEN_WIDTH - 40, DEF_SCREEN_WIDTH /2)];
    [image_top sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",image_head,self.item.img]]placeholderImage:[UIImage imageNamed:@"BigOc"]];
    image_top.contentMode = UIViewContentModeScaleAspectFit;
    image_top.userInteractionEnabled = YES;
    [self addSubview:image_top];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_image)];
    [image_top addGestureRecognizer:tap];
    
//    UILabel * label_hint = [[UILabel alloc]initWithFrame:CGRectMake(20, DEF_BOTTOM(image_top), DEF_WIDTH(image_top), 20)];
//    [self Eleven_Set_label:label_hint text:@"点击图片查看大图" textColor:DEF_RGB_COLOR(200, 200, 200) fontSize:13 fontAlpha:1 textAlignment:3];
//    [self addSubview:label_hint];
    
    
    UILabel * label_line = [[UILabel alloc]initWithFrame:CGRectMake(10, DEF_BOTTOM(image_top) + 10, DEF_SCREEN_WIDTH - 20, 1)];
    label_line.backgroundColor = DEF_RGB_COLOR(200, 200, 200);
    [self addSubview:label_line];
    
    CGSize size_content = [self sizeOfStr:self.item.mydescription andFont:[UIFont systemFontOfSize:15] andMaxSize:CGSizeMake(DEF_SCREEN_WIDTH - 40, MAXFLOAT) andLineBreakMode:NSLineBreakByClipping];
    UILabel * label_content = [[UILabel alloc]initWithFrame:CGRectMake(20, DEF_BOTTOM(label_line) + 10, DEF_SCREEN_WIDTH - 40, size_content.height)];
    [self Eleven_Set_label:label_content text:self.item.mydescription textColor:[UIColor grayColor] fontSize:15 fontAlpha:1 textAlignment:1];
    [self addSubview:label_content];
    
    UIButton * btn_bom = [UIButton buttonWithType:0];
    btn_bom.frame = CGRectMake(50, DEF_BOTTOM(label_content) + 40, DEF_SCREEN_WIDTH - 100, 50);
    [self Eleven_Set_Button:btn_bom setBackgroundColor:DEF_RGB_COLOR(79, 123, 230) setBackgroundImageNormal:nil setBackgroundImageHighlighted:nil setTitle:@"我要报名" setTitleFont:17 buttonTag:1 titleColor:[UIColor whiteColor]];
    btn_bom.layer.cornerRadius = 25;
    [btn_bom addTarget:self action:@selector(baoming) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn_bom];
    
    self.contentView.contentSize = CGSizeMake(DEF_SCREEN_WIDTH, DEF_BOTTOM(btn_bom) + 40);
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = DEF_RGB_COLOR(230, 230, 230);
}
                                    
-(void)tap_image{
//    HTmlViewController * hvc = [[HTmlViewController alloc]init];
//    hvc.url_my = [NSString stringWithFormat:@"%@%@",image_head,self.item.img];
//    [self.navigationController pushViewController:hvc animated:YES];
}

-(void)baoming{
    NSLog(@"点击报名");
    UIAlertView * al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否报名" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [al show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        NSDictionary * params = @{@"studentId":[self.userDefaults objectForKey:@"uid"],@"infoId":self.item.tid};
        
        NSLog(@"报名");
        [self getDataSource:[NSString stringWithFormat:@"%@%@",URL_url,URL_addEnrollApp] Params:params success:^(NSDictionary *json) {
            
            [self showString:@"报名成功"];
            //[self.navigationController popViewControllerAnimated:YES];
            
        } fail:^{
            
        }];
    }
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
