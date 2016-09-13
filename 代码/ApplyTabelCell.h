//
//  ApplyTabelCell.h
//  i_就业
//
//  Created by 赵奎博 on 16/7/11.
//  Copyright © 2016年 赵奎博. All rights reserved.
//

#import "BMBaseTableViewCell.h"
#import "ApplyItem.h"
#import "HJShapedImageView.h"
@interface ApplyTabelCell : BMBaseTableViewCell
@property (nonatomic,strong) UILabel * label_left;
@property (nonatomic,strong) UILabel * label_line_left;
@property (nonatomic,strong) UIImageView * image_left;

@property (nonatomic,strong) HJShapedImageView * image_right;
@property (nonatomic,strong) UILabel * label_top;
@property (nonatomic,strong) UILabel * label_Line_right;
@property (nonatomic,strong) UILabel * label_bottom;

-(void)getItem:(ApplyItem *)item;
@end
