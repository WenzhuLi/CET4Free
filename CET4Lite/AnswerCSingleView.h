//
//  AnswerCSingleView.h
//  CET4Lite
//
//  Created by Seven Lee on 12-3-15.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SevenLabel.h"
#import "QuestioinABView.h"
//#import "Question.h"
#import "FillingTheBlank.h"

@protocol AnswerCDelegate <NSObject>

@required
- (void)QuestionNoChanged:(int)offset;
- (void)AddToFavorite:(UIButton *)sender;
@end
@interface AnswerCSingleView : UIView{
    UITextField * inputField;
    UIView * keyboardToolbar;
    IBOutlet UIButton * collectButton;
    UISegmentedControl * nextPreviousControl;
    id<QuestionABViewDelegate> delegate;
    id<AnswerCDelegate> changeDelegate;
    FillingTheBlank * myQ;
    UIButton * collect;
    UIButton * play;
//    UIScrollView * littles;
//    UIView * AnswerView;
}
- (id)initWithFrame:(CGRect)frame Delegate:(id<QuestionABViewDelegate>)dele Question:(FillingTheBlank *)question;
- (id)initWithFrame:(CGRect)frame Delegate:(id<QuestionABViewDelegate>)dele Question:(FillingTheBlank *)question Collection:(BOOL)collect;
- (IBAction)itemPressed:(UIButton *)sender;
- (IBAction)playSound:(UIButton *)sender;
- (IBAction)AddToFavorite:(UIButton *)sender;
- (void) showRightOrWrong;
- (void) fitCollect;
@property (nonatomic, strong) id<QuestionABViewDelegate> delegate;
@property (nonatomic, strong) UITextField * inputField;
@property (nonatomic, strong) IBOutlet UIView * keyboardToolbar;
@property (nonatomic, strong) id<AnswerCDelegate> changeDelegate;
@end
