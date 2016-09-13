//
//  ViewController.m
//  i_就业
//
//  Created by 赵奎博 on 16/4/13.
//  Copyright © 2016年 赵奎博. All rights reserved.
//

#import "ViewController.h"
#import "Eleven_Header.h"
#import "BaseScrollView.h"
#import "ZKB_TabarViewController.h"
#import "EMSDK.h"
//#import "JSONKit.h"
@interface ViewController ()<UITextFieldDelegate>{
    UITextField * name;
    UITextField * passworld;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navView removeFromSuperview];
    self.contentView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT);
    
    CGFloat hei;
    if(DEF_SCREEN_HEIGHT < 500){
        hei = DEF_SCREEN_HEIGHT * 0.08;
    }
    else
    {
        hei = DEF_SCREEN_HEIGHT * 0.15;
    }
    
    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH * 0.2, hei, DEF_SCREEN_WIDTH * 0.6, DEF_SCREEN_WIDTH * 0.6 )];
    image.image = [UIImage imageNamed:@"2"];
    image.userInteractionEnabled = YES;
    [self.contentView addSubview:image];
    
    

    name = [[UITextField alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH * 0.15 + 20, DEF_BOTTOM(image), DEF_SCREEN_WIDTH * 0.7 - 20, 50)];
    name.placeholder = @"账号";
    name.tag = 0;
    name.delegate = self;
    if([self.userDefaults objectForKey:@"name"]){
        name.text = [self.userDefaults objectForKey:@"name"];
    }
    [self addSubview:name];
    
    UILabel * label_1 = [[UILabel alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH * 0.15, DEF_BOTTOM(name), DEF_WIDTH(name) + 20, 1)];
    label_1.backgroundColor = DEF_RGBA_COLOR(0, 0, 0, 0.5);
    [self addSubview:label_1];
    
    passworld = [[UITextField alloc]initWithFrame:CGRectMake(DEF_X(name), DEF_BOTTOM(name) + 10, DEF_WIDTH(name), 50)];
    passworld.tag = 1;
    passworld.delegate = self;
    passworld.placeholder = @"密码";
    passworld.secureTextEntry = YES;
    if([self.userDefaults objectForKey:@"pass"]){
        name.text = [self.userDefaults objectForKey:@"name"];
    }
    [self addSubview:passworld];
    
    UILabel * label_2 = [[UILabel alloc]initWithFrame:CGRectMake(DEF_X(label_1), DEF_BOTTOM(passworld), DEF_WIDTH(label_1), 1)];
    label_2.backgroundColor = DEF_RGBA_COLOR(0, 0, 0, 0.5);
    [self addSubview:label_2];
    
    UIButton * btn_login = [UIButton buttonWithType:0];
    btn_login.frame = CGRectMake(DEF_X(label_1), DEF_BOTTOM(passworld) + 60, DEF_WIDTH(label_1), 50);
    [btn_login setTitle:@"登录" forState:0];
    [btn_login setTitleColor:[UIColor whiteColor] forState:0];
    [btn_login setBackgroundImage:[UIImage imageNamed:@"组-3"] forState:0];
    btn_login.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [btn_login addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn_login];
    
}

-(void)login{
    NSLog(@"login");
    
    if([self stringIsToNull:name.text] && [self stringIsToNull:passworld.text]){
        
        [self PostDataSource:[NSString stringWithFormat:@"%@%@",URL_url,URL_login] Params:[NSString stringWithFormat:@"code=%@&password=%@",name.text,passworld.text]success:^(NSDictionary *json) {
            
            NSDictionary * js = json[@"data"];  
            
            NSLog(@"232131831======%@\n\n",js[@"tid"]);
            
            [self.userDefaults setObject:@"1" forKey:@"user"];
            [self.userDefaults setObject:js[@"tid"] forKey:@"uid"];
            [self.userDefaults setObject:js[@"code"] forKey:@"code"];
            [self.userDefaults setObject:js[@"name"] forKey:@"name"];
            [self.userDefaults setObject:js[@"nick"] forKey:@"nick"];
            [self.userDefaults setObject:js[@"email"] forKey:@"email"];
            [self.userDefaults setObject:passworld.text forKey:@"pass"];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                EMError *error = [[EMClient sharedClient] loginWithUsername:[[NSUserDefaults standardUserDefaults]objectForKey:@"code"] password:[[NSUserDefaults standardUserDefaults]objectForKey:@"pass"]];
                if (!error) {
                    NSLog(@"登录成功");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"chatsuc" object:nil];
                    });
                    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"chat"];
                }else{
                    NSLog(@"失败----\n%@",error.errorDescription);
                }
            });
            
            if(self.ismodel){
                [[NSNotificationCenter defaultCenter]postNotificationName:@"suc" object:nil];
                [self dismissModalViewControllerAnimated:YES];
            }
            else
            {
                ZKB_TabarViewController * nv = [[ZKB_TabarViewController alloc]init];
                [self.navigationController pushViewController:nv animated:YES];
            }
            
        } fail:^{
            
        }];
//        
//        
//        [self getDataSource:[NSString stringWithFormat:@"http://192.168.31.190:8080/getJob/studentLogin.do?code=%@&pwd=%@",name.text,passworld.text] Params:nil success:^(NSDictionary *json) {
//            
//            
//            
//        } fail:^{
//            
//        }];
    }
    else
    {
        [self showString:@"请填写账号和密码"];
    }
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField.tag == 0) {
        [passworld becomeFirstResponder];
    }
    if (theTextField.tag == 1) {
        [passworld resignFirstResponder];
    }

    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
