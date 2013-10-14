//
//  DownloaderView.m
//  CET4Lite
//
//  Created by Seven Lee on 12-3-2.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "DownloaderView.h"
#import "AppDelegate.h"
//#import "YouMiView.h"
#import "SVStoreKit.h"
#import "GADBannerView.h"
#import <QuartzCore/QuartzCore.h>

@implementation DownloaderView
@synthesize Downloader;
@synthesize NumberOfRequests;
@synthesize delegate;


- (id) initWithFrame:(CGRect)frame Array:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        QArray = array;
        NumberOfRequests = 0;
        [self drawView];
    }
    return self;
}
- (void) drawView{
    CGFloat pointX = 0;
    CGFloat pointY = 20;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    
    
    background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Sectionbg.png"]];
    background.frame = self.bounds;
    [self addSubview:background];
    BOOL isPad = [AppDelegate isPad];
    UILabel * cetiyuba = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, isPad ? 400 : 260, isPad ? 50 : 30)];
    cetiyuba.backgroundColor = [UIColor colorWithRed:0.263 green:0.725 blue:0.878 alpha:1.0];
    cetiyuba.textColor = [UIColor whiteColor];
    cetiyuba.center = CGPointMake(width / 2, isPad ? 120 : 30);
    cetiyuba.textAlignment = UITextAlignmentCenter;
    cetiyuba.numberOfLines = 0;
    cetiyuba.font = [UIFont boldSystemFontOfSize:isPad? 35 : 25];
//    cetiyuba.text = isPad? @"爱语吧四六级专题\ncet.iyuba.com\n隆重上线！" : @"cet.iyuba.com\n隆重上线！";
    cetiyuba.text = @"cet.iyuba.com";
    cetiyuba.layer.cornerRadius = 10;
    cetiyuba.layer.masksToBounds = YES;
    cetiyuba.shadowColor = [UIColor darkGrayColor];
    cetiyuba.shadowOffset = CGSizeMake(2, 2);
    [self addSubview:cetiyuba];
    self.backgroundColor = [UIColor clearColor];
    sayings = [[SayingsView alloc] initWithFrame:CGRectMake(20, pointY, isPad? 480 : 280, 150)];
    [sayings setCenter:CGPointMake(width / 2, (height - 70) / 2)];
    [self addSubview:sayings];
    
    UIImage * blackboard = [UIImage imageNamed:@"blackboard"];
    if ([blackboard respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
        blackboard = [blackboard resizableImageWithCapInsets:UIEdgeInsetsMake(151, 231, 45, 90)];
    }
    else
        blackboard = [blackboard stretchableImageWithLeftCapWidth:231 topCapHeight:151];
    UIImageView * blackboardImg = [[UIImageView alloc] initWithImage:blackboard];
    CGRect sayingsFrame = sayings.frame;
    sayingsFrame.origin.x -= 10;
    sayingsFrame.origin.y -= 25;
    sayingsFrame.size.width += 20;
    sayingsFrame.size.height = isPad ? 380 : 250;
    blackboardImg.frame = sayingsFrame;
     [self insertSubview:blackboardImg belowSubview:sayings];
    /*
    if (!([SVStoreKit productPurchased:IAPIDText] || [SVStoreKit productPurchased:IAPIDExplain])) {
        if ([AppDelegate isPad]) {

            YouMiView * yomiView = [[YouMiView alloc] initWithContentSizeIdentifier:YouMiBannerContentSizeIdentifier728x90 delegate:nil];
            yomiView.appID = YOUMI_ID;
            yomiView.appSecret = YOUMI_SEC;
            yomiView.appVersion = YOUMI_APP_VER;
//            CGRect rect = yomiView.frame;
//            rect.origin.x = 0;
//            rect.origin.y = 0;
//            yomiView.frame = rect;
            yomiView.center = CGPointMake(self.center.x, yomiView.size.height / 2);
            [yomiView start];
            [self addSubview:yomiView];

            GADBannerView * adview = [[GADBannerView alloc] initWithAdSize:kGADAdSizeLeaderboard];
            adview.adUnitID = MY_GAD_ID;
            adview.center = CGPointMake(self.center.x, adview.size.height / 2);
            [self addSubview:adview];
            [adview loadRequest:[GADRequest request]];

        }
        else{
            YouMiView * yomiView = [[YouMiView alloc] initWithContentSizeIdentifier:YouMiBannerContentSizeIdentifier320x50 delegate:nil];
            yomiView.appID = YOUMI_ID;
            yomiView.appSecret = YOUMI_SEC;
            yomiView.appVersion = YOUMI_APP_VER;
            CGRect rect = yomiView.frame;
            rect.origin.x = 0;
            rect.origin.y = 0;
            yomiView.frame = rect;
            [yomiView start];
            [self addSubview:yomiView];
            
            GADBannerView * adview = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
            adview.adUnitID = MY_GAD_ID;
            CGRect rect = adview.frame;
            rect.origin.x = 0;
            rect.origin.y = 0;
            adview.frame = rect;
            [self addSubview:adview];
            [adview loadRequest:[GADRequest request]];
             
        }
    }
     */
    pointY = height - 70;
    label = [[UILabel alloc] initWithFrame:CGRectMake(pointX, pointY, width, 30)];
//    pointY += height + 10;
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.text = @"准备下载。。。";
    [self addSubview:label];
    
    progress = [[SevenProgressBar alloc] initWithFrame:CGRectMake( 10 , self.frame.size.height - 30, 300, 19) andbackImg:[UIImage imageNamed:@"ProgressMin.png"] frontimg:[UIImage imageNamed:@"ProgressMax.png"]];
    progress.center = CGPointMake(width / 2, height - 25);
    [progress setProgress:0.0];
    [self addSubview:progress];
//    [sayings StartDisplay];
//    progress = [[UIProgressView alloc] initWithFrame:CGRectMake(pointX, pointY, width, 9)];
//    [progress setProgress:0];
//    [self addSubview:progress];
//    pointY += 20;
//    progressLabel = [[ProgressLabel alloc] initWithFrame:CGRectMake(0, pointY, width, 30)];
//    [progressLabel setProgress:0];
}
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    background.frame = CGRectMake(0, 0, width, height);
    progress.center = CGPointMake(width / 2, height - 25);
    label.center = CGPointMake(width / 2, height - 60);
    sayings.center = CGPointMake(width / 2, (height - 70) / 2);
}
- (void) startDownload{
    [sayings StartDisplay];
    self.Downloader = [[AudioDownloader alloc] initWithQArray:QArray];
    self.Downloader.downloadPro = progress;
    self.Downloader.delegate = self;
    [self.Downloader DownloadStart];
}
- (void)CancelDownload{
    [sayings StopDisplay];
    [sayings removeFromSuperview];
    [Downloader ClearDelegateAndCancel];
    [delegate DowloaderViewCancelled:self];
}
- (void)stopDownload{
    [sayings StopDisplay];
    [Downloader ClearDelegateAndCancel];
}
- (void) AudioDownloader:(AudioDownloader *)adioloader setNumberOfRequests:(NSInteger)number{
    self.NumberOfRequests = number;
}
- (void) AudioDownloader:(AudioDownloader *)adioloader setCurrentRequestTag:(NSInteger)tag{
    label.text = [NSString stringWithFormat:@"正在下载第%d/%d个听力文件",tag,self.NumberOfRequests];
}

- (void) AudioDownloader:(AudioDownloader *)adioloader FinishedRequestTag:(NSInteger)tag;{
    label.text = [NSString stringWithFormat:@"第%d/%d个文件下载完成",tag,self.NumberOfRequests];
}
- (void) AudioDownloader:(AudioDownloader *)adioloader FailedRequestTag:(NSInteger)tag Error:(NSError *)err{
    label.text = [NSString stringWithFormat:@"第%d/%d个文件下载失败",tag,self.NumberOfRequests];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"下载失败" message:[err localizedDescription] delegate:self cancelButtonTitle:@"返回" otherButtonTitles: nil];
    [alert show];
}
- (void) AudioDownloaderAllFileDownloaded:(AudioDownloader *)adioloader{
    label.text = @"下载完成！";
    [sayings StopDisplay];
    [sayings removeFromSuperview];
    [delegate DowloaderViewDidFinishDownload:self];
    [self removeFromSuperview];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [delegate DowloaderViewDidFailedDownload:self];
}
- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
