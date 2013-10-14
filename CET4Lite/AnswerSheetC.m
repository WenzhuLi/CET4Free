//
//  AnswerSheetC.m
//  CET4Lite
//
//  Created by Seven Lee on 12-3-29.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "AnswerSheetC.h"
#import "SevenLabel.h"

@implementation AnswerSheetC

- (id)initWithFrame:(CGRect)frame Questions:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.QuestionArray = array;
        [self drawView];
    }
    return self;
}
- (void)drawView{
    CGFloat pointX = 10;
    CGFloat pointY = -40;
    BlanksArray = [[NSMutableArray alloc] init];
    for (int i = 36; i <= 43; i++) {
        if (i % 2 == 0) {
            pointX = 10;
            pointY += 45;
            
        }
        else {
            pointX = 165;
        }
        FillBlankView * fbv = [[FillBlankView alloc] initWithFrame:CGRectMake(pointX, pointY, 120, 50) andType:FillBlankViewTypeShort question:[QuestionArray objectAtIndex:i - 36]];
        fbv.tag = i - 36;
        UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ChoiceViewTapped:)];
        [fbv addGestureRecognizer:ges];
        [SheetScroll addSubview:fbv];
        [BlanksArray addObject:fbv];
    }
    pointY += 60;
    pointX = 10;
    for (int i = 44; i <= 46; i++) {
        FillBlankView * fbv = [[FillBlankView alloc] initWithFrame:CGRectMake(pointX, pointY, 270, 65) andType:FillBlankViewTypeLong question:[QuestionArray objectAtIndex:i - 36]];
        fbv.tag = i - 36;
        UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ChoiceViewTapped:)];
        [fbv addGestureRecognizer:ges];
        [SheetScroll addSubview:fbv];
        [BlanksArray addObject:fbv];
        pointY += fbv.frame.size.height + 5;
    }
    SheetScroll.contentSize = CGSizeMake(SheetScroll.frame.size.width, pointY);
}
- (void) setArray:(NSArray *)array{
    self.QuestionArray = array;
    int count = [BlanksArray count];
    for (int i = 0; i < count ; i++) {
        FillBlankView * fbv = [BlanksArray objectAtIndex:i];
        Question * ques = [self.QuestionArray objectAtIndex:i];
        [fbv setMyQuestion:ques];
    }
}
- (void)ChoiceViewTapped:(UITapGestureRecognizer *)gesture{
    [delegate AnswerSheet:self QuestionIndexTapped:gesture.view.tag];
}
- (IBAction)HandInAnswerSheet:(UIButton *)sender{
    [sender setTitle:@"已交卷" forState:UIControlStateNormal];
    sender.enabled = NO;
    int count = [QuestionArray count];
    for (int i = 0; i < count ; i++) {
        FillBlankView * choice = [BlanksArray objectAtIndex:i];
        [choice showRightOrWrong];
    }
    [delegate AnswerSheetHandedIn:self];
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
