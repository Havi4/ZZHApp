//
//  NaviTitleScrollView.m
//  HaviProjectBase
//
//  Created by Havi on 16/8/2.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "NaviTitleScrollView.h"

@interface NaviTitleScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *titleScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation NaviTitleScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleScrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        [self addSubview:_titleScrollView];
    }
    return self;
}

- (void)setTitles:(NSArray *)titles
{
    _titleScrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _titleScrollView.contentSize = CGSizeMake(titles.count * self.frame.size.width, self.frame.size.height);
    _titleScrollView.showsHorizontalScrollIndicator = NO;
    _titleScrollView.delegate = self;
    _titleScrollView.scrollEnabled = YES;
    _titleScrollView.pagingEnabled = YES;
    _titleScrollView.bounces = NO;
    for (int i = 0;i<titles.count;i++) {
        NSString *title = [titles objectAtIndex:i];
        UILabel *label = [[UILabel alloc]initWithFrame:(CGRect){i*(self.frame.size.width),-5,self.frame.size.width,self.frame.size.height}];
        label.text = title;
        label.font = kDefaultWordFont;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [_titleScrollView addSubview:label];
    }
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.frame = CGRectMake((self.frame.size.width-20)/2, self.frame.size.height-20, 20, 20);
    _pageControl.numberOfPages = titles.count;
    _pageControl.currentPage = 0;
    [self addSubview:_pageControl];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
}

- (void)setCurrentIndex:(NSInteger)index
{
    _pageControl.currentPage = index;
    [_titleScrollView setContentOffset:CGPointMake(self.frame.size.width * index, 0)];
}

@end
