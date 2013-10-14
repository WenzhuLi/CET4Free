//
//  SayingsView.h
//  CET4Lite
//
//  Created by Seven Lee on 12-4-25.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SevenLabel.h"

@interface SayingsView : UIView{
    SevenLabel * EnglishLabel;
    SevenLabel * ChineseLabel;
    NSTimer * timer;
}
@property (nonatomic, strong) SevenLabel * EnglishLabel;
@property (nonatomic, strong) SevenLabel * ChineseLabel;

- (void) StartDisplay;
- (void) StopDisplay;
@end
