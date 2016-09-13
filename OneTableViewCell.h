//
//  OneTableViewCell.h
//  i_就业
//
//  Created by 赵奎博 on 16/4/13.
//  Copyright © 2016年 赵奎博. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwoItem.h"
@interface OneTableViewCell : UITableViewCell
@property (strong, nonatomic) UIImageView *leftimage;
@property (strong, nonatomic) UILabel *rightlabel;
@property (strong, nonatomic) UILabel *rightlabel_line;
-(void)getItem:(TwoItem *)item;
@end
