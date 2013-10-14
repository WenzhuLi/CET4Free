//
//  AnswerSheet.m
//  CET4Lite
//
//  Created by Seven Lee on 12-3-29.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "AnswerSheet.h"
#import "LoginViewController.h"
@implementation AnswerSheet
@synthesize ViewFromNib;
@synthesize SheetScroll;
@synthesize delegate;
@synthesize QuestionArray;
@synthesize UserNameBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:@"AnswerSheetView" owner:self options:nil];
        [self addSubview:self.ViewFromNib];
    }
    return self;
}

- (void) setUserName:(NSString * ) user{
    if ([user isEqualToString:@""]) {
        [self.UserNameBtn setTitle:@"尚未登录" forState:UIControlStateNormal];
        self.UserNameBtn.enabled = YES;
    }
    
    else {
        [self.UserNameBtn setTitle:user forState:UIControlStateDisabled];
        self.UserNameBtn.enabled = NO;
    }
}
- (IBAction)Loggin:(UIButton *)sender{
    [self.delegate AnswerSheetWannaLogin:self];
}
- (void) setArray:(NSArray *)array{
    //to be overriden
}
- (id) initWithFrame:(CGRect)frame Questions:(NSArray *)array{
    //to be overriden
    return nil;
}
- (IBAction)HandInAnswerSheet:(UIButton *)sender{
    //to be overriden
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
