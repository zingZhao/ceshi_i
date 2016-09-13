//
//  ApplyTabelCell.m
//  i_就业
//
//  Created by 赵奎博 on 16/7/11.
//  Copyright © 2016年 赵奎博. All rights reserved.
//

#import "ApplyTabelCell.h"
#import "ApplyItem.h"
@implementation ApplyTabelCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = DEF_RGB_COLOR(230, 230, 230);
        self.label_left = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 60, 30)];
        self.label_left.font = [UIFont systemFontOfSize:20];
        self.label_left.textColor = DEF_RGB_COLOR(160, 160, 160);
        [self addSubview:self.label_left];
        
        UILabel * label_line = [[UILabel alloc]initWithFrame:CGRectMake(70, 0, 1, 15)];
        label_line.backgroundColor = DEF_RGB_COLOR(160, 160, 160);
        [self addSubview:label_line];
        
        self.label_line_left = [[UILabel alloc]init];
        self.label_line_left.backgroundColor = DEF_RGB_COLOR(160, 160, 160);
        [self addSubview:self.label_line_left];
        
        self.image_left = [[UIImageView alloc]initWithFrame:CGRectMake(64, 20, 14, 14)];
        self.image_left.layer.masksToBounds = YES;
        self.image_left.layer.cornerRadius = 7;
        self.image_left.backgroundColor = DEF_RGB_COLOR(79, 123, 230);
        
        self.label_top = [[UILabel alloc]init];
        self.label_top.textColor = [UIColor grayColor];
        self.label_top.font = [UIFont systemFontOfSize:17];
        self.label_top.numberOfLines = 0;
        [self.image_right addSubview:self.label_top];
        
        self.label_Line_right = [[UILabel alloc]init];
        self.label_Line_right.backgroundColor = DEF_RGB_COLOR(230, 230, 230);
        [self.image_right addSubview:self.label_Line_right];
        
        self.label_bottom = [[UILabel alloc]init];
        self.label_bottom.textColor = DEF_RGB_COLOR(200, 200, 200);
        self.label_bottom.font = [UIFont systemFontOfSize:14];
        self.label_bottom.textAlignment = NSTextAlignmentRight;
        [self.image_right addSubview:self.label_bottom];
    }
    
    return self;
}


-(void)getItem:(ApplyItem *)item{
    self.label_left.text = [self dataTotimeint:item.createTime.integerValue];
    
    if(self.label_left.text.length > 0){
        NSMutableAttributedString * att = [[NSMutableAttributedString alloc]initWithString:self.label_left.text];
        NSRange range;
        range.location = self.label_left.text.length - 3;
        range.length = 3;
        [att setAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]} range:range];
        self.label_left.attributedText = att;
    }
    
    
    CGSize size = [self sizeOfStr:item.title andFont:[UIFont systemFontOfSize:17] andMaxSize:CGSizeMake(DEF_SCREEN_WIDTH - 110, MAXFLOAT)];
    
    self.label_line_left.frame = CGRectMake(70, 40, 1, size.height + 65);
    
    [self.image_left removeFromSuperview];
    [self addSubview:self.image_left];


    if(self.image_right){
        self.image_right = nil;
    }
    self.image_right = [[HJShapedImageView alloc]initWithFrame:CGRectMake(90, 10, DEF_SCREEN_WIDTH - 100, size.height + 80)];
    self.image_right.image = [UIImage imageNamed:@"OOP"];
    [self addSubview:self.image_right];
    
    if(1){
        [self.label_top removeFromSuperview];
        [self.image_right addSubview:self.label_top];
        
        [self.label_Line_right removeFromSuperview];
        [self.image_right addSubview:self.label_Line_right];
        
        
        [self.label_bottom removeFromSuperview];
        [self.image_right addSubview:self.label_bottom];
    }

    //[self.image_right setuoGO];
    
    if(item.title.length > 0 && ![item.title isEqualToString:@"(null)"]){
        self.label_top.text = item.title;
    }
    else
    {
        self.label_top.text = @"";
    }
    if(item.type.intValue == 1){
        self.label_bottom.text = @"投递成功";
    }
    else
    {
        self.label_bottom.text = @"投递成功";
    }
    self.label_top.frame = CGRectMake(20, 10, DEF_SCREEN_WIDTH - 130, size.height + 20);

//    if(size.height < 30){
//        self.label_top.frame = CGRectMake(20, 10, DEF_SCREEN_WIDTH - 130, size.height + 20);
//    }
//    else
//    {
//    }
    self.label_Line_right.frame = CGRectMake(DEF_X(self.label_top), DEF_BOTTOM(self.label_top) + 10, DEF_WIDTH(self.label_top), 1);
    self.label_bottom.frame = CGRectMake(DEF_X(self.label_top), DEF_BOTTOM(self.label_top) + 15, DEF_WIDTH(self.label_top), 30);
    
}

-(NSString *)dataTotimeint:(NSInteger)data
{
    data = data/1000;
    
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
    
    NSString * str_dian = array[0];
    
    NSArray * array_d = [str_dian componentsSeparatedByString:@"-"];
    
    NSString * str_r = [NSString stringWithFormat:@"%@/%@",array_d[2],array_d[1]];
    
    return str_r;
}

@end
