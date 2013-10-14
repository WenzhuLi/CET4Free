//
//  SevenLabel.h
//  CET4Lite
//
//  Created by Seven Lee on 12-3-14.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
//自适应高度的Label
@class SevenLabel;

@protocol SevenLabelDelegate <NSObject>

- (void) SevenLabel:(SevenLabel *) label CatchAWord:(NSString *)word;

@end
@interface SevenLabel : UILabel{
    CGFloat _width;
    id<SevenLabelDelegate> delegate;
//    UIView * wordBack;
}
@property (nonatomic, strong) id<SevenLabelDelegate> delegate;

+(void)RemoveBackground;
@end
