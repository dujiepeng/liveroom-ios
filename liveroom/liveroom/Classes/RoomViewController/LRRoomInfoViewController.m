//
//  LRRoomInfoViewController.m
//  liveroom
//
//  Created by easemob-DN0164 on 2019/4/9.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRRoomInfoViewController.h"
#import "LRSearchBar.h"
#import "LRFindView.h"
#import "LRRealtimeSearch.h"
#import "LRChatroomMembersCell.h"
#import "LRChatroomMembersModel.h"

#define kPadding 16
@interface LRRoomInfoViewController () <UITableViewDelegate, UITableViewDataSource, LRSearchBarDelegate, LRChatroomMembersCellDelegate>
{
    BOOL _currentUserIsOwner;
    NSString *_ownerName;
}
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic) BOOL isSearching;
@property (nonatomic, strong) LRSearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) UITableView *searchResultTableView;

@property (nonatomic, strong) NSString *cursor;

@end

@implementation LRRoomInfoViewController

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)searchResults
{
    if (_searchResults == nil) {
        _searchResults = [NSMutableArray array];
    }
    return _searchResults;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self autoReload];
    
    [self _setupSubviews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(exitChatroom:) name:LR_Exit_Chatroom_Notification
                                                 object:nil];
}

- (void)autoReload {
    [self.tableView.mj_header beginRefreshing];
    self.cursor = @"";
    [self reloadPage];
}

- (void)reloadPage {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error;
        EMChatroom *chatroom = [[EMClient sharedClient].roomManager getChatroomSpecificationFromServerWithId:weakSelf.model.roomId error:&error];
        if (!error) {
            [weakSelf.dataArray removeAllObjects];
            self->_ownerName = chatroom.owner;
            NSDictionary *dict = @{@"memberName":self->_ownerName,@"isOwner":@YES,@"ownerName":self->_ownerName};
            LRChatroomMembersModel *model = [LRChatroomMembersModel initWithChatroomMembersDict:dict];
            [weakSelf.dataArray addObject:model];
            self->_currentUserIsOwner = [EMClient.sharedClient.currentUsername isEqualToString:chatroom.owner];
        }
        
        EMCursorResult *result = [[EMClient sharedClient].roomManager getChatroomMemberListFromServerWithId:weakSelf.model.roomId cursor:weakSelf.cursor pageSize:50 error:&error];
        if (!error) {
            NSArray *list = result.list;
            for (NSString *membersName in list) {
                NSDictionary *dict = @{@"memberName":membersName,@"isOwner":@NO,@"ownerName":self->_ownerName};
                LRChatroomMembersModel *model = [LRChatroomMembersModel initWithChatroomMembersDict:dict];
                [weakSelf.dataArray addObject:model];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
           [weakSelf endReload];
        });
    });
}

- (void)endReload {
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
}

- (void)_setupSubviews
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.closeButton = [[UIButton alloc] init];
    self.closeButton.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 10, 15);
    [self.closeButton setImage:[UIImage imageNamed:@"close2"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(LRSafeAreaTopHeight);
        make.left.equalTo(self.view);
        make.width.equalTo(@45);
        make.height.equalTo(@25);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"成员列表";
    [self.titleLabel setTextColor:[UIColor blackColor]];
    self.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.closeButton.imageView);
        make.height.equalTo(@31);
    }];
    
    [self _setupSearch];
    [self _setupRefresh];
}

- (void)_setupSearch
{
    self.searchBar = [[LRSearchBar alloc] init];
    [self.searchBar.textField setTextColor:LRColor_MiddleBlackColor];
    self.searchBar.placeholderString = @"搜索";
    self.searchBar.placeholderTextFont = 12;
    self.searchBar.inputTextColor = [UIColor clearColor];
    self.searchBar.placeholderTextColor = [UIColor grayColor];
    self.searchBar.strokeColor = LRColor_LessBlackColor;
    self.searchBar.strokeWidth = 2;
    LRFindView *findView = [[LRFindView alloc] init];
    self.searchBar.leftView = findView;
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.left.equalTo(self.view).offset(kPadding);
        make.right.equalTo(self.view).offset(-kPadding);
        make.height.equalTo(@45);
    }];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.tag = 10;
    self.tableView.rowHeight = 40;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom).offset(6);
        make.left.equalTo(self.view).offset(kPadding - 1);
        make.right.equalTo(self.view).offset(-kPadding + 1);
        make.bottom.equalTo(self.view).offset(-LRSafeAreaBottomHeight - 49);
    }];
    UITapGestureRecognizer *tapTableView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTableViewAction:)];
    [self.tableView addGestureRecognizer:tapTableView];
    
    self.searchResultTableView = [[UITableView alloc] init];
    self.searchResultTableView.tag = 11;
    self.searchResultTableView.backgroundColor = [UIColor whiteColor];
    self.searchResultTableView.separatorStyle = UITableViewCellEditingStyleNone;
    self.searchResultTableView.rowHeight = self.tableView.rowHeight;
    self.searchResultTableView.delegate = self;
    self.searchResultTableView.dataSource = self;
    UITapGestureRecognizer *tapSRTableView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSRTableViewAction:)];
    [self.searchResultTableView addGestureRecognizer:tapSRTableView];
    
}

- (void)_setupRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadPage)];
}

#pragma mark - NSNotification
- (void)exitChatroom:(NSNotification *)aNoti
{
    NSString *info = aNoti.object;
    [LRSpeakHelper.sharedInstance leaveSpeakRoomWithRoomId:self.model.conferenceId completion:nil];
    [self showHint:info];
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - GestureRecognizer
-(void)tapTableViewAction:(UITapGestureRecognizer *)tapRecognizer
{
    [self.view endEditing:YES];
}

-(void)tapSRTableViewAction:(UITapGestureRecognizer *)tapRecognizer
{
    [self.view endEditing:YES];
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqual:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

#pragma mark - TouchesBegan
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - TablevViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (tableView == self.tableView) {
        count = [self.dataArray count];
    } else {
        count = [self.searchResults count];
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"LRChatroomMembersCell";
    LRChatroomMembersCell *cell = (LRChatroomMembersCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LRChatroomMembersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    LRChatroomMembersModel *model = nil;
    if (tableView == self.tableView) {
        model = [self.dataArray objectAtIndex:indexPath.row];
    } else {
        model = [self.searchResults objectAtIndex:indexPath.row];
    }
    cell.model = model;
    cell.exitMemberButton.hidden = !_currentUserIsOwner || [model.memberName isEqualToString:_ownerName];
    cell.ownerIconImageView.hidden = ![model.memberName isEqualToString:_ownerName];
    cell.delegate = self;
    return cell;
}

#pragma mark - TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark - LRSearchBarDelegate
- (void)searchBarShouldBeginEditing:(LRSearchBar *)searchBar
{
    // 遍历出来searchResultTableView
    for (UIView *subView in self.view.subviews) {
        if (!([subView isKindOfClass:[UITableView class]] && subView.tag == 11)) {
            if (!self.isSearching) {
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
                self.isSearching = YES;
                self.tableView.hidden = YES;
                [self.view addSubview:self.searchResultTableView];
                [self.searchResultTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.searchBar.mas_bottom).offset(6);
                    make.left.equalTo(self.view).offset(kPadding - 1);
                    make.right.equalTo(self.view).offset(-kPadding + 1);
                    make.bottom.equalTo(self.view).offset(-LRSafeAreaBottomHeight - 49);
                }];
            }
        }
    }
}

- (void)searchBarCancelAction:(LRSearchBar *)searchBar
{
    [[LRRealtimeSearch shared] realtimeSearchStop];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.isSearching = NO;
    [self.searchResults removeAllObjects];
    [self.searchResultTableView reloadData];
    [self.searchResultTableView removeFromSuperview];
    self.tableView.hidden = NO;
}

- (void)searchTextDidChangeWithString:(NSString *)aString
{
    if (!self.isSearching) {
        return;
    }
    __weak typeof(self) weakself = self;
    [[LRRealtimeSearch shared] realtimeSearchWithSource:self.dataArray searchText:aString collationStringSelector:@selector(memberName) resultBlock:^(NSArray *results) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.searchResults removeAllObjects];
            [weakself.searchResults addObjectsFromArray:results];
            [weakself.searchResultTableView reloadData];
        });
    }];
}

#pragma mark - LRChatroomMembersCellDelegate
- (void)chatroomMembersExit:(LRChatroomMembersModel *)model
{
    [[EMClient sharedClient].roomManager removeMembers:@[model.memberName] fromChatroom:self.model.roomId completion:^(EMChatroom *aChatroom, EMError *aError) {
        NSString *title = nil;
        NSString *info = nil;
        if (!aError) {
            title = @"踢人成功";
            [self.dataArray removeObject:model];
            [self.tableView reloadData];
        } else {
            title = @"踢人失败";
            info = aError.errorDescription;
        }
        LRAlertController *alertController = [LRAlertController showErrorAlertWithTitle:title
                                                                                   info:info];
        alertController.modalPresentationStyle = 0;
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

#pragma mark - KeyBoard
- (void)keyBoardWillShow:(NSNotification *)note
{
    if (!self.isSearching) {
        return;
    }
    // 获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    // 获取键盘高度
    CGRect keyBoardBounds  = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = keyBoardBounds.size.height;
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 定义好动作
    void (^animation)(void) = ^void(void) {
        [self.searchResultTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-keyBoardHeight);
        }];
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
    }
}

- (void)keyBoardWillHide:(NSNotification *)note
{
    if (!self.isSearching) {
        return;
    }
    // 获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 定义好动作
    void (^animation)(void) = ^void(void) {
        [self.searchResultTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
    }
}

- (void)closeButtonAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
