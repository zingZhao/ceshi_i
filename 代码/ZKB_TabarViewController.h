//
//  ZKB_TabarViewController.h
//  i_就业
//
//  Created by 赵奎博 on 16/4/25.
//  Copyright © 2016年 赵奎博. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKB_TabarViewController : UITabBarController
{
    UIButton * one;
    UIButton * two;
    UIButton * three;
    UIButton * four;
    
    UIImageView * one_image;
    UIImageView * two_image;
    UIImageView * three_image;
    UIImageView * four_image;
}
@property (nonatomic, strong) UIView* myTabbar;


-(void)setViewcontrolers:(NSArray *)viewControlers titles:(NSArray *)titles images:(NSArray *)images slectImages:(NSArray *)slectImages;

@end
