//
//  ShareViewController.m
//  i_就业
//
//  Created by 赵奎博 on 16/4/25.
//  Copyright © 2016年 赵奎博. All rights reserved.
//

#import "ShareViewController.h"
#import "OccupationViewController.h"
#import "CGViewController.h"
#import "ConversationListController.h"
@interface ShareViewController ()
@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = DEF_RGB_COLOR(230, 230, 230);
    
    [self initUI];
}

-(void)initUI{
    NSArray * array = @[@"职业测评",@"实习心语",@"就业指导",@"升学指导",@"群聊讨论"];
    NSArray * array_image = @[@"tab3_menu1",@"tab3_menu2",@"tab3_menu3",@"升学指导",@"聊天_my"];
//    NSArray * array = @[@"职业测评",@"实习心语",@"就业指导",@"升学指导"];
//    NSArray * array_image = @[@"tab3_menu1",@"tab3_menu2",@"tab3_menu3",@"升学指导"];
    
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
            OccupationViewController * ovc = [[OccupationViewController alloc]init];
            [self.navigationController pushViewController:ovc animated:YES];
        }
            break;
        case 1:
        {
            CGViewController * ovc = [[CGViewController alloc]init];
            ovc.str_title = @"实习心语";
            ovc.type = @"2";
            [self.navigationController pushViewController:ovc animated:YES];
        }
            break;
        case 2:
        {
            CGViewController * ovc = [[CGViewController alloc]init];
            ovc.str_title = @"就业指导";
            ovc.type = @"4";
            [self.navigationController pushViewController:ovc animated:YES];
        }
            break;
            
        case 3:
        {
            CGViewController * ovc = [[CGViewController alloc]init];
            ovc.str_title = @"升学指导";
            ovc.type = @"5";
            [self.navigationController pushViewController:ovc animated:YES];
        }
            break;
        case 4:
        {
            //[AFNetworkTool showHUDGood:YES];
            
            if([[self.userDefaults objectForKey:@"chat"] isEqualToString:@"1"]){
                ConversationListController * _chatListVC = [[ConversationListController alloc] initWithNibName:nil bundle:nil];
                //[_chatListVC networkChanged:_connectionState];
                [self.navigationController pushViewController:_chatListVC animated:YES];
            }else
            {
                [self showHint:@"聊天登录尚未完成"];
            }
            
            
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

- (void)showHint:(NSString *)hint
{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset = 180;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

@end
