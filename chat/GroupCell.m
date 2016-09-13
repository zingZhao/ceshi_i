//
//  GroupCell.m
//  i_就业
//
//  Created by 赵奎博 on 16/8/25.
//  Copyright © 2016年 赵奎博. All rights reserved.
//

#import "GroupCell.h"
#import "UIImageView+WebCache.h"
#define Swid [UIScreen mainScreen].bounds.size.width
@implementation GroupCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.groupImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 40, 40)];
        self.groupImage.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.groupImage];
        
        self.labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, Swid - 70, 20)];
        self.labelTitle.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.labelTitle];
        
        self.labelDec = [[UILabel alloc]initWithFrame:CGRectMake(60, 30, Swid - 70, 20)];
        self.labelDec.font = [UIFont systemFontOfSize:15];
        self.labelDec.textColor = [UIColor grayColor];
        [self addSubview:self.labelDec];
    }
    return self;
}

-(void)getGroup:(EMGroup *)group{
    [self.groupImage sd_setImageWithURL:@"" placeholderImage:[UIImage imageNamed:@"group_header"]];
    if (group.subject && group.subject.length > 0) {
        self.labelTitle.text = group.subject;
    }
    else {
        self.labelTitle.text = group.groupId;
    }
    CGFloat hei = [self sizeOfStr:group.description andFont:[UIFont systemFontOfSize:15] andMaxSize:CGSizeMake(Swid - 70, MAXFLOAT) andLineBreakMode:NSLineBreakByClipping].height;
    
    self.labelDec.frame = CGRectMake(60, 30, Swid - 70, hei);
    self.labelDec.text = group.description;
}

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

@end
