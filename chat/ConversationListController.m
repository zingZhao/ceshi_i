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

#import "ConversationListController.h"
#import "NSDate+Category.h"
#import "ChatViewController.h"
#import "EMSearchBar.h"
#import "EMSearchDisplayController.h"
#import "RobotManager.h"
#import "RobotChatViewController.h"
#import "UserProfileManager.h"
#import "RealtimeSearchUtil.h"
//#import "RedPacketChatViewController.h"
#import "ChatDemoHelper.h"
#import "EaseConvertToCommonEmoticonsHelper.h"
#import "GroupListViewController.h"
#define MESSAGE_ATTR_IS_BIG_EXPRESSION @"em_is_big_expression"

@implementation EMConversation (search)

//根据用户昵称,环信机器人名称,群名称进行搜索
- (NSString*)showName
{
    if (self.type == EMConversationTypeChat) {
        if ([[RobotManager sharedInstance] isRobotWithUsername:self.conversationId]) {
            return [[RobotManager sharedInstance] getRobotNickWithUsername:self.conversationId];
        }
        return [[UserProfileManager sharedInstance] getNickNameWithUsername:self.conversationId];
    } else if (self.type == EMConversationTypeGroupChat) {
        if ([self.ext objectForKey:@"subject"] || [self.ext objectForKey:@"isPublic"]) {
            return [self.ext objectForKey:@"subject"];
        }
    }
    return self.conversationId;
}

@end

@interface ConversationListController ()<EaseConversationListViewControllerDelegate, EaseConversationListViewControllerDataSource,UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UIView *networkStateView;
@property (nonatomic, strong) EMSearchBar           *searchBar;

@property (strong, nonatomic) EMSearchDisplayController *searchController;

@end

@implementation ConversationListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"聊天会话";
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 30, 30)];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    UIButton *detailButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 17, 35, 35)];
    [detailButton setImage:[UIImage imageNamed:@"list_my"] forState:UIControlStateNormal];
    [detailButton addTarget:self action:@selector(showGroupDetailAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:detailButton];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshDataSource) name:@"locon" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshDataSource) name:@"reLisy"object:nil];
    //self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
     self.edgesForExtendedLayout = UIRectEdgeBottom;
   // self.extendedLayoutIncludesOpaqueBars = NO;
    [self tableViewDidTriggerHeaderRefresh];
    
    [self.view addSubview:self.searchBar];
    self.tableView.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height- 44);
    [self networkStateView];
    
    [self searchController];
    
    [self removeEmptyConversationsFromDB];
    
    //self.tableView.tableHeaderView = self.searchBar;
}

/**
 *  此处重写导航方法是为了让displaysearch获取不到从而不会在跳入界面后隐藏导航栏；其他地方用到需改变为super.navagationController
 *
 *  @return ni;
 */
-(UINavigationController *)navigationController{
    return nil;
}

-(void)showGroupDetailAction{
    GroupListViewController * gvc = [[GroupListViewController alloc]init];
    [super.navigationController pushViewController:gvc animated:YES];
}

-(void)backAction{
    [super.navigationController popViewControllerAnimated:YES];
}

//-(void)viewWillLayoutSubviews
//{
//    if(self.searchDisplayController.isActive)
//    {
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//    }
//    [super viewWillLayoutSubviews];
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];
}


//- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
//    
//    //NSLog(@"%@,%@",self.searchDisplayController.searchResultsTableView,self.searchDisplayController.searchResultsTableView.superview);
//    [self performSelector:@selector(resetFrame) withObject:nil afterDelay:0.1];
//}
//- (void)resetFrame{
//    
//    CGRect bounds =  self.searchDisplayController.searchResultsTableView.superview.bounds;
//    CGFloat offset = CGRectGetMinY(bounds);
//    if (offset == 0)    {
//        self.searchDisplayController.searchResultsTableView.superview.frame = CGRectMake(0,104,self.view.frame.size.width,self.view.frame.size.height - 104);
//    }
////    for(UIView * v in self.searchDisplayController.searchResultsTableView.superview.subviews)    {        NSLog(@"%@",[v class]);
////        if([v isKindOfClass:NSClassFromString(@"_UISearchDisplayControllerDimmingView")])        {            v.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height - 20); //
////        }
////    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage || (conversation.type == EMConversationTypeChatRoom)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EMClient sharedClient].chatManager deleteConversations:needRemoveConversations deleteMessages:YES];
    }
}

#pragma mark - getter
- (UIView *)networkStateView
{
    if (_networkStateView == nil) {
        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"messageSendFail"];
        [_networkStateView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"网络未连接";
        [_networkStateView addSubview:label];
    }
    
    return _networkStateView;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索输入关键字";
        _searchBar.backgroundColor = [UIColor colorWithRed:0.747 green:0.756 blue:0.751 alpha:1.000];
    }
    
    return _searchBar;
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    //[searchBar setShowsCancelButton:YES animated:YES];
    
//    [UIView animateWithDuration:0.2 animations:^{
//        searchBar.frame = CGRectMake(searchBar.frame.origin.x, searchBar.frame.origin.y - 44, searchBar.frame.size.width, searchBar.frame.size.height);
//    }];
    
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
//    [UIView animateWithDuration:0.3 animations:^{
//        searchBar.frame = CGRectMake(searchBar.frame.origin.x, searchBar.frame.origin.y + 44, searchBar.frame.size.width, searchBar.frame.size.height);
//    }];
    
    return YES;
}


- (EMSearchDisplayController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        _searchController.searchResultsTableView.tableFooterView = [[UIView alloc] init];
        
        __weak ConversationListController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            NSString *CellIdentifier = [EaseConversationCell cellIdentifierWithModel:nil];
            EaseConversationCell *cell = (EaseConversationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            // Configure the cell...
            if (cell == nil) {
                cell = [[EaseConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            id<IConversationModel> model = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            cell.model = model;
            
            cell.detailLabel.attributedText = [weakSelf conversationListViewController:weakSelf latestMessageTitleForConversationModel:model];
            cell.timeLabel.text = [weakSelf conversationListViewController:weakSelf latestMessageTimeForConversationModel:model];
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [EaseConversationCell cellHeightWithModel:nil];
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [weakSelf.searchController.searchBar endEditing:YES];
            id<IConversationModel> model = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            EMConversation *conversation = model.conversation;
            ChatViewController *chatController;
            if ([[RobotManager sharedInstance] isRobotWithUsername:conversation.conversationId]) {
                chatController = [[RobotChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
                chatController.title = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.conversationId];
            }else {
#ifdef REDPACKET_AVALABLE
                chatController = [[RedPacketChatViewController alloc]
#else
                chatController = [[ChatViewController alloc]
#endif
                                  initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
                chatController.title = [conversation showName];
            }
            [super.navigationController pushViewController:chatController animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
            [weakSelf.tableView reloadData];
        }];
    }
    
    return _searchController;
}

#pragma mark - EaseConversationListViewControllerDelegate

- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
            didSelectConversationModel:(id<IConversationModel>)conversationModel
{
    if (conversationModel) {
        EMConversation *conversation = conversationModel.conversation;
        if (conversation) {
            if ([[RobotManager sharedInstance] isRobotWithUsername:conversation.conversationId]) {
                RobotChatViewController *chatController = [[RobotChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
                chatController.title = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.conversationId];
                [super.navigationController pushViewController:chatController animated:YES];
            } else {
#ifdef REDPACKET_AVALABLE
                RedPacketChatViewController *chatController = [[RedPacketChatViewController alloc]
#else
                ChatViewController *chatController = [[ChatViewController alloc]
#endif
                                                      initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
                chatController.title = conversationModel.title;
                [super.navigationController pushViewController:chatController animated:YES];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
        [self.tableView reloadData];
    }
}

#pragma mark - EaseConversationListViewControllerDataSource

- (id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                                    modelForConversation:(EMConversation *)conversation
{
    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:conversation];
    if (model.conversation.type == EMConversationTypeChat) {
        if ([[RobotManager sharedInstance] isRobotWithUsername:conversation.conversationId]) {
            model.title = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.conversationId];
        } else {
            UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:conversation.conversationId];
            if (profileEntity) {
                model.title = profileEntity.nickname == nil ? profileEntity.username : profileEntity.nickname;
                model.avatarURLPath = profileEntity.imageUrl;
            }
        }
    } else if (model.conversation.type == EMConversationTypeGroupChat) {
        NSString *imageName = @"groupPublicHeader";
        if (![conversation.ext objectForKey:@"subject"])
        {
            NSArray *groupArray = [[EMClient sharedClient].groupManager getAllGroups];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:conversation.conversationId]) {
                    NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
                    [ext setObject:group.subject forKey:@"subject"];
                    [ext setObject:[NSNumber numberWithBool:group.isPublic] forKey:@"isPublic"];
                    conversation.ext = ext;
                    break;
                }
            }
        }
        NSDictionary *ext = conversation.ext;
        model.title = [ext objectForKey:@"subject"];
        imageName = [[ext objectForKey:@"isPublic"] boolValue] ? @"groupPublicHeader" : @"groupPrivateHeader";
        model.avatarImage = [UIImage imageNamed:imageName];
    }
    return model;
}

- (NSAttributedString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
      latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:@""];
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        NSString *latestMessageTitle = @"";
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = @"图片";
            } break;
            case EMMessageBodyTypeText:{
                // 表情映射。
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
                if ([lastMessage.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
                    latestMessageTitle = @"[动画表情]";
                }
            } break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle = NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = NSLocalizedString(@"message.video1", @"[video]");
            } break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = NSLocalizedString(@"message.file1", @"[file]");
            } break;
            default: {
            } break;
        }
        
        if (lastMessage.direction == EMMessageDirectionReceive) {
            NSString *from = lastMessage.from;
            UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:from];
            if (profileEntity) {
                from = profileEntity.nickname == nil ? profileEntity.username : profileEntity.nickname;
            }
            latestMessageTitle = [NSString stringWithFormat:@"%@: %@", from, latestMessageTitle];
        }
        
        NSDictionary *ext = conversationModel.conversation.ext;
        if (ext && [ext[kHaveUnreadAtMessage] intValue] == kAtAllMessage) {
            latestMessageTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"group.atAll", nil), latestMessageTitle];
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
            [attributedStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:.0 blue:.0 alpha:0.5]} range:NSMakeRange(0, NSLocalizedString(@"group.atAll", nil).length)];
            
        }
        else if (ext && [ext[kHaveUnreadAtMessage] intValue] == kAtYouMessage) {
            latestMessageTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"group.atMe", @"[Somebody @ me]"), latestMessageTitle];
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
            [attributedStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:.0 blue:.0 alpha:0.5]} range:NSMakeRange(0, NSLocalizedString(@"group.atMe", @"[Somebody @ me]").length)];
        }
        else {
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
        }
    }
    
    return attributedStr;
}

- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
       latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        latestMessageTime = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }

    
    return latestMessageTime;
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    __weak typeof(self) weakSelf = self;
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.dataArray searchText:(NSString *)searchText collationStringSelector:@selector(title) resultBlock:^(NSArray *results) {
        if (results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.searchController.resultsSource removeAllObjects];
                [weakSelf.searchController.resultsSource addObjectsFromArray:results];
                [weakSelf.searchController.searchResultsTableView reloadData];
            });
        }
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - public

-(void)refresh
{
    [self refreshAndSortView];
}

-(void)refreshDataSource
{
    [self tableViewDidTriggerHeaderRefresh];
}

- (void)isConnect:(BOOL)isConnect{
    if (!isConnect) {
        self.tableView.tableHeaderView = _networkStateView;
    }
    else{
        self.tableView.tableHeaderView = nil;
    }
    
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    if (connectionState == EMConnectionDisconnected) {
        self.tableView.tableHeaderView = _networkStateView;
    }
    else{
        self.tableView.tableHeaderView = nil;
    }
}

@end
