//
//  BMBaseViewController.h
//  Eleven_frame
//
//  Created by 吕君 on 15/4/2.
//  Copyright (c) 2015年 eleven. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "UnityLHClass.h"
#import "BaseScrollView.h"
#import "Eleven_Header.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "Single.h"
#import "UIImageView+WebCache.h"
#import "PullingRefreshTableView.h"
#import "AFNetworkTool.h"
/**
 *  自定义ViewController的基类
 */
@interface BMBaseViewController : UIViewController<UIWebViewDelegate,NSXMLParserDelegate,UIAlertViewDelegate>
{
    UIWebView* _webView;
    NSMutableString * str_data;
    NSMutableData *webData;
    UIImageView * image_back;
    
    
    UIImageView *downimage;

}
@property (nonatomic,copy) NSString * selec;
@property (nonatomic,strong) UILabel *titleLB;
/**
 *  内容视图，所有的view都加载contentView上，而不再是self.view上
 */
@property (nonatomic, strong) BaseScrollView *contentView;
@property (nonatomic, retain) NSString *navTitle;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIImageView * buttonImageView_right;
@property (nonatomic ,strong) UIView *navView;
@property (nonatomic , strong) AppDelegate *appdele;
@property (nonatomic , strong) UIView* backgroundView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,assign) CGRect keyHide;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic,copy) NSString * cocID;
@property (nonatomic,copy) NSString * call_tel;

/**
 *  请求数据后使用 使用前请初始化
 */
@property (nonatomic , strong) NSMutableDictionary* interface_dic;
/**
 *  添加子视图，以后所有添加子视图的操作，都使用[self addSubview:...];，而不再用[self.view addSubview:...]
 *
 *  @param view 子视图
 */
@property (nonatomic,retain) UITapGestureRecognizer *tapGestureRecognizer;
/**
 *  导航栏背景图
 */
@property (nonatomic, retain) NSString * navgationImageName;
/**
 *  右按钮图片名
 */
@property (nonatomic, retain) NSString * rightButtonImageName;



//     ******************************************基类方法******************************************

/**
 *  添加 navi 上的常用控件
 *
 *  @param image_str   navi 背景图片
 *  @param title       title
 *  @param addNavView YES为添加返回按钮NO为不添加
 *  @param imageStr   <#imageStr description#>
 */
- (void)addNaviAllSubView_NaviView:(NSString*)image_str
                         NaviTitle:(NSString*)title
                    LeftButtonBool:(BOOL)YesOrNo;
/**
 *  添加导航栏 传图片
 *
 *  @param imageStr 图片名
 */
- (void)addNavView:(NSString *)imageStr;

#pragma mark -- 修改导航栏颜色
-(void)chageNavStyle;

/**
 *  添加导航 title
 *
 *  @param title  字符串
 */
- (void)addNavgationTitle:(NSString *)title;

/**
 *  添加左边按钮
 */
- (void)addNavgationLeftButton;

-(void)addNavgationLeftButton:(NSString *)image;

/**
 *  添加右按钮  之创建一个按钮
 *
 *  @param str 传图片名
 */
- (void)addNavgationRightButton:(NSString *)str;

/*
 *
 添加右按钮 按钮显示文字
 *
 */
- (void)addNavgationRightButton_title:(NSString *)str title_Color:(UIColor *)color;

/**
 *  添加两个右按钮
 *
 *  @param button_one_str 第一个按钮的图片名
 *  @param button_two_str 第二个按钮的图片名
 */
- (void)addNavgationRightButtons:(NSString*)button_one_str
                  Button_two_str:(NSString*)button_two_str;

#pragma mark - 添加右按钮 按钮显示图片和文字
- (void)addNavgationRightButtons:(NSString*)button_one_image
                  Button_one_str:(NSString*)button_one_str Button_oneStr_color:(UIColor *)color;

/**
 *  多个右按钮的点击事件  需要时重写
 *
 *  @param button <#button description#>
 */
- (void)rightButtons_action:(UIButton*)button;

/**
 *  添加子视图
 *
 *  @param view <#view description#>
 */
- (void)addSubview:(UIView *)view;

/**
 *  左边按钮点击事件  需要重写时调用
 */
- (void)leftAction;

/**
 *  右边按钮点击事件 只有一个按钮的
 */
- (void)rightAction;

/**
 *  创建 label
 *
 *  @param label         label 对象
 *  @param text          label 文字
 *  @param color         字体颜色
 *  @param size          字体大小  这里使用宏
 *  @param textAlignment 0为中间 1为左边 2为右边
 */
- (void)Eleven_Set_label:(UILabel*)label
                    text:(NSString*)text
               textColor:(UIColor*)color
                fontSize:(NSInteger)size
               fontAlpha:(CGFloat)alpha
           textAlignment:(NSInteger)textAlignment;
/**
 *  创建button
 *
 */
- (void)Eleven_Set_Button:(UIButton*)button
       setBackgroundColor:(UIColor*)color
 setBackgroundImageNormal:(NSString*)NormalImage_str
setBackgroundImageHighlighted:(NSString*)HighlightedImage_str
                 setTitle:(NSString*)text
             setTitleFont:(NSInteger)integer
                buttonTag:(NSInteger)tag titleColor:(UIColor *)titleCol;
/**
 *  创建 textField
 *
 */
- (void)Eleven_Set_TextField:(UITextField*)textField
             placeholderText:(NSString*)text
                   text_font:(NSInteger)font;
/**
 *  自适应 label
 *
 *  @param str   字符串
 *  @param font  字符大小
 *  @param size 最大值最小值
 *  @param mode 一般传0
 *
 *  @return <#return value description#>
 */
- (CGSize)sizeOfStr:(NSString *)str
            andFont:(UIFont *)font
         andMaxSize:(CGSize)size
   andLineBreakMode:(NSLineBreakMode)mode;

/**
 *  提示框 提示文字  自动消失
 *
 *  @param title <#title description#>
 */
//底部提示
- (void)showHUDWithString:(NSString *)title;

//上部提示
-(void)showString:(NSString *)title;

/**
 *  在 appdelegate.widow 上添加一层 实现有些按钮点击之后界面上的其他点击事件无效
 */
- (void)addBackgroundViewWithView;


/**
 *  手机号码正则
 *
 *  @param str 手机号码
 *
 *  @return 返回 no 为错误号码  返回 yes 为正确号码
 */
- (BOOL)checkTel:(NSString *)str;

/**
 *  身份证号码正则
 *
 *  @param identityCard 身份证号
 *
 *  @return 返回 no 为错误号码  返回 yes 为正确号码
 */
- (BOOL)checkIDCardNumber:(NSString *)value;

/**
 *  邮箱正则
 *
 *  @param email 邮箱
 *
 *  @return 返回 no 为错误号码  返回 yes 为正确号码
 */
- (BOOL)checkEmail:(NSString *)email;

/**
 *  判断字符串是否为空
 *
 *  @param str 要判断的字符串
 *
 *  @return 返回 no 为空   yes 为不是空
 */
- (BOOL)Judge_str_null_with_str:(NSString*)str;

/**
 *  压缩图片尺寸
 *
 *  @param myImage  image 对象
 *  @param newSize  压缩尺寸  CGSize
 *
 *  @return 返回尺寸压缩后的 image 对象
 */
- (UIImage*)set_imageWithImage:(UIImage*)myImage scaledToSize:(CGSize)newSize;

/**
 *  压缩图片文件大小
 *
 *  @param myImage  image 对象
 *  @param image_float  文件大小  0.5 -- 1.5 之间
 *
 *  @return 这里直接返回 NSData 对象 方便上传
 */
- (NSData*)set_ImageData_UIImageJPEGRepresentationWithImage:(UIImage*)image

                                CGFloat_compressionQuality:(CGFloat)image_float;
/**
 *  重写界面的触摸事件
 *
 */
-(void)keyboardHide:(UITapGestureRecognizer*)tap;


// 刷新
- (void)setupRefresh;

- (void)headerRereshing;
- (void)footerRereshing;

- (void)setupHaderRefresh;

#pragma mark -- 键盘上方完成按钮
-(void)keyboradReturn:(UITextField *)text;

// 比例适配
#define WIDTH_FIT (([UIScreen mainScreen].bounds.size.width / 375.0))
#define HEIGHT_FIT (([UIScreen mainScreen].bounds.size.height / 667.0))

//按屏幕返回字体大小
-(CGFloat)font;


//时间戳转时间
-(NSString *)dataTotime:(NSInteger)data;
-(NSString *)dataTotimemin:(NSString *)data;

//时间转成时间戳
-(NSInteger)timeTodata:(NSString *)timeStr;
-(NSString *)timeToStr:(NSString *)timeStr;
#pragma mark -- 生成当前时间的时间戳
-(NSString *)NowTimeDate;

//web
-(void)addWebView:(NSString *)url and:(CGRect)frame;

#pragma mark -- 跟据16位＃颜色值返回颜色
-(UIColor *) hexStringToColor: (NSString *) stringToConvert;

#pragma mark -- 矫正字符串为空
-(BOOL)stringIsToNull:(NSString *)str;

#pragma mark - JSON方式获取数据
-(void)getDataSource:(NSString *)urlStr
              Params:(NSDictionary*)params
             success:(void (^)(NSDictionary * json))success
                fail:(void (^)())fail;

#pragma mark - post方式获取数据
-(void)PostDataSource:(NSString *)urlStr
               Params:(NSString *)params
              success:(void (^)(NSDictionary * json))success
                 fail:(void (^)())fail;

#pragma mark - POST上传图片
-(void)Image_Post_UploadWithUrl:(NSString *)urlStr
                         Params:(NSDictionary*)params
              Idcard_front_Data:(NSData*)idcard_front_data
          Idcard_front_fileName:(NSString*)idcard_front_file_name
                        success:(void (^)(NSDictionary * json))success
                           fail:(void (^)())fail;

#pragma mark --- webservice Post请求
-(void)request:(NSString *)soap url_s:(NSString *)url_s success:(void(^)(NSDictionary * dic))success fail:(void(^)(NSString *failDes))fail;

#pragma mark -- 打电话
-(void)call_tel:(NSString *)tel;
-(void)call_tel_new:(NSString *)tel title:(NSString *)title_me;

#pragma mark -- 加在本地html
- (void)loadHTML:(NSString *)title;
- (void)loadHTML:(NSString *)title and:(CGRect)frame;

//各个屏幕的尺寸(宽)

#define iphone4S_5_5S_w 320.000000

#define iphone6_w 375.000000

#define iphone6Plus_w 414.000000

//各个屏幕的尺寸(高)

#define iphone4S_h 480.000000

#define iphone5_5S_h 568.000000

#define iphone6_h 667.000000

#define iphone6Plus_h 736.000000

#define topHight 64

#define def_gre [UIColor colorWithRed:85/255.00 green:191/255.00 blue:164/255.00 alpha:1]

#define def_yel [UIColor colorWithRed:229/255.00 green:164/255.00 blue:168/255.00 alpha:1]

@end
