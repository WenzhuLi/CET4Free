//
//  ExplainView.m
//  CET4Lite
//
//  Created by Seven Lee on 12-3-14.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "ExplainView.h"
#import "AppDelegate.h"

@implementation ExplainView

- (id)initWithFrame:(CGRect)frame andExplain:(Explain *)explain
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        myExp = explain;
        [self drawView];
    }
    return self;
}
- (void)drawView{
    
    CGFloat pointX = 0;
    CGFloat pointY = 0;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
//    scrollView.backgroundColor = [UIColor blueColor];
    SevenLabel * keyLabel = [[SevenLabel alloc] initWithFrame:CGRectMake(pointX, pointY, width, 0)];
//    keyLabel.backgroundColor = [UIColor grayColor];
    keyLabel.text = myExp.Keys;
    if ([AppDelegate isPad]) {
        keyLabel.font = [UIFont systemFontOfSize:24];
    }
    keyLabel.textColor = (IS_IOS7 && IS_IPAD) ? [UIColor colorWithRed:0.604 green:0.400 blue:0.176 alpha:1.0] : [UIColor whiteColor];
    [scrollView addSubview:keyLabel];
    pointY += keyLabel.frame.size.height + 10;
    
    SevenLabel * expLabel = [[SevenLabel alloc] initWithFrame:CGRectMake(pointX, pointY, width, 0)];
    expLabel.text = myExp.Explains;
    expLabel.textColor = (IS_IOS7 && IS_IPAD) ? [UIColor colorWithRed:0.604 green:0.400 blue:0.176 alpha:1.0] : [UIColor whiteColor];;
    
    if ([AppDelegate isPad]) {
        expLabel.font = [UIFont systemFontOfSize:24];
    }
    [scrollView addSubview:expLabel];
    pointY += expLabel.frame.size.height + 10;
    
    if (myExp.Knownledge) {
        SevenLabel * knownLabel = [[SevenLabel alloc] initWithFrame:CGRectMake(pointX, pointY, width, 0)];
        knownLabel.text = myExp.Knownledge;
        knownLabel.textColor = (IS_IOS7 && IS_IPAD) ? [UIColor colorWithRed:0.604 green:0.400 blue:0.176 alpha:1.0] : [UIColor whiteColor];
        if ([AppDelegate isPad]) {
            knownLabel.font = [UIFont systemFontOfSize:24];
        }
        [scrollView addSubview:knownLabel];
        pointY += knownLabel.frame.size.height + 10;
    }
    scrollView.contentSize = CGSizeMake(width, pointY);
    [self addSubview:scrollView];
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
