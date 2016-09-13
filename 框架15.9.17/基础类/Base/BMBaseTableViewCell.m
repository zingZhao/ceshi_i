//
//  BMBaseTableViewCell.m
//  Eleven_frame
//
//  Created by 吕君 on 15/4/2.
//  Copyright (c) 2015年 eleven. All rights reserved.
//
#import "BMBaseTableViewCell.h"

@implementation BMBaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSString *)dataTotimeint:(NSInteger)data
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
    
    NSArray * array = [confromTimespStr componentsSeparatedByString:@" "];
    
    NSString * str_dian = array[1];
    
    NSArray * array_d = [str_dian componentsSeparatedByString:@":"];
    
    NSString * str_r = [NSString stringWithFormat:@"%@:%@",array_d[0],array_d[1]];
    
    return str_r;
}

-(NSString *)dataTotime:(NSString *)data
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

- (CGSize)sizeOfStr:(NSString *)str
            andFont:(UIFont *)font
         andMaxSize:(CGSize)size
{
    CGSize s;
    if ([[[UIDevice currentDevice]systemVersion]doubleValue]>=7.0) {
        NSDictionary *dic=@{NSFontAttributeName:font};
        s = [str boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                           attributes:dic context:nil].size;
    }
    else
    {
        s=[str sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    }
    return s;
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

@end
