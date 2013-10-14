//
//  TextBCView.m
//  CET4Lite
//
//  Created by Seven Lee on 12-3-1.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "TextBCView.h"
#import "TimeAndString.h"
#import "AppDelegate.h"

@implementation TextBCView
//@synthesize PlayTimeForC;
- (id) initWithFrame:(CGRect)frame array:(NSMutableArray *)array;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        TASArray = array;
        currentIndex = 0;
        [self drawView];
//        PlayTimeForC = -1;
    }
    return self;
}

- (void)drawView{
    
    //几个基本数值
    int count = [TASArray count];
    CGFloat poinY = 0;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    //将所有的label和图片放在ScrollView上,这个Scroll的大小和题目的scroll大小一样
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    LabelArray = [[NSMutableArray alloc] init];
    //向scroll中添加对话
    for (int i = 0; i < count; i++) {
        
        //当前要绘制的对话
        TimeAndString * tas = [TASArray objectAtIndex:i];

        //绘制对话内容Label,同样,先计算这句话的行数
        NSString * str = tas.String;
//        CGSize strSize = [str sizeWithFont:[UIFont systemFontOfSize:18]];
//        int lines = strSize.width/(width - 60) + 1;
        SevenLabel * label = [[SevenLabel alloc] initWithFrame:CGRectMake(10, poinY, width - 20, 0)];
        label.text = str;
        label.textColor = (IS_IOS7 && IS_IPAD) ? [UIColor colorWithRed:0.922 green:0.682 blue:0.357 alpha:1.0] : [UIColor whiteColor];
        label.highlightedTextColor = (IS_IOS7 && IS_IPAD) ? [UIColor colorWithRed:0.604 green:0.400 blue:0.176 alpha:1.0] :[UIColor colorWithRed:1 green:0.98 blue:0.44 alpha:1];
        label.userInteractionEnabled = YES;
        label.delegate = self;
        if ([AppDelegate isPad]) {
            label.font = [UIFont systemFontOfSize:24];
        }
//        label.lineBreakMode = UILineBreakModeWordWrap;
//        label.numberOfLines = lines;
//        label.backgroundColor = [UIColor clearColor];
        [LabelArray addObject:label];
        [scroll addSubview:label];
        
        //计算下一句话的Y坐标
//        poinY += lines > 2 ? 20*lines + 10 : 40;
        poinY += label.frame.size.height + 5;
        
    }
    
    //scroll的内容大小
    scroll.contentSize = CGSizeMake(width, poinY);
    [self addSubview:scroll];
}

-(void)SychroWithTime:(NSTimeInterval)currentTime{
    //TODO
//    if (currentTime > nowTime && currentTime < nextTime) {
//        return;
//    }
//    int index;
    if (PlayTimeForC < 0) {//SectionB
        currentIndex = [self CalculateIndexWithTime:currentTime];
    }
    else {//SectionC
        currentIndex = [self CalculateSeciontCIndexWithTime:currentTime];
    }

    [self clearAllHighlight];
    SevenLabel * label = [LabelArray objectAtIndex:currentIndex];
    [label setHighlighted : YES];
    CGFloat offX = 0;
    int offY = label.frame.origin.y + label.frame.size.height / 2 - scroll.frame.size.height / 2;
    @try {
        [scroll scrollRectToVisible:CGRectMake(offX, offY, scroll.frame.size.width, scroll.frame.size.height) animated:YES];
    }
    @catch (NSException *exception) {
        
    }

}
- (int)CalculateSeciontCIndexWithTime:(NSTimeInterval)time{
    int count = [TASArray count];
    int i = 0;
    for (; i < count; i++) {
        TTTAndSForC * ttts = [TASArray objectAtIndex:i];
        if (time < [[ttts.Times objectAtIndex:PlayTimeForC] intValue]) {
            return i == 0 ? 0 : i - 1;
        }
    }
    return i-1;
}
-(int)CalculateIndexWithTime:(NSTimeInterval)time{
    
    int count = [TASArray count];
    int i = 0;
    for (; i < count; i++) {
        TimeAndString * ts = [TASArray objectAtIndex:i];
        if (time < ts.Time) {
            return i == 0 ? 0 : i - 1;
        }
    }
    return i-1;
}
- (void)clearAllHighlight{
    int count = [LabelArray count];
    for (int i = 0; i < count; i++) {
        [[LabelArray objectAtIndex:i] setHighlighted:NO];
    }
}
- (NSTimeInterval) StartTimeOfNextSentence:(NSTimeInterval)currentTime{
    if (currentIndex == [TASArray count] - 1) {
        return currentTime;
    }
    else {
        if (PlayTimeForC < 0) {//sectionB
            return [[TASArray objectAtIndex:currentIndex + 1] Time];
        }
        else {//sectionC
             TTTAndSForC * ttts = [TASArray objectAtIndex:currentIndex + 1];
            return [[ttts.Times objectAtIndex:PlayTimeForC] intValue];
        }
    }
    
}
- (NSTimeInterval) StartTimeOfCurrentSentence:(NSTimeInterval)currentTime{
    if (PlayTimeForC < 0) {//sectionB
        return [[TASArray objectAtIndex:currentIndex] Time];
    }
    else {//sectionC
        TTTAndSForC * ttts = [TASArray objectAtIndex:currentIndex];
        return [[ttts.Times objectAtIndex:PlayTimeForC] intValue];
    }
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
