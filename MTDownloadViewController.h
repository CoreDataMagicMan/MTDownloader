//
//  MTDownloadViewController.h
//  MTDownloader
//
//  Created by mtt0150 on 15/8/28.
//  Copyright (c) 2015年 MT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTDownloadViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *picImage;

- (IBAction)downloader:(id)sender;

- (IBAction)pause:(id)sender;

- (IBAction)resume:(id)sender;

@end
