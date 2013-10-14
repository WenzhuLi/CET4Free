//
//  AudioPlayerView.h
//  CET4Lite
//
//  Created by Seven Lee on 12-3-5.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>


@class AudioPlayerView;
@protocol AudioPlayerViewDelegate <NSObject>

@required
//- (void) AudioPlayerView:(AudioPlayerView *)playerView PlayPauseBtnPressed:(UIButton *)playpauseBtn;
//- (void) AudioPlayerView:(AudioPlayerView *)playerView AudioSliderChanged:(UISlider *)audioSlider;
//- (void) AudioPlayerView:(AudioPlayerView *)playerView BackwardBtnPressed:(UIButton *)backwardBtn;
//- (void) AudioPlayerView:(AudioPlayerView *)playerView ForwardBtnPressed:(UIButton *)forwardBtn;
- (void) AudioPlayerView:(AudioPlayerView *)playerView PlayerDidFinishPlayingSuccessfully:(BOOL)flag;

@end

@protocol SynchroProtocol <NSObject>

@required
- (void)SychroWithTime:(NSTimeInterval)currentTime;
- (NSTimeInterval) StartTimeOfNextSentence:(NSTimeInterval)currentTime;
- (NSTimeInterval) StartTimeOfCurrentSentence:(NSTimeInterval)currentTime;
@end
@interface AudioPlayerView : UIView<AVAudioPlayerDelegate>{
    IBOutlet UIButton * PlayPauseButton;
    IBOutlet UILabel * CurrentTimeLabel;
    IBOutlet UILabel * FilenameLabel;
    IBOutlet UILabel * DurationLabel;
    IBOutlet UISlider * AudioSlider;
    IBOutlet UIButton * BackwardButton;
    IBOutlet UIButton * ForwardButton;
    
    NSString * CurrentAudio;
    NSURL * CurrentURL;
    AVAudioPlayer * AudioPlayer;
    NSTimer								*updateTimer;
	NSTimer								*rewTimer;
	NSTimer								*ffwTimer;
    BOOL    RrfOrNext;              //识别快进和后退按钮是下一首（点击一下，NO）还是快进（长按 YES）
    id<AudioPlayerViewDelegate> delegate;
    id<SynchroProtocol> SynchroID;
}
@property (nonatomic, retain) IBOutlet UILabel * CurrentTimeLabel;
@property (nonatomic, retain) IBOutlet UIButton * PlayPauseButton;
@property (nonatomic, retain) IBOutlet UILabel * DurationLabel;
@property (nonatomic, retain) IBOutlet UILabel * FilenameLabel;
@property (nonatomic, retain) IBOutlet UISlider * AudioSlider;
@property (nonatomic, retain) IBOutlet UIButton * BackwardButton;
@property (nonatomic, retain) IBOutlet UIButton * ForwardButton;
@property (nonatomic, retain) NSString * CurrentAudio;
@property (nonatomic, strong) AVAudioPlayer	*AudioPlayer;
@property (nonatomic, strong) id<SynchroProtocol> SynchroID;
@property (nonatomic, strong) id<AudioPlayerViewDelegate> delegate;

- (void) playAudio:(NSString *)audio URL:(NSString *)url;

- (IBAction)playButtonPressed:(UIButton*)sender;
- (IBAction)rewButtonPressed:(UIButton*)sender;
- (IBAction)rewButtonReleased:(UIButton*)sender;
- (IBAction)ffwButtonPressed:(UIButton*)sender;
- (IBAction)ffwButtonReleased:(UIButton*)sender;
- (IBAction)progressSliderMoved:(UISlider*)sender;
- (IBAction)ffwButtonTouchUPInside:(UIButton *)sender;
- (IBAction)rewButtonTouchUPInside:(UIButton *)sender;
//-(void)pausePlaybackForPlayer:(AVAudioPlayer*)p;
//-(void)startPlaybackForPlayer:(AVAudioPlayer*)p;
//-(void)updateViewForPlayerInfo:(AVAudioPlayer*)p;
//- (void)updateViewForPlayerState:(AVAudioPlayer *)p;
//- (void)updateViewForPlayerState:(AVAudioPlayer *)p;
//- (void)updateCurrentTime;
- (void)start;
- (void)stop;
- (void)pause;
- (BOOL)isPlaying;
- (void)DestroyPlayer;
@end
