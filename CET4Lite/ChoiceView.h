//
//  ChoiceView.h
//  CET4Lite
//
//  Created by Seven Lee on 12-3-29.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"

@interface ChoiceView : UIView{
    UILabel * QuestionNoLabel;
    UILabel * ALabel;
    UILabel * BLabel;
    UILabel * CLabel;
    UILabel * DLabel;
    UIImageView * ChosenBack;
    Question * myQuestion;
}
- (id)initWithFrame:(CGRect)frame Question:(Question *)ques;
- (void)showRightOrWrong;
- (void)setMyQuestion:(Question *)question;
@end
