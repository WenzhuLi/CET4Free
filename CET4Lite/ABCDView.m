//
//  ABCDView.m
//  CET4Lite
//
//  Created by Seven Lee on 12-3-23.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "ABCDView.h"
#import "AppDelegate.h"
@implementation ABCDView
@synthesize Content;
@synthesize ChoiceName;
//@synthesize delegate;
- (id)initWithFrame:(CGRect)frame ChoiceNo:(NSString *)choiceno Content:(NSString *)content
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.ChoiceName = choiceno;
        self.Content = content;
        [self drawView];
    }
    return self;
}

- (void)drawView{
    SevenLabel * test = [[SevenLabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 30, 0)];
    test.text = @"Test";
    choice = [[SevenLabel alloc] initWithFrame:CGRectMake(30, 0, self.frame.size.width - 40, 0)];
    choice.text = self.Content;
    choice.lineBreakMode = UILineBreakModeWordWrap;
    choice.textColor = [UIColor whiteColor];
    choice.highlightedTextColor = [UIColor colorWithRed:1 green:0.98 blue:0.44 alpha:1];
    abcdLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 30, 20)];
    abcdLabel.text = [NSString stringWithFormat:@"%@、",self.ChoiceName];
    abcdLabel.textColor = [UIColor whiteColor];
    abcdLabel.highlightedTextColor = [UIColor colorWithRed:1 green:0.98 blue:0.44 alpha:1];
    abcdLabel.backgroundColor = [UIColor clearColor];
    if ([AppDelegate isPad]) {
        test.font = [UIFont systemFontOfSize:24];
        choice.font = [UIFont systemFontOfSize:24];
        choice.textColor = [UIColor brownColor];
        choice.frame = CGRectMake(44, 0, choice.frame.size.width, choice.frame.size.height);
        choice.highlightedTextColor = [UIColor orangeColor];
        abcdLabel.font = [UIFont systemFontOfSize:24];
        abcdLabel.textColor = [UIColor brownColor];
        abcdLabel.highlightedTextColor = [UIColor orangeColor];
        abcdLabel.frame = CGRectMake(5, 0, 44, 25);
    }
    CGFloat height = test.frame.size.height * 2;
    
    if (choice.frame.size.height == test.frame.size.height) {
        [choice setCenter:CGPointMake(choice.frame.origin.x + choice.frame.size.width / 2, height / 2)];
        [abcdLabel setCenter:CGPointMake(abcdLabel.frame.size.width / 2 + 5, height / 2)];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
    }
    else {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, choice.frame.size.height);
    }
    UIImageView * background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    background.image = [UIImage imageNamed:@"ABCDBackground.png"];
    [self addSubview:background];
    [self addSubview:abcdLabel];
    [self addSubview:choice];
}
- (void)setHighlighted:(BOOL)highlighted{
    choice.highlighted = highlighted;
    abcdLabel.highlighted = highlighted;
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
