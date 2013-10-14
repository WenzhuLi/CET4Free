//
//  TextView.m
//  CET4Lite
//
//  Created by Seven Lee on 12-3-1.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "TextView.h"

@implementation TextView
@synthesize PlayTimeForC;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        PlayTimeForC = -1;
        WordView = nil;
    }
    return self;
}
- (void)clearAllHighlight{
    //To be overriden
}
- (void)drawView{
    //To be overriden
}
#pragma mark SevenLabelDelegate
- (void)SevenLabel:(SevenLabel *)label CatchAWord:(NSString *)word{
    PLSqliteDatabase * worddata = [database WordsDatabase];
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM Words WHERE Word = \"%@\";",word];
    id<PLResultSet> result = [worddata executeQuery:sql];
    
//    NSString * name = word;
    NSString * defi = @"词义未找到 (°_°)";
    NSString * pron = @"";
    NSString * audio = @"";
    Word * thisword = [[Word alloc] initWithWord:word Pron:pron Def:defi Audio:audio];
    if ([result next]) {//本地词库中查找到
       
        if (![result isNullForColumn:@"Word"]) {
            thisword.Name = [result objectForColumn:@"Word"];
        }
        if (![result isNullForColumn:@"def"]) {
            thisword.Definition = [result objectForColumn:@"def"];
        }
        if (![result isNullForColumn:@"pron"]) {
            pron = [result objectForColumn:@"pron"];
            thisword.Pronunciation = [pron stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        }
        if (![result isNullForColumn:@"audio"]) {
            thisword.Audio = [result objectForColumn:@"audio"];
        }
//        thisword = [[Word alloc] initWithWord:word Pron:pron Def:defi Audio:audio]
        if (WordView) {
            WordView = [WordExplainView ViewWithState:SVWordViewStateDis errMSG:nil word:thisword];
//            [self.superview addSubview:WordView];
            [WordView show];
        }
        else {
            WordView = [WordExplainView ViewWithState:SVWordViewStateDis errMSG:nil word:thisword];
//            [self.superview addSubview:WordView];
            UIWindow * window = [[UIApplication sharedApplication] keyWindow];
            //        [[UIApplication sharedApplication].keyWindow addSubview:view];
            if (!window) 
                window = [[UIApplication sharedApplication].windows objectAtIndex:0];
            [[[window subviews] objectAtIndex:1] addSubview:WordView];
            [WordView show];
        }
        
        return;
    }
    else {//本地词库中没有找到，调用生词API
        thisword = [[Word alloc] initWithWord:word Pron:pron Def:defi Audio:audio];
        thisword.delegate = self;

        if (WordView) {
            WordView = [WordExplainView ViewWithState:SVWordViewStateWaiting errMSG:nil word:thisword];
            //            [self.superview addSubview:WordView];
            [WordView show];
        }
        else {
            WordView = [WordExplainView ViewWithState:SVWordViewStateWaiting errMSG:nil word:thisword];
//            [self.superview addSubview:WordView];
            UIWindow * window = [[UIApplication sharedApplication] keyWindow];
            //        [[UIApplication sharedApplication].keyWindow addSubview:view];
            if (!window) 
                window = [[UIApplication sharedApplication].windows objectAtIndex:0];
            [[[window subviews] objectAtIndex:1] addSubview:WordView];
            [WordView show];
        }

        
//        [self performSelector:@selector(FindWordOnInternet:) withObject:thisword afterDelay:1];
        [thisword FindWordOnInternet:word];
//        if (err) {
//            WordView = [WordExplainView ViewWithState:SVWordViewStateDisFail errMSG:err.domain word:thisword];
//            [WordView show];
//        }
//        else {
//            WordView = [WordExplainView ViewWithState:SVWordViewStateDis errMSG:nil word:thisword];
//            [WordView show];
//        }
    }
}

#pragma mark WordDelegate
- (void)WordFindInternetExpSucceed:(Word*)thisWord {
    if (WordView) {
        WordView = [WordExplainView ViewWithState:SVWordViewStateDis errMSG:nil word:thisWord];
        //            [self.superview addSubview:WordView];
        [WordView show];
    }
    else {
        WordView = [WordExplainView ViewWithState:SVWordViewStateDis errMSG:nil word:thisWord];
        //            [self.superview addSubview:WordView];
        UIWindow * window = [[UIApplication sharedApplication] keyWindow];
        //        [[UIApplication sharedApplication].keyWindow addSubview:view];
        if (!window) 
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        [[[window subviews] objectAtIndex:1] addSubview:WordView];
        [WordView show];
    }
}
- (void)WordFindInternetExpFailed:(Word *)thisWord witError:(NSError *)err{
    if (WordView) {
        WordView = [WordExplainView ViewWithState:SVWordViewStateDisFail errMSG:err.domain word:thisWord];
        //            [self.superview addSubview:WordView];
        [WordView show];
    }
    else {
        WordView = [WordExplainView ViewWithState:SVWordViewStateDisFail errMSG:err.domain word:thisWord];
        //            [self.superview addSubview:WordView];
        UIWindow * window = [[UIApplication sharedApplication] keyWindow];
        //        [[UIApplication sharedApplication].keyWindow addSubview:view];
        if (!window) 
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        [[[window subviews] objectAtIndex:1] addSubview:WordView];
        [WordView show];
    }
}
#pragma mark SychronProtocol
- (void)SychroWithTime:(NSTimeInterval)currentTime{
    //Tobe Overridden
}
- (NSTimeInterval) StartTimeOfNextSentence:(NSTimeInterval)currentTime{
    //Tobe Overridden
    return 0;
}
- (NSTimeInterval) StartTimeOfCurrentSentence:(NSTimeInterval)currentTime{
    //Tobe Overridden
    return 0;
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
