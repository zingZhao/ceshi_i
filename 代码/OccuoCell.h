//
//  OccuoCell.h
//  i_就业
//
//  Created by 赵奎博 on 16/7/6.
//  Copyright © 2016年 赵奎博. All rights reserved.
//

#import "BMBaseTableViewCell.h"
#import "TwoItem.h"
@interface OccuoCell : BMBaseTableViewCell
@property (nonatomic,strong)UIImageView * topImageView;
@property (nonatomic,strong)UIButton * leftButton;
@property (nonatomic,strong)UIButton * rightButton;
@property (nonatomic,strong)UILabel * centerLabel;
-(void)getData:(TwoItem *)item;
@end
