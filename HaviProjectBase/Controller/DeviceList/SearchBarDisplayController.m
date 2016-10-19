//
//  SearchBarDisplayController.m
//  SleepRecoding
//
//  Created by Havi on 15/11/12.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "SearchBarDisplayController.h"
#import "XHRealTimeBlur.h"
#import "SearchUserTableViewCell.h"
#import "RexpUntil.h"
#import "SearchDeviceDelegate.h"

@class DeviceListViewController;

@interface SearchBarDisplayController ()<UISearchBarDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITableView *searchTableView;
@property (nonatomic, strong) XHRealTimeBlur *backgroundView;
@property (nonatomic, strong) SearchDeviceDelegate *searchDelegate;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) NSArray *requestUser;

@end

@implementation SearchBarDisplayController

- (void)setActive:(BOOL)visible animated:(BOOL)animated {
    if(!visible) {
        [_searchTableView removeFromSuperview];
        [_backgroundView removeFromSuperview];
        [_contentView removeFromSuperview];
        _searchTableView = nil;
        _contentView = nil;
        _backgroundView = nil;
        [super setActive:visible animated:animated];
    }else {
        [super setActive:visible animated:animated];
        NSArray *subViews = self.searchContentsController.view.subviews;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
            for (UIView *view in subViews) {
                if ([view isKindOfClass:NSClassFromString(@"UISearchDisplayControllerContainerView")]) {
                    NSArray *sub = view.subviews;
                    ((UIView*)sub[2]).hidden = YES;
                }
            }
        } else {
            [[subViews lastObject] removeFromSuperview];
        }
        if(!_contentView) {
            _contentView = ({
                UIView *view = [[UIView alloc] init];
                view.frame = CGRectMake(0.0f, 64.0f, kScreen_Width, kScreen_Height - 64.0f);
                view.backgroundColor = KTableViewBackGroundColor;
                view.userInteractionEnabled = YES;
                UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedContentView:)];
                [view addGestureRecognizer:tapGestureRecognizer];
                view;
            });
            _backgroundView = ({
                XHRealTimeBlur *blur = [[XHRealTimeBlur alloc] initWithFrame:_contentView.frame];
                blur.blurStyle = XHBlurStyleBlackGradient;
                blur;
            });
            _backgroundView.userInteractionEnabled = NO;
        }
        [self.parentVC.view addSubview:_backgroundView];
        [self.parentVC.view addSubview:_contentView];
        [self.parentVC.view bringSubviewToFront:_contentView];
        self.searchBar.delegate = self;
    }
}

- (void)didClickedContentView:(UIGestureRecognizer *)sender {
    
    [self.searchBar resignFirstResponder];
    [self.searchBar removeFromSuperview];
    [self.searchTableView removeFromSuperview];
    
    [_backgroundView removeFromSuperview];
    [_contentView removeFromSuperview];
    _searchTableView = nil;
    _contentView = nil;
    _backgroundView = nil;
}

- (void)addTableViewDataHandle
{
    TableViewCellConfigureBlock configureCellBlock = ^(NSIndexPath *indexPath, id item, UITableViewCell *cell){
        [cell configure:cell customObj:item indexPath:indexPath];
    };
    CellHeightBlock configureCellHeightBlock = ^ CGFloat (NSIndexPath *indexPath, id item){
        return 64;
    };
    @weakify(self);
    DidSelectCellBlock didSelectBlock = ^(NSIndexPath *indexPath, id item){
        @strongify(self);
        [self sendMyRequest:item andIndex:indexPath];
    };
    self.searchDelegate = [[SearchDeviceDelegate alloc]initWithItems:nil cellIdentifier:@"cell" configureCellBlock:configureCellBlock cellHeightBlock:configureCellHeightBlock didSelectBlock:didSelectBlock];
    [self.searchDelegate handleTableViewDataSourceAndDelegate:self.searchTableView];
}

#pragma mark Private Method

- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc]init];
        _messageLabel.frame = CGRectMake(0, self.searchTableView.frame.size.height/2-100,self.parentVC.view.frame.size.width , 40);
        _messageLabel.text = @"没有相应的用户！";
        _messageLabel.font = [UIFont systemFontOfSize:17];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = [UIColor lightGrayColor];
        
    }
    return _messageLabel;
}

- (UITableView *)searchTableView
{
    if (!_searchTableView) {
        _searchTableView = [[UITableView alloc] initWithFrame:_contentView.frame style:UITableViewStyleGrouped];
        _searchTableView.backgroundColor = [UIColor whiteColor];
        _searchTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _contentView.frame.size.width, 0.001)];
        [self.parentVC.parentViewController.view addSubview:_searchTableView];
    }
    return _searchTableView;
}

#pragma mark UISearchBarDelegate Support

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.searchBar resignFirstResponder];
    [self initSearchResultsTableView];
    [_searchTableView layoutSubviews];
    [self searchUserList:(NSString *)self.searchBar.text];
    
}

//
- (void)searchUserList:(NSString *)searchText
{
    if (![RexpUntil checkTelNumber:self.searchBar.text]) {
        [self.searchTableView addSubview:self.messageLabel];
        self.messageLabel.text = @"请输入正确的手机号码!";
        return;
    }else{
        [self.messageLabel removeFromSuperview];
    }
    NSDictionary *para = @{
                           @"SelectionCriteria" : self.searchBar.text,
                           };
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    [client requestSearchFriendParam:para andBlock:^(FriendListModel *friendModel, NSError *error) {
        if (friendModel.userList.count == 0) {
            [self.searchTableView addSubview:self.messageLabel];
            self.messageLabel.text = @"没有对应用户哦！";
        }else{
            [self.messageLabel removeFromSuperview];
        }
        self.searchDelegate.items = friendModel.userList;
        self.requestUser = friendModel.userList;
        [self.searchTableView reloadData];
    }];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchTableView removeFromSuperview];

    [self.searchBar removeFromSuperview];
    
    [_backgroundView removeFromSuperview];
    [_contentView removeFromSuperview];
    _searchTableView = nil;
    _contentView = nil;
    _backgroundView = nil;
}

- (void)initSearchResultsTableView {
    [self addTableViewDataHandle];
    [_searchTableView.superview bringSubviewToFront:_searchTableView];
}

- (void)sendMyRequest:(NSString *)commentRequest andIndex:(NSIndexPath *)indexPath
{
    NSString *responseId = ((UserList *)[self.requestUser objectAtIndex:indexPath.row]).userID;
    NSDictionary *para = @{
                           @"RequestUserId":thirdPartyLoginUserId,
                           @"ResponseUserId":responseId,
                           @"Comment":commentRequest,
                           };
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    [client requestRequestToAddFriendParam:para andBlock:^(BaseModel *resultModel, NSError *error) {
        if ([resultModel.returnCode intValue]==10037) {
            [NSObject showHudTipStr:@"该好友已添加"];
            
        }else{
            [self searchBarCancelButtonClicked:nil];
            [NSObject showHudTipStr:@"申请成功"];
        }
    }];
}


@end
