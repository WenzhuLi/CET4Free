//
//  FillBlankView.m
//  CET4Lite
//
//  Created by Seven Lee on 12-3-30.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "FillBlankView.h"

@implementation FillBlankView

- (id)initWithFrame:(CGRect)frame andType:(FillBlankViewType)type question:(Question *)question
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        myType = type;
        myQ = question;
        [self drawView];
    }
    return self;
}
- (void)drawView{
    
    number = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 21)];
    number.text = [NSString stringWithFormat:@"%d.",myQ.Number];
    number.backgroundColor = [UIColor clearColor];
    [self addSubview:number];
    
    if (myType == FillBlankViewTypeShort) {
//        answer = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, self.frame.size.width - 30, 21)];
        answer = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, self.frame.size.width - 30, 21)];
        answer.text = myQ.YourAnswer;
        answer.backgroundColor = [UIColor clearColor];
        answer.adjustsFontSizeToFitWidth = YES;
        answer.minimumFontSize = 10.0;
        [self addSubview:answer];
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(answer.frame.origin.x, answer.frame.origin.y +answer.frame.size.height - 1, answer.frame.size.width, 1)];
        line.backgroundColor = [UIColor brownColor];
        [self addSubview:line];
        Realanswer = [[UILabel alloc] initWithFrame:CGRectMake(30, answer.frame.size.height + 5, answer.frame.size.width, 21)];
        Realanswer.textColor = [UIColor redColor];
        Realanswer.text = myQ.answer;
        Realanswer.hidden = YES;
        Realanswer.adjustsFontSizeToFitWidth = YES;
        Realanswer.minimumFontSize = 10.0;
        Realanswer.backgroundColor = [UIColor clearColor];
        [self addSubview:Realanswer];
    }
    else {
        answer = [[SevenLabel alloc] initWithFrame:CGRectMake(30, 0, self.frame.size.width - 30, 0)];
        answer.text = myQ.YourAnswer;
        answer.backgroundColor = [UIColor clearColor];
        [self addSubview:answer];
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(answer.frame.origin.x, answer.frame.origin.y + 20, answer.frame.size.width, 1)];
        line.backgroundColor = [UIColor brownColor];
        [self addSubview:line];
        UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(answer.frame.origin.x, answer.frame.origin.y + 40, answer.frame.size.width, 1)];
        line2.backgroundColor = [UIColor brownColor];
        [self addSubview:line2];
        UIView * line3 = [[UIView alloc] initWithFrame:CGRectMake(answer.frame.origin.x, answer.frame.origin.y + 60, answer.frame.size.width, 1)];
        line3.backgroundColor = [UIColor brownColor];
        [self addSubview:line3];
        Realanswer = [[SevenLabel alloc] initWithFrame:CGRectMake(30, line3.frame.origin.y + 2, answer.frame.size.width, 21)];
        Realanswer.textColor = [UIColor redColor];
        Realanswer.text = myQ.answer;
        Realanswer.hidden = YES;
        Realanswer.backgroundColor = [UIColor colorWithRed:0.98 green:0.913 blue:0.859 alpha:1];
        [self addSubview:Realanswer];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, Realanswer.frame.origin.y + Realanswer.frame.size.height);
    }
}
- (void)setMyQuestion:(Question *)question{
    myQ = question;
    answer.text = question.YourAnswer;
}

- (void)showRightOrWrong{
    Realanswer.hidden = NO;
    if ([myQ GiveMeTheScore] == 1) {
        UIImageView * Righttick = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightTick.png"]];
        Righttick.frame = CGRectMake(0, 0, 16, 14);
        Righttick.backgroundColor = [UIColor clearColor];
        Righttick.tag = 99;
        [Righttick setCenter:number.center];
        [self addSubview:Righttick];
    }
    else {
        UIImageView * WrongX = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WrongX.png"]];
        WrongX.frame = CGRectMake(0, 0, 16, 14);
        WrongX.backgroundColor = [UIColor clearColor];
        WrongX.tag = 99;
        [WrongX setCenter:number.center];
        [self addSubview:WrongX];
    }
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
