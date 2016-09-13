//
//  DetailViewController.m
//  i_就业
//
//  Created by 赵奎博 on 16/4/13.
//  Copyright © 2016年 赵奎博. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
{
    UIView * one;
    UIView * oneAdd;
    UIView * two;
    UIView * three;
    UIView * four;
    UIView * five;
}
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //左按钮
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 23, 25, 25)];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:[UIImage imageNamed:@"arrow_left_fff"] forState:0];
    [leftBtn setImage:[UIImage imageNamed:@"arrow_left_fff"] forState:UIControlStateSelected];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    if([self.type isEqualToString:@"1"]){
        self.title = @"实习心语详情";
    }
    else if ([self.type isEqualToString:@"2"]){
        self.title = @"职业测评详情";
    }
    else if ([self.type isEqualToString:@"3"]){
        self.title = @"个人简历";
    }
    else
    {
        self.title = @"详情";
    }
    
    if(self.myurl == nil){
        [self addWebView:self.item.link and:CGRectMake(0, 64, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT - 64)];
    }else{
        [self addWebView:self.myurl and:CGRectMake(0, 64, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT - 64)];
    }
    
    
    
    //[self initUI];

}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initUI{
    
    self.contentView.backgroundColor = DEF_RGB_COLOR(220, 220, 220);
    
    [self one];
    
    [self one_add];
    
    [self two];
    
    [self three];
    
    [self four];
    
    [self five];
    
    if(DEF_BOTTOM(five) + 20 + topHight > DEF_SCREEN_HEIGHT){
        self.contentView.contentSize = CGSizeMake(DEF_SCREEN_WIDTH, DEF_BOTTOM(five) + 20 + topHight);
    }
}

-(void)one{
    CGSize size1 = [self sizeOfStr:self.item.name andFont:[UIFont systemFontOfSize:15] andMaxSize:CGSizeMake(DEF_SCREEN_WIDTH - 80, 20000) andLineBreakMode:NSLineBreakByClipping];
    CGSize size2 = [self sizeOfStr:self.item.company andFont:[UIFont systemFontOfSize:15] andMaxSize:CGSizeMake(DEF_SCREEN_WIDTH - 80, 20000) andLineBreakMode:NSLineBreakByClipping];
    
    one = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, size1.height + size2.height + 60)];
    one.backgroundColor = [UIColor whiteColor];
    [self addSubview:one];
    
    UILabel * label_time = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, DEF_SCREEN_WIDTH - 100, 30)];
    [self Eleven_Set_label:label_time text:self.item.riqi textColor:[UIColor grayColor] fontSize:12 fontAlpha:1 textAlignment:1];
    [one addSubview:label_time];
    
    UILabel * label_name = [[UILabel alloc]initWithFrame:CGRectMake(20, DEF_BOTTOM(label_time), DEF_SCREEN_WIDTH - 100, size1.height + 10)];
    [self Eleven_Set_label:label_name text:self.item.name textColor:[UIColor blackColor] fontSize:17 fontAlpha:1 textAlignment:1];
    [one addSubview:label_name];
    
    UILabel * label_company = [[UILabel alloc]initWithFrame:CGRectMake(20, DEF_BOTTOM(label_name), DEF_SCREEN_WIDTH - 100, size2.height + 10)];
    [self Eleven_Set_label:label_company text:self.item.company textColor:[UIColor grayColor] fontSize:14 fontAlpha:1 textAlignment:1];
    [one addSubview:label_company];
    
    UILabel * label_salary = [[UILabel alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH - 80, 20, 60, 30)];
    [self Eleven_Set_label:label_salary text:[NSString stringWithFormat:@"%@",self.item.salary] textColor:[UIColor redColor] fontSize:17 fontAlpha:1 textAlignment:2];
    [one addSubview:label_salary];
}

-(void)one_add{
    oneAdd = [[UIView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(one) + 20, DEF_SCREEN_WIDTH, DEF_SCREEN_WIDTH / 2 + 40)];
    oneAdd.backgroundColor = [UIColor whiteColor];
    [self addSubview:oneAdd];
    
    UIImageView * image_one = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, DEF_SCREEN_WIDTH - 40, DEF_SCREEN_WIDTH / 2)];
    image_one.contentMode = UIViewContentModeScaleAspectFit;
    image_one.image = [UIImage imageNamed:@"BigOc"];
    [oneAdd addSubview:image_one];
}

-(void)two{
    CGSize size1 = [self sizeOfStr:self.item.des andFont:[UIFont systemFontOfSize:15] andMaxSize:CGSizeMake(DEF_SCREEN_WIDTH - 40, 20000) andLineBreakMode:NSLineBreakByClipping];
    
    
    two = [[UIView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(oneAdd) + 20, DEF_SCREEN_WIDTH, size1.height + 70)];
    two.backgroundColor = [UIColor whiteColor];
    [self addSubview:two];
    
    UIView * view = [self view_image:@"job_desc" title:@"职位描述"];
    [two addSubview:view];
    
    UILabel * label_des = [[UILabel alloc]initWithFrame:CGRectMake(20, DEF_BOTTOM(view) + 10, DEF_SCREEN_WIDTH - 20, size1.height)];
    [self Eleven_Set_label:label_des text:self.item.description textColor:[UIColor blackColor] fontSize:15 fontAlpha:1 textAlignment:1];
    [two addSubview:label_des];
    
}

-(void)three{
    CGSize size1 = [self sizeOfStr:self.item.ask andFont:[UIFont systemFontOfSize:15] andMaxSize:CGSizeMake(DEF_SCREEN_WIDTH - 20, 20000) andLineBreakMode:NSLineBreakByClipping];
    
    
    three = [[UIView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(two) + 20, DEF_SCREEN_WIDTH, size1.height + 70)];
    three.backgroundColor = [UIColor whiteColor];
    [self addSubview:three];
    
    UIView * view = [self view_image:@"job_ask" title:@"职位要求"];
    [three addSubview:view];
    
    UILabel * label_ask = [[UILabel alloc]initWithFrame:CGRectMake(20, DEF_BOTTOM(view) + 10, DEF_SCREEN_WIDTH - 40, size1.height)];
    [self Eleven_Set_label:label_ask text:self.item.ask textColor:[UIColor blackColor] fontSize:15 fontAlpha:1 textAlignment:1];
    [three addSubview:label_ask];
}

-(void)four{
    CGSize size1 = [self sizeOfStr:self.item.phone andFont:[UIFont systemFontOfSize:15] andMaxSize:CGSizeMake(DEF_SCREEN_WIDTH - 40, 20000) andLineBreakMode:NSLineBreakByClipping];
    
    
    four = [[UIView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(three) + 20, DEF_SCREEN_WIDTH, size1.height + 70)];
    four.backgroundColor = [UIColor whiteColor];
    [self addSubview:four];
    
    UIView * view = [self view_image:@"job_contact" title:@"联系方式"];
    [four addSubview:view];
    
    UILabel * label_rela = [[UILabel alloc]initWithFrame:CGRectMake(20, DEF_BOTTOM(view) + 10, DEF_SCREEN_WIDTH - 40, size1.height)];
    [self Eleven_Set_label:label_rela text:self.item.phone textColor:[UIColor blackColor] fontSize:15 fontAlpha:1 textAlignment:1];
    [four addSubview:label_rela];
}

-(void)five{
    five = [[UIView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(four) + 20, DEF_SCREEN_WIDTH, 90)];
    five.backgroundColor = [UIColor whiteColor];
    [self addSubview:five];
    
    UIButton * btn_bom = [UIButton buttonWithType:0];
    btn_bom.frame = CGRectMake(50, 20, DEF_SCREEN_WIDTH - 100, 50);
    [self Eleven_Set_Button:btn_bom setBackgroundColor:DEF_RGB_COLOR(79, 123, 230) setBackgroundImageNormal:nil setBackgroundImageHighlighted:nil setTitle:@"申请职位" setTitleFont:17 buttonTag:1 titleColor:[UIColor whiteColor]];
    btn_bom.layer.cornerRadius = 25;
    [btn_bom addTarget:self action:@selector(ApplyPosition) forControlEvents:UIControlEventTouchUpInside];
    [five addSubview:btn_bom];
}

-(void)ApplyPosition{

    NSLog(@"申请职位");

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


-(UIView *)view_image:(NSString *)image title:(NSString *)title{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(20, 0, DEF_SCREEN_WIDTH - 40, 50)];
    
    UIImageView * image_i = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 30,30)];
    image_i.image = [UIImage imageNamed:image];
    [view addSubview:image_i];
    
    UILabel * label_t = [[UILabel alloc]initWithFrame:CGRectMake(DEF_RIGHT(image_i) + 10, 0, DEF_SCREEN_WIDTH - 80 , 50)];
    [self Eleven_Set_label:label_t text:title textColor:[UIColor blackColor] fontSize:17 fontAlpha:1 textAlignment:1];
    [view addSubview:label_t];
    
    UILabel * label_line = [[UILabel alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(view) - 1, DEF_SCREEN_WIDTH - 40, 1)];
    label_line.backgroundColor = DEF_RGB_COLOR(200, 200, 200);
    [view addSubview:label_line];
    
    return view;
    
}

@end
