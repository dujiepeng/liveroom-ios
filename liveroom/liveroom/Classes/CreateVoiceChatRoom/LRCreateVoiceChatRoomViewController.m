//
//  LRCreateVoiceChatRoomViewController.m
//  liveroom
//
//  Created by easemob-DN0164 on 2019/4/12.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRCreateVoiceChatRoomViewController.h"

#define kPadding 16
@interface LRCreateVoiceChatRoomViewController ()

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *voiceChatroomIDTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UILabel *chatroomIDLabel;
@property (nonatomic, strong) UILabel *passwordLabel;
@property (nonatomic, strong) UIButton *submitButton;

@end

@implementation LRCreateVoiceChatRoomViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.voiceChatroomIDTextField endEditing:YES];
    [self.passwordTextField endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubviews];
    
    // post
    //    NSString *url = @"http://turn2.easemob.com:8082/app/huangcl/create/talk/room";
    //    NSDictionary *parameters = @{@"roomName":@"chatroom1",
    //                                 @"password":@"123456",
    //                                 @"desc":@"desc",
    //                                 @"allowAudienceTalk":@true,
    //                                 @"imChatRoomMaxusers":@100,
    //                                 @"confrDelayMillis":@3600
    //                                 };
    //    [[LRRequestManager sharedInstance] requestWithMethod:@"POST"
    //                                               urlString:url
    //                                              parameters:parameters
    //                                                   token:nil completion:^(NSString * _Nonnull result, NSError * _Nonnull error) {
    //        NSLog(@"result---%@,----%@", result,error);
    //    }];
    
    
    // delete
    //    NSString *url = @"http://turn2.easemob.com:8082/app/huangcl/delete/talk/room/79230364876801";
    //    [[LRRequestManager sharedInstance] requestWithMethod:@"DELETE"
    //                                               urlString:url
    //                                              parameters:nil
    //                                                   token:nil
    //                                              completion:^(NSString * _Nonnull result, NSError * _Nonnull error) {
    //
    //        NSLog(@"result---%@,----%@", result,error);
    //    }];
    
    // get
    NSString *url = @"http://turn2.easemob.com:8082/app/talk/rooms/0/10";
    [[LRRequestManager sharedInstance] requestWithMethod:@"GET"
                                               urlString:url
                                              parameters:nil
                                                   token:nil
                                              completion:^(NSString * _Nonnull result, NSError * _Nonnull error) {
                                                  NSLog(@"result---%@,----%@", result,error);
                                              }];
}

- (void)_setupSubviews
{
    self.view.backgroundColor = [UIColor blackColor];
    self.closeButton = [[UIButton alloc] init];
    self.closeButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(LRSafeAreaTopHeight);
        make.left.equalTo(self.view).offset(kPadding);
        make.width.equalTo(@15);
        make.height.equalTo(@15);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"创建 CreateVoiceChatroom";
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.closeButton);
    }];
    
    self.voiceChatroomIDTextField = [[UITextField alloc] init];
    self.voiceChatroomIDTextField.placeholder = @"房间号 voiceChatroomID";
    [self.voiceChatroomIDTextField setupTextField];
    [self.voiceChatroomIDTextField strokeWithColor:LRStrokeWhite];
    [self.view addSubview:self.voiceChatroomIDTextField];
    [self.voiceChatroomIDTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
        make.left.equalTo(self.view).offset(kPadding);
        make.right.equalTo(self.view).offset(-kPadding);
        make.height.equalTo(@48);
    }];
    
    self.chatroomIDLabel = [[UILabel alloc] init];
    self.chatroomIDLabel.text = @"房间号必须由8位的字母、数字组成。Room number must consist of 8-digit letters and numbers.";
    [self.chatroomIDLabel setTextColor:[UIColor whiteColor]];
    self.chatroomIDLabel.numberOfLines = 2;
    self.chatroomIDLabel.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:self.chatroomIDLabel];
    [self.chatroomIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.voiceChatroomIDTextField.mas_bottom);
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
    }];
    
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.placeholder = @"密码 password";
    [self.passwordTextField setupTextField];
    [self.passwordTextField strokeWithColor:LRStrokeWhite];
    [self.view addSubview:self.passwordTextField];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chatroomIDLabel.mas_bottom).offset(12);
        make.left.equalTo(self.view).offset(kPadding);
        make.right.equalTo(self.view).offset(-kPadding);
        make.height.equalTo(@48);
    }];
    
    self.passwordLabel = [[UILabel alloc] init];
    self.passwordLabel.text = @"密码最多不能超过16位。Passwords should not exceed 16 bits at most.";
    [self.passwordLabel setTextColor:[UIColor whiteColor]];
    self.passwordLabel.numberOfLines = 2;
    self.passwordLabel.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:self.passwordLabel];
    [self.passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom);
        make.left.equalTo(self.view).offset(kPadding);
        make.right.equalTo(self.view).offset(-kPadding);
    }];
    
    self.submitButton = [[UIButton alloc] init];
    [self.submitButton setTitle:@"创建 create" forState:UIControlStateNormal];
    [self.submitButton setBackgroundColor:[UIColor whiteColor]];
    [self.submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.submitButton addTarget:self action:@selector(submitButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitButton];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordLabel.mas_bottom).offset(44);
        make.left.equalTo(self.view).offset(kPadding);
        make.right.equalTo(self.view).offset(-kPadding);
        make.height.equalTo(@48);
    }];
}

#pragma mark ButtonAction
- (void)closeButtonAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)submitButtonAction
{
    
}

@end
