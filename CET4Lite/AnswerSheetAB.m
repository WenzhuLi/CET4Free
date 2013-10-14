//
//  AnswerSheetAB.m
//  CET4Lite
//
//  Created by Seven Lee on 12-3-29.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "AnswerSheetAB.h"

@implementation AnswerSheetAB

@synthesize ChoiceViewArray;

- (id) initWithFrame:(CGRect)frame Questions:(NSArray *)array
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
    CGFloat pointX = 20;
    CGFloat pointY = 0;
    CGFloat scrollwidth = self.SheetScroll.frame.size.width;
    CGFloat littlewidth = 60;
    
    UIImageView * BGimg = [[UIImageView alloc] initWithFrame:CGRectMake(9, 0, SheetScroll.frame.size.width - 9, 420)];
    BGimg.image = [UIImage imageNamed:@"AnswerSheetChoice.png"];
    [self.SheetScroll addSubview:BGimg];
    int count = [QuestionArray count];
    int i = 0;
    ChoiceViewArray = [[NSMutableArray alloc] init];
    for (i = 0; i < count; ) {
        for (int j = 1; j <= 4; j++) {
            if (i < count) {
                ChoiceView * choice = [[ChoiceView alloc] initWithFrame:CGRectMake(pointX, pointY, 0, 0) Question:[QuestionArray objectAtIndex:i]];
                choice.tag = i;
                UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ChoiceViewTapped:)];
                [choice addGestureRecognizer:ges];
                [self.SheetScroll addSubview:choice];
                pointX += littlewidth + 10;
                [ChoiceViewArray addObject:choice];
                i++;
            }
        }
        pointY += 105;
        pointX = 20;
    }
    SheetScroll.contentSize = CGSizeMake(scrollwidth, pointY);
}
- (void)ChoiceViewTapped:(UITapGestureRecognizer *)gesture{
    [delegate AnswerSheet:self QuestionIndexTapped:gesture.view.tag];
}
- (void) setArray:(NSArray *)array{
    self.QuestionArray = array;
    int count = [ChoiceViewArray count];
    for (int i = 0; i < count ; i++) {
        ChoiceView * cv = [ChoiceViewArray objectAtIndex:i];
        [cv setMyQuestion:[QuestionArray objectAtIndex:i]];
    }
}
- (IBAction)HandInAnswerSheet:(UIButton *)sender{
    [sender setTitle:@"已交卷" forState:UIControlStateNormal];
    sender.enabled = NO;
    int count = [ChoiceViewArray count];
    for (int i = 0; i < count ; i++) {
        ChoiceView * choice = [ChoiceViewArray objectAtIndex:i];
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
