//
//  AudioDownloader.m
//  CET4Lite
//
//  Created by Seven Lee on 12-3-2.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "AudioDownloader.h"
//#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "UserInfo.h"
#import "SVStoreKit.h"

static BOOL isDownloading;
@implementation AudioDownloader
@synthesize downloadPro;
@synthesize delegate;

+(BOOL)isDownloading{
    return isDownloading;
}
- (id) initWithQArray:(NSArray *)Qarray{
    if (self = [super init]) {
        QuestionArray = [NSArray arrayWithArray:Qarray];
        year = [[QuestionArray objectAtIndex:0] Year];
        requestQueue = nil;
        isDownloading = NO;
        [self PutAudiosIntoBag];
    }
    return self;
}

- (void)PutAudiosIntoBag{
//    AudioBag = [[NSMutableSet alloc] init];
    int count = [QuestionArray count];
    
    //由于QuestionArray中有可能有重复出现的音频（即几个问题共享同一个音频），故先用集合将其去重
    NSMutableSet * bag = [[NSMutableSet alloc] init];
    
    //将QuestionArray中每一个元素的audio、QuestionSound属性加入集合
    for (int i = 0; i < count; i++) {
        Question * q = [QuestionArray objectAtIndex:i];
        [bag addObject:[NSString stringWithFormat:@"%d/%@",q.Year, q.audio]];
        [bag addObject:[NSString stringWithFormat:@"%d/%@",q.Year, q.QuestionSound]];
    }
    
    //再将集合转换为数组，方便操作
    NSEnumerator * AudioEnum = [bag objectEnumerator];
    AudioBag = [AudioEnum allObjects];
}

- (void)DownloadStart{
    int count = [AudioBag count];
    isDownloading = YES;
    //发消息给委托，设置请求个数
    [delegate AudioDownloader:self setNumberOfRequests:count];
    
    //初始化requestQueue
    if (!requestQueue) {
        requestQueue = [[ASINetworkQueue alloc] init];
    }
    //设置下载目的路径，为用户目录，为当前年建一个目录

    NSFileManager * fm = [NSFileManager defaultManager];

    [fm createDirectoryAtPath:[database AudioFileDirectory] withIntermediateDirectories:YES attributes:nil error:nil];

    //为AudioBag中的每一个元素创建一个ASIHTTPRequest，并加入队列，加入之前判断该文件是否存在，若存在，则跳过
    for (int i = 0; i < count; i++) {
        NSString * q = [AudioBag objectAtIndex:i];
        NSString * filePath = [[database AudioFileDirectory] stringByAppendingPathComponent:q];

        NSURL *myURL = [NSURL fileURLWithPath:filePath];
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:myURL options:nil];

        if (![fm fileExistsAtPath:filePath] || !asset.playable) {
            [fm createDirectoryAtPath:[filePath stringByDeletingLastPathComponent] withIntermediateDirectories:NO attributes:nil error:nil];
            BOOL vip = [UserInfo isVIPValid] || [SVStoreKit productPurchased:IAPIDExplain] || [SVStoreKit productPurchased:IAPIDText];
            NSString * http = [NSString stringWithFormat:@"%@%@",vip ? kVIPAudioSuffix : kAudioSuffix, q];
            ASIHTTPRequest * reques = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:http]];
            [reques setTag:i+1];
            [reques setTimeOutSeconds:30];
            [reques setNumberOfTimesToRetryOnTimeout:2];
            [reques setDownloadDestinationPath:filePath];
            [reques setDownloadProgressDelegate:self];
            reques.showAccurateProgress = YES;
            [reques setDelegate:self];
            [reques setDidStartSelector:@selector(requestStarted:)];
            [reques setDidFinishSelector:@selector(requestFinished:)];
            [reques setDidFailSelector:@selector(requestFailed:)];
            [reques setShouldContinueWhenAppEntersBackground:YES];
            [requestQueue addOperation:reques];
        }  
    }
    //若队列为空，即数组中所有要下载的文件都存在，调用QueueDidFinished方法
    if (requestQueue.requestsCount == 0) {
        [self QueueDidFinished:requestQueue];
    }


    else {
        //设置请求队列的一些属性
        requestQueue.shouldCancelAllRequestsOnFailure = YES;
        requestQueue.downloadProgressDelegate = downloadPro;
        [requestQueue setQueueDidFinishSelector:@selector(QueueDidFinished:)];
        requestQueue.showAccurateProgress = YES;
        requestQueue.maxConcurrentOperationCount = 1;
        requestQueue.delegate = self;
        
        //开始下载
        [requestQueue go];
    }
    
}
- (void)ClearDelegateAndCancel{
    [requestQueue reset];
    requestQueue.delegate = nil;
    isDownloading = NO;
}
- (void) QueueDidFinished:(ASINetworkQueue *)queue{
    isDownloading = NO;
    [delegate AudioDownloaderAllFileDownloaded:self];
}
#pragma mark ASIHTTPRequestDelegate
- (void)requestStarted:(ASIHTTPRequest *)request{
    [delegate AudioDownloader:self setCurrentRequestTag:request.tag];
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    [delegate AudioDownloader:self FinishedRequestTag:request.tag];

}
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders{
    NSLog(@"%@",responseHeaders);
    NSString * contentType = [responseHeaders objectForKey:@"Content-Type"];
    if ([contentType compare:@"audio/mpeg" options:NSCaseInsensitiveSearch] != NSOrderedSame) {
        NSLog(@"wrong url : %@",request.url);
        [request cancel];
        NSLog(@"%@  audio/mpeg required!!!!!",request.url);
        NSError * err = [[NSError alloc] initWithDomain:NetworkRequestErrorDomain code:ASIRequestCancelledErrorType userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"对不起，服务器忙，请重试",NSLocalizedDescriptionKey,nil]];
        [delegate AudioDownloader:self FailedRequestTag:request.tag Error:err];
        
        self.delegate = nil;
        
        [requestQueue reset];
    }
    
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"url:%@",request.url);
    NSLog(@"err:%@",request.error);
    [delegate AudioDownloader:self FailedRequestTag:request.tag Error:request.error];
    self.delegate = nil;
    [requestQueue reset];
}
@end
