//
//  SayingsView.m
//  CET4Lite
//
//  Created by Seven Lee on 12-4-25.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "SayingsView.h"
#import "database.h"
#import "AppDelegate.h"

@implementation SayingsView
@synthesize EnglishLabel;
@synthesize ChineseLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self drawView];
    }
    return self;
}
- (void)drawView{
    CGFloat PonitX = 20;
    CGFloat PointY = 0;
    CGFloat width = self.frame.size.width - 40;
    CGFloat height = self.frame.size.height;
    
    self.EnglishLabel = [[SevenLabel alloc] initWithFrame:CGRectMake(PonitX, PointY, width, 0)];
    PointY = height / 2;
    EnglishLabel.textColor = [UIColor whiteColor];
    EnglishLabel.shadowColor = [UIColor grayColor];
    EnglishLabel.shadowOffset = CGSizeMake(1, 1);
    if ([AppDelegate isPad]) {
        EnglishLabel.font = [UIFont systemFontOfSize:32];
    }
    [self addSubview:EnglishLabel];
    self.ChineseLabel = [[SevenLabel alloc] initWithFrame:CGRectMake(PonitX, PointY, width, 0)];
    ChineseLabel.textColor = [UIColor whiteColor];
    ChineseLabel.shadowColor = [UIColor grayColor];
    ChineseLabel.shadowOffset = CGSizeMake(1, 1);
    if ([AppDelegate isPad]) {
        ChineseLabel.font = [UIFont systemFontOfSize:24];
    }
    [self addSubview:ChineseLabel];
}
- (void)ChangeSayings{
    NSInteger SayingID = arc4random() % 185 + 1;
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM sayings WHERE id = %d",SayingID];
    PLSqliteDatabase * sayingDB = [database SayingsDatabase];
    id<PLResultSet> result = [sayingDB executeQuery:sql];
    NSString * en = nil;
    NSString * ch = nil;
    if ([result next]) {
        en = [result objectForColumn:@"English"];
        ch = [result objectForColumn:@"Chinese"];
    }

    
    [UIView beginAnimations:@"ChangeSaying" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.7];
    self.EnglishLabel.alpha = 0;
    self.ChineseLabel.alpha = 0;
    [UIView commitAnimations];
    
    self.EnglishLabel.text = en;
    self.ChineseLabel.text = ch;
    CGRect chFrame = self.ChineseLabel.frame;
    self.ChineseLabel.frame = CGRectMake(chFrame.origin.x, EnglishLabel.frame.origin.y + EnglishLabel.frame.size.height + 20, chFrame.size.width, chFrame.size.height);
    
    [UIView beginAnimations:@"ChangeSaying" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.7];
    self.EnglishLabel.alpha = 1;
    self.ChineseLabel.alpha = 1;
    [UIView commitAnimations];
}
- (void) StartDisplay{
    [self ChangeSayings];
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(ChangeSayings) userInfo:nil repeats:YES];
}
- (void) StopDisplay{
    if (timer) {
        [timer invalidate];
        timer = nil;
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
