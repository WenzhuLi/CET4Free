//
//  DownloaderView.h
//  CET4Lite
//
//  Created by Seven Lee on 12-3-2.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioDownloader.h"
//#import "ProgressLabel.h"
#import "SevenProgressBar.h"
#import "SayingsView.h"

@class DownloaderView;
@protocol DownloaderViewDelegate <NSObject>

- (void) DowloaderViewDidFinishDownload:(DownloaderView *)downloaderView ;
- (void) DowloaderViewDidFailedDownload:(DownloaderView *)downloaderView ;
- (void) DowloaderViewCancelled:(DownloaderView *)downloaderView ;
@end
//下载视图
@interface DownloaderView : UIView<AudioDownloaderDelegate,UIAlertViewDelegate,ASIProgressDelegate>{
    NSArray * QArray;               //QuestionArray
    SevenProgressBar * progress;      //进度条
    NSInteger NumberOfRequests;     //请求个数（需要下载的文件数）
    UILabel * label;                //显示正在下载第几个文件，和共几个文件
    AudioDownloader * Downloader;
    id<DownloaderViewDelegate> delegate;
//    ProgressLabel * progressLabel;
    SayingsView * sayings;
    UIImageView * background;
}
@property (nonatomic, strong) AudioDownloader * Downloader;
@property (nonatomic, assign) NSInteger NumberOfRequests;
@property (nonatomic, strong) id<DownloaderViewDelegate> delegate;

//初始化
- (id) initWithFrame:(CGRect)frame Array:(NSArray *)array;

//绘图
- (void) drawView;

//开始下载，外部调用
- (void) startDownload;

- (void)CancelDownload;

- (void)stopDownload;
@end
