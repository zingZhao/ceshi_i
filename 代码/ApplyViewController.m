//
//  ApplyViewController.m
//  i_就业
//
//  Created by 赵奎博 on 16/7/11.
//  Copyright © 2016年 赵奎博. All rights reserved.
//

#import "ApplyViewController.h"
#import "ApplyItem.h"
#import "ApplyTabelCell.h"

@interface ApplyViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableOne;
    NSInteger page;
    NSMutableArray * _dataArray;
}

@end

@implementation ApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    page = 1;
    _dataArray = [[NSMutableArray alloc]init];

    //左按钮
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 23, 25, 25)];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:[UIImage imageNamed:@"arrow_left_fff"] forState:0];
    [leftBtn setImage:[UIImage imageNamed:@"arrow_left_fff"] forState:UIControlStateSelected];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = item;
    self.title = @"报名记录";


    _tableOne = [[UITableView alloc]initWithFrame:CGRectMake(0, topHight, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT - topHight)];
    _tableOne.showsVerticalScrollIndicator = NO;
    _tableOne.tableFooterView = [[UIView alloc]init];
    _tableOne.rowHeight = 60;
    _tableOne.backgroundColor = DEF_RGB_COLOR(230, 230, 230);
    _tableOne.delegate = self;
    _tableOne.dataSource = self;
    _tableOne.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableOne];
    
    [self setupRefresh];
    
    [self getData];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ApplyItem * item = _dataArray[indexPath.row];
    CGSize size = [self sizeOfStr:item.title andFont:[UIFont systemFontOfSize:17] andMaxSize:CGSizeMake(DEF_SCREEN_WIDTH - 110, MAXFLOAT) andLineBreakMode:NSLineBreakByClipping];
    return size.height + 100;
}

-(void)getData{
    
    if(page == 1)
    {
        [_dataArray removeAllObjects];
    }
    
    
    [self getDataSource:[NSString stringWithFormat:@"%@%@",URL_url,URL_enrollListApp] Params:@{@"page":[NSString stringWithFormat:@"%ld",page],@"studentId":[self.userDefaults objectForKey:@"uid"]} success:^(NSDictionary *json) {
        
        NSDictionary * array_lis = json[@"data"];
        
        NSArray * array_list_job = array_lis[@"list"];
        
        
        if(page > 1 && array_list_job.count == 0){
            page--;
        }
        
        for (NSDictionary * di in array_list_job) {
            ApplyItem * item = [[ApplyItem alloc]init];
            [item setValuesForKeysWithDictionary:di];
            item.Mydescription = [NSString stringWithFormat:@"%@",di[@"description"]];
            //item.salary = [NSString stringWithFormat:@"%@",di[@"salary"]];
            [_dataArray addObject:item];
            
        }
        [_tableOne.mj_header endRefreshing];
        [_tableOne.mj_footer endRefreshing];
//        [_tableOne headerEndRefreshing];
//        [_tableOne footerEndRefreshing];
        
        [_tableOne reloadData];
        
    } fail:^{
        [_tableOne.mj_header endRefreshing];
        [_tableOne.mj_footer endRefreshing];
//        [_tableOne headerEndRefreshing];
//        [_tableOne footerEndRefreshing];
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApplyTabelCell * cell = [tableView dequeueReusableCellWithIdentifier:@"q2"];
    if(cell == nil){
        cell = [[ApplyTabelCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"q2"];
    }
    
   ApplyItem * item = _dataArray[indexPath.row];
    [cell getItem:item];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark --  设置刷新
- (void)setupRefresh
{
    __weak ApplyViewController *weakSelf = self;
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    _tableOne.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf tableViewDidTriggerHeaderRefresh];
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
    //[_tableOne addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    _tableOne.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf tableViewDidTriggerFooterRefresh];
        [weakSelf.tableView.mj_footer beginRefreshing];
    }];
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
//    [_tableOne addHeaderWithTarget:self action:@selector(headerRereshing)];
//    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
//    [_tableOne addFooterWithTarget:self action:@selector(footerRereshing)];
//    [_tableOne footerEndRefreshing];
//    
//    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
//    _tableOne.headerPullToRefreshText = @"下拉刷新";
//    _tableOne.headerReleaseToRefreshText = @"松开刷新";
//    _tableOne.headerRefreshingText = @"正在刷新";
//    
//    _tableOne.footerPullToRefreshText = @"上拉加载";
//    _tableOne.footerReleaseToRefreshText = @"松开加载更多数据";
//    _tableOne.footerRefreshingText = @"正在加载";
}

- (void)tableViewDidTriggerHeaderRefresh
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        page = 1;
        
        [self getData];
    });
}

- (void)tableViewDidTriggerFooterRefresh
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        page = 1 + page;
        
        [self getData];
    });
}

-(void)headerRereshing
{
    //[self removebtnall];
    
    //[self end_search];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        page = 1;
        
        [self getData];
    });
    
    //sleep(1);
    
}

-(void)footerRereshing
{
    //[self removebtnall];
    
    //sleep(1);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        page = 1 + page;
        
        [self getData];
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
