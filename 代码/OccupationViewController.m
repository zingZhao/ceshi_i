//
//  OccupationViewController.m
//  i_就业
//
//  Created by 赵奎博 on 16/7/6.
//  Copyright © 2016年 赵奎博. All rights reserved.
//

#import "OccupationViewController.h"
#import "OccuoCell.h"
#import "TwoItem.h"
#import "DetailViewController.h"
@interface OccupationViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger page;
    NSMutableArray * _dataArray;
}
@property (strong, nonatomic)  UITableView  * MyTableView;

@end

@implementation OccupationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    page = 1;
    
    _dataArray = [[NSMutableArray alloc]init];

    self.view.backgroundColor = DEF_RGB_COLOR(230, 230, 230);
    //左按钮
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 23, 25, 25)];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:[UIImage imageNamed:@"arrow_left_fff"] forState:0];
    [leftBtn setImage:[UIImage imageNamed:@"arrow_left_fff"] forState:UIControlStateSelected];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = item;
    self.title = @"职业测评";
    
    _MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT - 64)];
    _MyTableView.showsVerticalScrollIndicator = NO;
    _MyTableView.delegate = self;
    _MyTableView.dataSource = self;
    _MyTableView.rowHeight = DEF_SCREEN_WIDTH / 3 + 60;
    _MyTableView.backgroundColor = DEF_RGB_COLOR(219, 219, 219);
    _MyTableView.tableFooterView = [[UIView alloc]init];
    _MyTableView.userInteractionEnabled = YES;
    [self.view addSubview:_MyTableView];
    //_MyTableView.contentSize = CGSizeMake(DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT * 3);
    [self setupRefresh];
    
    [self getData];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OccuoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"hehe"];
    
    if(cell == nil){
        cell = [[OccuoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"hehe"];
    }
    
    TwoItem * item = _dataArray[indexPath.row];
    
    [cell.topImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",image_head,item.img]]];
    
    cell.centerLabel.text = item.title;
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPat{
    TwoItem * item = _dataArray[indexPat.row];
    
    DetailViewController * dvc = [[DetailViewController alloc]init];
    dvc.item = item;
    dvc.type = @"2";
    [self.navigationController pushViewController:dvc animated:YES];
}


#pragma mark --  设置刷新
- (void)setupRefresh
{
    
    __weak OccupationViewController *weakSelf = self;
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    _MyTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf tableViewDidTriggerHeaderRefresh];
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
    //[_tableOne addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    _MyTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf tableViewDidTriggerFooterRefresh];
        [weakSelf.tableView.mj_footer beginRefreshing];
    }];
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
//    [_MyTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
//    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
//    [_MyTableView addFooterWithTarget:self action:@selector(footerRereshing)];
//    [_MyTableView footerEndRefreshing];
//    
//    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
//    _MyTableView.headerPullToRefreshText = @"下拉刷新";
//    _MyTableView.headerReleaseToRefreshText = @"松开刷新";
//    _MyTableView.headerRefreshingText = @"正在刷新";
//    
//    _MyTableView.footerPullToRefreshText = @"上拉加载";
//    _MyTableView.footerReleaseToRefreshText = @"松开加载更多数据";
//    _MyTableView.footerRefreshingText = @"正在加载";
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
    
   // sleep(1);
    //[_MyTableView headerEndRefreshing];
    
}

-(void)footerRereshing
{
    //[self removebtnall];
    
    //sleep(1);
    //[_MyTableView footerEndRefreshing];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        page = 1 + page;
        
        [self getData];
    });
    
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getData{
    
    if(page == 1)
    {
        [_dataArray removeAllObjects];
    }
    
    
    [self getDataSource:[NSString stringWithFormat:@"%@%@",URL_url,URL_list] Params:@{@"page":[NSString stringWithFormat:@"%ld",page],@"type":@"3"} success:^(NSDictionary *json) {
        
        NSDictionary * array_lis = json[@"data"];
        
        NSArray * array_list_job = array_lis[@"list"];
        
        
        if(page > 1 && array_list_job.count == 0){
            page--;
        }
        
        for (NSDictionary * di in array_list_job) {
            TwoItem * item = [[TwoItem alloc]init];
            item.mydescription = [NSString stringWithFormat:@"%@",di[@"description"]];
            [item setValuesForKeysWithDictionary:di];
            [_dataArray addObject:item];
            
        }
        [_MyTableView.mj_header endRefreshing];
        [_MyTableView.mj_footer endRefreshing];
//        [_MyTableView headerEndRefreshing];
//        [_MyTableView footerEndRefreshing];
        
        [_MyTableView reloadData];
        
    } fail:^{
        [_MyTableView.mj_header endRefreshing];
        [_MyTableView.mj_footer endRefreshing];
//        [_MyTableView headerEndRefreshing];
//        [_MyTableView footerEndRefreshing];
        
    }];
}

@end
