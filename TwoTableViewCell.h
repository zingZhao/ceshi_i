//
//  TwoTableViewCell.h
//  i_就业
//
//  Created by 赵奎博 on 16/4/13.
//  Copyright © 2016年 赵奎博. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwoItem.h"
@interface TwoTableViewCell : UITableViewCell
@property (strong, nonatomic) UILabel *leftlabel;
@property (strong, nonatomic) UILabel *centerlabel;
@property (strong, nonatomic) UILabel *rightlabel;
@property (strong, nonatomic) UILabel *rightlabel_line;
-(void)getItem:(TwoItem *)item;
@end
