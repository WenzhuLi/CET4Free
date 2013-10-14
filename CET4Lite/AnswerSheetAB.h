//
//  AnswerSheetAB.h
//  CET4Lite
//
//  Created by Seven Lee on 12-3-29.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerSheet.h"
#import "ChoiceView.h"

@interface AnswerSheetAB : AnswerSheet{
    NSMutableArray * ChoiceViewArray;
}

@property (nonatomic, strong) NSMutableArray * ChoiceViewArray;


@end
