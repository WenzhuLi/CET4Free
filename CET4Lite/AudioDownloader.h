//
//  AudioDownloader.h
//  CET4Lite
//
//  Created by Seven Lee on 12-3-2.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "database.h"
#define kAudioSuffix @"http://cetsounds.iyuba.com/4/"
#define kVIPAudioSuffix @"http://cetsoundsvip.iyuba.com/4/"

@class AudioDownloader;

@protocol AudioDownloaderDelegate <NSObject>

@required
- (void) AudioDownloader:(AudioDownloader *)adioloader setNumberOfRequests:(NSInteger)number;
- (void) AudioDownloader:(AudioDownloader *)adioloader setCurrentRequestTag:(NSInteger)tag;
- (void) AudioDownloader:(AudioDownloader *)adioloader FinishedRequestTag:(NSInteger)tag;
- (void) AudioDownloader:(AudioDownloader *)adioloader FailedRequestTag:(NSInteger)tag Error:(NSError *)err;
- (void) AudioDownloaderAllFileDownloaded:(AudioDownloader *)adioloader;
@end
//下载器，负责下载音频
@interface AudioDownloader : NSObject<ASIHTTPRequestDelegate>{
    NSArray * QuestionArray;            //需要下载的问题数组，其中每个元素的audio、questionSound都要下载
    NSArray * AudioBag;                 //应命名为AudioArray更好，要下载的音频NSString数组，文件名
    NSInteger year;                     //年份，下载地址为http://cetsounds.iyuba.com/4/年份/文件名.mp3
    ASINetworkQueue * requestQueue;     //下载队列
//    UIProgressView * downloadPro;       //进度条
    id<ASIProgressDelegate> downloadPro;
//    ProgressLabel * downloadPro;
    id<AudioDownloaderDelegate> delegate;
//    NSMutableArray * RequestArray;
}
//@property (nonatomic, strong) UIProgressView * downloadPro;
@property (nonatomic, strong) id<ASIProgressDelegate> downloadPro;
//@property (nonatomic, strong) ProgressLabel * downloadPro;
@property (nonatomic, strong) id<AudioDownloaderDelegate> delegate;

+(BOOL)isDownloading;

//初始化
- (id) initWithQArray:(NSArray *)Qarray;

//将QuestionArray中的有用音频去重，并放入AudioBag中
- (void)PutAudiosIntoBag;

//初始化完成后并不立即开始下载，调用此方法后才开始
- (void)DownloadStart;

- (void)ClearDelegateAndCancel;

//队列下载完成后调用此方法，处理委托
- (void) QueueDidFinished:(ASINetworkQueue *)queue;
@end
