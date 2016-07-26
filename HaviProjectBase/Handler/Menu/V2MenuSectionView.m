//
//  V2MenuSectionView.m
//  v2ex-iOS
//
//  Created by Singro on 3/30/14.
//  Copyright (c) 2014 Singro. All rights reserved.
//

#import "V2MenuSectionView.h"

//#import "SCActionSheet.h"
//#import "SCActionSheetButton.h"
#import "ScrollViewFrameAccessor.h"

#import "V2MenuSectionCell.h"

static CGFloat const kAvatarHeight = 70.0f;

@interface V2MenuSectionView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIImageView *profileBackView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIButton    *avatarButton;
@property (nonatomic, strong) UIImageView *divideImageView;
@property (nonatomic, strong) UILabel     *usernameLabel;
@property (nonatomic, strong) UILabel     *userPhoneLabel;

//@property (nonatomic, strong) SCActionSheet      *actionSheet;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray     *sectionImageNameArray;
@property (nonatomic, strong) NSArray     *sectionTitleArray;

@end

@implementation V2MenuSectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.sectionImageNameArray = @[@"icon_todays_data_0", @"icon_data_analysis_0", @"icon_equipment_management_0", @"icon_alarm_clock_0", @"icon_message", @"icon_setting_0"];
        self.sectionTitleArray = @[@"今日数据", @"数据分析", @"设备管理", @"睡眠设置", @"我的消息", @"设        定"];

        [self configureTableView];
        [self configureProfileView];
        [self configureNotifications];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configureTableView {
    
    self.tableView                 = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    self.tableView.contentInsetTop = 120;
    [self addSubview:self.tableView];
    
}

- (void)configureProfileView {
    self.profileBackView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"profile_back"]];
    [self addSubview:self.profileBackView];
    
    self.avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar_default"]];
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 35; //kAvatarHeight / 2.0;
    self.avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avatarImageView.layer.borderWidth = 1.0f;
    [self addSubview:self.avatarImageView];
    

    self.avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.avatarButton];
    
    self.divideImageView = [[UIImageView alloc] init];
    self.divideImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.divideImageView.image = [UIImage imageNamed:@"section_divide"];
    self.divideImageView.clipsToBounds = YES;
    [self addSubview:self.divideImageView];
    
    self.usernameLabel = [[UILabel alloc]init];
    self.usernameLabel.text = @"哈维";
    self.usernameLabel.textAlignment = NSTextAlignmentLeft;
    self.usernameLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.usernameLabel];
    self.userPhoneLabel = [[UILabel alloc]init];
    self.userPhoneLabel.textAlignment = NSTextAlignmentLeft;
    self.userPhoneLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.userPhoneLabel];
    
    NSMutableString *userId = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%@",thirdPartyLoginNickName]];
    NSString *name;
    if (userId.length == 0) {
        name = @"匿名用户";
    }else if ([userId intValue]>0){
        [userId replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        name = userId;
    }else{
        name = userId;
    }
    self.userPhoneLabel.text = name;
    // Handles
}

- (void)configureSearchView {
    
    
    
    
}

- (void)configureNotifications {
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@",kAppBaseURL,@"v1/file/DownloadFile/",thirdPartyLoginUserId];
    @weakify(self);
    [[NSNotificationCenter defaultCenter] addObserverForName:@"iconImageChanged" object:nil queue:nil usingBlock:^(NSNotification *note) {
        @strongify(self);
        
        [self.avatarImageView setImageWithURL:[NSURL URLWithString:url] placeholder:[UIImage imageNamed:@"avatar_default"]];
        self.avatarImageView.layer.borderColor = [UIColor grayColor].CGColor;

    }];
//
    
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:url] placeholder:[UIImage imageNamed:[NSString stringWithFormat:@"head_portrait_%d",0]] options:YYWebImageOptionRefreshImageCache completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
    }];


}

#pragma mark - Layout

- (void)layoutSubviews {
    
//    CGFloat spaceHeight = (self.tableView.contentInsetTop - kAvatarHeight) / 3.0;
    self.avatarImageView.frame = (CGRect){30, 30, kAvatarHeight, kAvatarHeight};
    self.profileBackView.frame = (CGRect){0,0,self.width,120};
    self.avatarButton.frame = self.avatarImageView.frame;
    self.divideImageView.frame = (CGRect){80, kAvatarHeight + 50, 80, 0.5};
    self.divideImageView.frame = (CGRect){-self.width, kAvatarHeight + 50, self.width * 2, 0.5};
    self.tableView.frame = (CGRect){0, 0, self.width, self.height};
    self.usernameLabel.frame = (CGRect){110,30,130,35};
    self.userPhoneLabel.frame = (CGRect){110,65,130,35};
    [self.avatarButton addTarget:self action:@selector(showProfile:) forControlEvents:UIControlEventTouchUpInside];
//
}

- (void)showProfile:(UIButton *)button
{
    [[NSNotificationCenter defaultCenter]postNotificationName:kPostTapProfileImage object:nil];
}

#pragma mark - Setters

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    
    if (selectedIndex < self.sectionTitleArray.count) {
        _selectedIndex = selectedIndex;
        
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = - scrollView.contentOffsetY;
    
//    CGFloat spaceHeight = (self.tableView.contentInsetTop - kAvatarHeight) / 3.0;
    
    self.avatarImageView.y = 30 - (scrollView.contentInsetTop - offsetY) / 1.7;
    self.avatarButton.frame = self.avatarImageView.frame;

    self.divideImageView.y = self.avatarImageView.y + kAvatarHeight + (offsetY - (self.avatarImageView.y + kAvatarHeight)) / 2.0 + fabs(offsetY - self.tableView.contentInsetTop)/self.tableView.contentInsetTop * 8.0 + 10;
    self.profileBackView.frame = (CGRect){0,0,self.width,fabs(offsetY)};
    
}

#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sectionTitleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightCellForIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    V2MenuSectionCell *cell = (V2MenuSectionCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[V2MenuSectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return [self configureWithCell:cell IndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.didSelectedIndexBlock) {
        self.didSelectedIndexBlock(indexPath.row);
    }
    
}

#pragma mark - Configure TableCell

- (CGFloat)heightCellForIndexPath:(NSIndexPath *)indexPath {
    
    return [V2MenuSectionCell getCellHeight];
    
}

- (V2MenuSectionCell *)configureWithCell:(V2MenuSectionCell *)cell IndexPath:(NSIndexPath *)indexPath {
    
    cell.imageName = self.sectionImageNameArray[indexPath.row];
    cell.title     = self.sectionTitleArray[indexPath.row];
    
    cell.badge = nil;
    
//    if (indexPath.row == 5) {
//        if ([V2CheckInManager manager].isExpired && kSetting.checkInNotiticationOn) {
//            cell.badge = @"";
//        }
//    }
    
    return cell;
    
}


#pragma mark - Notifications

- (void)didReceiveThemeChangeNotification {
    
    [self.tableView reloadData];
//    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:[V2SettingManager manager].selectedSectionIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
//    self.avatarImageView.alpha = kSetting.imageViewAlphaForCurrentTheme;
//    self.divideImageView.alpha = kSetting.imageViewAlphaForCurrentTheme;

}

- (void)didReceiveUpdateCheckInBadgeNotification {
    
    [self.tableView reloadData];
//    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.sectionTitleArray.count - 1 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
}

@end