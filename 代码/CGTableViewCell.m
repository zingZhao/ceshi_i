//
//  CGTableViewCell.m
//  i_就业
//
//  Created by 赵奎博 on 16/7/11.
//  Copyright © 2016年 赵奎博. All rights reserved.
//

#import "CGTableViewCell.h"
#import "Eleven_Header.h"
@implementation CGTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        //self.backgroundColor = DEF_RGB_COLOR(230, 230, 230);
        
        self.rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH - 35, 20, 20, 20)];
        //self.topImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.rightImage.image = [UIImage imageNamed:@"arrow_right_dbdbdb"];
        [self addSubview:self.rightImage];
        
        
        self.leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(16,10, DEF_SCREEN_WIDTH - 55, 40)];
        self.leftLabel.font = [UIFont systemFontOfSize:15];
        self.leftLabel.numberOfLines = 0;
        //self.centerLabel.backgroundColor = [UIColor greenColor];
        [self addSubview:self.leftLabel];
        
        self.rightlabel_line = [[UILabel alloc]initWithFrame:CGRectMake(0, 59, DEF_SCREEN_WIDTH, 1)];
        self.rightlabel_line.backgroundColor = DEF_RGB_COLOR(230, 230, 230);
        [self addSubview:self.rightlabel_line];
    }
    
    return self;
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
