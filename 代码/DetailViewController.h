//
//  DetailViewController.h
//  i_就业
//
//  Created by 赵奎博 on 16/4/13.
//  Copyright © 2016年 赵奎博. All rights reserved.
//

#import "BMBaseViewController.h"
#import "TwoItem.h"
@interface DetailViewController : BMBaseViewController
@property (nonatomic,retain) TwoItem * item;
@property (nonatomic,copy) NSString * myurl;
@property (nonatomic,copy) NSString * type;
@end
