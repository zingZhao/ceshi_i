//
//  Eleven_Header.h
//  Eleven_frame
//
//  Created by 吕君 on 15/4/2.
//  Copyright (c) 2015年 eleven. All rights reserved.
//

#ifndef Eleven_frame_Eleven_Header_h
#define Eleven_frame_Eleven_Header_h

/**
 *  导航栏颜色
 */
#define NAVColor  [UIColor colorWithRed:50/255.00 green:102/255.00 blue:204/255.00 alpha:1]


/**
 *  导航栏颜色
 */
#define AppColor  [UIColor colorWithRed:53/255.00 green:165/255.00 blue:241/255.00 alpha:1]

/**
 *  导航栏颜色
 */
#define GrayText  [UIColor colorWithRed:153/255.00 green:153/255.00 blue:153/255.00 alpha:1]

/**
 *  导航栏颜色
 */
#define GrayLine  [UIColor colorWithRed:219/255.00 green:219/255.00 blue:219/255.00 alpha:1]

/**
 *  导航栏颜色
 */
#define RedText  [UIColor colorWithRed:227/255.00 green:85/255.00 blue:7/255.00 alpha:1]


/**
 *  网络请求域名
 */
#define URL_url @"http://121.42.63.42/"
//#define URL_url @"http://siqi.ilikedh.com/"

//#define URL_url @"http://121.42.63.42:8090/"


/**
 *  图片前缀
 *
 *  @param ... <#... description#>
 *
 *  @return <#return value description#>
 */
#define image_head @"http://121.42.63.42/web/jobImage/"


/**
 *  登录
 */
#define URL_login @"ijob/loginApp.do"

/**
 *  申请记录
 *
 *  @param ... studentId 账号id
 *
 *  @return nil
 */
#define URL_applyList @"ijob/applyJobListApp.do"

/**
 *  单条申请记录
 *
 *  @param ... tid 申请记录id
 *
 *  @return nil
 */
#define URL_applyDetailApp @"ijob/applyDetailApp.do"

/**
 *  新增申请
 *
 *  @param ... studentId 个人id jobId 工作id
 *
 *  @return nil
 */
#define URL_addApplyApp @"ijob/addApplyApp.do"

/**
 *  新增报名
 *
 *  @param ... studentId 个人id jobId 工作id
 *
 *  @return nil
 */
#define URL_addEnrollApp @"ijob/addEnrollApp.do"

/**
 *  修改申请
 *
 *  @param ... studentId-个人id jobId-工作id  state-状态 tid-申请id
 *
 *  @return nil
 */
#define URL_updateApplyApp @"ijob/updateApplyApp.do"

/**
 *  删除申请
 *
 *  @param ... tid-申请id
 *
 *  @return nil
 */
#define URL_deleteApplyApp @"ijob/deleteApplyApp.do"

/**
 *  申请职位记录
 *
 *  @param ... studentId-个人id
 *
 *  @return nil
 */
#define URL_applyJobListApp @"ijob/applyJobListApp.do"

/**
 *  公司记录
 *
 *  @param ... nil
 *
 *  @return nil
 */
#define URL_companyListApp @"ijob/companyListApp.do"


/**
 *  单条公司记录
 *
 *  @param ... tid 公司id
 *
 *  @return nil
 */
#define URL_companyDetailApp @"ijob/companyDetailApp.do"


/**
 *  新增公司记录
 *
 *  @param ... name-公司名字 description-公司描述 link-公司链接
 *
 *  @return nil
 */
#define URL_addCompanyApp @"ijob/addCompanyApp.do"

/**
 *  修改公司记录
 *
 *  @param ... name-公司名字 description-公司描述 link-公司链接 tid-公司id
 *
 *  @return nil
 */
#define URL_updateCompanyApp @"ijob/updateCompanyApp.do"

/**
 *  删除公司记录
 *
 *  @param ... tid-公司id
 *
 *  @return nil
 */
#define URL_deleteCompanyApp @"ijob/deleteCompanyApp.do"

/**
 *  报名记录
 *
 *  @param ... nil
 *
 *  @return nil
 */
#define URL_enrollListApp @"ijob/enrollInfoListApp.do"


/**
 *  单条登记记录
 *
 *  @param ... nil  tid-登记id
 *
 *  @return nil
 */
#define URL_enrollDetailApp @"ijob/enrollDetailApp.do"


/**
 *  单条登记记录
 *
 *  @param ... nil  tid-登记id
 *
 *  @return nil
 */
#define URL_enrollDetailApp @"ijob/enrollDetailApp.do"

/**
 *  新增登记记录
 *
 *  @param ... nil  studentId-个人id  infoId-信息id
 *
 *  @return nil
 */
#define URL_enrollDetailApp @"ijob/enrollDetailApp.do"


/**
 *  校企合作
 */
#define URL_sch @"ijob/companyListPageApp.do"

/**
 *  首页第一张图片
 */
#define URL_oneImage @"getJob/imgs/500_80.jpg"

/**
 *  首页第二张图片
 */
#define URL_twoImage @"getJob/imgs/500_200.jpg"

/**
 *  首页第三张图片
 */
#define URL_threeImage @"getJob/imgs/100_40_1.jpg"

/**
 *  首页第四张图片
 */
#define URL_fourImage @"getJob/imgs/100_40_2.jpg"


/**
 *  首页列表
 */
//#define URL_list @"getJob/queryPosition.do"
#define URL_list @"ijob/infoListPageApp.do"

/**
 *  职位信息列表
 */
#define URL_list_job @"ijob/jobListApp.do"


/**
 *  修改个人资料
 */
#define URL_save @"ijob/updateStudentApp.do"

/**
 *  子视图的高度 全部以这个系数为基准
 */
#define DEF_SubView_Height 30

/**
 *  字号
 */
#define DEF_Font 13

/// DEBUG模式下进行调试打印

#define DEF_DEBUG(...)   NSLog(__VA_ARGS__)

/**
 *	获取视图宽度
 *
 *	@param 	view 	视图对象
 *
 *	@return	宽度
 */
#define DEF_WIDTH(view) view.bounds.size.width

/**
 *	获取视图高度
 *
 *	@param 	view 	视图对象
 *
 *	@return	高度
 */
#define DEF_HEIGHT(view) view.bounds.size.height

/**
 *	获取视图原点横坐标
 *
 *	@param 	view 	视图对象
 *
 *	@return	原点横坐标
 */
#define DEF_X(view) view.frame.origin.x

/**
 *	获取视图原点纵坐标
 *
 *	@param 	view 	视图对象
 *
 *	@return	原点纵坐标
 */
#define DEF_Y(view) view.frame.origin.y

/**
 *	获取视图右下角横坐标
 *
 *	@param 	view 	视图对象
 *
 *	@return	右下角横坐标
 */
#define DEF_RIGHT(view) (DEF_X(view) + DEF_WIDTH(view))

/**
 *	获取视图右下角纵坐标
 *
 *	@param 	view 	视图对象
 *
 *	@return	右下角纵坐标
 */
#define DEF_BOTTOM(view) (DEF_Y(view) + DEF_HEIGHT(view))

/**
 *  主屏的宽
 */
#define DEF_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

/**
 *  主屏的高
 */
#define DEF_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

/**
 *  主屏的size
 */
#define DEF_SCREEN_SIZE   [[UIScreen mainScreen] bounds].size

/**
 *  主屏的frame
 */
#define DEF_SCREEN_FRAME  [UIScreen mainScreen].applicationFrame

/**
 *	生成RGB颜色
 *
 *	@param 	red 	red值（0~255）
 *	@param 	green 	green值（0~255）
 *	@param 	blue 	blue值（0~255）
 *
 *	@return	UIColor对象
 */
#define DEF_RGB_COLOR(a,b,c) [UIColor colorWithRed:a/255.00 green:b/255.00 blue:c/255.00 alpha:1]

/**
 *	生成RGBA颜色
 *
 *	@param 	red 	red值（0~255）
 *	@param 	green 	green值（0~255）
 *	@param 	blue 	blue值（0~255）
 *	@param 	alpha 	blue值（0~1）
 *
 *	@return	UIColor对象
 */
#define DEF_RGBA_COLOR(a, b, c, d) [UIColor colorWithRed:a/255.00 green:b/255.00 blue:c/255.00 alpha:d]


/**
 *	生成RGB颜色
 *
 *	@param 	rgb 	RGB颜色值（必须0x开头，例如:0xffffff）
 *
 *	@return	UIColor对象
 */
#define DEF_RGB_INT_COLOR(rgb) [UIColor colorWithRGB:rgb]

/**
 *	生成RGBA颜色
 *
 *	@param 	string 	颜色描述字符串，带“＃”开头
 *
 *	@return	UIColor对象
 */
#define DEF_STRING_COLOR(string) [UIColor colorWithString:string]

/**
 *  self.contentView的高度
 */
#define DEF_CONTENT DEF_SCREEN_HEIGHT - 20 - 44

/**
 *  字号适配 iphone5为基准  需要时使用 一般 iphone 不需要适配字体
 */
#define DEF_Adaptation_Font (([UIScreen mainScreen].bounds.size.height / 568.0))
/**
 *  判断屏幕尺寸是否为640*1136
 *
 *	@return	判断结果（YES:是 NO:不是）
 */
#define DEF_SCREEN_IS_640_1136 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

/**
 *	永久存储对象
 *
 *	@param	object    需存储的对象
 *	@param	key    对应的key
 */
#define DEF_PERSISTENT_SET_OBJECT(object, key)                                                                                                 \
({                                                                                                                                             \
NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];                                                                         \
[defaults setObject:object forKey:key];                                                                                                    \
[defaults synchronize];                                                                                                                    \
})

/**
 *	取出永久存储的对象
 *
 *	@param	key    所需对象对应的key
 *	@return	key所对应的对象
 */
#define DEF_PERSISTENT_GET_OBJECT(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

/*
 字体大小
 */
#define font(a) a/1.7

#endif
