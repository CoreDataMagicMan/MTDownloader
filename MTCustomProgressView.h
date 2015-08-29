//
//  MTCustomProgressView.h
//  MTMeiZhuang
//
//  Created by mtt0150 on 15/8/6.
//  Copyright (c) 2015年 MT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTCustomProgressView : UIView
@property (retain, nonatomic) UIImageView *trackView;
@property (retain, nonatomic) UIImageView *progressView;
@property (retain, nonatomic) NSTimer *progressTimer;
@property (assign, nonatomic) CGFloat targetProgress;
@property (assign, nonatomic) CGFloat currentProgress;
- (void)setProgress:(CGFloat)progress;

@end
