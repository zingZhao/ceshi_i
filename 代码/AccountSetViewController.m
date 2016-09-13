//
//  AccountSetViewController.m
//  i_就业
//
//  Created by 赵奎博 on 16/4/25.
//  Copyright © 2016年 赵奎博. All rights reserved.
//

#import "AccountSetViewController.h"
#import "ViewController.h"
#import "EMSDK.h"
@interface AccountSetViewController ()<UIAlertViewDelegate,UITextFieldDelegate>
{
    UITextField * acount;
    UITextField * name;
    UITextField * password;
    UITextField * email;
}
@end

@implementation AccountSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:@"suc" object:nil];

    //左按钮
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 23, 25, 25)];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:[UIImage imageNamed:@"arrow_left_fff"] forState:0];
    [leftBtn setImage:[UIImage imageNamed:@"arrow_left_fff"] forState:UIControlStateSelected];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    UIButton * btn_out = [UIButton buttonWithType:0];
    btn_out.frame = CGRectMake(0, 23, 40, 40);
    [self Eleven_Set_Button:btn_out setBackgroundColor:nil setBackgroundImageNormal:nil setBackgroundImageHighlighted:nil setTitle:@"注销" setTitleFont:16 buttonTag:1 titleColor:[UIColor whiteColor]];
    [btn_out addTarget:self action:@selector(out_account) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * itemr = [[UIBarButtonItem alloc]initWithCustomView:btn_out];
    self.navigationItem.rightBarButtonItem = itemr;
    self.title = @"账号设置";

    self.view.backgroundColor = DEF_RGB_COLOR(230, 230, 230);
    self.contentView.backgroundColor = DEF_RGB_COLOR(230, 230, 230);
    [self initUI];
}

-(void)initUI{
    
    acount = [[UITextField alloc]init];
    acount.tag = 0;
    name = [[UITextField alloc]init];
    name.tag = 1;
    name.delegate = self;
    password = [[UITextField alloc]init];
    password.tag = 2;
    password.delegate = self;
    email = [[UITextField alloc]init];
    email.tag = 3;
    email.delegate = self;
    
    UIView * view_acount = [self newAView_title:@"账号：" frame:CGRectMake(0, 20, DEF_SCREEN_WIDTH, 50) testFiled:acount];
    acount.userInteractionEnabled = NO;
    [self.contentView addSubview:view_acount];
    
    UIView * view_name = [self newAView_title:@"昵称：" frame:CGRectMake(0, 100, DEF_SCREEN_WIDTH, 50) testFiled:name];
    [self.contentView addSubview:view_name];
    
    UIView * view_passworld = [self newAView_title:@"密码：" frame:CGRectMake(0, 180, DEF_SCREEN_WIDTH, 50) testFiled:password];
    password.secureTextEntry = YES;
    [self.contentView addSubview:view_passworld];
    
    UIView * view_email = [self newAView_title:@"邮箱：" frame:CGRectMake(0, 260, DEF_SCREEN_WIDTH, 50) testFiled:email];
    [self.contentView addSubview:view_email];
    
    UIButton * btn_save = [UIButton buttonWithType:0];
    btn_save.frame = CGRectMake(20, 370, DEF_SCREEN_WIDTH - 40, 50);
    [self Eleven_Set_Button:btn_save setBackgroundColor:NAVColor setBackgroundImageNormal:nil setBackgroundImageHighlighted:nil setTitle:@"保存个人信息" setTitleFont:20 buttonTag:1 titleColor:[UIColor whiteColor]];
    [btn_save addTarget:self action:@selector(asveUserChange) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn_save];
    
    if(DEF_SCREEN_HEIGHT < 450 + topHight){
        self.contentView.contentSize = CGSizeMake(DEF_SCREEN_WIDTH, 450 + topHight);
    }
    
    acount.text = [self.userDefaults objectForKey:@"code"];
    name.text = [self.userDefaults objectForKey:@"nick"];
    password.text = [self.userDefaults objectForKey:@"pass"];
    email.text = [self.userDefaults objectForKey:@"email"];
}

-(void)refresh{
    acount.text = [self.userDefaults objectForKey:@"code"];
    name.text = [self.userDefaults objectForKey:@"nick"];
    password.text = [self.userDefaults objectForKey:@"pass"];
    email.text = [self.userDefaults objectForKey:@"email"];
    
    //page = 0;
}

-(void)out_account{
    NSLog(@"退出");
    
    UIAlertView * al = [[UIAlertView alloc]initWithTitle:@"是否确认退出" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    al.delegate = self;
    [al show];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        [self.userDefaults setObject:@"" forKey:@"uid"];
        [self.userDefaults setObject:@"" forKey:@"code"];
        [self.userDefaults setObject:@"" forKey:@"name"];
        [self.userDefaults setObject:@"" forKey:@"nick"];
        [self.userDefaults setObject:@""forKey:@"email"];
        [self.userDefaults setObject:@"" forKey:@"pass"];
        [self.userDefaults setObject:@"" forKey:@"user"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            EMError *error = [[EMClient sharedClient] logout:YES];
            if (!error) {
                NSLog(@"退出成功");
            }else{
                NSLog(@"失败----\n%@",error.errorDescription);
            }
        });
        
        ViewController * vvc = [[ViewController alloc]init];
        vvc.ismodel = YES;
        [self presentModalViewController:vvc animated:YES];
        
        
    }
}

-(void)asveUserChange{
    
    
    if([name.text isEqualToString:[self.userDefaults objectForKey:@"nick"]] && [password.text isEqualToString:[self.userDefaults objectForKey:@"pass"]] && [email.text isEqualToString:[self.userDefaults objectForKey:@"email"]]){
        [self showString:@"您未做任何修改"];
        return;
    }
    
    if([self stringIsToNull:acount.text] && [self stringIsToNull:name.text] && [self stringIsToNull:password.text] && [self stringIsToNull:email.text]){
        NSLog(@"save");
        
        [self PostDataSource:[NSString stringWithFormat:@"%@%@",URL_url,URL_save] Params:[NSString stringWithFormat:@"tid=%@&nick=%@&pwd=%@&email=%@&code=%@",[self.userDefaults objectForKey:@"uid"],name.text,password.text,email.text,acount.text] success:^(NSDictionary *json) {
            
            [self showString:@"修改成功"];
            
            [self.userDefaults setObject:name.text forKey:@"nick"];
            [self.userDefaults setObject:email.text forKey:@"email"];
            [self.userDefaults setObject:password.text forKey:@"pass"];
            
            [self refresh];
            
        } fail:^{
            
        }];
        
    }else{
        [self showString:@"请将信息填写完整"];
    }
    
    
}

-(UIView *)newAView_title:(NSString *)title frame:(CGRect)frame testFiled:(UITextField *)testfiled{
    UIView * view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 60, 50)];
    [self Eleven_Set_label:label text:title textColor:[UIColor blackColor] fontSize:20 fontAlpha:1 textAlignment:1];
    [view addSubview:label];
    
    testfiled.frame = CGRectMake(DEF_RIGHT(label), 0, DEF_WIDTH(view) - 120, 50);
    testfiled.textAlignment = NSTextAlignmentRight;
    testfiled.textColor = [UIColor grayColor];
    [view addSubview:testfiled];
    
    UIImageView * image_enter = [[UIImageView alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH - 30, 10, 20, 30)];
    image_enter.image = [UIImage imageNamed:@"57.jpg"];
    [view addSubview:image_enter];
    
    return view;
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
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField.tag == 1) {
        [password becomeFirstResponder];
    }
    if (theTextField.tag == 2) {
        [email becomeFirstResponder];
    }
    if (theTextField.tag == 3) {
        [email resignFirstResponder];
    }
    return YES;
}
@end
