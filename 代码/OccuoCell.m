//
//  OccuoCell.m
//  i_就业
//
//  Created by 赵奎博 on 16/7/6.
//  Copyright © 2016年 赵奎博. All rights reserved.
//

#import "OccuoCell.h"
#define wid 15
@implementation OccuoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor = DEF_RGB_COLOR(230, 230, 230);
        self.userInteractionEnabled = YES;
        
        self.topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(wid, 20, DEF_SCREEN_WIDTH - wid * 2, DEF_SCREEN_WIDTH / 3)];
        //self.topImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.topImageView];
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(wid, DEF_BOTTOM(self.topImageView), DEF_SCREEN_WIDTH - wid * 2, 40)];
        view.backgroundColor = [UIColor whiteColor];
        view.userInteractionEnabled = YES;
        [self addSubview:view];
        
        self.leftButton = [UIButton buttonWithType:0];
         [self.leftButton setImage:[UIImage imageNamed:@"oc_leftbtn.png"] forState:0];
        self.leftButton.frame = CGRectMake(5,5, 30, 30);
        [self.leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
        //self.leftButton.backgroundColor = [UIColor purpleColor];
        [view addSubview:self.leftButton];
        
        self.rightButton = [UIButton buttonWithType:0];
        [self.rightButton setImage:[UIImage imageNamed:@"oc_rightbtn.png"] forState:0];
        self.rightButton.frame = CGRectMake(DEF_RIGHT(view) - 45,5, 30, 30);
        [self.rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
        //self.rightButton.backgroundColor = [UIColor whiteColor];
        [view addSubview:self.rightButton];
        
        self.centerLabel = [[UILabel alloc]initWithFrame:CGRectMake(40,5, DEF_WIDTH(view) - 80, 30)];
        self.centerLabel.textAlignment = NSTextAlignmentCenter;
        self.centerLabel.font = [UIFont systemFontOfSize:15];
        //self.centerLabel.backgroundColor = [UIColor greenColor];
        [view addSubview:self.centerLabel];
    }
    
    return self;
}

-(void)getData:(TwoItem *)item{
    //[self.topImageView sd_setImageWithURL:[NSURL URLWithString:item.img]];
    
    //self.centerLabel.text = item.title;
}

-(void)leftAction{
    NSLog(@"left");
}

-(void)rightAction{
    NSLog(@"right");
}

@end
