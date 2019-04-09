//
//  LRSpeakerViewController.m
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/4.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import "LRSpeakerViewController.h"
#import "Headers.h"

#define kCurrentUserIsAdmin NO

@interface LRSpeakerViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSMutableArray *dataAry;
@end

@implementation LRSpeakerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self _setupSubViews];
    

    LRSpeakerCellModel *model = [[LRSpeakerCellModel alloc] init];
    model.username = @"zhangsong";
    model.isMyself = NO;
    model.isAdmin = YES;
    
    LRSpeakerCellModel *model1 = [[LRSpeakerCellModel alloc] init];
    model1.username = @"dujiepeng";
    model1.isMyself = YES;
    model1.isAdmin = NO;
    
    LRSpeakerCellModel *model2 = [[LRSpeakerCellModel alloc] init];
    model2.username = @"shengxi";
    model2.isMyself = NO;
    model2.isAdmin = NO;
    
    [self.dataAry addObject:model];
    [self.dataAry addObject:model1];
    [self.dataAry addObject:model2];
    
    
    [self.tableView reloadData];
}

- (void)_setupSubViews {
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.tableView.mas_top);
        make.height.equalTo(@40);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - table view delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView
                 cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LRSpeakerCellModel *model = self.dataAry[indexPath.row];
    LRSpeakerCell *cell;
    if (model.username) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"LRSpeakerOnCell"];
        if (!cell) {
            cell = [[LRSpeakerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LRSpeakerOnCell"];
        }
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"LRSpeakerOffCell"];
        if (!cell) {
            cell = [[LRSpeakerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LRSpeakerOffCell"];
        }
    }
    [cell setModel:model];
    return cell;
}



#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = LRColor_MiddleBlackColor;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 60;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor redColor];
    }
    return _headerView;
}

- (NSMutableArray *)dataAry {
    if (!_dataAry) {
        _dataAry = [NSMutableArray array];
    }
    return _dataAry;
}

@end

@interface LRSpeakerCell ()
@property (nonatomic, strong) UIView *lightView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *crownImage;
@property (nonatomic, strong) UIView *volumeView;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIButton *voiceEnableBtn;
@property (nonatomic, strong) UIButton *disconnectBtn;

@end

@implementation LRSpeakerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self _setupSubViews];
    }
    return self;
}

#pragma mark - subviews
- (void)_setupSubViews {
    [self.contentView addSubview:self.lightView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.crownImage];
    [self.contentView addSubview:self.volumeView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.voiceEnableBtn];
    [self.contentView addSubview:self.disconnectBtn];
    
    [self.lightView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.nameLabel);
        make.right.equalTo(self.nameLabel.mas_left).offset( -5);
        make.width.height.equalTo(@8);
    }];
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.right.lessThanOrEqualTo(self.volumeView.mas_left).offset(-32);
        make.height.equalTo(@30);
    }];
    
    [self.crownImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.left.equalTo(self.nameLabel.mas_right).offset(5);
        make.height.width.equalTo(@25);
    }];
    
    [self.volumeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView).offset(-10);
        make.width.equalTo(@15);
        make.height.equalTo(@20);
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.equalTo(@2);
    }];
    
    [self layoutIfNeeded];
}

- (void)_setupUI {
    BOOL voiceEnableBtnNeedShow = NO;
    BOOL disconnectBtnNeedShow = NO;
    
    // 如果有数据
    if (_model.username) {
        self.nameLabel.text = _model.username;
        self.lightView.backgroundColor = !_model.isMute ? [UIColor yellowColor] : LRColor_HeightBlackColor;
        if (_model.isAdmin) {
            self.crownImage.hidden = NO;
        }else {
            self.crownImage.hidden = YES;
        }
    
        // 如果显示的是当前用户，或者当前用户是群主时，才需要展示这两个按钮
        voiceEnableBtnNeedShow = _model.isMyself || kCurrentUserIsAdmin;
        disconnectBtnNeedShow = !_model.isMyself && kCurrentUserIsAdmin;
    } else {
        self.nameLabel.text = @"disconnected";
        self.lightView.backgroundColor = LRColor_LowBlackColor;
        self.crownImage.hidden = YES;
    }
    
    if (voiceEnableBtnNeedShow) {
        self.voiceEnableBtn.hidden = NO;
        [self.voiceEnableBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            make.left.equalTo(self.lightView);
            make.width.equalTo(@100);
            make.height.equalTo(@30);
            make.bottom.equalTo(self.lineView.mas_top).offset(-10);
        }];
    }else {
        [self.voiceEnableBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            make.left.equalTo(self.lightView);
            make.width.height.equalTo(@0);
        }];
        self.voiceEnableBtn.hidden = YES;
    }

    if (disconnectBtnNeedShow) {
        self.disconnectBtn.hidden = NO;
        [self.disconnectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            make.left.equalTo(self.voiceEnableBtn.mas_right).offset(10);
            make.width.equalTo(@100);
            make.height.equalTo(@30);
            make.bottom.equalTo(self.lineView.mas_top).offset(-10);
        }];
    }else {
        [self.disconnectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            make.left.equalTo(self.voiceEnableBtn.mas_right).offset(10);
            make.width.height.equalTo(@0);
        }];
        self.disconnectBtn.hidden = YES;
    }
}

#pragma mark - actions
- (void)voiceEnableAction:(UIButton *)aBtn {
    aBtn.selected = !aBtn.selected;
    if (aBtn.selected) {
        [_voiceEnableBtn strokeWithColor:LRStrokeGreen];
    }else {
        [_voiceEnableBtn strokeWithColor:LRStrokeLowBlack];
    }
}

- (void)disconnectAction:(UIButton *)aBtn {
    aBtn.selected = !aBtn.selected;
}

#pragma mark - getter
- (UIView *)lightView {
    if (!_lightView) {
        _lightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        _lightView.layer.masksToBounds = YES;
        _lightView.layer.cornerRadius = 4;
        _lightView.backgroundColor = [UIColor yellowColor];
    }
    return _lightView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:17];
    }
    return _nameLabel;
}

- (UIImageView *)crownImage {
    if (!_crownImage) {
        _crownImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _crownImage.image = [UIImage imageNamed:@"crown"];
    }
    return _crownImage;
}

- (UIView *)volumeView {
    if (!_volumeView) {
        _volumeView = [[UIView alloc] init];
        _volumeView.backgroundColor = [UIColor blueColor];
    }
    return _volumeView;
}

- (UIButton *)voiceEnableBtn {
    if (!_voiceEnableBtn) {
        _voiceEnableBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voiceEnableBtn strokeWithColor:LRStrokeLowBlack];
        [_voiceEnableBtn setTitle:@"音频 voiceOpen" forState:UIControlStateNormal];
        [_voiceEnableBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_voiceEnableBtn setTitleColor:LRColor_LowBlackColor forState:UIControlStateSelected];
        _voiceEnableBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_voiceEnableBtn addTarget:self action:@selector(voiceEnableAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceEnableBtn;
}

- (UIButton *)disconnectBtn {
    if (!_disconnectBtn) {
        _disconnectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_disconnectBtn strokeWithColor:LRStrokeRed];
        [_disconnectBtn setTitle:@"下麦 disconnect" forState:UIControlStateNormal];
        [_disconnectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_disconnectBtn setTitleColor:LRColor_LowBlackColor forState:UIControlStateSelected];
        _disconnectBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_disconnectBtn addTarget:self action:@selector(disconnectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _disconnectBtn;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor blackColor];
    }
    return _lineView;
}

#pragma mark - setter
- (void)setModel:(LRSpeakerCellModel *)model {
    _model = model;
    [self _setupUI];
}
@end

@implementation LRSpeakerCellModel
@end
