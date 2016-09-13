//
//  UnityLH.m
//  UnityLH
//
//  Created by apple on 13-5-30.
//  Copyright (c) 2013年 UnityLH. All rights reserved.
//

#import "UnityLHClass.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@implementation UnityLHClass
static UnityLHClass *unityObject = nil;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (UnityLHClass*)shareUnityClassObject
{
    if (unityObject == nil) {
        unityObject = [[UnityLHClass alloc] init];
    }
    return unityObject;
}

#pragma mark -系统控件的初始化
+(UILabel*)initUILabel:(NSString*)strTitle font:(float)font color:(UIColor*)textColor  rect:(CGRect) rectText
{
    UILabel* label = [[UILabel alloc] initWithFrame:rectText];
    if ([strTitle isEqual:[NSNull null]]) {
        strTitle = @"";
    }
    label.text = strTitle;
    label.textColor = textColor;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:font];
    return label;
}

+(UIImageView*)initUIImageView:(NSString*) imageName rect:(CGRect)rectImage
{
    UIImageView*  imageView = [[UIImageView alloc] initWithFrame:rectImage];
    imageView.image = [UIImage imageNamed:imageName];
    return imageView;
}
+(UIButton*)initButton:(CGRect)rectButton str:(NSString *)strName
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:rectButton];
    [button setBackgroundImage:[UIImage imageNamed:strName] forState:UIControlStateNormal];
    return button;
}

+ (UITextField*)initTextFilerect:(CGRect) rectText
{
    UITextField *textTF = [[UITextField alloc]initWithFrame:rectText];
    textTF.font = [UIFont systemFontOfSize:13.0];
    textTF.placeholder = @"请输入....";
    textTF.clearsOnBeginEditing = YES;
    textTF.borderStyle = UITextBorderStyleRoundedRect;
    return textTF;
}
#pragma mark 弹出提示框
+(void)showPointOut:(NSString*)str
{
    UIAlertView* alertDlg = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertDlg show];
}

//获取字符串的宽度
+(int)getWithFromStr:(NSString*)str font:(float)font
{
    CGSize titleSize = [str sizeWithFont:[UIFont systemFontOfSize:font] constrainedToSize:CGSizeMake(MAXFLOAT, 20)];
    return titleSize.width;
}
//根据字符串的宽度获取size
+ (int)getsize:(NSString *)str wid:(CGFloat)th font:(CGFloat)size
{
    CGSize constraint = CGSizeMake(th, 20000.0f);
    CGSize sizeStr = [str sizeWithFont:[UIFont systemFontOfSize:size] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return sizeStr.height;
}

//判断是否是整形
+ (BOOL)isPureInt:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
//判断是否是浮点型
+ (BOOL)isPureFloat:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}
//判断是否是手机号码是否合法
+ (BOOL)checkTel:(NSString *)str
{
    //1[0-9]{10}
    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    //    NSString *regex = @"[0-9]{11}";
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}
//判断邮箱地址是否合法
+ (BOOL) validateEmail: (NSString *) candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}


//+ (NSString *)changeISO88591StringToUnicodeString:(NSString *)iso88591String
//{
//    NSMutableString *srcString = [[NSMutableString alloc]initWithString:iso88591String];
//    [srcString replaceOccurrencesOfString:@"&amp;" withString:@"&" options:NSLiteralSearch range:NSMakeRange(0, [srcString length])];
//    [srcString replaceOccurrencesOfString:@"&#x" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [srcString length])];
//    
//    NSMutableString *desString = [[NSMutableString alloc]init];
//    
//    NSArray *arr = [srcString componentsSeparatedByString:@";"];
//    
//    for(int i=0;i<[arr count]-1;i++){
//        NSString *v = [arr objectAtIndex:i];
//        char *c = malloc(3);
//        int value = [StringUtil changeHexStringToDecimal:v];
//        c[1] = value  &0x00FF;
//        c[0] = value >>8 &0x00FF;
//        c[2] = '\0';
//        [desString appendString:[NSString stringWithCString:c encoding:NSUnicodeStringEncoding]];
//        free(c);
//    }
//    
//    return desString;
//}

#pragma mark －获取当前系统的时间
+(NSString*)getCurrentTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    return dateString;
}


+(NSString*)strSepTime:(NSString*)strTime
{
    strTime = [strTime substringWithRange:NSMakeRange(0, 16)];
    return strTime;
}


/***************  金额小写转大写 start  ****************/
+(NSString *)converter:(NSString *)numStr
{//转换中文大写数字
    NSString *rel = nil;
    NSString *intStr = nil;
    NSString *floatStr1 = nil;
    NSString *floatStr2 = nil;
    NSRange range = [numStr rangeOfString:@"."];
    if (range.location != NSNotFound) {
        NSString *dStr = [numStr substringFromIndex:range.location+1];
        floatStr1 = [dStr substringToIndex:1];
        if (dStr.length == 2) {
            floatStr2 = [dStr substringFromIndex:1];
        }
        intStr = [numStr substringToIndex:range.location];
    }else{
        intStr = numStr;
    }
    
    NSString *topstr=[intStr stringByReplacingOccurrencesOfString:@"," withString:@""];//过滤逗号
    NSInteger numl=[topstr length];//确定长度
    NSString *cache;//缓存
    if ((numl==2||numl==6)&&[topstr hasPrefix:@"1"] ){//十位或者万位为一时候
        cache=@"拾";
        for (int i=1; i<numl; i++) {
            cache=[NSString stringWithFormat:@"%@%@",cache,[self bit:topstr thenum:i]];
        }
    }else{//其他
        cache=@"";
        for (int i=0; i<numl; i++) {
            cache=[NSString stringWithFormat:@"%@%@",cache,[self bit:topstr thenum:i]];
        }
    }//转换完大写
    rel = @"";
    if (![cache isEqualToString:@""]) {
        cache=[cache substringWithRange:NSMakeRange(0, [cache length]-1)];
    }else
    {
        cache = @"0";
    }
    for (NSInteger i=[cache length]; i>0; i--) {//擦屁股，如果尾部为0就擦除
        if ([cache hasSuffix:@"零"]) {
            cache=[cache substringWithRange:NSMakeRange(0, i-1)];
        }else{
            continue;
        }
    }
    for (NSInteger i=[cache length]; i>0; i--) {//重复零，删零
        NSString *a=[cache substringWithRange:NSMakeRange(i-1, 1)];
        NSString *b=[cache substringWithRange:NSMakeRange(i-2, 1)];
        if (!([a isEqualToString:b]&&[a isEqualToString:@"零"])) {
            rel = [NSString stringWithFormat:@"%@%@",a,rel];
        }
        cache=[cache substringWithRange:NSMakeRange(0, i-1)];
    }
    cache = rel;
    rel = @"元";
    for (NSInteger i=[cache length]; i>0; i--) {//去掉 “零万” 和 “亿万”
        NSString *a=[cache substringWithRange:NSMakeRange(i-1, 1)];
        NSString *b=[cache substringWithRange:NSMakeRange(i-2, 1)];
        if ([a isEqualToString:@"万"]&&[b isEqualToString:@"零"]) {
            NSString *c=[cache substringWithRange:NSMakeRange(i-3, 1)];
            if ([c isEqualToString:@"亿"]){
                rel = [NSString stringWithFormat:@"%@%@",c,rel];
                cache=[cache substringWithRange:NSMakeRange(0, i-3)];
                i=i-2;
            }else{
                rel = [NSString stringWithFormat:@"%@%@",a,rel];
                cache=[cache substringWithRange:NSMakeRange(0, i-2)];
                i--;
            }
        }else{
            rel = [NSString stringWithFormat:@"%@%@",a,rel];
        }
        cache=[cache substringWithRange:NSMakeRange(0, i-1)];
    }
    
    if ([rel isEqualToString:@"元"]) {
        rel=@"零元";
    }
    
    
    if (floatStr1!=nil ) {
        if (floatStr2!=nil && ![floatStr2 isEqualToString:@"0"]) {
            rel = [NSString stringWithFormat:@"%@%@角%@分",rel,[self NumtoCN:floatStr1 site:0],[self NumtoCN:floatStr2 site:0]];
        }else{
            if (![floatStr1 isEqualToString:@"0"]) {
                rel = [NSString stringWithFormat:@"%@%@角",rel,[self NumtoCN:floatStr1 site:0]];
            }
        }
    }
    
    return rel;
}


+(NSString*)NumtoCN:(NSString*)string site:(NSInteger)site
{//阿拉伯数字转中文大写
    if ([string isEqualToString:@"0"]) {
        if (site==5) {
            return @"万零";
        }else{
            return @"零";
        }
    }else if ([string isEqualToString:@"1"]) {
        string=@"壹";
    }else if ([string isEqualToString:@"2"]) {
        string=@"贰";
    }else if ([string isEqualToString:@"3"]) {
        string=@"叁";
    }else if ([string isEqualToString:@"4"]) {
        string=@"肆";
    }else if ([string isEqualToString:@"5"]) {
        string=@"伍";
    }else if ([string isEqualToString:@"6"]) {
        string=@"陆";
    }else if ([string isEqualToString:@"7"]) {
        string=@"柒";
    }else if ([string isEqualToString:@"8"]) {
        string=@"捌";
    }else if ([string isEqualToString:@"9"]) {
        string=@"玖";
    }
    
    
    switch (site) {
        case 1:
            return [NSString stringWithFormat:@"%@元",string];
            break;
        case 2:
            return [NSString stringWithFormat:@"%@拾",string];
            break;
        case 3:
            return [NSString stringWithFormat:@"%@佰",string];
            break;
        case 4:
            return [NSString stringWithFormat:@"%@仟",string];
            break;
        case 5:
            return [NSString stringWithFormat:@"%@万",string];
            break;
        case 6:
            return [NSString stringWithFormat:@"%@拾",string];
            break;
        case 7:
            return [NSString stringWithFormat:@"%@佰",string];
            break;
        case 8:
            return [NSString stringWithFormat:@"%@仟",string];
            break;
        case 9:
            return [NSString stringWithFormat:@"%@亿",string];
            break;
        default:
            return string;
            break;
    }
}
+(NSString*)bit:(NSString*)string thenum:(int)num
{ //取位转大写
    NSInteger site=[string length]-num;
    string=[string stringByReplacingOccurrencesOfString:@"," withString:@""];
    //    NSLog(@"传入字符串%@，总长度%d,传入位%d",string,[string length],num);
    string=[string substringWithRange:NSMakeRange(num,1)];
    string=[self NumtoCN:string site:site];
    //    NSLog(@"转换后:%@",string);
    return string;
    
}
@end
