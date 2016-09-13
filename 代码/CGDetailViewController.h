//
//  CGDetailViewController.h
//  i_就业
//
//  Created by 赵奎博 on 16/7/11.
//  Copyright © 2016年 赵奎博. All rights reserved.
//

#import "BMBaseViewController.h"
#import "TwoItem.h"
@interface CGDetailViewController : BMBaseViewController
@property (nonatomic,retain) TwoItem * item;
@property (nonatomic,copy) NSString * type;
@end
