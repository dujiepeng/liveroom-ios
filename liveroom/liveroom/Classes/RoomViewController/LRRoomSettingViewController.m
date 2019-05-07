//
//  LRRoomSettingViewController.m
//  liveroom
//
//  Created by easemob-DN0164 on 2019/4/28.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRRoomSettingViewController.h"

#define kPadding 16
@interface LRRoomSettingViewController ()
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UILabel *roomNameLabel;
@property (nonatomic, strong) UILabel *roomProfileLabel;
@end

@implementation LRRoomSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubviews];
}

- (void)_setupSubviews
{
    self.view.backgroundColor = [UIColor blackColor];
    self.closeButton = [[UIButton alloc] init];
    self.closeButton.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 10, 15);
    [self.closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(LRSafeAreaTopHeight);
        make.left.equalTo(self.view);
        make.width.equalTo(@45);
        make.height.equalTo(@25);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"房间设置 VoiceChatroom Profile";
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.closeButton.imageView);
    }];
    
    // LRColor_HeightBlackColor  LRColor_MiddleBlackColor  LRColor_LowBlackColor
    self.backGroundView = [[UIView alloc] init];
    self.backGroundView.layer.borderWidth = 2;
    self.backGroundView.layer.borderColor = LRColor_LowBlackColor.CGColor;
    self.backGroundView.backgroundColor = LRColor_HeightBlackColor;
    [self.view addSubview:self.backGroundView];
    [self.backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(kPadding);
        make.right.equalTo(self.view).offset(-kPadding);
        make.height.equalTo(@255);
    }];
    
    self.roomNameLabel = [[UILabel alloc] init];
    [self.roomNameLabel setTextColor:[UIColor whiteColor]];
    [self.roomNameLabel setText:_model.roomname];
    self.roomNameLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.backGroundView addSubview:self.roomNameLabel];
    [self.roomNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backGroundView).offset(16);
        make.left.equalTo(self.backGroundView).offset(kPadding);
        make.right.equalTo(self.backGroundView).offset(-kPadding);
    }];
    
    self.roomProfileLabel = [[UILabel alloc] init];
    self.roomProfileLabel.numberOfLines = 0;
//    [self.roomProfileLabel setText:[NSString stringWithFormat:@"房间id：%@\n密码password：%@\n聊天室chatroomid：%@\n会议confrenceid：%@\n音质模式voicequality：%@\n互动主播speakerlimited：%d\n房间人数memberlimited：%d\n创建时间createtime：%@\n允许观众申请上麦applyAllow：%d\n互动模式type：%ld",_model.roomId,_rommPassword,_model.roomId,_model.conferenceId,@"highlevel",_speakerLimited,_model.maxCount,_model.createTime,_model.allowAudienceOnSpeaker,_model.roomType]];
    NSString *roomType = nil;
    if (_model.roomType == 1) {
        roomType = @"communication";
    } else if (_model.roomType == 2) {
        roomType = @"host";
    } else {
        roomType = @"monopoly";
    }
    NSString *allowAudienceOnSpeaker = _model.allowAudienceOnSpeaker? @"ture" : @"false";
    NSString *info = [NSString stringWithFormat:@"房间id：%@\n密码password：%@\n聊天室chatroomid：%@\n会议confrenceid：%@\n音质模式voicequality：%@\n互动主播speakerlimited：%d\n房间人数memberlimited：%d\n创建时间createtime：%@\n允许观众申请上麦applyAllow：%@\n互动模式type：%@",_model.roomId,_rommPassword,_model.roomId,_model.conferenceId,@"highlevel",_speakerLimited,_model.maxCount,_model.createTime,allowAudienceOnSpeaker,roomType];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 6;
    NSDictionary *ats = @{
                          NSFontAttributeName : [UIFont systemFontOfSize:12.0f],
                          NSParagraphStyleAttributeName : style,
                          };
    self.roomProfileLabel.attributedText = [[NSAttributedString alloc] initWithString:info attributes:ats];
    
    [self.roomProfileLabel setTextColor:RGBACOLOR(155, 155, 155, 1)];
    [self.backGroundView addSubview:self.roomProfileLabel];
    [self.roomProfileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.roomNameLabel.mas_bottom);
        make.left.equalTo(self.backGroundView).offset(kPadding);
        make.right.equalTo(self.backGroundView).offset(-kPadding);
    }];
}

#pragma mark ButtonAction
- (void)closeButtonAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
