//
//  OneTableViewCell.m
//  i_就业
//
//  Created by 赵奎博 on 16/4/13.
//  Copyright © 2016年 赵奎博. All rights reserved.
//

#import "OneTableViewCell.h"
#import "Eleven_Header.h"
#import "UIImageView+WebCache.h"
@implementation OneTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.leftimage = [[UIImageView alloc]initWithFrame:CGRectMake(16, 10, 100, 65)];
        [self addSubview:self.leftimage];
        
        self.rightlabel = [[UILabel alloc]initWithFrame:CGRectMake(DEF_RIGHT(self.leftimage) + 10, 10, DEF_SCREEN_WIDTH - DEF_RIGHT(self.leftimage) - 20, DEF_HEIGHT(self.leftimage))];
        self.rightlabel.numberOfLines = 0;
        self.rightlabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.rightlabel];
        
        self.rightlabel_line = [[UILabel alloc]initWithFrame:CGRectMake(16, 81.3, DEF_SCREEN_WIDTH - 16, 0.7)];
        self.rightlabel_line.backgroundColor = DEF_RGB_COLOR(200, 200, 200);
        [self addSubview:self.rightlabel_line];
    }
    
    return self;
}


-(void)getItem:(TwoItem *)item{
    [self.leftimage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",image_head,item.img]] placeholderImage:[UIImage imageNamed:@"3.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"%@",@"完成");
    }];
    
    self.rightlabel.text = item.title;
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
