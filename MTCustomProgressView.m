//
//  MTCustomProgressView.m
//  MTMeiZhuang
//
//  Created by mtt0150 on 15/8/6.
//  Copyright (c) 2015年 MT. All rights reserved.
//

#import "MTCustomProgressView.h"
#import "UIColor+Hex.h"
@interface MTCustomProgressView ()
@property (assign, nonatomic) CGFloat g_width;
@property (assign, nonatomic) CGFloat g_height;
- (void)moveProgress;
- (void)changeProgressViewFrame;
@end
@implementation MTCustomProgressView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        //self.clipsToBounds = YES;
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        _g_width = width;
        _g_height = height;
        _trackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _trackView.backgroundColor = [UIColor darkGrayColor];
        _trackView.clipsToBounds = YES;//当前view的主要作用是将出界了的_progressView剪切掉，所以需将clipsToBounds设置为YES
        [self addSubview:_trackView];
        
        _progressView = [[UIImageView alloc] initWithFrame:CGRectMake(0 - width, 0, width, height)];
        _progressView.backgroundColor = [UIColor mt_applicationPurpleColor];
        [_trackView addSubview:_progressView];
        
        _currentProgress = 0.0;
    }
    return self;
}
- (void)setProgress:(CGFloat)progress{
    if (0 == progress) {
        self.currentProgress = 0;
        [self changeProgressViewFrame];
        return;
    }
    
    _targetProgress = progress;
    if (_progressTimer == nil)
    {
        _progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(moveProgress) userInfo:nil repeats:YES];
    }
}

//////////////////////////////////////////////////////
- (void) moveProgress
{
    if (self.currentProgress < _targetProgress)
    {
        self.currentProgress = MIN(self.currentProgress + 0.1, _targetProgress);
        [self changeProgressViewFrame];
    } else {
        //使定时器失效
        [_progressTimer invalidate];
        _progressTimer = nil;
    }
}

- (void)changeProgressViewFrame{
    _progressView.frame = CGRectMake(_g_width * _currentProgress - _g_width, 0, _g_width, _g_height);
}
@end
