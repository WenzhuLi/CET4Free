//
//  ChoiceView.m
//  CET4Lite
//
//  Created by Seven Lee on 12-3-29.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "ChoiceView.h"

@implementation ChoiceView

- (id)initWithFrame:(CGRect)frame Question:(Question *)ques
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 60, 100)];
    if (self) {
        // Initialization code
        myQuestion = ques;
        [self drawView];
    }
    return self;
}
- (void)drawView{
    CGFloat pointX = 0;
    CGFloat pointY = 0;
    CGFloat width = 35;
    CGFloat height = 20;
    QuestionNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(pointX, pointY, 25, 20)];
    QuestionNoLabel.text = [NSString stringWithFormat:@"%d.",myQuestion.Number];
    QuestionNoLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:QuestionNoLabel];
    pointX += 25;
    ALabel = [[UILabel alloc] initWithFrame:CGRectMake(pointX, pointY, width, height)];
    ALabel.text = @"[ A ]";
    ALabel.backgroundColor = [UIColor clearColor];
//    ALabel.textAlignment = UITextAlignmentCenter;
    [self addSubview:ALabel];
    pointY += height + 5;
    BLabel = [[UILabel alloc] initWithFrame:CGRectMake(pointX, pointY, width, height)];
    BLabel.text = @"[ B ]";
    BLabel.backgroundColor = [UIColor clearColor];
//    BLabel.textAlignment = UITextAlignmentCenter;
    [self addSubview:BLabel];
    pointY += height + 5;
    CLabel = [[UILabel alloc] initWithFrame:CGRectMake(pointX, pointY, width, height)];
    CLabel.text = @"[ C ]";
    CLabel.backgroundColor = [UIColor clearColor];
//    CLabel.textAlignment = UITextAlignmentCenter;
    [self addSubview:CLabel];
    pointY += height + 5;
    DLabel = [[UILabel alloc] initWithFrame:CGRectMake(pointX, pointY, width, height)];
    DLabel.text = @"[ D ]";
    DLabel.backgroundColor = [UIColor clearColor];
//    DLabel.textAlignment = UITextAlignmentCenter;
    [self addSubview:DLabel];
    
    ChosenBack = nil;
    
    if (myQuestion.YourAnswer) {
        [self ChangeChoice];
    }
}
- (UILabel *) LabelOfAnswer:(NSString *)answer{
    if ([answer isEqualToString:@"A"]) 
        return ALabel;
    else 
        if ([answer isEqualToString:@"B"]) 
            return BLabel;
        else
            if ([answer isEqualToString:@"C"]) 
                return CLabel;
            else 
                if ([answer isEqualToString:@"D"]) 
                    return DLabel;
    return nil;
}
- (void)showRightOrWrong{
    for (UIImageView * img in self.subviews) {
        if (img.tag == 99)
            [img removeFromSuperview];
    }
    UIImageView * Righttick = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightTick.png"]];
    Righttick.frame = CGRectMake(0, 0, 16, 14);
    Righttick.backgroundColor = [UIColor clearColor];
    Righttick.tag = 99;
    [Righttick setCenter:[self LabelOfAnswer:myQuestion.answer].center];
    [self addSubview:Righttick];
    if (myQuestion.YourAnswer) {
        if ([myQuestion GiveMeTheScore] == 1) {
            return;
        }
        UIImageView * WrongX = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WrongX.png"]];
        WrongX.frame = CGRectMake(0, 0, 16, 14);
        WrongX.tag = 99;
        WrongX.backgroundColor = [UIColor clearColor];
        [WrongX setCenter:[self LabelOfAnswer:myQuestion.YourAnswer].center];
        [self addSubview:WrongX];
    }
    
}
- (void)setMyQuestion:(Question *)question{
    myQuestion = question;
    [self ChangeChoice];
}
- (void)ChangeChoice{
    UILabel * label = [self LabelOfAnswer:myQuestion.YourAnswer];
    @try {
        if (ChosenBack == nil) {
            ChosenBack = [[UIImageView alloc] initWithFrame:label.frame];
            ChosenBack.backgroundColor = [UIColor colorWithRed:0.157 green:0.0706 blue:0.0 alpha:0.95];
//            ChosenBack.alpha = 0.8;
            [self addSubview:ChosenBack];
        }
        else {
            ChosenBack.frame = label.frame;
        }
        
    }
    @catch (NSException *exception) {
        
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
