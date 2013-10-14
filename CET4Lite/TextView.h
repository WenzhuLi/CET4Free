//
//  TextView.h
//  CET4Lite
//
//  Created by Seven Lee on 12-3-1.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SevenLabel.h"
#import "AudioPlayerView.h"
#import "database.h"
#import "WordExplainView.h"


@interface TextView : UIView<SynchroProtocol,SevenLabelDelegate,WordDelegate>{
    UIScrollView * scroll;
    NSInteger PlayTimeForC;     //若是SectionC时，表示现在读的是第几遍，从0开始
    WordExplainView * WordView;
}
@property (nonatomic, assign) NSInteger PlayTimeForC;
- (void)drawView;
- (void)clearAllHighlight;
@end
