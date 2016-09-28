//
//  SliderView.m
//  HaviProjectBase
//
//  Created by Havi on 2016/9/28.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "SliderView.h"

@interface SliderView ()
{
    float proValue;
}

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIImageView *titleView;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SliderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        proValue = 0.1;
        _progressView = [[UIProgressView alloc]init];
        _progressView.frame = (CGRect){0,15,kScreenSize.width - 60,5};
        _progressView.progressImage = [UIImage imageNamed:@"blue_tracker"];
        _progressView.trackImage = [UIImage imageNamed:@"bluec"];
        [_progressView setProgressViewStyle:UIProgressViewStyleDefault];
        [self addSubview:_progressView];
        _titleView = [[UIImageView alloc]init];
        _titleView.image = [UIImage imageNamed:@"car"];
        _titleView.frame = (CGRect){0,0,15,10};
        [self addSubview:_titleView];
        
    }
    return self;
}

- (void)start{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(changeProgress) userInfo:nil repeats:YES];
}

-(void)changeProgress

{
    
    proValue += 0.03;
    if(proValue > 0.94)
        
    {
        
        //停用计时器
        
        [self.timer invalidate];
        
    }
    else
        
    {
        [self.progressView setProgress:(proValue)];//重置进度条
        CGFloat width = (kScreenSize.width - 60)*proValue;
        _titleView.frame = (CGRect){width,0,15,10};

    }
    
}

- (void)stop{
    proValue = 0.0;
    _titleView.frame = (CGRect){0,0,15,10};
    [self.progressView setProgress:0];
    [self.timer invalidate];
}

@end
