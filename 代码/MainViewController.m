//
//  MainViewController.m
//  i_就业
//
//  Created by 赵奎博 on 16/4/13.
//  Copyright © 2016年 赵奎博. All rights reserved.
//

#import "MainViewController.h"
#import "Zkb_advertisement_Scroll.h"
#import "OneTableViewCell.h"
#import "TwoTableViewCell.h"
#import "oneItem.h"
#import "TwoItem.h"
#import "DetailViewController.h"
#import "ViewController.h"
//#import "EMMessage.h"
#import "EMSDK.h"
#import "UserProfileManager.h"
//#import "EaseSDKHelper.h"
#define kGroupMessageAtList      @"em_at_list"
#define kGroupMessageAtAll       @"all"
#define kMessageType  @"MessageType";
#define kConversationChatter  @"ConversationChatter";
#define kGroupName  @"GroupName";
#import "EMCDDeviceManager.h"
#import "EaseMessageReadManager.h"
@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,zkb_adverDelegate>
{
    UIScrollView * baseScroll;
    
    UITableView * _tableOne;
    
    NSInteger nowSelect;
    
    UITextField * acount;
    UITextField * name;
    UITextField * password;
    UITextField * email;
    
    NSInteger page;
    NSMutableArray * _dataArray;
    
    Zkb_advertisement_Scroll * scrolTop;
    UIView * headtab;
    
    NSString * url_headLink;
    
    NSData * play;
}
@property (strong, nonatomic) NSDate* lastPlaySoundDate;
@end

@implementation MainViewController

-(void)load_adver_viewUrl:(NSString *)urlLink{
    DetailViewController * dvc = [[DetailViewController alloc]init];
    dvc.myurl = urlLink;
    [self.navigationController pushViewController:dvc animated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showNotificationWithMessage:) name:@"loc" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playSoundAndVibration) name:@"locon" object:nil];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; 
    
    page = 1;
    _dataArray = [[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:@"suc" object:nil];
    [self initUI];
    
}

-(void)initUI{
    
    nowSelect = 0;
    
    [self one];
    
    //[self scroll];
    
    //[self bottom];
    
}

-(void)scroll{
    baseScroll  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT - 60)];
    baseScroll.pagingEnabled = YES;
    baseScroll.backgroundColor = DEF_RGB_COLOR(240, 240, 240);
    baseScroll.showsVerticalScrollIndicator = NO;
    baseScroll.showsHorizontalScrollIndicator = NO;
    baseScroll.bounces = NO;
    baseScroll.delegate = self;
    baseScroll.contentSize = CGSizeMake(DEF_SCREEN_WIDTH, DEF_HEIGHT(baseScroll));
    [self.view addSubview:baseScroll];
    
    [self one];
    
//    [self two];
//    
//    [self three];

}

-(void)bottom{
    UIView * view_bottom = [[UIView alloc]initWithFrame:CGRectMake(0, DEF_SCREEN_HEIGHT - 60, DEF_SCREEN_WIDTH, 60)];
    view_bottom.backgroundColor = NAVColor;
    [self.view addSubview:view_bottom];
    
    NSArray * array = @[@"i就业",@"求职",@"分享",@"我"];
    
    for(int i=0; i< 3; i++){
        UIButton * btn = [UIButton buttonWithType:0];
        [self Eleven_Set_Button:btn setBackgroundColor:nil setBackgroundImageNormal:nil setBackgroundImageHighlighted:nil setTitle:array[i] setTitleFont:18 buttonTag:i titleColor:[UIColor whiteColor]];
        btn.frame = CGRectMake(i * DEF_WIDTH(view_bottom) / 3, 0, DEF_WIDTH(view_bottom) / 3, DEF_HEIGHT(view_bottom));
        [btn addTarget:self action:@selector(bottomAction:) forControlEvents:UIControlEventTouchUpInside];
        [view_bottom addSubview:btn];
        
        if(i > 0){
            UILabel * label_line = [[UILabel alloc]initWithFrame:CGRectMake(DEF_X(btn), 0, 1, DEF_HEIGHT(view_bottom))];
            label_line.backgroundColor = [UIColor whiteColor];
            [view_bottom addSubview:label_line];
        }
    }
    
}

-(void)bottomAction:(UIButton *)btn{
    
    
    if(btn.tag == nowSelect)
    {
        return;
    }
    
    switch (btn.tag) {
        case 0:
        {
            [baseScroll setContentOffset:CGPointMake(0, 0)];
            nowSelect = 0;
        }
            break;
        case 1:
        {
            [baseScroll setContentOffset:CGPointMake(DEF_SCREEN_WIDTH, 0)];
            nowSelect = 1;
        }
            break;
        case 2:
        {
            [baseScroll setContentOffset:CGPointMake(DEF_SCREEN_WIDTH * 2, 0)];
            nowSelect = 2;
        }
            break;
            
        default:
            break;
    }
}

-(void)one{
    
//    UILabel * label_one = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, DEF_SCREEN_WIDTH, 56)];
//    [self Eleven_Set_label:label_one text:@"" textColor:[UIColor whiteColor] fontSize:22 fontAlpha:1 textAlignment:3];
//    //label_one.backgroundColor = NAVColor;
//    [view_one addSubview:label_one];
    
    headtab = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_WIDTH * 0.7 + 10)];
    
    scrolTop = [[Zkb_advertisement_Scroll alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_WIDTH * 0.3)];
    [headtab addSubview:scrolTop];
    
    
#pragma mark --- 列表
    UIView * view_back = [[UIView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(scrolTop), DEF_SCREEN_WIDTH, 10)];
    view_back.backgroundColor = DEF_RGB_COLOR(220, 220,220);
    [headtab addSubview:view_back];
    
    
    _tableOne = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT - topHight - 48)];
    _tableOne.tableHeaderView = headtab;
    _tableOne.showsVerticalScrollIndicator = NO;
    _tableOne.tableFooterView = [[UIView alloc]init];
    _tableOne.rowHeight = 60;
    _tableOne.delegate = self;
    _tableOne.dataSource = self;
    _tableOne.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_tableOne];
    
    [self setupRefresh];
    
    [self getData];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TwoItem * item = _dataArray[indexPath.row];
    
//    if(indexPath.row < 2){
//        return 82;
//    }
//    else if(indexPath.row > 2){
//        return 60;
//    }
    return 82;
}

-(void)getData{
    
    [self getDataSource:[NSString stringWithFormat:@"%@%@",URL_url,URL_list] Params:@{@"page":[NSString stringWithFormat:@"%ld",page],@"type":@"1"} success:^(NSDictionary *json) {
        
        NSDictionary * array_lis = json[@"data"];
        
        NSArray * array_list_job = array_lis[@"list"];
        
        
        if(page == 1)
        {
            [_dataArray removeAllObjects];
        }
//
//            TwoItem * item = [[TwoItem alloc]init];
//            item.type = @"1";
//            item.title1 = @"英国心理学家研究发现，职业倦怠与季节变化有比较明显的关系";
//            item.url = [NSString stringWithFormat:@"%@%@",URL_url,URL_threeImage];
//            [_dataArray addObject:item];
//            
//            TwoItem * item1 = [[TwoItem alloc]init];
//            item1.type = @"1";
//            item1.title1 = @"加入企业，成为“星员工”，尽享个人职业发展“星计划”";
//            item1.url = [NSString stringWithFormat:@"%@%@",URL_url,URL_fourImage];
//            [_dataArray addObject:item1];
//            
//            TwoItem * item2 = [[TwoItem alloc]init];
//            item2.type = @"0";
//            [_dataArray addObject:item2];
//        }
        
        if(page > 1 && array_list_job.count == 0){
            page--;
        }
        
        for (NSDictionary * di in array_list_job) {
            TwoItem * item = [[TwoItem alloc]init];
            [item setValuesForKeysWithDictionary:di];
            [_dataArray addObject:item];
            
        }
        
        NSInteger op = 3;
        if(_dataArray.count < 3){
            op = _dataArray.count;
        }
        NSMutableArray * ary = [NSMutableArray array];
        NSMutableArray * linkary = [NSMutableArray array];
        for( int i=0; i< op; i++){
            TwoItem * item = _dataArray[i];
            [ary addObject:item.img];
            [linkary addObject:item.link];
        }
        scrolTop.zkb_delegate = self;
        [scrolTop Zkb_AdverScroll_hight:DEF_HEIGHT(scrolTop) width:DEF_WIDTH(scrolTop) Source:ary time_space:5 placeholderImageStr:@"57.jpg" link:[NSArray arrayWithArray:linkary]];
        
        if(_dataArray.count > 3){
            
            headtab.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_WIDTH * 0.7 + 10);
            
            TwoItem * item = _dataArray[3];
            
            UIImageView * headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, DEF_SCREEN_WIDTH * 0.3 + 10, DEF_SCREEN_WIDTH, DEF_SCREEN_WIDTH * 0.4)];
            headView.userInteractionEnabled = YES;
            [headView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",image_head,item.img]] placeholderImage:[UIImage imageNamed:@"3.jpg"]];
            url_headLink = item.link;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_Action:)];
            [headView addGestureRecognizer:tap];
            
            UILabel * label_head = [[UILabel alloc]initWithFrame:CGRectMake(0, DEF_HEIGHT(headView) - 20, DEF_SCREEN_WIDTH, 20)];
            [self Eleven_Set_label:label_head text:[NSString stringWithFormat:@"    %@",item.title] textColor:[UIColor whiteColor] fontSize:15 fontAlpha:1 textAlignment:1];
            label_head.backgroundColor = DEF_RGBA_COLOR(0, 0, 0, 0.2);
            [headView addSubview:label_head];
            
            [headtab addSubview:headView];
        }
        [_tableOne.mj_header endRefreshing];
        [_tableOne.mj_footer endRefreshing];
        
//        [_tableOne headerEndRefreshing];
//        [_tableOne footerEndRefreshing];
        
        [_tableOne reloadData];
        
    } fail:^{
        
        if(page == 1)
        {
            [_dataArray removeAllObjects];
        }
//
//            TwoItem * item = [[TwoItem alloc]init];
//            item.type = @"1";
//            item.title1 = @"英国心理学家研究发现，职业倦怠与季节变化有比较明显的关系";
//            item.url = [NSString stringWithFormat:@"%@%@",URL_url,URL_threeImage];
//            [_dataArray addObject:item];
//            
//            TwoItem * item1 = [[TwoItem alloc]init];
//            item1.type = @"1";
//            item1.title1 = @"加入企业，成为“星员工”，尽享个人职业发展“星计划”";
//            item1.url = [NSString stringWithFormat:@"%@%@",URL_url,URL_fourImage];
//            [_dataArray addObject:item1];
//            
//            TwoItem * item2 = [[TwoItem alloc]init];
//            item2.type = @"0";
//            [_dataArray addObject:item2];
//        }
        [_tableOne.mj_header endRefreshing];
        [_tableOne.mj_footer endRefreshing];
//        [_tableOne headerEndRefreshing];
//        [_tableOne footerEndRefreshing];
        
    }];
}

-(void)tap_Action:(UITapGestureRecognizer *)tap{
    [self load_adver_viewUrl:url_headLink];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_dataArray.count < 4){
        return 0;
    }
    return _dataArray.count - 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cel ;
    TwoItem * item = _dataArray[indexPath.row + 4];
    
    
    OneTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"T1"];
    if(cell == nil){
        cell = [[OneTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"T1"];
    }
    
    //[cell.rightlabel_line removeFromSuperview];
    
    if(indexPath.row == 0){
        [cell addSubview:cell.rightlabel_line];
    }
    [cell getItem:item];
    //cell.leftimage.backgroundColor = [UIColor greenColor];
    //cell.separatorInset = UIEdgeInsetsMake(0, -20, 0, cell.bounds.size.width + 20);
    cel = cell;
    
    return cel;
    
    if(indexPath.row > 2){
        
        
        TwoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"T2"];
        if(cell == nil){
            cell = [[TwoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"T2"];
        }
        
        
        //        item.title1 = @"dsajdbnakjndsakjdnasjkdnakj";
        //        item.title2 = @"dsajdbnakjndsakjdnasjkdnakj";
        //        item.title3 = @"dsajdbnakjndsakjdnasjkdnakj";
        [cell getItem:item];
        cel = cell;
        
    }
    else if(indexPath.row < 2)
    {
        OneTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"T1"];
        if(cell == nil){
            cell = [[OneTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"T1"];
        }
        
        [cell.rightlabel_line removeFromSuperview];

        if(indexPath.row == 0){
            [cell addSubview:cell.rightlabel_line];
        }
        [cell getItem:item];
        //cell.leftimage.backgroundColor = [UIColor greenColor];
        //cell.separatorInset = UIEdgeInsetsMake(0, -20, 0, cell.bounds.size.width + 20);
        cel = cell;
    }
    else
    {
        cel = [[UITableViewCell alloc]init];
        cel.backgroundColor= DEF_RGB_COLOR(220, 220, 220);
    }
    cel.selectionStyle = UITableViewCellSelectionStyleNone;
    return cel;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TwoItem * item = _dataArray[indexPath.row + 4];
    
    DetailViewController * dvc = [[DetailViewController alloc]init];
    dvc.item = item;
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- 第二部分
-(void)two{
    UIView * view_one = [[UIView alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH,0, DEF_SCREEN_WIDTH, DEF_HEIGHT(baseScroll))];
    view_one.backgroundColor = [UIColor whiteColor];
    [baseScroll addSubview:view_one];
    
    UILabel * label_o = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 20)];
    label_o.backgroundColor = NAVColor;
    [view_one addSubview:label_o];
    
    UILabel * label_one = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, DEF_SCREEN_WIDTH, 58)];
    [self Eleven_Set_label:label_one text:@"分享互联" textColor:[UIColor whiteColor] fontSize:22 fontAlpha:1 textAlignment:3];
    label_one.backgroundColor = NAVColor;
    [view_one addSubview:label_one];
}

#pragma mark -- 第三部分
-(void)three{
    BaseScrollView * view_one = [[BaseScrollView alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH * 2,0, DEF_SCREEN_WIDTH, DEF_HEIGHT(baseScroll))];
    view_one.backgroundColor = DEF_RGB_COLOR(220, 220, 220);
    [baseScroll addSubview:view_one];
    
    UILabel * label_o = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 20)];
    label_o.backgroundColor = NAVColor;
    [view_one addSubview:label_o];
    
    UILabel * label_one = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, DEF_SCREEN_WIDTH, 58)];
    [self Eleven_Set_label:label_one text:@"个人中心" textColor:[UIColor whiteColor] fontSize:22 fontAlpha:1 textAlignment:3];
    label_one.backgroundColor = NAVColor;
    label_one.userInteractionEnabled = YES;
    [view_one addSubview:label_one];
    
    UIButton * btn_out = [UIButton buttonWithType:0];
    btn_out.frame = CGRectMake(DEF_SCREEN_WIDTH - 60, 23, 60, 40);
    [self Eleven_Set_Button:btn_out setBackgroundColor:nil setBackgroundImageNormal:nil setBackgroundImageHighlighted:nil setTitle:@"退出" setTitleFont:16 buttonTag:1 titleColor:[UIColor whiteColor]];
    [btn_out addTarget:self action:@selector(out) forControlEvents:UIControlEventTouchUpInside];
    [view_one addSubview:btn_out];
    
    BaseScrollView * view_two = [[BaseScrollView alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH * 2,68, DEF_SCREEN_WIDTH, DEF_HEIGHT(baseScroll) - 68)];
    [baseScroll addSubview:view_two];
    
    acount = [[UITextField alloc]init];
    name = [[UITextField alloc]init];
    password = [[UITextField alloc]init];
    email = [[UITextField alloc]init];
    
    UIView * view_acount = [self newAView_title:@"账号：" frame:CGRectMake(0, 20, DEF_SCREEN_WIDTH, 50) testFiled:acount];
    acount.userInteractionEnabled = NO;
    [view_two addSubview:view_acount];
    
    UIView * view_name = [self newAView_title:@"昵称：" frame:CGRectMake(0, 100, DEF_SCREEN_WIDTH, 50) testFiled:name];
    [view_two addSubview:view_name];
    
    UIView * view_passworld = [self newAView_title:@"密码：" frame:CGRectMake(0, 180, DEF_SCREEN_WIDTH, 50) testFiled:password];
    password.secureTextEntry = YES;
    [view_two addSubview:view_passworld];
    
    UIView * view_email = [self newAView_title:@"邮箱：" frame:CGRectMake(0, 260, DEF_SCREEN_WIDTH, 50) testFiled:email];
    [view_two addSubview:view_email];
    
    UIButton * btn_save = [UIButton buttonWithType:0];
    btn_save.frame = CGRectMake(20, 370, DEF_SCREEN_WIDTH - 40, 50);
    [self Eleven_Set_Button:btn_save setBackgroundColor:NAVColor setBackgroundImageNormal:nil setBackgroundImageHighlighted:nil setTitle:@"保存个人信息" setTitleFont:20 buttonTag:1 titleColor:[UIColor whiteColor]];
    [btn_save addTarget:self action:@selector(asveUserChange) forControlEvents:UIControlEventTouchUpInside];
    [view_two addSubview:btn_save];
    
    if(DEF_SCREEN_HEIGHT < 450 + topHight){
        view_two.contentSize = CGSizeMake(DEF_SCREEN_WIDTH, 450 + topHight);
    }
    
    acount.text = [self.userDefaults objectForKey:@"code"];
    name.text = [self.userDefaults objectForKey:@"nick"];
    password.text = [self.userDefaults objectForKey:@"pass"];
    email.text = [self.userDefaults objectForKey:@"email"];
}

-(void)refresh{
    acount.text = [self.userDefaults objectForKey:@"code"];
    name.text = [self.userDefaults objectForKey:@"nick"];
    password.text = [self.userDefaults objectForKey:@"pass"];
    email.text = [self.userDefaults objectForKey:@"email"];
    
    //page = 0;
}

-(void)out{
    NSLog(@"退出");
    
    [self.userDefaults setObject:@"" forKey:@"uid"];
    [self.userDefaults setObject:@"" forKey:@"code"];
    [self.userDefaults setObject:@"" forKey:@"name"];
    [self.userDefaults setObject:@"" forKey:@"nick"];
    [self.userDefaults setObject:@""forKey:@"email"];
    [self.userDefaults setObject:@"" forKey:@"pass"];
    [self.userDefaults setObject:@"" forKey:@"user"];
    
    ViewController * vvc = [[ViewController alloc]init];
    vvc.ismodel = YES;
    [self presentModalViewController:vvc animated:YES];
}

-(void)asveUserChange{
    
    
    if([name.text isEqualToString:[self.userDefaults objectForKey:@"nick"]] && [password.text isEqualToString:[self.userDefaults objectForKey:@"pass"]] && [email.text isEqualToString:[self.userDefaults objectForKey:@"email"]]){
        [self showString:@"您未做任何修改"];
        return;
    }
        
    if([self stringIsToNull:acount.text] && [self stringIsToNull:name.text] && [self stringIsToNull:password.text] && [self stringIsToNull:email.text]){
        NSLog(@"save");
        
        [self PostDataSource:[NSString stringWithFormat:@"%@%@",URL_url,URL_save] Params:[NSString stringWithFormat:@"nick=%@&pwd=%@&email=%@&code=%@",name.text,password.text,email.text,acount.text] success:^(NSDictionary *json) {
            
            [self showString:@"修改成功"];
            
            [self.userDefaults setObject:name.text forKey:@"nick"];
            [self.userDefaults setObject:email.text forKey:@"email"];
            [self.userDefaults setObject:password.text forKey:@"pass"];
            
            [self refresh];
            
        } fail:^{
            
        }];
        
    }else{
        [self showString:@"请将信息填写完整"];
    }
    
    
}

-(UIView *)newAView_title:(NSString *)title frame:(CGRect)frame testFiled:(UITextField *)testfiled{
    UIView * view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 60, 50)];
    [self Eleven_Set_label:label text:title textColor:[UIColor blackColor] fontSize:20 fontAlpha:1 textAlignment:1];
    [view addSubview:label];
    
    testfiled.frame = CGRectMake(DEF_RIGHT(label), 0, DEF_WIDTH(view) - 120, 50);
    testfiled.textAlignment = NSTextAlignmentRight;
    testfiled.textColor = [UIColor grayColor];
    [view addSubview:testfiled];
    
    UIImageView * image_enter = [[UIImageView alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH - 30, 10, 20, 30)];
    image_enter.image = [UIImage imageNamed:@"57.jpg"];
    [view addSubview:image_enter];
    
    return view;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark --  设置刷新
- (void)setupRefresh
{
    __weak MainViewController *weakSelf = self;
    
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


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"%f",scrollView.contentOffset.x);
    nowSelect = scrollView.contentOffset.x / 375;
}

#pragma mark -- chat
-(void)showNotificationWithMessage:(NSNotification *)message
{
    EMPushOptions * options = [[EMClient sharedClient] pushOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    /*
    if (options.displayStyle == EMPushDisplayStyleMessageSummary) {
        EMMessageBody *messageBody = message.body;
        NSString *messageStr = nil;
        switch (messageBody.type) {
            case EMMessageBodyTypeText:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case EMMessageBodyTypeImage:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case EMMessageBodyTypeVideo:{
                messageStr = NSLocalizedString(@"message.video", @"Video");
            }
                break;
            default:
                break;
        }
        
        do {
            NSString *title = [[UserProfileManager sharedInstance] getNickNameWithUsername:message.from];
            if (message.chatType == EMChatTypeGroupChat) {
                NSDictionary *ext = message.ext;
                if (ext && ext[kGroupMessageAtList]) {
                    id target = ext[kGroupMessageAtList];
                    if ([target isKindOfClass:[NSString class]]) {
                        if ([kGroupMessageAtAll compare:target options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                            notification.alertBody = [NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"group.atPushTitle", @" @ me in the group")];
                            break;
                        }
                    }
                    else if ([target isKindOfClass:[NSArray class]]) {
                        NSArray *atTargets = (NSArray*)target;
                        if ([atTargets containsObject:[EMClient sharedClient].currentUsername]) {
                            notification.alertBody = [NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"group.atPushTitle", @" @ me in the group")];
                            break;
                        }
                    }
                }
                NSArray *groupArray = [[EMClient sharedClient].groupManager getAllGroups];
                for (EMGroup *group in groupArray) {
                    if ([group.groupId isEqualToString:message.conversationId]) {
                        title = [NSString stringWithFormat:@"%@(%@)", message.from, group.subject];
                        break;
                    }
                }
            }
            else if (message.chatType == EMChatTypeChatRoom)
            {
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[EMClient sharedClient] currentUsername]];
                NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
                NSString *chatroomName = [chatrooms objectForKey:message.conversationId];
                if (chatroomName)
                {
                    title = [NSString stringWithFormat:@"%@(%@)", message.from, chatroomName];
                }
            }
            
            notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
        } while (0);
    }
    else{//receiveMessage
        notification.alertBody = @"您有一条新消息";
    }
    */
    EMMessage * mess = message.userInfo[@"mes"];
    
    notification.alertBody = @"您有一条新消息";
#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    //notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
    
    notification.alertAction = NSLocalizedString(@"open", @"Open");
    notification.timeZone = [NSTimeZone defaultTimeZone];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < 3.0) {
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
    } else {
        notification.soundName = UILocalNotificationDefaultSoundName;
        self.lastPlaySoundDate = [NSDate date];
    }
    //static NSString *kMessageType = @"MessageType";
    //    static NSString *kConversationChatter = @"ConversationChatter";
    //    static NSString *kGroupName = @"GroupName";
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:@(1) forKey:@"MessageType"];
    [userInfo setObject:mess.conversationId forKey:@"ConversationChatter"];
    notification.userInfo = userInfo;
    
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber += 1;
}

- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < 3.0) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)didReceiveMessages:(NSArray *)aMessages
{
    for(EMMessage *message in aMessages){
        BOOL needShowNotification = (message.chatType != EMChatTypeChat) ? [self _needShowNotification:message.conversationId] : YES;
        
        if (needShowNotification) {
            //这里本地推送message
            
        }
    }
}

- (BOOL)_needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EMClient sharedClient].groupManager getAllIgnoredGroupIds];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    return ret;
}

@end
