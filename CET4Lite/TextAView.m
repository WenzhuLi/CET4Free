//
//  TextAView.m
//  CET4Lite
//
//  Created by Seven Lee on 12-2-29.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "TextAView.h"
#import "TAndSForA.h"

@implementation TextAView

//初始化
- (id)initWithFrame:(CGRect)frame array:(NSMutableArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        TAndSSArray = array;
        CurrentIndex = 0;
        [self drawView];
    }
    return self;
}

//绘图
- (void)drawView{
    
    //几个基本数值
    int count = [TAndSSArray count];
    CGFloat poinY = 0;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    //将所有的label和图片放在ScrollView上,这个Scroll的大小和题目的scroll大小一样
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    LabelArray = [[NSMutableArray alloc] init];
    //向scroll中添加对话
    for (int i = 0; i < count; i++) {
        
        //当前要绘制的对话
        TAndSForA * tsa = [TAndSSArray objectAtIndex:i];
        BoyOrGirlLabelView * bgView = [[BoyOrGirlLabelView alloc] initWithFrame:CGRectMake(0, poinY, width, 0) Sex:tsa.Sex Content:tsa.String];
        bgView.ContentLabel.delegate = self;
        [LabelArray addObject:bgView];
        [scroll addSubview:bgView];
        
        poinY += bgView.frame.size.height + 10;
//        //首先加入区别男女的图片男图为M.jpg,女图为W.jpg
//        UIImageView * img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",tsa.Sex]]];
//        img.frame = CGRectMake(0, poinY, 40, 40);
//        [scroll addSubview:img];
//        
//        //绘制对话内容Label,同样,先计算这句话的行数
//        NSString * str = tsa.String;
//
//        SevenLabel * label = [[SevenLabel alloc] initWithFrame:CGRectMake(50, poinY, width - 60, 0)];
//        label.text = str;
//        label.highlightedTextColor = [UIColor colorWithRed:1 green:0.98 blue:0.44 alpha:1Color];
//        label.delegate = self;
//
//        label.userInteractionEnabled = YES;
//        [scroll addSubview:label];
//        
//        //计算下一句话的Y坐标
//        poinY += label.frame.size.height > img.frame.size.height ? (label.frame.size.height + 5) : (img.frame.size.height + 5);
  
    }
    
    //scroll的内容大小
    scroll.contentSize = CGSizeMake(width, poinY);
    [self addSubview:scroll];
}

- (void)SychroWithTime:(NSTimeInterval)currentTime{
    
//    int index;

    CurrentIndex = [self CalculateIndexWithTime:currentTime];

    //    SevenLabel * 
    [self clearAllHighlight];
    BoyOrGirlLabelView * label = [LabelArray objectAtIndex:CurrentIndex];
    [label setHighlighted : YES];
    CGFloat offX = 0;
    int offY = label.frame.origin.y + label.frame.size.height / 2 - scroll.frame.size.height / 2;
    @try {
        [scroll scrollRectToVisible:CGRectMake(offX, offY, scroll.frame.size.width, scroll.frame.size.height) animated:YES];
    }
    @catch (NSException *exception) {
       
    }
}
-(int)CalculateIndexWithTime:(NSTimeInterval)time{
    
    int count = [TAndSSArray count];
    int i = 0;
    for (; i < count; i++) {
        TimeAndString * ts = [TAndSSArray objectAtIndex:i];
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
    if (CurrentIndex == [TAndSSArray count] - 1) {
        return currentTime;
    }
    else {
        return [[TAndSSArray objectAtIndex:CurrentIndex + 1] Time];
    }
}
- (NSTimeInterval) StartTimeOfCurrentSentence:(NSTimeInterval)currentTime{
    return [[TAndSSArray objectAtIndex:CurrentIndex] Time];
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
