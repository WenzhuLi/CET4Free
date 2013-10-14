//
//  AudioPlayerView.m
//  CET4Lite
//
//  Created by Seven Lee on 12-3-5.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "AudioPlayerView.h"
#import "CET4Constents.h"
// amount to skip on rewind or fast forward
#define SKIP_TIME 2.0			
// amount to play between skips
#define SKIP_INTERVAL .2

//static AVAudioPlayer * AudioPlayer;
//static AudioPlayerView * audioPlayerView;

@implementation AudioPlayerView
@synthesize SynchroID;
@synthesize PlayPauseButton;
@synthesize CurrentTimeLabel;
@synthesize delegate;
@synthesize DurationLabel;
@synthesize BackwardButton;
@synthesize ForwardButton;
@synthesize AudioSlider;
@synthesize FilenameLabel;
@synthesize CurrentAudio;
@synthesize AudioPlayer;

//要实现单子模式试试
void RouteChangeListener(	void *                  inClientData,
                         AudioSessionPropertyID	inID,
                         UInt32                  inDataSize,
                         const void *            inData);

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        // Initialization code
        NSArray * nibs = [[NSBundle mainBundle] loadNibNamed:@"AudioPlayerView" owner:self options:nil];
        [self addSubview:[nibs objectAtIndex:0]];       
  //      [self drawView];
        [AudioSlider setMaximumTrackImage:[UIImage imageNamed:@"SliderMin.png"] forState:UIControlStateNormal];
        [AudioSlider setMinimumTrackImage:[UIImage imageNamed:@"SliderMax.png"] forState:UIControlStateNormal];
        [AudioSlider setThumbImage:[UIImage imageNamed:@"Thumb.png"] forState:UIControlStateNormal];
        CGFloat pointX = frame.origin.x;
        CGFloat pointY = frame.origin.y;
        CGFloat centerX = pointX + self.frame.size.width/2;
        CGFloat centerY = pointY + self.frame.size.height/2;
        [self setCenter:CGPointMake(centerX , centerY)];
        DurationLabel.adjustsFontSizeToFitWidth = YES;
        CurrentTimeLabel.adjustsFontSizeToFitWidth = YES;
        self.CurrentAudio = nil;
        AudioPlayer = nil;
        updateTimer = nil;
        rewTimer = nil;
        ffwTimer = nil;
        RrfOrNext = NO;
        OSStatus result = AudioSessionInitialize(NULL, NULL, NULL, NULL);
        
        [[AVAudioSession sharedInstance] setDelegate: self];
        NSError *setCategoryError = nil;
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &setCategoryError];
        
        result = AudioSessionAddPropertyListener (kAudioSessionProperty_AudioRouteChange, RouteChangeListener,(__bridge void *)((__bridge AudioPlayerView*)objc_unretainedPointer(self)));
       
    }
    return self;
}

void RouteChangeListener(	void *                  inClientData,
                         AudioSessionPropertyID	inID,
                         UInt32                  inDataSize,
                         const void *            inData)
{
	AudioPlayerView* This = (__bridge AudioPlayerView *)inClientData;
	
	if (inID == kAudioSessionProperty_AudioRouteChange) {
		
		CFDictionaryRef routeDict = (CFDictionaryRef)inData;
		NSNumber* reasonValue = (__bridge NSNumber*)CFDictionaryGetValue(routeDict, CFSTR(kAudioSession_AudioRouteChangeKey_Reason));
		
		int reason = [reasonValue intValue];
        
		if (reason == kAudioSessionRouteChangeReason_OldDeviceUnavailable) {
            
			[This pause];
		}
	}
}

- (void) playAudio:(NSString *)audio URL:(NSString *)url{
    CurrentURL = [[NSURL alloc] initFileURLWithPath:url];
    self.CurrentAudio = [NSString stringWithString:audio];
    if (AudioPlayer) {
        [self stop];
    }
    NSError * err;
    AudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:CurrentURL error:&err];	
	if (AudioPlayer)
	{
        NSString * filename = [[[AudioPlayer.url relativePath] lastPathComponent] stringByDeletingPathExtension];
        if ([[filename substringToIndex:1] isEqualToString:@"C"]) {
            self.FilenameLabel.text = [NSString stringWithFormat:@"第%@遍", [filename substringWithRange:NSMakeRange(1, 1)]];
        }
        else {
            self.FilenameLabel.text = [NSString stringWithFormat:@"第%@题", filename];
        }
		
		[self updateViewForPlayerInfo:AudioPlayer];
		[self updateViewForPlayerState:AudioPlayer];
		AudioPlayer.numberOfLoops = 0;
		AudioPlayer.delegate = self;
	}
    
    
//    [AudioPlayer play];
}

-(void)updateViewForPlayerInfo:(AVAudioPlayer*)p
{
	self.DurationLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)p.duration / 60, (int)p.duration % 60, nil];
	self.AudioSlider.maximumValue = p.duration;
}

- (void)updateViewForPlayerState:(AVAudioPlayer *)p
{
	[self updateCurrentTimeForPlayer:p];
	if (updateTimer) 
		[updateTimer invalidate];
    
    [self.PlayPauseButton setSelected:((p.playing == YES) ? YES : NO)];
	if (p.playing)
	{
		
		updateTimer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(updateCurrentTime) userInfo:p repeats:YES];
	}
	else
	{
		[self.PlayPauseButton setSelected:((p.playing == YES) ? YES : NO)];
		updateTimer = nil;
	}
	
}

- (IBAction)playButtonPressed:(UIButton *)sender
{
	if (AudioPlayer.playing == YES)
		[self pausePlaybackForPlayer:AudioPlayer];
	else
		[self startPlaybackForPlayer:AudioPlayer];
}

-(void)updateCurrentTimeForPlayer:(AVAudioPlayer *)p
{
	self.CurrentTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)p.currentTime / 60, (int)p.currentTime % 60, nil];
	self.AudioSlider.value = p.currentTime;
    [SynchroID SychroWithTime:p.currentTime];
}
- (void)updateCurrentTime
{
	[self updateCurrentTimeForPlayer:AudioPlayer];
}

- (void)rewind
{
    RrfOrNext = YES;
	AVAudioPlayer *p = rewTimer.userInfo;
	p.currentTime-= SKIP_TIME;
	[self updateCurrentTimeForPlayer:p];
}

- (void)ffwd
{
    RrfOrNext = YES;
	AVAudioPlayer *p = ffwTimer.userInfo;
	p.currentTime+= SKIP_TIME;	
	[self updateCurrentTimeForPlayer:p];
}
- (IBAction)rewButtonPressed:(UIButton *)sender
{
	if (rewTimer) [rewTimer invalidate];
	rewTimer = [NSTimer scheduledTimerWithTimeInterval:SKIP_INTERVAL target:self selector:@selector(rewind) userInfo:AudioPlayer repeats:YES];
}

- (IBAction)ffwButtonTouchUPInside:(UIButton *)sender{
    
    if (RrfOrNext) {
        RrfOrNext = NO;
        return;
    }
    else {
        AudioPlayer.currentTime = [SynchroID StartTimeOfNextSentence:AudioPlayer.currentTime];
        [self updateCurrentTimeForPlayer:AudioPlayer];
    }
}

- (IBAction)rewButtonTouchUPInside:(UIButton *)sender{
    if (RrfOrNext) {
        RrfOrNext = NO;
        return;
    }
    else {
        AudioPlayer.currentTime = [SynchroID StartTimeOfCurrentSentence:AudioPlayer.currentTime];
        [self updateCurrentTimeForPlayer:AudioPlayer];
    }
}

- (IBAction)rewButtonReleased:(UIButton *)sender
{
	if (rewTimer) [rewTimer invalidate];
	rewTimer = nil;
}

- (IBAction)ffwButtonPressed:(UIButton *)sender
{
	if (ffwTimer) [ffwTimer invalidate];
	ffwTimer = [NSTimer scheduledTimerWithTimeInterval:SKIP_INTERVAL target:self selector:@selector(ffwd) userInfo:AudioPlayer repeats:YES];
}

- (IBAction)ffwButtonReleased:(UIButton *)sender
{
	if (ffwTimer) [ffwTimer invalidate];
	ffwTimer = nil;
}



- (IBAction)progressSliderMoved:(UISlider *)sender
{
	AudioPlayer.currentTime = sender.value;
	[self updateCurrentTimeForPlayer:AudioPlayer];
}

-(void)pausePlaybackForPlayer:(AVAudioPlayer*)p
{
	[p pause];
	[self updateViewForPlayerState:p];
}

-(void)startPlaybackForPlayer:(AVAudioPlayer*)p
{
//    AudioSessionSetActive(YES);
	if ([AudioPlayer play])
	{
		[self updateViewForPlayerState:p];
	}
	else
		FilenameLabel.text = @"音频错误";
}


//- (void)dealloc
//{
//	[FilenameLabel release];
//	[PlayPauseButton release];
//	[ForwardButton release];
//	[BackwardButton release];
//	[AudioSlider release];
//	[CurrentTimeLabel release];
//	[DurationLabel release];
//	
//	[updateTimer release];
//	[AudioPlayer release];
//    [super dealloc];
//	
//}
- (void)start{
    AudioSessionSetActive(YES);
    [self startPlaybackForPlayer:AudioPlayer];
}
- (void)stop{
    AudioSessionSetActive(NO);
    [self DestroyPlayer];
}
- (void)pause{
    [self pausePlaybackForPlayer:AudioPlayer];
}
- (BOOL)isPlaying{
    return [AudioPlayer isPlaying];
}
#pragma mark AVAudioPlayer delegate methods

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)p successfully:(BOOL)flag
{
    
	[p setCurrentTime:0.];
	[self updateViewForPlayerState:p];
    [updateTimer invalidate];
    updateTimer = nil;
    [delegate AudioPlayerView:self PlayerDidFinishPlayingSuccessfully:flag];
}

- (void)playerDecodeErrorDidOccur:(AVAudioPlayer *)p error:(NSError *)error
{
	FilenameLabel.text = @"音频错误";
}

// we will only get these notifications if playback was interrupted
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)p
{
	// the object has already been paused,	we just need to update UI
    [self updateViewForPlayerState:p];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)p
{
	[self startPlaybackForPlayer:p];
}
- (void)DestroyPlayer{
    if (AudioPlayer) {
        [self.AudioPlayer stop];
    }
    self.AudioPlayer = nil;
}
//- (void) drawView{
//    
//}
//- (id)init{
//    
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
