//
//  BMBaseTableViewCell.h
//  Eleven_frame
//
//  Created by 吕君 on 15/4/2.
//  Copyright (c) 2015年 eleven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Eleven_Header.h"
/**
 *  自定义TableViewCell的基类
 */
@interface BMBaseTableViewCell : UITableViewCell

/**
 *  初始化TableViewCell的数据
 */
@property (nonatomic, strong) id data;

/**
 *  时间戳到时间
 *
 */
-(NSString *)timeToStr:(NSString *)timeStr;
/**
 *  时间到时间戳
 *
 */
-(NSString *)dataTotime:(NSString *)data;
-(NSString *)dataTotimeint:(NSInteger)data;
/**
 *  计算label所需高度
 *
 */
- (CGSize)sizeOfStr:(NSString *)str
            andFont:(UIFont *)font
         andMaxSize:(CGSize)size;
/**
 *  16进制数转uicolor
 *
 */
-(UIColor *) hexStringToColor: (NSString *) stringToConvert;

@end
