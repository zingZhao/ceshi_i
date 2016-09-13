//
//  TwoTableViewCell.m
//  i_就业
//
//  Created by 赵奎博 on 16/4/13.
//  Copyright © 2016年 赵奎博. All rights reserved.
//

#import "TwoTableViewCell.h"
#import "Eleven_Header.h"
@implementation TwoTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        self.leftlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, DEF_SCREEN_WIDTH / 4.1, 20)];
        self.leftlabel.numberOfLines = 0;
        self.leftlabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.leftlabel];
        
        self.centerlabel = [[UILabel alloc]initWithFrame:CGRectMake(DEF_RIGHT(self.leftlabel), 20, DEF_SCREEN_WIDTH / 1.8 - 40, 20)];
        self.centerlabel.numberOfLines = 0;
        self.centerlabel.font = [UIFont systemFontOfSize:15];
        self.centerlabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.centerlabel];
        
        self.rightlabel = [[UILabel alloc]initWithFrame:CGRectMake(DEF_RIGHT(self.centerlabel), 20, DEF_SCREEN_WIDTH - DEF_RIGHT(self.centerlabel) - 30, 20)];
        self.rightlabel.numberOfLines = 0;
        self.rightlabel.textAlignment = NSTextAlignmentRight;
        self.rightlabel.font = [UIFont systemFontOfSize:15];
        self.rightlabel.textColor = [UIColor redColor];
        [self addSubview:self.rightlabel];
        
        UIImageView * image_enter = [[UIImageView alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH - 25, 20, 20, 20)];
        image_enter.image = [UIImage imageNamed:@"arrow_right_dbdbdb"];
        [self addSubview:image_enter];
        
        self.rightlabel_line = [[UILabel alloc]initWithFrame:CGRectMake(0, 59, DEF_SCREEN_WIDTH, 1)];
        self.rightlabel_line.backgroundColor = DEF_RGB_COLOR(230, 230, 230);
        [self addSubview:self.rightlabel_line];
    }
    
    return self;
}


-(void)getItem:(TwoItem *)item{
    
//    self.leftlabel.text = @"dsakdnsakldnsalkndsalkndklsandslkad";
//    
//    self.centerlabel.text = @"dksan klsaxmklsaunx asnxjsak x";
//    
//    self.rightlabel.text = @"dwiqhnxksxj92918hnxkls";
//    return;

    self.leftlabel.text = item.name;
    
    self.centerlabel.text = item.company;

    self.rightlabel.text = [NSString stringWithFormat:@"%@",item.salary];
    if(item.salary.integerValue == 0 && item.salary.length < 2){
        self.rightlabel.hidden = YES;
    }
    else
    {
        self.rightlabel.hidden = NO;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
