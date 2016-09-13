//
//  BMBaseViewController.m
//  Eleven_frame
//
//  Created by 吕君 on 15/4/2.
//  Copyright (c) 2015年 eleven. All rights reserved.
//

#import "BMBaseViewController.h"
//#import "BannerScrollView.h"
//#import "QRViewController.h"
#import "MJRefresh.h"
//#import "LoginViewController.h"
#import "DataHander.h"
//#import "JSONKit.h"
#define kCachePath [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/cache.db"]
@interface BMBaseViewController ()<UIAlertViewDelegate>//<BannerScrollViewDelegate>
{
    UIButton* first_button;//第一个右按钮
    UIButton* sceond_button;//第二个右按钮
    //BannerScrollView* banners;//广告位
   
}
@end

@implementation BMBaseViewController
@synthesize navView;
@synthesize navTitle;
@synthesize leftButton;
@synthesize rightButton;
@synthesize tapGestureRecognizer;
@synthesize rightButtonImageName;
@synthesize navgationImageName;
@synthesize appdele;
@synthesize backgroundView;
//@synthesize ShoppingCartHidden;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(chatsuc) name:@"chatsuc" object:nil];
    
    str_data = [[NSMutableString alloc]initWithString:@""];
    
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //背景
    image_back = [[UIImageView alloc]initWithFrame:CGRectMake(0,topHight,DEF_SCREEN_WIDTH,DEF_SCREEN_HEIGHT - topHight)];
    image_back.userInteractionEnabled = YES;
    image_back.image = [UIImage imageNamed:@"tab01_bg"];
    [self.view addSubview:image_back];
    
    // 内容视图
    self.contentView = [[BaseScrollView alloc] initWithFrame:CGRectMake(0, topHight, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT - topHight)];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.showsVerticalScrollIndicator = NO;
    //self.contentView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    self.contentView.userInteractionEnabled = YES;
    self.contentView.showsHorizontalScrollIndicator = NO;
    self.contentView.showsVerticalScrollIndicator = NO;
    self.contentView.contentSize = CGSizeMake(DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT - topHight);
    [self.view addSubview:self.contentView];
    
    [self addNavView:@""];
    
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)chatsuc{
    [self showHUDWithString:@"聊天登录完成"];
}

-(CGFloat)font
{
    if([UIScreen mainScreen].bounds.size.height > 570)
    {
        return 20;
    }
    
    return 18;
    
}

#pragma mark - 给 view 上加一层 实现有些按钮点击后界面上的其他控件不能被点击
- (void)addBackgroundViewWithView{
    appdele = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT)];
    backgroundView.backgroundColor=[UIColor lightGrayColor];
    backgroundView.alpha=.5;
    [appdele.window addSubview:backgroundView];
}
#pragma mark - 添加 navi 上的
- (void)addNaviAllSubView_NaviView:(NSString*)image_str
                         NaviTitle:(NSString*)title
                    LeftButtonBool:(BOOL)YesOrNo
{
    [self addNavView:image_str];
    [self addNavgationTitle:title];
    if (YesOrNo == YES) {
        [self addNavgationLeftButton];
    }
}
#pragma mark - 软键盘
-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
}

#pragma mark - 添加子视图
- (void)addSubview:(UIView *)view
{
    [self.contentView addSubview:view];
}

#pragma mark - 添加自定义导航栏
- (void)addNavView:(NSString *)imageStr
{
    navgationImageName = imageStr;
    navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 0)];
    navView.userInteractionEnabled = YES;
    navView.alpha = 0.8;
    //[self chageNavStyle];
    navView.backgroundColor = DEF_RGB_COLOR(60, 166, 239);
    //[navView setBackgroundColor:[self hexStringToColor:@"#415151"]];
    downimage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, navView.frame.size.width, navView.frame.size.height)];
    downimage.image = [UIImage imageNamed:@""];
    downimage.userInteractionEnabled = YES;
    downimage.backgroundColor = [UIColor clearColor];
    [navView addSubview:downimage];
    [self.view addSubview:navView];
}

#pragma mark -- 修改导航栏颜色
-(void)chageNavStyle
{
    if([self.userDefaults objectForKey:@"style"])
    {
        NSString * str_style = [self.userDefaults objectForKey:@"style"];
        
        if(str_style.intValue == 0)
        {
            [navView setBackgroundColor:[self hexStringToColor:@"#353a3d"]];
        }
        if(str_style.intValue == 1)
        {
            [navView setBackgroundColor:[self hexStringToColor:@"#44cdac"]];
        }
        if(str_style.intValue == 2)
        {
            [navView setBackgroundColor:[self hexStringToColor:@"#75b4ea"]];
        }
    }
    else
    {
        [navView setBackgroundColor:[self hexStringToColor:@"#44cdac"]];
    }
}

#pragma mark - 添加左按钮
- (void)addNavgationLeftButton
{
    leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 70)];
    [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    
    UIImageView* buttonImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 25, 30, 30)];
    [buttonImageView setImage:[UIImage imageNamed:@"back"]];
    [downimage addSubview:buttonImageView];
    [downimage addSubview:leftButton];
    
}

-(void)addNavgationLeftButton:(NSString *)image
{
    leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    
    UIImageView* buttonImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 28, 25, 25)];
    [buttonImageView setImage:[UIImage imageNamed:image]];
    [downimage addSubview:buttonImageView];
    [downimage addSubview:leftButton];
}
#pragma mark - 左按钮点击事件
- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 添加右按钮 按钮显示文字
- (void)addNavgationRightButton_title:(NSString *)str title_Color:(UIColor *)color
{
    rightButton = [[UIButton alloc] initWithFrame:CGRectMake(DEF_SCREEN_WIDTH - 100 - 20, 0 , 100 , 70)];
    [rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    
    UILabel * label_right = [[UILabel alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH  - 200, 25, 185, 30)];
    [self Eleven_Set_label:label_right text:str textColor:color fontSize:16 fontAlpha:1 textAlignment:2];
    label_right.font = [UIFont boldSystemFontOfSize:17];
    [downimage addSubview:label_right];
    [downimage addSubview:rightButton];
}

#pragma mark - 添加右按钮 按钮显示图片
- (void)addNavgationRightButton:(NSString *)str
{
    rightButton = [[UIButton alloc] initWithFrame:CGRectMake(DEF_SCREEN_WIDTH - 70, 0 , 70 , 70)];
    [rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    
    self.buttonImageView_right = [[UIImageView alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH - 40, 25, 30, 30)];
    [self.buttonImageView_right setImage:[UIImage imageNamed:str]];
    [downimage addSubview:self.buttonImageView_right];
    [downimage addSubview:rightButton];
}
#pragma mark - 添加多个右按钮 按钮显示图片
- (void)addNavgationRightButtons:(NSString*)button_one_str
                  Button_two_str:(NSString*)button_two_str
{
    first_button = [[UIButton alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH - (DEF_SCREEN_WIDTH) / 3, 0, ((DEF_SCREEN_WIDTH) / 3) / 2, DEF_HEIGHT(self.navView))];
    [self Eleven_Set_Button:first_button
         setBackgroundColor:[UIColor clearColor]
   setBackgroundImageNormal:nil
setBackgroundImageHighlighted:nil
                   setTitle:nil
               setTitleFont:0
                  buttonTag:0 titleColor:[UIColor whiteColor]];
    [first_button addTarget:self action:@selector(rightButtons_action:) forControlEvents:UIControlEventTouchUpInside];
    [downimage addSubview:first_button];
    
    UIImageView* first_buttonImageView = [[UIImageView alloc]initWithFrame:CGRectMake(DEF_X(first_button) + (DEF_WIDTH(first_button) - 20) / 2 , 30, 20, 20)];
    [first_buttonImageView setImage:[UIImage imageNamed:button_one_str]];
    [downimage addSubview:first_buttonImageView];
    
    sceond_button = [[UIButton alloc]initWithFrame:CGRectMake(DEF_RIGHT(first_button), 0, ((DEF_SCREEN_WIDTH) / 3) / 2, DEF_HEIGHT(self.navView))];
    [self Eleven_Set_Button:sceond_button
         setBackgroundColor:[UIColor clearColor]
   setBackgroundImageNormal:nil
setBackgroundImageHighlighted:nil
                   setTitle:nil
               setTitleFont:0
                  buttonTag:1 titleColor:[UIColor whiteColor]];
    [sceond_button addTarget:self action:@selector(rightButtons_action:) forControlEvents:UIControlEventTouchUpInside];
    [downimage addSubview:sceond_button];
    
    UIImageView* sceond_buttonImageView = [[UIImageView alloc]initWithFrame:CGRectMake(DEF_X(sceond_button) + (DEF_WIDTH(sceond_button) - 20) / 2, 30, 20, 20)];
    [sceond_buttonImageView setImage:[UIImage imageNamed:button_two_str]];
    [downimage addSubview:sceond_buttonImageView];
}

#pragma mark - 添加右按钮 按钮显示图片和文字
- (void)addNavgationRightButtons:(NSString*)button_one_image
                  Button_one_str:(NSString*)button_one_str Button_oneStr_color:(UIColor *)color
{
    first_button = [[UIButton alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH - 100, 0, 100, DEF_HEIGHT(self.navView))];
    [self Eleven_Set_Button:first_button
         setBackgroundColor:[UIColor clearColor]
   setBackgroundImageNormal:nil
setBackgroundImageHighlighted:nil
                   setTitle:nil
               setTitleFont:0
                  buttonTag:0 titleColor:[UIColor whiteColor]];
    [first_button addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [downimage addSubview:first_button];
    
    UIImageView* first_buttonImageView = [[UIImageView alloc]initWithFrame:CGRectMake(DEF_X(first_button), 30, 20, 20)];
    [first_buttonImageView setImage:[UIImage imageNamed:button_one_image]];
    [downimage addSubview:first_buttonImageView];
    
    UILabel * label_str = [[UILabel alloc]initWithFrame:CGRectMake(DEF_RIGHT(first_buttonImageView), 30, 80, 20)];
    [self Eleven_Set_label:label_str text:button_one_str textColor:color fontSize:16 fontAlpha:1 textAlignment:1];
    [downimage addSubview:label_str];
    
//    sceond_button = [[UIButton alloc]initWithFrame:CGRectMake(DEF_RIGHT(first_button), 0, ((DEF_SCREEN_WIDTH) / 3) / 2, DEF_HEIGHT(self.navView))];
//    [self Eleven_Set_Button:sceond_button
//         setBackgroundColor:[UIColor clearColor]
//   setBackgroundImageNormal:nil
//setBackgroundImageHighlighted:nil
//                   setTitle:nil
//               setTitleFont:0
//                  buttonTag:1 titleColor:[UIColor whiteColor]];
//    [sceond_button addTarget:self action:@selector(rightButtons_action:) forControlEvents:UIControlEventTouchUpInside];
//    [downimage addSubview:sceond_button];
//    
//    UIImageView* sceond_buttonImageView = [[UIImageView alloc]initWithFrame:CGRectMake(DEF_X(sceond_button) + (DEF_WIDTH(sceond_button) - 20) / 2, 30, 20, 20)];
//    [sceond_buttonImageView setImage:[UIImage imageNamed:button_two_str]];
//    [downimage addSubview:sceond_buttonImageView];
}

#pragma mark - 多个右按钮的点击事件
- (void)rightButtons_action:(UIButton*)button
{
    if (button.tag == 0) {
        [self showHUDWithString:@"右按钮1"];
    }else{
        [self showHUDWithString:@"右按钮2"];
    }
}
#pragma mark - 右按钮方法 单个按钮
- (void)rightAction
{
    
}
#pragma mark - 导航栏标题
- (void)addNavgationTitle:(NSString *)title
{
    self.titleLB = [[UILabel alloc] initWithFrame:CGRectMake(DEF_SCREEN_WIDTH/2-160/2, 25, 160, 30)];
    self.titleLB.textAlignment = NSTextAlignmentCenter;
    self.titleLB.textColor = [UIColor whiteColor];
    self.titleLB.font = [UIFont boldSystemFontOfSize:20.0];
    self.titleLB.text = title;
    [downimage addSubview:self.titleLB];
}
#pragma mark -去除所有多余的线条
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


#pragma amrk - 获取字符串自适应后所占高度
- (CGSize)sizeOfStr:(NSString *)str
            andFont:(UIFont *)font
         andMaxSize:(CGSize)size
   andLineBreakMode:(NSLineBreakMode)mode
{
    CGSize s;
    if ([[[UIDevice currentDevice]systemVersion]doubleValue]>=7.0) {
        NSDictionary *dic=@{NSFontAttributeName:font};
        s = [str boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                           attributes:dic context:nil].size;
    }
    else
    {
        s=[str sizeWithFont:font constrainedToSize:size lineBreakMode:mode];
    }
    return s;
}
#pragma mark - 提示框 自动消失
-(void)showHUDWithString:(NSString *)title
{
    UIView* view = [[UIView alloc]init];
    
    if ([UIApplication sharedApplication].windows.count > 0) {
        view = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }else{
        view = self.contentView;
    }
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.margin = 10.f;
    hud.labelFont=[UIFont boldSystemFontOfSize:12];
    hud.yOffset = DEF_SCREEN_HEIGHT / 2 - 70.f;
    [view addSubview:hud];
    [hud.superview bringSubviewToFront:hud];
    hud.labelText=title;
    hud.userInteractionEnabled = NO;
    [hud show:YES];
    [hud hide:YES afterDelay:1.0];
    
}

-(void)showString:(NSString *)title
{
    [AFNetworkTool hide];
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    hud.margin = 10.f;
    //hud.yOffset = IS_IPHONE_5?200.f:150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2.0];
}


#pragma mark - 创建 Label
- (void)Eleven_Set_label:(UILabel*)label
                    text:(NSString*)text
               textColor:(UIColor*)color
                fontSize:(NSInteger)size
               fontAlpha:(CGFloat)alpha
           textAlignment:(NSInteger)textAlignment
{
    label.numberOfLines = 0;
    label.text = text;
    //[label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:color];
    [label setFont:[UIFont systemFontOfSize:size]];
    //[label setAlpha:alpha];
    
    if (textAlignment == 1) {
        [label setTextAlignment:NSTextAlignmentLeft];
    }else if (textAlignment == 2){
        [label setTextAlignment:NSTextAlignmentRight];
    }else if (textAlignment == 3){
        [label setTextAlignment:NSTextAlignmentCenter];
    }else{
        [label setTextAlignment:NSTextAlignmentJustified];
    }
}
#pragma mark - 创建 button
- (void)Eleven_Set_Button:(UIButton*)button
       setBackgroundColor:(UIColor*)color
 setBackgroundImageNormal:(NSString*)NormalImage_str
setBackgroundImageHighlighted:(NSString*)HighlightedImage_str
                 setTitle:(NSString*)text
             setTitleFont:(NSInteger)integer
                buttonTag:(NSInteger)tag titleColor:(UIColor *)titleCol
{
    [button setBackgroundColor:color];
    
    [button setBackgroundImage:[UIImage imageNamed:NormalImage_str] forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:HighlightedImage_str] forState:UIControlStateHighlighted];
    
    [button setTitle:text forState:UIControlStateNormal];
    
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:5.0];
    
    if(titleCol == [UIColor blackColor])
    {
        [button.titleLabel setFont:[UIFont systemFontOfSize:integer]];
    }
    else
    {
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:integer]];
    }
    
    [button setTitleColor:titleCol forState:UIControlStateNormal];
    
    button.tag = tag;
}

#pragma mark - 创建 textField
- (void)Eleven_Set_TextField:(UITextField*)textField
             placeholderText:(NSString*)text
                   text_font:(NSInteger)font
{
    textField.borderStyle=UITextBorderStyleNone;
    textField.backgroundColor=[UIColor whiteColor];
    textField.returnKeyType =UIReturnKeyDone;
    textField.font = [UIFont systemFontOfSize:font];
    textField.placeholder = text;
    //textField.clearButtonMode = UITextFieldViewModeWhileEditing;
}

//#pragma mark - 广告位
//- (void)LoGo_BannerView:(NSArray *)bannerArray
//    CGRectMakeWithFrame:(CGRect)frame;
//{
//    banners = [[BannerScrollView alloc] initWithFrame:frame imageArray:bannerArray];
//    banners.delegate = self;
//    banners.pageFrame = CGRectMake(DEF_WIDTH(banners) - 80, 120, 80, 20);
//    banners.sizeMake = CGSizeMake(320 * 3, 184);
//    [self.contentView addSubview:banners];
//}
//#pragma mark - 调用二维码相机
//- (void)Open_QR_Code{
//    if ([self validateCamera]) {
//        
//        [self showQRViewController];
//        
//    } else {
//        [UnityLHClass showPointOut:@"对不起 您的设备没有相机或相机不可用!"];
//    }
//}
//- (BOOL)validateCamera {
//    
//    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&
//    [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
//}
//
//- (void)showQRViewController {
//    QRViewController *qrVC = [[QRViewController alloc] init];
//    [self presentViewController:qrVC animated:YES completion:nil];
//}
//

#pragma mark -  验证手机号是否符合格式
- (BOOL)checkTel:(NSString *)str
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    BOOL res1 = [regextestmobile evaluateWithObject:str];
    BOOL res2 = [regextestcm evaluateWithObject:str];
    BOOL res3 = [regextestcu evaluateWithObject:str];
    BOOL res4 = [regextestct evaluateWithObject:str];
    
    if (res1 || res2 || res3 || res4 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}
#pragma mark - 邮箱
- (BOOL)checkEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark - 验证身份证
- (BOOL)checkIDCardNumber:(NSString *)value
{
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([value length] != 18) {
        return NO;
    }
    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd = @"0229";
    NSString *year = @"(19|20)[0-9]{2}";
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];
    
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![regexTest evaluateWithObject:value]) {
        return NO;
    }
    int summary = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7
    + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9
    + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10
    + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5
    + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8
    + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4
    + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2
    + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6
    + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
    NSInteger remainder = summary % 11;
    NSString *checkBit = @"";
    NSString *checkString = @"10X98765432";
    checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];// 判断校验位
    return [checkBit isEqualToString:[[value substringWithRange:NSMakeRange(17,1)] uppercaseString]];
}

////身份证号正则 自己写的  不太全...  留着是个纪念
- (BOOL)checkIdentityCard: (NSString *)identityCard
{
//    if (identityCard.length <= 0) {
//        return NO;
//    }
    if (identityCard.length != 18)
    {
        return NO;
    }
    //得到当前时间
    NSDate* timeNow=[NSDate date];
    NSDateFormatter* dformatter=[[NSDateFormatter alloc]init];
    dformatter.dateFormat=@"yyyy";
    NSString* NewTimeNow=[dformatter stringFromDate:timeNow];
    NSString* NewTime = [NSString stringWithString:NewTimeNow];

    NSInteger min_integer = 1900;
    NSInteger max_integer = [NewTime integerValue] + 1;
    NSInteger month_integer = 12;
    NSInteger day_integer = 31;

    NSMutableString* new_identityCard_str = [NSMutableString stringWithString:identityCard];

    NSRange year_range = {6,4};
    NSRange month_range = {10,2};
    NSRange day_range = {12,2};

    NSString* year_str = [new_identityCard_str substringWithRange:year_range];
    NSString* month_str = [new_identityCard_str substringWithRange:month_range];
    NSString* day_str = [new_identityCard_str substringWithRange:day_range];

    if ([year_str integerValue] <= min_integer || [year_str integerValue] > max_integer) {
        return NO;
    }
    if ([month_str integerValue] > month_integer || [month_str integerValue] == 0) {
        return NO;
    }
    if ([day_str integerValue] > day_integer || [day_str integerValue] == 0) {
        return NO;
    }

    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

#pragma mark - 判断字符串是否为空
- (BOOL)Judge_str_null_with_str:(NSString*)str{
    if (str.length == 0 || [str isEqualToString:@"(null)"] || [str isEqualToString:@"<null>"]) {
        return NO;
    }else{
        return YES;
    }
}

//毛玻璃效果  没用得方法  使用时把这里的代码 copy 出去
- (void)visualEfView_frame:(CGRect)frame with_view:(id)view
{
    // blur效果
    UIVisualEffectView* visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    visualEfView.frame = frame;
    visualEfView.alpha = .7;
    [view addSubview:visualEfView];
}

#pragma mark - 压缩图片
- (UIImage*)set_imageWithImage:(UIImage*)myImage
                  scaledToSize:(CGSize)newSize

{
    
    // Create a graphics image context
    
    UIGraphicsBeginImageContext(newSize);
    
    
    // Tell the old image to draw in this new context, with the desired
    
    // new size
    
    [myImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    
    // Get the new image from the context
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    
    // End the context
    
    UIGraphicsEndImageContext();
    // Return the new image.
    
    return newImage;
}

#pragma mark - 压缩图片文件大小
- (NSData*)set_ImageData_UIImageJPEGRepresentationWithImage:(UIImage*)image
                                 CGFloat_compressionQuality:(CGFloat)image_float
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString* dateString = [formatter stringFromDate:[NSDate date]];
    dateString = [NSString stringWithFormat:@"%@.png",dateString];
    NSData *imageData = UIImageJPEGRepresentation(image, image_float);
    
    return imageData;
}
#pragma mark 刷新
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
//    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
//    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
//    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
//    [self.tableView footerEndRefreshing];
//    
//    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
//    self.tableView.headerPullToRefreshText = @"下拉刷新";
//    self.tableView.headerReleaseToRefreshText = @"松开刷新";
//    self.tableView.headerRefreshingText = @"正在刷新";
//    
//    self.tableView.footerPullToRefreshText = @"上拉加载";
//    self.tableView.footerReleaseToRefreshText = @"松开加载更多数据";
//    self.tableView.footerRefreshingText = @"正在加载";
}

- (void)setupHaderRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
//    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
//    // [self.tableView1 headerBeginRefreshing];
//    
//    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
//    self.tableView.headerPullToRefreshText = @"下拉刷新";
//    self.tableView.headerReleaseToRefreshText = @"松开刷新";
//    self.tableView.headerRefreshingText = @"正在刷新";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    
}

- (void)footerRereshing
{
    
}

#pragma mark ---  电源条变色
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark -- 键盘上方加返回
-(void)keyboradReturn:(UITextField *)text
{
    UIView * view_b = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 30)];
    view_b.backgroundColor = [UIColor whiteColor];
    
    UILabel * label_vie = [[UILabel alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH - 80, 0, 80, 30)];
    [self Eleven_Set_label:label_vie text:@"完成" textColor:DEF_RGB_COLOR(124, 207, 251) fontSize:17 fontAlpha:1 textAlignment:3];
    [view_b addSubview:label_vie];
    
    UIButton * btn_return = [UIButton buttonWithType:0];
    btn_return.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 30);
    [btn_return addTarget:self action:@selector(keyboardHide:) forControlEvents:UIControlEventTouchUpInside];
    [view_b addSubview:btn_return];
    
    text.inputAccessoryView = view_b;
}

#pragma mark -- 时间戳转时间
-(NSString *)dataTotimemin:(NSString *)data
{
    NSString * str = [[NSString alloc]init];
    if(data.length > 10)
    {
        str = [data substringToIndex:10];
    }
    else
    {
        str = data;
    }
    
    //规则
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //时间戳转时间的方法
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:str.integerValue];
    //NSLog(@"time  = %@",confromTimesp);
    //匹配时间规则
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    //NSLog(@"time =  %@",confromTimespStr);
    
    NSArray * array = [confromTimespStr componentsSeparatedByString:@" "];
    
    NSString * str_dian = array[1];
    
    NSArray * array_d = [str_dian componentsSeparatedByString:@":"];
    
    NSString * str_r = [NSString stringWithFormat:@"%@:%@",array_d[0],array_d[1]];
    
    return str_r;
}


-(NSString *)dataTotime:(NSInteger)data
{
    //规则
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //时间戳转时间的方法
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:data];
    //NSLog(@"time  = %@",confromTimesp);
    //匹配时间规则
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    //NSLog(@"time =  %@",confromTimespStr);
    
    //return confromTimespStr;
    NSArray * array = [confromTimespStr componentsSeparatedByString:@" "];
    
    NSLog(@"%@",array[0]);
    
    return array[0];
}

//时间转成时间戳
-(NSInteger)timeTodata:(NSString *)timeStr
{
    
    NSString * time_s = [NSString stringWithFormat:@"%@  00:00:00",timeStr];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSDate* date = [formatter dateFromString:time_s];

    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate * datenow;
    if(date == nil)
    {
        datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    }
    else
    {
        datenow = date;
    }
    //时间转时间戳的方法:
    NSString * timeSp = [NSString stringWithFormat:@"%f",[datenow timeIntervalSince1970]];
    
    //时间戳的值
    NSLog(@"data = %@",timeSp);
    
    return timeSp.integerValue;
    
}

-(NSString *)timeToStr:(NSString *)timeStr
{
    
    NSString * time_s = [NSString stringWithFormat:@"%@  00:00:00",timeStr];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSDate* date = [formatter dateFromString:time_s];
    
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow;
    if(date == nil)
    {
        datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    }
    else
    {
        datenow = date;
    }
    //时间转时间戳的方法:
    NSString * timeSp = [NSString stringWithFormat:@"%f",[datenow timeIntervalSince1970]];
    
    //时间戳的值
    NSLog(@"data = %@",timeSp);
    
    NSArray * arr_t = [timeSp componentsSeparatedByString:@"."];
    
    NSString * str_t = [NSString stringWithFormat:@"%@",arr_t[0]];
    
    return str_t;
    
}

#pragma mark -- 生成当前时间的时间戳
-(NSString *)NowTimeDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置日期格式
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString * fileName = [formatter stringFromDate:[NSDate date]];
    
    NSString * str_da = [NSString stringWithFormat:@"%ld",[self timeTodata:fileName]];
    
    return str_da;
}

#pragma mark -- 跟据16位＃颜色值返回颜色
-(UIColor *) hexStringToColor: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 charactersif ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appearsif ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

#pragma mark -- 矫正字符串为空
-(BOOL)stringIsToNull:(NSString *)str
{
    if([str isEqualToString:@""] || !str)
    {
        return NO;
    }
    return YES;
}

#pragma mark - JSON方式获取数据
-(void)getDataSource:(NSString *)urlStr
              Params:(NSDictionary*)params
             success:(void (^)(NSDictionary * json))success
                fail:(void (^)())fail
{
    
    [AFNetworkTool Eleven_GET_JSONDataWithUrl:urlStr Params:params success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:0 error:nil];
        
        NSLog(@"%@",dic);
        
        if([[NSString stringWithFormat:@"%@",dic[@"status"]] isEqualToString:@"200"])
        {
            success(dic);
        }
        else
        {
            //[self showString:@"请求数据失败"];
            fail();
            [self showString:dic[@"info"]];
        }
        
    } fail:^{
        fail();
        [self showString:@"请求数据失败"];
    }];
    
}


#pragma mark - JSON方式获取数据
-(void)PostDataSource:(NSString *)urlStr
              Params:(NSString *)params
             success:(void (^)(NSDictionary * json))success
                fail:(void (^)())fail
{
    //加 菊花加载动画
    [AFNetworkTool showHUDGood:YES];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    
    NSData *data = [params dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:data];
    
    NSOperationQueue * queue = [[NSOperationQueue alloc]init];
    //第三步，连接服务器
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        [AFNetworkTool hide];
        
        if(connectionError || data.length == 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                fail();
                [self showString:@"请求数据失败"];
            });
            
            return ;
            
        }
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSLog(@"%@",dic);
        
        if([[NSString stringWithFormat:@"%@",dic[@"status"]] isEqualToString:@"200"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(dic);
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showString:dic[@"info"]];
            });
        }
        
        
        
    }];
}

#pragma mark - POST上传图片
-(void)Image_Post_UploadWithUrl:(NSString *)urlStr
                           Params:(NSDictionary*)params
                Idcard_front_Data:(NSData*)idcard_front_data
            Idcard_front_fileName:(NSString *)idcard_front_file_name
                          success:(void (^)(NSDictionary * json))success
                             fail:(void (^)())fail
{
    [AFNetworkTool Eleven_Post_UploadWithUrl:urlStr Params:params Idcard_front_Data:idcard_front_data success:^(id responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        NSLog(@"%@",dic);
        
        if([[NSString stringWithFormat:@"%@",dic[@"status"]] isEqualToString:@"200"])
        {
            success(dic);
        }
        else
        {
            [self showString:dic[@"info"]];
        }
        
    } fail:^{
        
        fail();
        [self showString:@"请求数据失败"];
        
    }];
}

#pragma mark --- webservice Post请求
-(void)request:(NSString *)soap url_s:(NSString *)url_s success:(void(^)(NSDictionary * dic))success fail:(void(^)(NSString *failDes))fail
{
    [AFNetworkTool showHUDGood:YES];
    //封装soap请求消息
    NSString *soapMessage1 = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ser=\"http://server.webservice.xingning.com/\">\n"
                              "<soapenv:Header/>\n"
                              "<soapenv:Body>\n"
                              "<ser:%@>\n"
                              "<arg0>{\
                              %@\
                              }</arg0>\n"
                              "</ser:%@>\n"
                              "</soapenv:Body>\n"
                              "</soapenv:Envelope>\n",url_s,soap,url_s];
    //请求发送到的路径
    NSURL *url = [NSURL URLWithString:@"http://server.sinaean-healthy.com/TransferServer/transferService?wsdl"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest setTimeoutInterval:20.0];
    NSString *msgLength = [NSString stringWithFormat:@"%ld", [soapMessage1 length]];
    
    //以下对请求信息添加属性前四句是必有的，第五句是soap信息。
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //[theRequest addValue: @"false" forHTTPHeaderField:@"SOAPAction"];
    
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage1 dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:theRequest queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        [[DataHander sharedDataHander] hideDlg];
        
        if (connectionError == nil) {
            // 网络请求结束之后执行!
            // 将Data转换成字符串
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSArray * array_1 = [str componentsSeparatedByString:@"<return>"];
            
            NSArray * array_2 = [[NSString stringWithFormat:@"%@",array_1[1]] componentsSeparatedByString:@"</return>"];
            
            NSData * data = [[NSString stringWithFormat:@"%@",array_2[0]] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary * dic_ = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                success(dic_);
                
            }];
        }
        else
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                //[self showString:hinppp];
                fail(connectionError.description);
                
            }];
        }
    }];
}

-(void)call_tel:(NSString *)tel
{
    UIAlertView * al = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"确定拨打电话:%@?",tel] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    al.tag = 185;
    [al show];
    self.call_tel = tel;
    //有提示
//    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",tel];
//    UIWebView * callWebview = [[UIWebView alloc] init];
//    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//    [self addSubview:callWebview];
}

-(void)call_tel_new:(NSString *)tel title:(NSString *)title_me
{
    UIAlertView * al = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"您确认拨打%@电话?",title_me] delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"确认", nil];
    al.tag = 1851;
    [al show];
    self.call_tel = tel;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0 && alertView.tag == 185)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.call_tel]]];
        
        return;
    }
    if(alertView.tag == 1851)
    {
        if(buttonIndex == 1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.call_tel]]];
        }
        
        return;
    }
}

//#pragma mark -- 加在本地html
//- (void)loadHTML:(NSString *)title
//{
//    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, topHight, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT - topHight)];
//    web.scrollView.bounces = NO;
//    [self.view addSubview:web];
//    
//    NSURL *filePath = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"666666/%@.html",title] withExtension:nil];
//    NSURLRequest *request = [NSURLRequest requestWithURL:filePath];
//    
//    [web loadRequest:request];
//}
//
//#pragma mark -- 加在本地html
//- (void)loadHTML:(NSString *)title and:(CGRect)frame
//{
//    UIWebView *web = [[UIWebView alloc] initWithFrame:frame];
//    web.scrollView.bounces = NO;
//    [self.view addSubview:web];
//    
//    NSURL *filePath = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"mall/%@.html",title] withExtension:nil];
//    NSURLRequest *request = [NSURLRequest requestWithURL:filePath];
//    
//    [web loadRequest:request];
//}
//
#pragma mark -- 添加web
-(void)addWebView:(NSString *)url and:(CGRect)frame
{
    if(!url)
    {
        [self showHUDWithString:@"链接无效"];
    }
    
    _webView = [[UIWebView alloc]initWithFrame:frame];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    [self.view addSubview:_webView];
    _webView.delegate = self;
    _webView.scrollView.bounces = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    NSURL* url_l = [NSURL URLWithString:url];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url_l];
    [_webView loadRequest:request];//加载
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'";
    [webView stringByEvaluatingJavaScriptFromString:str];
}
@end

