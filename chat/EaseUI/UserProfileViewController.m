/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "UserProfileViewController.h"

#import "ChatViewController.h"
#import "UserProfileManager.h"
#import "UIImageView+HeadImage.h"
#define NAVColor  [UIColor colorWithRed:50/255.00 green:102/255.00 blue:204/255.00 alpha:1]

@interface UserProfileViewController ()

@property (strong, nonatomic) UserProfileEntity *user;

@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UILabel *usernameLabel;

@end

@implementation UserProfileViewController

- (instancetype)initWithUsername:(NSString *)username
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _username = username;
    }
    return self;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"个人资料";
    
    self.view.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.allowsSelection = NO;
    
    [self setupBarButtonItem];
    [self loadUserProfile];
}

- (UIImageView*)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.frame = CGRectMake(20, 10, 60, 60);
        _headImageView.contentMode = UIViewContentModeScaleToFill;
    }
    [_headImageView imageWithUsername:_username placeholderImage:nil];
    return _headImageView;
}

- (UILabel*)usernameLabel
{
    if (!_usernameLabel) {
        _usernameLabel = [[UILabel alloc] init];
        _usernameLabel.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + 10.f, 10, 200, 20);
        _usernameLabel.text = _username;
        _usernameLabel.textColor = [UIColor lightGrayColor];
    }
    return _usernameLabel;
}

#pragma mark - Table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([_username isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"code"]]){
        return 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    if (indexPath.row == 0) {
//        cell.detailTextLabel.text = NSLocalizedString(@"setting.personalInfoUpload", @"Upload HeadImage");
        
        UILabel * label_name = [[UILabel alloc]initWithFrame:CGRectMake(100, 45, [UIScreen mainScreen].bounds.size.width - 120, 20)];
        label_name.textColor = [UIColor lightGrayColor];
        label_name.text = [NSString stringWithFormat:@"账号 : %@",self.usernameLabel.text];
        [cell addSubview:label_name];
        
        UILabel * label_nick = [[UILabel alloc]initWithFrame:CGRectMake(100, 15, [UIScreen mainScreen].bounds.size.width - 120, 20)];
        label_nick.textColor = [UIColor lightGrayColor];
        UserProfileEntity *entity = [[UserProfileManager sharedInstance] getUserProfileByUsername:_username];
        if (entity && entity.nickname.length>0) {
            label_nick.text = [NSString stringWithFormat:@"昵称 : %@",entity.nickname];
        } else {
            label_nick.text = [NSString stringWithFormat:@"昵称 : %@",_username];
        }
        [cell addSubview:label_nick];
        
        [cell.contentView addSubview:self.headImageView];
    } else if (indexPath.row == 1) {
//        cell.textLabel.text = @"姓名";
//        cell.detailTextLabel.text = self.usernameLabel.text;
        
        UIButton * btn_send = [UIButton buttonWithType:0];
        [btn_send setTitleColor:[UIColor whiteColor] forState:0];
        btn_send.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 70, 10, 140, 40);
        [btn_send setBackgroundColor:NAVColor];
        [btn_send setTitle:@"发送消息" forState:0];
        btn_send.layer.cornerRadius = 5.0;
        btn_send.alpha = 0.8;
        btn_send.titleLabel.font = [UIFont systemFontOfSize:17];
        [btn_send addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn_send];
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"昵称";
        UserProfileEntity *entity = [[UserProfileManager sharedInstance] getUserProfileByUsername:_username];
        if (entity && entity.nickname.length>0) {
            cell.detailTextLabel.text = entity.nickname;
        } else {
            cell.detailTextLabel.text = _username;
        }
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

#pragma mark --  发送消息
-(void)sendMessage{
    NSLog(@"发送新高");
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    
    ChatViewController *chatController = [[ChatViewController alloc]
                                          initWithConversationChatter:_username conversationType:EMConversationTypeChat];
    chatController.title = _username.length != 0 ? [_username copy] : @"";
    if ([array count] >= 3) {
        [array removeLastObject];
        [array removeLastObject];
    }
    if(self.isGroup){
        self.isGroup = NO;
        [array removeLastObject];
    }
    [array addObject:chatController];
    [self.navigationController setViewControllers:array animated:YES];
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 80;
    }
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)setupBarButtonItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

- (void)loadUserProfile
{
//    [self hideHud];
//    [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
//    __weak typeof(self) weakself = self;
//    [[UserProfileManager sharedInstance] loadUserProfileInBackground:@[_username] saveToLoacal:YES completion:^(BOOL success, NSError *error) {
//        [weakself hideHud];
//        if (success) {
//            [weakself.tableView reloadData];
//        }
//    }];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
