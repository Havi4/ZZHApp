//
//  TopChannelView.h
//  HaviProjectBase
//
//  Created by HaviLee on 2016/11/4.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TTTopChannelContianerViewDelegate <NSObject>

@optional

- (void)showOrHiddenAddChannelsCollectionView:(UIButton *)button;
- (void)chooseChannelWithIndex:(NSInteger)index;

@end


@interface TopChannelView : UIView

- (instancetype)initWithFrame:(CGRect)frame;
- (void)addAChannelButtonWithChannelName:(NSString *)channelName;
- (void)selectChannelButtonWithIndex:(NSInteger)index;
- (void)deleteChannelButtonWithIndex:(NSInteger)index;

//- (void)didShowEditChannelView:(BOOL)value;

@property (nonatomic, strong) NSArray *channelNameArray;
@property (nonatomic, weak) UIScrollView *scrollView;
//@property (nonatomic, weak) UIButton *addButton;
@property (nonatomic, weak) id<TTTopChannelContianerViewDelegate> delegate;

@end
