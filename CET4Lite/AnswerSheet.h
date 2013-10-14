//
//  AnswerSheet.h
//  CET4Lite
//
//  Created by Seven Lee on 12-3-29.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"

@class AnswerSheet;

@protocol AnswerSheetDelegate <NSObject>

- (void) AnswerSheet:(AnswerSheet *) answersheet QuestionIndexTapped:(NSInteger)index;
- (void) AnswerSheetHandedIn:(AnswerSheet *)answersheet;
- (void) AnswerSheetWannaLogin:(AnswerSheet *)answersheet;
//- (void) AnswerSheetWantsToHide:(AnswerSheet *)answersheet;
//- (void) AnswerSheetWantsToDisplay:(AnswerSheet *)answersheet;
@end

@interface AnswerSheet : UIView{
    IBOutlet UIView * ViewFromNib;
    IBOutlet UIScrollView * SheetScroll;
    IBOutlet UIButton * UserNameBtn;
    NSArray * QuestionArray;
    id<AnswerSheetDelegate> delegate;
}
@property (nonatomic, strong) IBOutlet UIView * ViewFromNib;
@property (nonatomic, strong) IBOutlet UIScrollView * SheetScroll;
@property (nonatomic, strong) IBOutlet UIButton * UserNameBtn;
@property (nonatomic, strong) id<AnswerSheetDelegate> delegate;
@property (nonatomic, strong) NSArray * QuestionArray;

- (void) setArray:(NSArray *)array;
- (id) initWithFrame:(CGRect)frame Questions:(NSArray *)array;
- (IBAction)HandInAnswerSheet:(UIButton *)sender;
- (void) setUserName:(NSString * ) user;
- (IBAction)Loggin:(UIButton *)sender;
@end
