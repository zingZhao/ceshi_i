//
//  SchComViewController.m
//  i_就业
//
//  Created by 赵奎博 on 16/5/27.
//  Copyright © 2016年 赵奎博. All rights reserved.
//

#import "SchComViewController.h"
#import "SchCmnItem.h"
#import "SchDesViewController.h"
@interface SchComViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    NSInteger page;
    NSMutableArray * _dataArray;
}
@property (nonatomic,strong) UITableView * tabel;
@end

@implementation SchComViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self addNavgationTitle:@"校企合作"];
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 23, 25, 25)];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:[UIImage imageNamed:@"arrow_left_fff"] forState:0];
    [leftBtn setImage:[UIImage imageNamed:@"arrow_left_fff"] forState:UIControlStateSelected];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    
    self.title = @"校企合作";

    page = 1;
    _dataArray = [[NSMutableArray alloc]init];
    
    [self initUI];
    
    [self setupRefresh];
    
    [self getData];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initUI{
   // self.tabelview
    [self.view addSubview:self.tabel];
}


-(UITableView *)tabel
{
    if(!_tabel){
        _tabel = [[UITableView alloc]initWithFrame:CGRectMake(0, topHight, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT - topHight)];
        _tabel.dataSource = self;
        _tabel.delegate = self;
        _tabel.rowHeight = 60;
        _tabel.tableFooterView = [[UIView alloc]init];
    }
    
    return _tabel;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"tb"];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"tb"];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.numberOfLines = 0;
        UIImageView * image_enter = [[UIImageView alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH - 30, 20, 20, 20)];
        image_enter.image = [UIImage imageNamed:@"arrow_right_dbdbdb"];
        [cell addSubview:image_enter];
    }
    
    SchCmnItem * itme = _dataArray[indexPath.row];
    cell.textLabel.text = itme.name;

    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SchCmnItem * item = _dataArray[indexPath.row];
    
    SchDesViewController * dvc = [[SchDesViewController alloc]init];
    dvc.url_zkb = item.link;
    [self.navigationController pushViewController:dvc animated:YES];
}

#pragma mark --  设置刷新
- (void)setupRefresh
{

    __weak SchComViewController *weakSelf = self;
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    _tabel.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf tableViewDidTriggerHeaderRefresh];
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
    //[_tableOne addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    _tabel.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf tableViewDidTriggerFooterRefresh];
        [weakSelf.tableView.mj_footer beginRefreshing];
    }];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
//    [self.tabel addHeaderWithTarget:self action:@selector(headerRereshing)];
//    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
//    [self.tabel addFooterWithTarget:self action:@selector(footerRereshing)];
//    [self.tabel footerEndRefreshing];
//    
//    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
//    self.tabel.headerPullToRefreshText = @"下拉刷新";
//    self.tabel.headerReleaseToRefreshText = @"松开刷新";
//    self.tabel.headerRefreshingText = @"正在刷新";
//    
//    
//    self.tabel.footerPullToRefreshText = @"上拉加载";
//    self.tabel.footerReleaseToRefreshText = @"松开加载更多数据";
//    self.tabel.footerRefreshingText = @"正在加载";
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

-(void)getData{
    
    if(page == 1)
    {
        [_dataArray removeAllObjects];
    }
    
    
    [self getDataSource:[NSString stringWithFormat:@"%@%@",URL_url,URL_sch] Params:@{@"page":[NSString stringWithFormat:@"%ld",page]} success:^(NSDictionary *json) {
        
        NSDictionary * array_lis = json[@"data"];
        
        NSArray * array_list_job = array_lis[@"list"];
        
//        
        if(page > 1 && array_list_job.count == 0){
            page--;
        }
        
        for (NSDictionary * di in array_list_job) {
            SchCmnItem * item = [[SchCmnItem alloc]init];
            [item setValuesForKeysWithDictionary:di];
            item.mydescription = [NSString stringWithFormat:@"%@",di[@"description"]];
            [_dataArray addObject:item];
            
        }
        
        [_tabel.mj_header endRefreshing];
        [_tabel.mj_footer endRefreshing];
//        [self.tabel headerEndRefreshing];
//        [self.tabel footerEndRefreshing];
        
        [self.tabel reloadData];
        
    } fail:^{
        [_tabel.mj_header endRefreshing];
        [_tabel.mj_footer endRefreshing];
//        [self.tabel headerEndRefreshing];
//        [self.tabel footerEndRefreshing];
        
    }];
}

@end
