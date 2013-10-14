//
//  TextAView.h
//  CET4Lite
//
//  Created by Seven Lee on 12-2-29.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAndSForA.h"
#import "TextView.h"
#import "BoyOrGirlLabelView.h"

//单个textA的原文View，男女对话
@interface TextAView : TextView{
    NSMutableArray * TAndSSArray;       //TAndSForA数组,根据这个数组来绘图
    NSMutableArray * LabelArray;
    NSInteger CurrentIndex;
}

//初始化
- (id)initWithFrame:(CGRect)frame array:(NSMutableArray *)array;

@end
