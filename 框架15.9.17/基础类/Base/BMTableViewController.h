//
//  BMTableViewController.h
//  Eleven_frame
//
//  Created by 吕君 on 15/4/2.
//  Copyright (c) 2015年 eleven. All rights reserved.
//
#import "BMBaseViewController.h"

@interface BMTableViewController : BMBaseViewController

/**
 *  第几页
 */
@property (nonatomic, assign) int pageNo;

/**
 *  每页几条
 */
@property (nonatomic, assign) int pageSize;      

/**
 *  刷新数据
 */
- (void)reloadData;

/**
 *  加载更多数据
 */
- (void)loadMoreData;

@end
