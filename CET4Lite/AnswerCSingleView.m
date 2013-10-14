//
//  AnswerCSingleView.m
//  CET4Lite
//
//  Created by Seven Lee on 12-3-15.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "AnswerCSingleView.h"
#import "AppDelegate.h"

@implementation AnswerCSingleView
@synthesize keyboardToolbar;
@synthesize delegate;
@synthesize inputField;
@synthesize changeDelegate;
- (id)initWithFrame:(CGRect)frame Delegate:(id<QuestionABViewDelegate>)dele Question:(FillingTheBlank *)question
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        myQ = question;
        self.delegate = dele;
        self.backgroundColor = [UIColor clearColor];
        [self drawView];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame Delegate:(id<QuestionABViewDelegate>)dele Question:(FillingTheBlank *)question Collection:(BOOL)_collect{
    if (_collect) {
        self = [super initWithFrame:frame];
        if (self) {
            // Initialization code
            myQ = question;
            self.delegate = dele;
            self.backgroundColor = [UIColor clearColor];
            [self drawCollectView];
        }
        return self;
    }
    else {
        return [self initWithFrame:frame Delegate:dele Question:question];
    }
}
- (void)drawCollectView{
    if ([AppDelegate isPad]) {
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
//        CGFloat pointX = 0;
//        CGFloat pointY = 0;
        UIImageView * bg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cards.png"]];
        bg.frame = CGRectMake(0, 0, width, height);
        [self addSubview:bg];
        SevenLabel * QLabel = [[SevenLabel alloc] initWithFrame:CGRectMake(5, 5, width - 10, 0)];
        QLabel.backgroundColor = [UIColor clearColor];
        QLabel.text = myQ.question;
        QLabel.textColor = [UIColor whiteColor];
        QLabel.font = [UIFont systemFontOfSize:24];
        [self addSubview:QLabel];
        
        self.inputField = [[UITextField alloc] initWithFrame:CGRectMake(5, QLabel.frame.origin.y + QLabel.frame.size.height + 10, width - 10, 30)];
        self.inputField.backgroundColor = [UIColor clearColor];
        self.inputField.textColor = [UIColor whiteColor];
        self.inputField.autocorrectionType = UITextAutocorrectionTypeNo;
        //    self.inputField.background = [UIImage imageNamed:@"TextInputBG.png"];
        self.inputField.borderStyle = UITextBorderStyleRoundedRect;
        self.inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.inputField.placeholder = @"Please type your answer here";
        self.inputField.keyboardType = UIKeyboardTypeAlphabet;
        self.inputField.returnKeyType = UIReturnKeyDone;
        self.inputField.autocapitalizationType = UITextAutocapitalizationTypeNone;
//        self.inputField.delegate = self;
        if (myQ.YourAnswer) {
            inputField.text = myQ.YourAnswer;
        }
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.inputField];
        play = [UIButton buttonWithType:UIButtonTypeCustom];
        play.frame = CGRectMake(0, 0, 39, 29);
        [play setCenter:CGPointMake(self.frame.size.width / 3, self.inputField.frame.origin.y + self.inputField.size.height + 30)];
        [play setImage:[UIImage imageNamed:@"LoudSpeaker.png"] forState:UIControlStateNormal];
        [play addTarget:self action:@selector(playSound:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:play];
        
        collect = [UIButton buttonWithType:UIButtonTypeCustom];
        collect.frame = CGRectMake(0, 0, 36, 34);
        [collect setCenter:CGPointMake(self.frame.size.width / 3 * 2, self.inputField.frame.origin.y + self.inputField.size.height + 30)];
        [collect setImage:[UIImage imageNamed:@"DECollect.png"] forState:UIControlStateNormal];
        [collect addTarget:self action:@selector(AddToFavorite:) forControlEvents:UIControlEventTouchUpInside];
//        collect.tag = myQ.Number;
        [self addSubview:collect];
        
    }
    else{
        CGFloat width = self.frame.size.width;
        SevenLabel * QLabel = [[SevenLabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
        QLabel.backgroundColor = [UIColor clearColor];
        QLabel.text = myQ.question;
        QLabel.textColor = [UIColor whiteColor];
        
        self.inputField = [[UITextField alloc] initWithFrame:CGRectMake(0, 110, width, 30)];
        self.inputField.backgroundColor = [UIColor clearColor];
        self.inputField.autocorrectionType = UITextAutocorrectionTypeNo;
        //    self.inputField.background = [UIImage imageNamed:@"TextInputBG.png"];
        self.inputField.borderStyle = UITextBorderStyleRoundedRect;
        self.inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.inputField.placeholder = @"Please type your answer here";
        self.inputField.keyboardType = UIKeyboardTypeAlphabet;
        self.inputField.returnKeyType = UIReturnKeyNext;
        self.inputField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        if (myQ.YourAnswer) {
            inputField.text = myQ.YourAnswer;
        }
        self.backgroundColor = [UIColor clearColor];
        
            UIScrollView * littles = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 5, width, 100)];
            littles.backgroundColor = [UIColor clearColor];
            [littles addSubview:QLabel];
            littles.contentSize = QLabel.frame.size;
            //        QLabel.textAlignment = UITextAlignmentCenter;
            //    [self addSubview:QLabel];
            [self addSubview:littles];
            if (self.inputField.inputAccessoryView == nil) {
                [[NSBundle mainBundle] loadNibNamed:@"keyboardToolBarView" owner:self options:nil];
                // Loading the AccessoryView nib file sets the accessoryView outlet.
                self.inputField.inputAccessoryView = keyboardToolbar;
                collectButton.selected = YES;
                // After setting the accessory view for the text view, we no longer need a reference to the accessory view.
                self.keyboardToolbar = nil;
            }
            [self addSubview:self.inputField];
            UIButton * next = [UIButton buttonWithType:UIButtonTypeCustom];
            [next setImage:[UIImage imageNamed:@"nextQues.png"] forState:UIControlStateNormal];
            next.frame = CGRectMake(self.frame.size.width - 40, self.inputField.frame.origin.y + self.inputField.frame.size.height + 10, 40, 30);
            next.tag = 1;
            [next addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:next];
            
            UIButton * pre = [UIButton buttonWithType:UIButtonTypeCustom];
            [pre setImage:[UIImage imageNamed:@"lastQues.png"] forState:UIControlStateNormal];
            pre.frame = CGRectMake(2, self.inputField.frame.origin.y + self.inputField.frame.size.height + 10, 40, 30);
            pre.tag = -1;
            [pre addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:pre];
            
            play = [UIButton buttonWithType:UIButtonTypeCustom];
            play.frame = CGRectMake(0, 0, 39, 29);
            [play setCenter:CGPointMake(self.frame.size.width / 3, pre.center.y)];
            [play setImage:[UIImage imageNamed:@"LoudSpeaker.png"] forState:UIControlStateNormal];
            [play addTarget:self action:@selector(playSound:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:play];
            
            collect = [UIButton buttonWithType:UIButtonTypeCustom];
            collect.frame = CGRectMake(0, 0, 36, 34);
            [collect setCenter:CGPointMake(self.frame.size.width / 3 * 2, pre.center.y)];
            [collect setImage:[UIImage imageNamed:@"DECollect.png"] forState:UIControlStateNormal];
            [collect addTarget:self action:@selector(AddToFavorite:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:collect];
    }
    
    
    //    [sounbtn addTarget:self action:@selector(QuestionSoundPressed) forControlEvents:UIControlEventTouchUpInside];
    //    [self addSubview:sounbtn];
    
    
    
    //    CGFloat maxheight = QLabel.frame.size.height > 30 ? QLabel.frame.size.height + 10 : 40;
    

    
    //        [input becomeFirstResponder];
    
    
}
- (void)drawView{
//    UIButton * sounbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    sounbtn.frame = CGRectMake(0, 0, 30, 30);
    CGFloat width = self.frame.size.width;
//    [sounbtn addTarget:self action:@selector(QuestionSoundPressed) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:sounbtn];
    UIScrollView * littles = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, IS_IPHONE_5 ? 125 : 50)];
    littles.backgroundColor = [UIColor clearColor];
    
    SevenLabel * QLabel = [[SevenLabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    QLabel.backgroundColor = [UIColor clearColor];
    QLabel.text = myQ.question;
    QLabel.textColor = [UIColor whiteColor];
    [littles addSubview:QLabel];
    littles.contentSize = QLabel.frame.size;
    //        QLabel.textAlignment = UITextAlignmentCenter;
//    [self addSubview:QLabel];
    [self addSubview:littles];
    self.backgroundColor = [UIColor clearColor];
//    CGFloat maxheight = QLabel.frame.size.height > 30 ? QLabel.frame.size.height + 10 : 40;
    self.inputField = [[UITextField alloc] initWithFrame:CGRectMake(0, littles.frame.origin.y + littles.frame.size.height + 5, width, 30)];
    self.inputField.backgroundColor = [UIColor clearColor];
    self.inputField.autocorrectionType = UITextAutocorrectionTypeNo;
//    self.inputField.background = [UIImage imageNamed:@"TextInputBG.png"];
    self.inputField.borderStyle = UITextBorderStyleRoundedRect;
    self.inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.inputField.placeholder = @"Please type your answer here";
    self.inputField.keyboardType = UIKeyboardTypeAlphabet;
    self.inputField.returnKeyType = UIReturnKeyNext;
    self.inputField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    if (myQ.YourAnswer) {
        inputField.text = myQ.YourAnswer;
    }
    if (self.inputField.inputAccessoryView == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"keyboardToolBarView" owner:self options:nil];
        // Loading the AccessoryView nib file sets the accessoryView outlet.
        self.inputField.inputAccessoryView = keyboardToolbar;    
        // After setting the accessory view for the text view, we no longer need a reference to the accessory view.
        self.keyboardToolbar = nil;
    }
    //        [input becomeFirstResponder];
    [self addSubview:self.inputField];
    
    UIButton * next = [UIButton buttonWithType:UIButtonTypeCustom];
    [next setImage:[UIImage imageNamed:@"nextQues.png"] forState:UIControlStateNormal];
    next.frame = CGRectMake(self.frame.size.width - 40, self.inputField.frame.origin.y + self.inputField.frame.size.height + 10, 40, 30);
    next.tag = 1;
    [next addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:next];
    
    UIButton * pre = [UIButton buttonWithType:UIButtonTypeCustom];
    [pre setImage:[UIImage imageNamed:@"lastQues.png"] forState:UIControlStateNormal];
    pre.frame = CGRectMake(2, self.inputField.frame.origin.y + self.inputField.frame.size.height + 10, 40, 30);
    pre.tag = -1;
    [pre addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:pre];
    
    play = [UIButton buttonWithType:UIButtonTypeCustom];
    play.frame = CGRectMake(0, 0, 39, 29);
    [play setCenter:CGPointMake(self.frame.size.width / 3, pre.center.y)];
    [play setImage:[UIImage imageNamed:@"LoudSpeaker.png"] forState:UIControlStateNormal];
    [play addTarget:self action:@selector(playSound:) forControlEvents:UIControlEventTouchUpInside];
//    play.tag = myQ.Number;
    [self addSubview:play];
    
    collect = [UIButton buttonWithType:UIButtonTypeCustom];
    collect.frame = CGRectMake(0, 0, 36, 34);
//    collect.tag = myQ.Number;
    [collect setCenter:CGPointMake(self.frame.size.width / 3 * 2, pre.center.y)];
    [collect setImage:[UIImage imageNamed:@"CollectAB.png"] forState:UIControlStateNormal];
    [collect addTarget:self action:@selector(AddToFavorite:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:collect];
}
- (void)setTag:(NSInteger)tag{
    [super setTag:tag];
    self.inputField.tag = tag;
    collect.tag = tag;
    play.tag = tag;
}
- (IBAction)playSound:(UIButton *)sender{
    if ([AppDelegate isPad]) {
        [delegate PlayCurrentQuestionSound:sender];
    }
    else
        [delegate PlayCurrentQuestionSound:nil];

}
- (IBAction)AddToFavorite:(UIButton *)sender{
    if ([AppDelegate isPad]) {
        [changeDelegate AddToFavorite:sender];
    }
    else
        [changeDelegate AddToFavorite:nil];

}
- (IBAction)itemPressed:(UIBarItem *)sender{
    [changeDelegate QuestionNoChanged:sender.tag];
}
- (void) fitCollect{
    
}
- (void) showRightOrWrong{
    [self.inputField resignFirstResponder];
    
    for (UIView * sub in self.subviews) {
        if (sub.tag == 99) {
            [sub removeFromSuperview];
        }
    }
    UIScrollView * scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(10, self.inputField.frame.origin.y + self.inputField.frame.size.height + 50, self.inputField.frame.size.width - 20, self.frame.size.height - 150)];
//    UIScrollView * scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 150, self.inputField.frame.size.width - 20, 100)];
    scroll.tag = 99;
//    scroll.backgroundColor = [UIColor blueColor];
    SevenLabel * yourans = [[SevenLabel alloc] initWithFrame:CGRectMake(0, 0, scroll.frame.size.width, 0)];
    NSString * customString = self.inputField.text;
    if ([customString isEqual:[NSNull null]]) {
        customString = @"";
    }
    yourans.text = [NSString stringWithFormat:@"您的答案：%@",customString];
    myQ.YourAnswer = inputField.text;
    yourans.tag = 99;
    yourans.textColor = [UIColor whiteColor];
    [scroll addSubview:yourans];
    
    SevenLabel * rightans = [[SevenLabel alloc] initWithFrame:CGRectMake(0, yourans.frame.size.height + 10, scroll.frame.size.width, 0)];
    rightans.tag = 99;
    rightans.text = [NSString stringWithFormat:@"正确答案：%@",myQ.answer];
    rightans.textColor = [UIColor whiteColor];
    [scroll addSubview:rightans];
    
    NSString * imgName = nil;
    if ([myQ GiveMeTheScore] == 1) 
        imgName = @"RightTick.png";
    else 
        imgName = @"WrongX.png";
    UIImageView * RorW = [[UIImageView alloc] initWithFrame:CGRectMake(70, 5, 16, 14)];
    RorW.image = [UIImage imageNamed:imgName];
    RorW.tag = 99;
    [scroll addSubview:RorW];
    if (myQ.keywords && ![[myQ.keywords objectAtIndex:0] isEqualToString:@""]) {
        SevenLabel * keys = [[SevenLabel alloc] initWithFrame:CGRectMake(0, rightans.frame.origin.y + rightans.frame.size.height + 10, scroll.frame.size.width, 0)];
        keys.tag = 99;
        keys.text = [NSString stringWithFormat:@"关键词：%@、%@、%@",[myQ.keywords objectAtIndex:0],[myQ.keywords objectAtIndex:1],[myQ.keywords objectAtIndex:2]];
        keys.textColor = [UIColor whiteColor];
        [scroll addSubview:keys];
        NSLog(@"keyFram:(%.0f,%.0f,%.0f,%.0f);scrollFrame: (%.0f,%.0f,%.0f,%.0f);",keys.frame.origin.x,keys.frame.origin.y,keys.frame.size.width,keys.frame.size.height,scroll.frame.origin.x,scroll.frame.origin.y,scroll.frame.size.width,scroll.frame.size.height);
        scroll.contentSize = CGSizeMake(scroll.frame.size.width, keys.frame.origin.y + keys.frame.size.height +10);
        NSLog(@"contentSize:%.0f,%0.f",scroll.contentSize.width,scroll.contentSize.height);
    }
    else {
        scroll.contentSize = CGSizeMake(scroll.frame.size.width, rightans.frame.origin.y + rightans.frame.size.height +10);
    }
    [self addSubview:scroll];
}
//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [textField resignFirstResponder];
//    [self showRightOrWrong];
//    return YES;
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
