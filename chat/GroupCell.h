//
//  GroupCell.h
//  i_就业
//
//  Created by 赵奎博 on 16/8/25.
//  Copyright © 2016年 赵奎博. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "EMGroup.h"
@interface GroupCell : BaseTableViewCell
@property (nonatomic,strong)UIImageView * groupImage;
@property (nonatomic,strong)UILabel * labelTitle;
@property (nonatomic,strong)UILabel * labelDec;
-(void)getGroup:(EMGroup *)group;
@end
