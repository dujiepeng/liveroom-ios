//
//  LRMainViewController.m
//  Tigercrew
//
//  Created by easemob-DN0164 on 2019/3/29.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRMainViewController.h"
#import "LRRoomListViewController.h"
#import "LRRoomViewController.h"
#import "LRCreateRoomViewController.h"
#import "LRSettingViewController.h"
#import "LRTabBar.h"
#import "LRRoomModel.h"

@interface LRMainViewController () <UITabBarControllerDelegate, LRTabBarDelegate, EMClientDelegate>

@property (nonatomic, strong) LRRoomListViewController *voiceChatRoomListVC;
@property (nonatomic, strong) LRSettingViewController *settingVC;

@end

@implementation LRMainViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBar.hidden = YES;
    [EMClient.sharedClient addDelegate:self delegateQueue:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubviews];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(roomDidCreated:) name:LR_NOTIFICATION_ROOM_LIST_DIDCHANGEED object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(kickedOutChatroom:) name:LR_Kicked_Out_Chatroom_Notification object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(joinConferencePasswordError:) name:LR_Join_Conference_Password_Error_Notification object:nil];
    
}

- (void)_setupSubviews
{
    LRTabBar *tabBar = [[LRTabBar alloc] initWithFrame:CGRectMake(0, LRWindowHeight - LRSafeAreaBottomHeight - 49, LRWindowWidth, 49)];
    tabBar.delegate = self;
    [self.view addSubview:tabBar];
    [self.view bringSubviewToFront:tabBar];
    
    [self _setupChildrenViewController];
}

- (void)_setupChildrenViewController
{
    self.voiceChatRoomListVC = [[LRRoomListViewController alloc] init];
    self.settingVC = [[LRSettingViewController alloc] init];
    self.viewControllers = @[self.voiceChatRoomListVC,self.settingVC];
}

#pragma mark - LRTabBarDelegate
- (void)tabBar:(LRTabBar *)tabBar clickViewAction:(NSInteger)tag
{
    if (tag != 101) {
        if (tag == 100) {
            self.selectedIndex = tag - 100;
        } else {
            self.selectedIndex = tag - 101;
        }
        return;
    }
    LRCreateRoomViewController *createVC = [[LRCreateRoomViewController alloc] init];
    [self presentViewController:createVC animated:YES completion:nil];
}


- (void)roomDidCreated:(NSNotification *)aNoti {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (aNoti.object) {
        NSDictionary *roomInfo = aNoti.object;
        LRRoomModel *model = [LRRoomModel roomWithDict:roomInfo];
        model.roomType = [roomInfo[@"type"] integerValue];
        LRRoomViewController *lrVC = [[LRRoomViewController alloc] initWithUserType:LRUserType_Admin roomModel:model password:roomInfo[@"rtcConfrPassword"]];
        [self presentViewController:lrVC animated:YES completion:nil];
    }
}

- (void)kickedOutChatroom:(NSNotification *)aNoti {
    LRAlertController *alertController = [LRAlertController showTipsAlertWithTitle:@"提示"
                                                                               info:@"您被房主移出房间"];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)joinConferencePasswordError:(NSNotification *)aNoti {
    LRAlertController *alertController = [LRAlertController showErrorAlertWithTitle:@"错误 Error"
                                                                               info:@"房间密码错误，请重新加入"];
    [self presentViewController:alertController animated:YES completion:nil];
}

// 被踢
- (void)userAccountDidLoginFromOtherDevice {
    [NSNotificationCenter.defaultCenter postNotificationName:LR_Did_Login_Other_Device_Notification object:nil];
}



@end
