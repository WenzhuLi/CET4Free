//
//  QuestionCView.m
//  CET4Lite
//
//  Created by Seven Lee on 12-3-14.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "QuestionCView.h"

@implementation QuestionCView
@synthesize scrollView;
@synthesize delegate;
@synthesize answerHandler;
@synthesize collectDlegate;
- (id)initWithFrame:(CGRect)frame andQArray:(NSArray *)array
{
    CGFloat pointX = frame.origin.x;
    CGFloat pointY = frame.origin.y;
    NSArray * nibs = [[NSBundle mainBundle] loadNibNamed:@"QuestionCView" owner:self options:nil];
    UIView * myView = [nibs objectAtIndex:0];
    frame = CGRectMake(pointX, pointY, myView.frame.size.width, myView.frame.size.height);
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        NSArray * nibs = [[NSBundle mainBundle] loadNibNamed:@"QuestionCView" owner:self options:nil];
//        [self addSubview:[nibs objectAtIndex:0]];       

        [self addSubview:myView];
        CGFloat centerX = pointX + self.frame.size.width/2;
        CGFloat centerY = pointY + self.frame.size.height/2;
        [self setCenter:CGPointMake(centerX , centerY)];
        QuesArray = array;
        [self drawView];
        currentIndex = 0;
//        [[[AnswerViewArray objectAtIndex:currentIndex] inputField] becomeFirstResponder];
        self.delegate = nil;
        self.collectDlegate = nil;
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
- (id)initWithScroll:(UIScrollView *)scroll andQArray:(NSArray *)array{
    self = [super initWithFrame:scroll.frame];
    if (self) {
        scrollView = scroll;
        QuesArray = array;
        [self drawView];
        currentIndex = 0;
        [[[AnswerViewArray objectAtIndex:currentIndex] inputField] becomeFirstResponder];
        self.delegate = nil;
    }
    return self;
}
-(IBAction)PageChange:(UIButton *)sender{
    [self rollPage:sender.tag];
    
}
- (NSInteger)CurrentIndex{
    return currentIndex;
}
- (void)rollPage:(int)offset{

    CGFloat offx = scrollView.contentOffset.x;
    CGFloat width = scrollView.frame.size.width;
    CGFloat newoffx = offx + offset*width;
    UITextField * preTF = [[AnswerViewArray objectAtIndex:currentIndex] inputField];
    [answerHandler restoreCustomAnswer:preTF.text ofNumber:[[QuesArray objectAtIndex:currentIndex] Number]];

    if (newoffx <0){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"第一题啦" message:@"前面没有题啦～" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (newoffx >= scrollView.contentSize.width){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"最后一题啦" message:@"已经是最后一题啦，点右上角的答题卡交卷吧～" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        return;
    }

    
    [preTF resignFirstResponder];
    
    
    currentIndex = newoffx/width;
    [answerHandler CurrentIndexChanged:currentIndex];
    CGRect newRect = [[AnswerViewArray objectAtIndex:currentIndex] frame];
    [scrollView scrollRectToVisible:newRect animated:YES];
    [[[AnswerViewArray objectAtIndex:currentIndex] inputField] becomeFirstResponder];
}
- (void)rollToIndex:(NSInteger)index{
    CGRect newRect = [[AnswerViewArray objectAtIndex:index] frame];
    [scrollView scrollRectToVisible:newRect animated:YES];
    [[[AnswerViewArray objectAtIndex:index] inputField] becomeFirstResponder];
    currentIndex = index;
}
- (void)drawView{
    CGFloat pointX = 0;
    CGFloat pointY = 0;
    CGFloat width = scrollView.frame.size.width;
    CGFloat height = scrollView.frame.size.height;
    int count = [QuesArray count];
    AnswerViewArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        AnswerCSingleView * single = [[AnswerCSingleView alloc] initWithFrame:CGRectMake(pointX, pointY, width, height) Delegate:self Question:[QuesArray objectAtIndex:i]];
        pointX += width;
        single.inputField.delegate = self;
        single.changeDelegate = self;
        [AnswerViewArray addObject:single];
        [scrollView addSubview:single];
        
    }
    scrollView.contentSize = CGSizeMake(pointX, height);
    scrollView.scrollEnabled = NO;

    [self addSubview:scrollView];
}
- (void)showRightOrWrongAndDisable{
    int count = [AnswerViewArray count];
    scrollView.scrollEnabled = YES;
    for (int i = 0; i < count; i++) {
        AnswerCSingleView * ansc = [AnswerViewArray objectAtIndex:i];
        [ansc showRightOrWrong];
        ansc.inputField.enabled = NO;
    }
}
-(void)PlayCurrentQuestionSound:(UIButton *)sender{
    [delegate PlayCurrentQuestionSound:nil];
}
- (void)AddToFavorite:(UIButton *)sender{
    [collectDlegate AddCurrentQuestionToFav:currentIndex];
}
- (void)QuestionNoChanged:(int)offset{
    [self rollPage:offset];
}
- (void)willDisappear{
    [[[AnswerViewArray objectAtIndex:currentIndex] inputField] resignFirstResponder];
}
- (void)willappear{
    [[[AnswerViewArray objectAtIndex:currentIndex] inputField] becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [answerHandler restoreCustomAnswer:textField.text ofNumber:[[QuesArray objectAtIndex:currentIndex] Number]];
    [answerHandler CurrentIndexChanged:currentIndex];
    if (currentIndex == [QuesArray count] - 1) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"最后一题啦" message:@"已经是最后一题啦，点右上角的答题卡交卷吧～" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
    [self rollPage:1];
    return YES;
}
- (NSString *)CurrentCustomAnswer{
    NSString * str = [[AnswerViewArray objectAtIndex:currentIndex] inputField].text;
    NSLog(@"str:%@",str);
    return str;
}


@end
