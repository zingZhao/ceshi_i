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

#import "ChatGroupDetailViewController.h"
//#import "EMGroupManagerDelegate.h"
//#import "ContactSelectionViewController.h"
//#import "GroupSettingViewController.h"
#import "ContactView.h"
//#import "GroupBansViewController.h"
//#import "GroupSubjectChangingViewController.h"
//#import "SearchMessageViewController.h"
#import "EMClient.h"
#import "EMAlertView.h"
#import "MyGroupDetailViewController.h"
#import "UIViewController+HUD.h"
#import "UserProfileViewController.h"
#pragma mark - ChatGroupDetailViewController

#define kColOfRow 5
#define kContactSize 60

#define left_my 12
//EMGroupManagerDelegate, EMChooseViewDelegate,
@interface ChatGroupDetailViewController ()< UIAlertViewDelegate>
{
    UISwitch * swi;
    CGFloat hei;
}
- (void)unregisterNotifications;
- (void)registerNotifications;

@property (nonatomic) GroupOccupantType occupantType;
@property (strong, nonatomic) EMGroup *chatGroup;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIButton *addButton;

@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) UIButton *clearButton;
//@property (strong, nonatomic) UIButton *exitButton;
//@property (strong, nonatomic) UIButton *dissolveButton;
@property (strong, nonatomic) UIButton *configureButton;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPress;
//@property (strong, nonatomic) ContactView *selectedContact;

- (void)dissolveAction;
- (void)clearAction;
- (void)exitAction;
- (void)configureAction;

@end

@implementation ChatGroupDetailViewController

- (void)registerNotifications {
    [self unregisterNotifications];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
}

- (void)unregisterNotifications {
    [[EMClient sharedClient].groupManager removeDelegate:self];
}

- (void)dealloc {
    [self unregisterNotifications];
}

- (instancetype)initWithGroup:(EMGroup *)chatGroup
{
    self = [super init];
    if (self) {
        // Custom initialization
        _chatGroup = chatGroup;
        _dataSource = [NSMutableArray array];
        _occupantType = GroupOccupantTypeMember;
        [self registerNotifications];
    }
    return self;
}

- (instancetype)initWithGroupId:(NSString *)chatGroupId
{
    EMGroup *chatGroup = nil;
    NSArray *groupArray = [[EMClient sharedClient].groupManager getAllGroups];
    for (EMGroup *group in groupArray) {
        if ([group.groupId isEqualToString:chatGroupId]) {
            chatGroup = group;
            break;
        }
    }
    
    if (chatGroup == nil) {
        chatGroup = [EMGroup groupWithId:chatGroupId];
    }
    
    self = [self initWithGroup:chatGroup];
    if (self) {
        //
    }
    
    return self;
}

-(void)myBadgeNumber{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(myBadgeNumber) name:@"myb" object:nil];
    // Do any additional setup after loading the view.
    
//    EMError *error = nil;
//    EMPushOptions * optionss = [[EMClient sharedClient] getPushOptionsFromServerWithError:&error];
    
    //self.title = @"群信息";
    hei = 20;
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupBansChanged) name:@"GroupBansChanged" object:nil];
    
    if(_chatGroup){
        if (_chatGroup.subject && _chatGroup.subject.length > 0) {
            self.title = [NSString stringWithFormat:@"%@(%ld)",_chatGroup.subject,_chatGroup.occupantsCount];
        }
        else {
            self.title = [NSString stringWithFormat:@"%@(%ld)",_chatGroup.groupId,_chatGroup.occupantsCount];
        }
    }
    
    [self fetchGroupInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - getter

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, kContactSize)];
        _scrollView.tag = 0;
        
//        _addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kContactSize - 10, kContactSize - 10)];
//        [_addButton setImage:[UIImage imageNamed:@"group_participant_add"] forState:UIControlStateNormal];
//        [_addButton setImage:[UIImage imageNamed:@"group_participant_addHL"] forState:UIControlStateHighlighted];
//        [_addButton addTarget:self action:@selector(addContact:) forControlEvents:UIControlEventTouchUpInside];
//        
//        _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteContactBegin:)];
//        _longPress.minimumPressDuration = 0.5;
    }
    
    return _scrollView;
}

- (UIButton *)clearButton
{
    if (_clearButton == nil) {
        _clearButton = [[UIButton alloc] init];
        [_clearButton setTitle:@"删除历史消息" forState:UIControlStateNormal];
        [_clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_clearButton addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
        [_clearButton setBackgroundColor:[UIColor colorWithRed:87 / 255.0 green:186 / 255.0 blue:205 / 255.0 alpha:1.0]];
        _clearButton.layer.cornerRadius = 5.0;
    }
    
    return _clearButton;
}

//- (UIButton *)dissolveButton
//{
//    if (_dissolveButton == nil) {
//        _dissolveButton = [[UIButton alloc] init];
//        [_dissolveButton setTitle:NSLocalizedString(@"group.destroy", @"dissolution of the group") forState:UIControlStateNormal];
//        [_dissolveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_dissolveButton addTarget:self action:@selector(dissolveAction) forControlEvents:UIControlEventTouchUpInside];
//        [_dissolveButton setBackgroundColor: [UIColor colorWithRed:191 / 255.0 green:48 / 255.0 blue:49 / 255.0 alpha:1.0]];
//    }
//    
//    return _dissolveButton;
//}

//- (UIButton *)exitButton
//{
//    if (_exitButton == nil) {
//        _exitButton = [[UIButton alloc] init];
//        [_exitButton setTitle:NSLocalizedString(@"group.leave", @"quit the group") forState:UIControlStateNormal];
//        [_exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_exitButton addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
//        [_exitButton setBackgroundColor:[UIColor colorWithRed:191 / 255.0 green:48 / 255.0 blue:49 / 255.0 alpha:1.0]];
//    }
//    
//    return _exitButton;
//}

- (UIView *)footerView
{
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 160)];
        _footerView.backgroundColor = [UIColor clearColor];
        
        self.clearButton.frame = CGRectMake(20, 40, _footerView.frame.size.width - 40, 40);
        [_footerView addSubview:self.clearButton];
        
        //self.dissolveButton.frame = CGRectMake(20, CGRectGetMaxY(self.clearButton.frame) + 30, _footerView.frame.size.width - 40, 35);
        
        //self.exitButton.frame = CGRectMake(20, CGRectGetMaxY(self.clearButton.frame) + 30, _footerView.frame.size.width - 40, 35);
    }
    
    return _footerView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
//    if (self.occupantType == GroupOccupantTypeOwner)
//    {
//        return 7;
//    }
//    else
//    {
//        return 6;
//    }
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.scrollView];
    }
//    else if (indexPath.row == 1)
//    {
//        cell.textLabel.text = NSLocalizedString(@"group.id", @"group ID");
//        cell.accessoryType = UITableViewCellAccessoryNone;
//        cell.detailTextLabel.text = _chatGroup.groupId;
//    }
    if (indexPath.row == 2)
    {
        cell.textLabel.text = @"清空聊天记录";
//        UITextView * text = [[UITextView alloc]initWithFrame:CGRectMake(left_my, 10, DEF_SCREEN_WIDTH - left_my * 2, hei + 10)];
//        text.text = [NSString stringWithFormat:@"群描述 : %@",_chatGroup.description];
//        text.editable = NO;
//        text.font = [UIFont systemFontOfSize:17];
//        [cell addSubview:text];
    }
    if (indexPath.row == 3)
    {
        if([cell.textLabel.text isEqualToString:@"屏蔽群消息通知"]){
            swi.on = !_chatGroup.isPushNotificationEnabled;
            return cell;
        }
        cell.textLabel.text = @"屏蔽群消息通知";
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        swi = [[UISwitch alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 80, 10, 80, 60)];
        //swi.on = YES;
        swi.on = !_chatGroup.isPushNotificationEnabled;
        swi.onTintColor = [UIColor redColor];
        [swi addTarget:self action:@selector(isSwich:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:swi];
    }
    else if (indexPath.row == 1){
        cell.textLabel.text = @"群ID";
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = _chatGroup.groupId;
    }
//    else if (indexPath.row == 4)
//    {
//        cell.textLabel.text = NSLocalizedString(@"title.groupSubjectChanging", @"Change group name");
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
//    else if (indexPath.row == 5)
//    {
//        cell.textLabel.text = NSLocalizedString(@"title.groupSearchMessage", @"Search Message from History");
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
//    else if (indexPath.row == 6)
//    {
//        cell.textLabel.text = NSLocalizedString(@"title.groupBlackList", @"Group black list");
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
    
    return cell;
}

-(void)isSwich:(UISwitch *)swi{
    [self showHudInView:self.view hint:@"loading"];
    //加loading
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        EMError *error = [[EMClient sharedClient].groupManager ignoreGroupPush:_chatGroup.groupId ignore:swi.isOn];
        if(!error){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideHud];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideHud];
                [self showHint:[NSString stringWithFormat:@"%@",error.errorDescription]];
            });
        }
        
        NSLog(@"error-----\n%@",error.errorDescription);
    });
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.row == 11){
//        return hei + 30;
//    }
    
    //return 50;
    int row = (int)indexPath.row;
    if (row == 0) {
        return self.scrollView.frame.size.height + 40;
    }
    else {
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == 1){
//        MyGroupDetailViewController * mvc = [[MyGroupDetailViewController alloc]init];
//        mvc._dataArray = [NSMutableArray arrayWithArray:_chatGroup.occupants];
//        [self.navigationController pushViewController:mvc animated:YES];
        [self clearAction];
    }
    
//    if (indexPath.row == 3) {
//        GroupSettingViewController *settingController = [[GroupSettingViewController alloc] initWithGroup:_chatGroup];
//        [self.navigationController pushViewController:settingController animated:YES];
//    }
//    else if (indexPath.row == 4)
//    {
//        GroupSubjectChangingViewController *changingController = [[GroupSubjectChangingViewController alloc] initWithGroup:_chatGroup];
//        [self.navigationController pushViewController:changingController animated:YES];
//    }
//    else if (indexPath.row == 5) {
//        SearchMessageViewController *bansController = [[SearchMessageViewController alloc] initWithConversationId:_chatGroup.groupId conversationType:EMConversationTypeGroupChat];
//        [self.navigationController pushViewController:bansController animated:YES];
//    }
//    else if (indexPath.row == 6) {
//        GroupBansViewController *bansController = [[GroupBansViewController alloc] initWithGroup:_chatGroup];
//        [self.navigationController pushViewController:bansController animated:YES];
//    }
}

#pragma mark - EMChooseViewDelegate
/*
- (BOOL)viewController:(EMChooseViewController *)viewController didFinishSelectedSources:(NSArray *)selectedSources
{
    NSInteger maxUsersCount = _chatGroup.setting.maxUsersCount;
    if (([selectedSources count] + _chatGroup.occupantsCount) > maxUsersCount) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"group.maxUserCount", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        [alertView show];
        
        return NO;
    }
    
    [self showHudInView:self.view hint:NSLocalizedString(@"group.addingOccupant", @"add a group member...")];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *source = [NSMutableArray array];
        for (NSString *username in selectedSources) {
            [source addObject:username];
        }
        
        NSString *username = [[EMClient sharedClient] currentUsername];
        NSString *messageStr = [NSString stringWithFormat:NSLocalizedString(@"group.somebodyInvite", @"%@ invite you to join group \'%@\'"), username, weakSelf.chatGroup.subject];
        EMError *error = nil;
        weakSelf.chatGroup = [[EMClient sharedClient].groupManager addOccupants:source toGroup:weakSelf.chatGroup.groupId welcomeMessage:messageStr error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                [weakSelf reloadDataSource];
            }
            else
            {
                [weakSelf hideHud];
                [weakSelf showHint:error.errorDescription];
            }
        
        });
    });
    
    return YES;
}

 */
- (void)groupBansChanged
{
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:self.chatGroup.occupants];
    [self refreshScrollView];
}

#pragma mark - EMGroupManagerDelegate

- (void)didReceiveAcceptedGroupInvitation:(EMGroup *)aGroup
                                  invitee:(NSString *)aInvitee
{
//    if ([aGroup.groupId isEqualToString:self.chatGroup.groupId]) {
//        [self fetchGroupInfo];
//    }
}

#pragma mark - data

- (void)fetchGroupInfo
{
    __weak typeof(self) weakSelf = self;
    [self showHudInView:self.view hint:@"正在加载..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        EMGroup *group = [[EMClient sharedClient].groupManager fetchGroupInfo:weakSelf.chatGroup.groupId includeMembersList:YES error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
        });
        if (!error) {
            weakSelf.chatGroup = group;
            
            if (group.subject && group.subject.length > 0) {
                self.title = [NSString stringWithFormat:@"%@(%ld)",group.subject,group.occupantsCount];
            }
            else {
                self.title = [NSString stringWithFormat:@"%@(%ld)",group.groupId,group.occupantsCount];
            }
           // hei = [self sizeOfStr:[NSString stringWithFormat:@"群描述 : %@",group.description] andFont:[UIFont systemFontOfSize:17] andMaxSize:CGSizeMake(DEF_SCREEN_WIDTH - left_my * 2, MAXFLOAT) andLineBreakMode:NSLineBreakByClipping].height;
            
            EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:group.groupId type:EMConversationTypeGroupChat createIfNotExist:YES];
            if ([group.groupId isEqualToString:conversation.conversationId]) {
                NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
                [ext setObject:group.subject forKey:@"subject"];
                [ext setObject:[NSNumber numberWithBool:group.isPublic] forKey:@"isPublic"];
                conversation.ext = ext;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf reloadDataSource];
            });
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showHint:@"群信息获取失败"];
            });
        }
    });
}


- (void)reloadDataSource
{
    [self.dataSource removeAllObjects];
    
    self.occupantType = GroupOccupantTypeMember;
    NSString *loginUsername = [[EMClient sharedClient] currentUsername];
    if ([self.chatGroup.owner isEqualToString:loginUsername]) {
        self.occupantType = GroupOccupantTypeOwner;
    }
    
    if (self.occupantType != GroupOccupantTypeOwner) {
        for (NSString *str in self.chatGroup.members) {
            if ([str isEqualToString:loginUsername]) {
                self.occupantType = GroupOccupantTypeMember;
                break;
            }
        }
    }
    
    [self.dataSource addObjectsFromArray:self.chatGroup.occupants];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshScrollView];
        [self refreshFooterView];
        //[self hideHud];
    });
}

- (void)refreshScrollView
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.scrollView removeGestureRecognizer:_longPress];
    [self.addButton removeFromSuperview];
    
    BOOL showAddButton = NO;
    if (self.occupantType == GroupOccupantTypeOwner) {
        [self.scrollView addGestureRecognizer:_longPress];
        [self.scrollView addSubview:self.addButton];
        showAddButton = YES;
    }
    else if (self.chatGroup.setting.style == EMGroupStylePrivateMemberCanInvite && self.occupantType == GroupOccupantTypeMember) {
        [self.scrollView addSubview:self.addButton];
        showAddButton = YES;
    }
    
    int tmp = ([self.dataSource count] + 1) % kColOfRow;
    int row = (int)([self.dataSource count] + 1) / kColOfRow;
    row += tmp == 0 ? 0 : 1;
    self.scrollView.tag = row;
    self.scrollView.frame = CGRectMake(10, 20, self.tableView.frame.size.width - 20, row * kContactSize);
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, row * kContactSize);
    
    NSString *loginUsername = [[EMClient sharedClient] currentUsername];
    
    CGFloat wid_sc = ([UIScreen mainScreen].bounds.size.width - 300) / 7;
    
    int i = 0;
    int j = 0;
    BOOL isEditing = self.addButton.hidden ? YES : NO;
    BOOL isEnd = NO;
    for (i = 0; i < row; i++) {
        for (j = 0; j < kColOfRow; j++) {
            NSInteger index = i * kColOfRow + j;
            if (index < [self.dataSource count]) {
                NSString *username = [self.dataSource objectAtIndex:index];
                
                NSLog(@"username%@",username);
                
                ContactView *contactView = [[ContactView alloc] initWithFrame:CGRectMake(j * (kContactSize + wid_sc), i * kContactSize, kContactSize, kContactSize)];
                contactView.index = i * kColOfRow + j;
                contactView.image = [UIImage imageNamed:@"chatListCellHead.png"];
                contactView.remark = username;
                contactView.tag = contactView.index;
                if (![username isEqualToString:loginUsername]) {
                    contactView.editing = isEditing;
                }
                
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_avaImage:)];
                [contactView addGestureRecognizer:tap];
                
               // __weak typeof(self) weakSelf = self;
//                [contactView setDeleteContact:^(NSInteger index) {
//                    //[weakSelf showHudInView:weakSelf.view hint:NSLocalizedString(@"group.removingOccupant", @"deleting member...")];
//                    NSArray *occupants = [NSArray arrayWithObject:[weakSelf.dataSource objectAtIndex:index]];
//                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
//                        EMError *error = nil;
//                        EMGroup *group = [[EMClient sharedClient].groupManager removeOccupants:occupants fromGroup:weakSelf.chatGroup.groupId error:&error];
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            //[weakSelf hideHud];
//                            if (!error) {
//                                weakSelf.chatGroup = group;
//                                [weakSelf.dataSource removeObjectAtIndex:index];
//                                [weakSelf refreshScrollView];
//                            }
//                            else{
//                                //[weakSelf showHint:error.errorDescription];
//                            }
//                        });
//                    });
//                }];
                
                [self.scrollView addSubview:contactView];
            
            }
            else{
                if(showAddButton && index == self.dataSource.count)
                {
                    //self.addButton.frame = CGRectMake(j * kContactSize + 5, i * kContactSize + 10, kContactSize - 10, kContactSize - 10);
                }
                
                isEnd = YES;
                break;
            }
        }
        
        if (isEnd) {
            break;
        }
    }
    
    [self.tableView reloadData];
}

-(void)tap_avaImage:(UITapGestureRecognizer *)tap{
    NSString *username = [self.dataSource objectAtIndex:tap.view.tag];
    
    UserProfileViewController *userprofile = [[UserProfileViewController alloc] initWithUsername:username];
    userprofile.isGroup = YES;
    [self.navigationController pushViewController:userprofile animated:YES];
}

- (void)refreshFooterView
{
//    if (self.occupantType == GroupOccupantTypeOwner) {
//        //[_exitButton removeFromSuperview];
//        [_footerView addSubview:self.dissolveButton];
//    }
//    else{
////        [_dissolveButton removeFromSuperview];
////        [_footerView addSubview:self.exitButton];
//    }
}

#pragma mark - action

- (void)tapView:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded)
    {
        if (self.addButton.hidden) {
            [self setScrollViewEditing:NO];
        }
    }
}

- (void)deleteContactBegin:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan)
    {
        NSString *loginUsername = [[EMClient sharedClient] currentUsername];
        NSLog(@"%@",loginUsername);
        /*
        for (ContactView *contactView in self.scrollView.subviews)
        {
            CGPoint locaton = [longPress locationInView:contactView];
            if (CGRectContainsPoint(contactView.bounds, locaton))
            {
                if ([contactView isKindOfClass:[ContactView class]]) {
                    if ([contactView.remark isEqualToString:loginUsername]) {
                        return;
                    }
                    _selectedContact = contactView;
                    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"delete", @"deleting member..."), NSLocalizedString(@"friend.block", @"add to black list"), nil];
                    [sheet showInView:self.view];
                }
            }
        }
         */
    }
}

- (void)setScrollViewEditing:(BOOL)isEditing
{
    NSString *loginUsername = [[EMClient sharedClient] currentUsername];
    
    for (ContactView *contactView in self.scrollView.subviews)
    {
        if ([contactView isKindOfClass:[ContactView class]]) {
            if ([contactView.remark isEqualToString:loginUsername]) {
                continue;
            }
            
            [contactView setEditing:isEditing];
        }
    }
    
    self.addButton.hidden = isEditing;
}

- (void)addContact:(id)sender
{
//    ContactSelectionViewController *selectionController = [[ContactSelectionViewController alloc] initWithBlockSelectedUsernames:_chatGroup.occupants];
//    selectionController.delegate = self;
//    [self.navigationController pushViewController:selectionController animated:YES];
}

//清空聊天记录
- (void)clearAction
{
//    __weak typeof(self) weakSelf = self;
//    [EMAlertView showAlertWithTitle:NSLocalizedString(@"prompt", @"Prompt")
//                            message:NSLocalizedString(@"sureToDelete", @"please make sure to delete")
//                    completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
//                        if (buttonIndex == 1) {
//                            [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveAllMessages" object:weakSelf.chatGroup.groupId];
//                        }
//                    } cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel")
//                  otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
    UIAlertView * al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否删除历史消息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [al show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        
        [self showHudInView:self.view hint:@"正在删除"];
        
        BOOL isde = NO;
        isde = [[EMClient sharedClient].chatManager deleteConversation:self.chatGroup.groupId deleteMessages:YES];
        
        [self hideHud];
        if(isde){
            NSLog(@"删除成功");
            [self showHUDWithString:@"删除成功"];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"zkb_delete" object:nil];
        }
        else
        {
            NSLog(@"删除失败");
        }
    }
}

#pragma mark - 提示框 自动消失
-(void)showHUDWithString:(NSString *)title
{
    UIView* view = [[UIView alloc]init];
    
    if ([UIApplication sharedApplication].windows.count > 0) {
        view = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }else{
        view = self.view;
    }
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.margin = 10.f;
    hud.labelFont=[UIFont boldSystemFontOfSize:12];
    hud.yOffset = DEF_SCREEN_HEIGHT / 2 - 70.f;
    [view addSubview:hud];
    [hud.superview bringSubviewToFront:hud];
    hud.labelText=title;
    hud.userInteractionEnabled = NO;
    [hud show:YES];
    [hud hide:YES afterDelay:1.0];
    
}

//解散群组
- (void)dissolveAction
{
    /*
    __weak typeof(self) weakSelf = self;
    [self showHudInView:self.view hint:NSLocalizedString(@"group.destroy", @"dissolution of the group")];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        [[EMClient sharedClient].groupManager destroyGroup:weakSelf.chatGroup.groupId error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
            if (error) {
                [weakSelf showHint:NSLocalizedString(@"group.destroyFail", @"dissolution of group failure")];
            }
            else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ExitGroup" object:nil];
            }
        });
    });
     */
}

//设置群组
- (void)configureAction {
    // todo
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        [[EMClient sharedClient].groupManager ignoreGroupPush:weakSelf.chatGroup.groupId ignore:weakSelf.chatGroup.isPushNotificationEnabled];
    });
}

//退出群组
- (void)exitAction
{
    /*
    __weak typeof(self) weakSelf = self;
    [self showHudInView:self.view hint:NSLocalizedString(@"group.leave", @"quit the group")];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        [[EMClient sharedClient].groupManager leaveGroup:weakSelf.chatGroup.groupId error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
            if (error) {
                [weakSelf showHint:NSLocalizedString(@"group.leaveFail", @"exit the group failure")];
            }
            else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ExitGroup" object:nil];
            }
        });
    });
     */
}

- (void)didIgnoreGroupPushNotification:(NSArray *)ignoredGroupList error:(EMError *)error {
    // todo
    NSLog(@"ignored group list:%@.", ignoredGroupList);
}

/*
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger index = _selectedContact.index;
    if (buttonIndex == 0)
    {
        //delete
        _selectedContact.deleteContact(index);
    }
    else if (buttonIndex == 1)
    {
        //add to black list
        [self showHudInView:self.view hint:NSLocalizedString(@"group.ban.adding", @"Adding to black list..")];
        NSArray *occupants = [NSArray arrayWithObject:[self.dataSource objectAtIndex:_selectedContact.index]];
        __weak ChatGroupDetailViewController *weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
            EMError *error = nil;
            EMGroup *group = [[EMClient sharedClient].groupManager blockOccupants:occupants
                                                                       fromGroup:weakSelf.chatGroup.groupId
                                                                           error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hideHud];
                if (!error) {
                    weakSelf.chatGroup = group;
                    [weakSelf.dataSource removeObjectAtIndex:index];
                    [weakSelf refreshScrollView];
                }
                else{
                    [weakSelf showHint:error.errorDescription];
                }
            });
        });
    }
    _selectedContact = nil;
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    _selectedContact = nil;
}
 */

@end
