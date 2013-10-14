//
//  FillBlankView.h
//  CET4Lite
//
//  Created by Seven Lee on 12-3-30.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SevenLabel.h"
#import "Question.h"

typedef enum {
    FillBlankViewTypeShort,
    FillBlankViewTypeLong,
} FillBlankViewType;

@interface FillBlankView : UIView{
    FillBlankViewType myType;
    UILabel * answer;
    UILabel * Realanswer;
    Question * myQ;
    UILabel * number;
}
- (id)initWithFrame:(CGRect)frame andType:(FillBlankViewType)type question:(Question *)question;
- (void)setMyQuestion:(Question *)question;
- (void)showRightOrWrong;
@end
