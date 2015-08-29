//
//  MTDownloadViewController.m
//  MTDownloader
//
//  Created by mtt0150 on 15/8/28.
//  Copyright (c) 2015年 MT. All rights reserved.
//

#import "MTDownloadViewController.h"
#import "MTCustomProgressView.h"
//文件下载的URL
#define URLSTRING @"http://sucaimobile.dl.meitudata.com/meizhuangxiangji/iphone/zip/zip104.zip"
//文件存放的位置
#define FILESAVINGPATH @"/Users/mtt0150/Desktop/104.zip"
@interface MTDownloadViewController ()<NSURLSessionDownloadDelegate>
@property (strong, nonatomic) MTCustomProgressView *customProgress;
@property (weak, nonatomic) IBOutlet UIView *progressView;
//下载的任务
@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;
//暂存数据
@property (strong, nonatomic) NSData *partData;
@end

@implementation MTDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //视图加载完之后，显示进度条
    _customProgress = [[MTCustomProgressView alloc] initWithFrame:_progressView.frame];
    [self.view addSubview:_customProgress];
}
//创建一个nssession
- (NSURLSession *)createSession{
    //配置configure
    NSURLSessionConfiguration *configure = [NSURLSessionConfiguration defaultSessionConfiguration];
    //声明一个nssession
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configure delegate:self delegateQueue:nil];
    return session;
}
//创建一个url请求
- (NSURLRequest *)sendRequest{
    NSURL *url = [NSURL URLWithString:URLSTRING];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:2.0];
    return request;
}
//创建一个文件存储的路径
- (NSURL *)FileSavePath:(NSURL *)location{
//    NSFileManager *manager = [NSFileManager defaultManager];
//    NSArray *URLpaths = [manager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
//    NSURL *URLpath = URLpaths[0];
    //NSURL *URLpath = [NSURL fileURLWithPath:@"/Users/mtt0150/Desktop"];
//    NSURL *saveURLPath = [URLpath URLByAppendingPathComponent:[location lastPathComponent]];
    NSURL *saveURLPath = [NSURL fileURLWithPath:FILESAVINGPATH];
    return saveURLPath;
}
//将文件拷贝到指定的路径
- (BOOL)copyitemToPath:(NSURL *)location toDesmation:(NSURL *)desmation{
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtURL:desmation error:NULL];
    BOOL isCopy = [manager copyItemAtURL:location toURL:desmation error:NULL];
    if (isCopy) {
        return YES;
    }
    else{
        return NO;
    }
}
- (IBAction)downloader:(id)sender {
    //开始下载,需要有三个条件：一个是下载的task，一个是nsurlsession,一个是request
    self.downloadTask = [[self createSession] downloadTaskWithRequest:[self sendRequest]];
    //默认任务是挂起的，所以我要将他唤醒
    [self.downloadTask resume];
    
}

- (IBAction)pause:(id)sender {
    if (self.downloadTask) {
        [_downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
            self.partData = resumeData;
            self.downloadTask = nil;
        }];
    }
}

- (IBAction)resume:(id)sender {
    //重新开启任务
    if (!self.downloadTask) {
        if (!self.partData) {
            //如果数据没有那就重新下载
            self.downloadTask = [[self createSession] downloadTaskWithRequest:[self sendRequest]];
        }
        else{
        //如果有数据，那么就从暂停的部分重新开始
            self.downloadTask = [[self createSession] downloadTaskWithResumeData:_partData];
        }
    }
    //重新开启任务
    [self.downloadTask resume];
}
#pragma mark NSURLSessionDownloadDelegate代理
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    NSLog(@"Download success for URL: %@",location.description);
    //创建一个最终存储的位置
    NSURL *desnimation = [self FileSavePath:location];
    //将文件已到目的处
    BOOL isCopy = [self copyitemToPath:location toDesmation:desnimation];
    NSLog(@"%d",isCopy);
    if (isCopy) {
        //回到主线程当中去显示图片
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithContentsOfFile:[desnimation path]];
            self.picImage.image = image;
        });
    }
    else{
        NSLog(@"路径错误");
    }
    self.downloadTask = nil;
    
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
     double currentProgress = totalBytesWritten/(double)totalBytesExpectedToWrite;
    NSLog(@"%f",currentProgress);
    dispatch_async(dispatch_get_main_queue(), ^{
        [_customProgress setProgress:currentProgress];

    });
}

@end
