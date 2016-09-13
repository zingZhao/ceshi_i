//
//  ZKB_TabarViewController.m
//  i_就业
//
//  Created by 赵奎博 on 16/4/25.
//  Copyright © 2016年 赵奎博. All rights reserved.
//

#import "ZKB_TabarViewController.h"
#import "MainViewController.h"
#import "ResumeViewController.h"
#import "ShareViewController.h"
#import "MeViewController.h"
//此处定义宏:tabbar上item的高度-----------------------------------------------
#define tabbar_Image_HIGHT5s 50

#define tabbar_Image_HIGHT4 40


#define one_n @"tab1_u"
#define one_s @"tab1_s"

#define two_n @"tab2_u"
#define two_s @"tab2_s"

#define three_n @"tab3_u"
#define three_s @"tab3_s"

#define four_n @"tab4_u"
#define four_s @"tab4_s"

#define fontt 20
@interface ZKB_TabarViewController ()<UINavigationControllerDelegate>

@end

@implementation ZKB_TabarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //隐藏系统的tabbar
    self.tabBar.hidden = YES;
    
    [self initTabbarUI];
}

/**
 *  初始化 TabBar
 */
- (void)initTabbarUI{
    
    
    
    NSMutableArray* viewControllers = [NSMutableArray array];
    
    MainViewController * homeVC = [[MainViewController alloc]init];
    homeVC.title = @"商旅i就业";
    UINavigationController* navi1 = [[UINavigationController alloc]initWithRootViewController:homeVC];
    navi1.navigationBar.barTintColor = NAVColor;
    navi1.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor],UITextAttributeFont : [UIFont boldSystemFontOfSize:fontt]};
    navi1.delegate = self;
    [viewControllers addObject:navi1];
    
    //
    ResumeViewController * needsVC = [[ResumeViewController alloc]init];
    needsVC.title = @"求职";
    UINavigationController* navi2 = [[UINavigationController alloc]initWithRootViewController:needsVC];
    navi2.navigationBar.barTintColor = NAVColor;
    navi2.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor],UITextAttributeFont : [UIFont boldSystemFontOfSize:fontt]};
    navi2.delegate = self;
    [viewControllers addObject:navi2];

    
    ShareViewController* userVC = [[ShareViewController alloc]init];
    userVC.title = @"分享";
    UINavigationController* navi3 = [[UINavigationController alloc]initWithRootViewController:userVC];
    navi3.navigationBar.barTintColor = NAVColor;
    navi3.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor],UITextAttributeFont : [UIFont boldSystemFontOfSize:fontt]};
    navi3.delegate = self;
    [viewControllers addObject:navi3];
    
    
    MeViewController * meVC = [[MeViewController alloc]init];
    meVC.title = @"我";
    UINavigationController* navi4 = [[UINavigationController alloc]initWithRootViewController:meVC];
    navi4.navigationBar.barTintColor = NAVColor;
    navi4.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor],UITextAttributeFont : [UIFont boldSystemFontOfSize:fontt]};
    navi4.delegate = self;
    [viewControllers addObject:navi4];
    
    self.viewControllers = viewControllers;
    
    self.selectedIndex = 0;
    
    [self initUI];
}

/**
 *  初始化自定义 TabBar
 */
- (void)initUI{
    
    CGFloat hignt =tabbar_Image_HIGHT5s ;
    
    self.myTabbar = [[UIView alloc] init];
    self.myTabbar.backgroundColor = [UIColor whiteColor];
    
    self.myTabbar.frame = CGRectMake(0, DEF_SCREEN_HEIGHT - hignt, DEF_SCREEN_WIDTH, hignt);
    
    [self.view addSubview:self.myTabbar];
    
    CGFloat wid = DEF_SCREEN_WIDTH / 4;
    
    one = [UIButton buttonWithType:UIButtonTypeCustom];
    one.frame = CGRectMake(0, 0, wid , hignt);
    //one.titleLabel.font = [UIFont systemFontOfSize:13];
    one.tag = 0;
    [one addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
    [self.myTabbar addSubview:one];
    one_image = [[UIImageView alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH / 8 - 12.5, 5, 25, 25)];
    one_image.image = [UIImage imageNamed:one_n];
    [self.myTabbar addSubview:one_image];
    
    UILabel * label_one = [[UILabel alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(one_image), DEF_SCREEN_WIDTH / 4, hignt - DEF_BOTTOM(one_image))];
    label_one.textColor = GrayText;
    label_one.text = @"i就业";
    label_one.textAlignment = NSTextAlignmentCenter;
    label_one.font = [UIFont systemFontOfSize:12];
    [self.myTabbar addSubview:label_one];
    
    
    two = [UIButton buttonWithType:UIButtonTypeCustom];
    two.frame = CGRectMake(wid, 0, wid , hignt);
    two.titleLabel.font = [UIFont systemFontOfSize:13];
    two.tag = 1;
    [two addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
    [self.myTabbar addSubview:two];
    two_image = [[UIImageView alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH / 8 - 12.5 + DEF_SCREEN_WIDTH / 4, 5, DEF_WIDTH(one_image), DEF_HEIGHT(one_image))];
    two_image.image = [UIImage imageNamed:two_n];
    [self.myTabbar addSubview:two_image];
    
    UILabel * label_two = [[UILabel alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH / 4, DEF_Y(label_one), DEF_SCREEN_WIDTH / 4, DEF_HEIGHT(label_one))];
    label_two.textColor = GrayText;
    label_two.text = @"求职";
    label_two.textAlignment = NSTextAlignmentCenter;
    label_two.font = [UIFont systemFontOfSize:12];
    [self.myTabbar addSubview:label_two];
    
    
    
    three = [UIButton buttonWithType:UIButtonTypeCustom];
    three.frame = CGRectMake(wid * 2, 0, wid, hignt);
    three.titleLabel.font = [UIFont systemFontOfSize:13];
    three.tag = 2;
    [three addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
    [self.myTabbar addSubview:three];
    
    three_image = [[UIImageView alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH / 8 - 12.5 + DEF_SCREEN_WIDTH / 2, 5, DEF_WIDTH(one_image), DEF_HEIGHT(one_image))];
    three_image.image = [UIImage imageNamed:three_n];
    [self.myTabbar addSubview:three_image];
    
    UILabel * label_three = [[UILabel alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH / 2, DEF_Y(label_one), DEF_SCREEN_WIDTH / 4, DEF_HEIGHT(label_one))];
    label_three.textColor = GrayText;
    label_three.text = @"分享";
    label_three.textAlignment = NSTextAlignmentCenter;
    label_three.font = [UIFont systemFontOfSize:12];
    [self.myTabbar addSubview:label_three];
    
    
    four = [UIButton buttonWithType:UIButtonTypeCustom];
    four.frame = CGRectMake(wid * 3, 0, wid, hignt);
    four.titleLabel.font = [UIFont systemFontOfSize:13];
    four.tag = 3;
    [four addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
    [self.myTabbar addSubview:four];
    
    four_image = [[UIImageView alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH / 8 - 12.5 + DEF_SCREEN_WIDTH / 4 * 3, 5, DEF_WIDTH(one_image), DEF_HEIGHT(one_image))];
    four_image.image = [UIImage imageNamed:four_n];
    [self.myTabbar addSubview:four_image];
    
    UILabel * label_four = [[UILabel alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH / 4 * 3, DEF_Y(label_one), DEF_SCREEN_WIDTH / 4, DEF_HEIGHT(label_one))];
    label_four.textColor = GrayText;
    label_four.text = @"我";
    label_four.textAlignment = NSTextAlignmentCenter;
    label_four.font = [UIFont systemFontOfSize:12];
    [self.myTabbar addSubview:label_four];
    
    [self selectedTab:one];
    
    UILabel * label_li = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 1)];
    label_li.backgroundColor = GrayLine;
    [self.myTabbar addSubview:label_li];
    
//    for(int i=0; i< 3; i++){
//        UILabel * label_line = [[UILabel alloc]initWithFrame:CGRectMake((i + 1) * wid, 0, 1, DEF_HEIGHT(self.myTabbar))];
//        label_line.backgroundColor = GrayLine;
//        [self.myTabbar addSubview:label_line];
//    }
}

-(void)selectedTab:(UIButton*)sender{
    
    self.selectedIndex = sender.tag;
    
    self.tabBar.hidden = YES;
    self.myTabbar.hidden = NO;
    
    if (sender.tag == 0) {
        one_image.image = [UIImage imageNamed:one_s];
        two_image.image = [UIImage imageNamed:two_n];
        three_image.image = [UIImage imageNamed:three_n];
        four_image.image = [UIImage imageNamed:four_n];
    }
    if (sender.tag == 1)
    {
        one_image.image = [UIImage imageNamed:one_n];
        two_image.image = [UIImage imageNamed:two_s];
        three_image.image = [UIImage imageNamed:three_n];
        four_image.image = [UIImage imageNamed:four_n];
        
    }
    
    if (sender.tag == 2)
    {
        one_image.image = [UIImage imageNamed:one_n];
        two_image.image = [UIImage imageNamed:two_n];
        three_image.image = [UIImage imageNamed:three_s];
        four_image.image = [UIImage imageNamed:four_n];
        
    }
    
    if (sender.tag == 3)
    {
        one_image.image = [UIImage imageNamed:one_n];
        two_image.image = [UIImage imageNamed:two_n];
        three_image.image = [UIImage imageNamed:three_n];
        four_image.image = [UIImage imageNamed:four_s];
        
    }
    
}
//---------------------------------   -

#pragma mark --- 此方法使用系统的tabbar
-(void)setViewcontrolers:(NSArray *)viewControlers titles:(NSArray *)titles images:(NSArray *)images slectImages:(NSArray *)slectImages{
    
    NSMutableArray * _dataArray = [NSMutableArray array];
    
    for(int i=0; i< viewControlers.count; i++){
        UIViewController * m = viewControlers[i];
        m.title = titles[i];
        UINavigationController * nm = [[UINavigationController alloc]initWithRootViewController:m];
        nm.navigationBar.tintColor = [UIColor whiteColor];
        nm.tabBarItem.image = [UIImage imageNamed:images[i]];
        nm.tabBarItem.selectedImage = [UIImage imageNamed:slectImages[i]];
        
        [_dataArray addObject:nm];
    }
    
    self.viewControllers = _dataArray;
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

//navigation的一个代理方法，系统自带的
#pragma mark - navigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (navigationController.viewControllers.count >1) {
        
        self.myTabbar.hidden = YES;
        self.tabBar.hidden = YES;
        
    } else {
        if (navigationController.viewControllers.count <= 1) {
            self.myTabbar.hidden = NO;
            self.tabBar.hidden = YES;
        }
    }
}



@end
