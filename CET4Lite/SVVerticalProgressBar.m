//
//  SVVerticalProgressBar.m
//  CET4Free
//
//  Created by Lee Seven on 13-9-30.
//  Copyright (c) 2013年 iyuba. All rights reserved.
//

#import "SVVerticalProgressBar.h"

#define kCornerRadius 8
@interface SVVerticalProgressBar ()
@property (nonatomic, strong)UIColor * foregroundColor;
@property (nonatomic, strong)UIView * foregroundView;

@end
@implementation SVVerticalProgressBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self foregroundViewInit];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self foregroundViewInit];
}

- (void)foregroundViewInit{
    if (!self.foregroundView) {
        self.foregroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:self.foregroundView];
        self.foregroundView.layer.cornerRadius = kCornerRadius;
        self.layer.cornerRadius = kCornerRadius;
    }
    
}
- (void)setBackgroundColor:(UIColor *)backgroundColor foregroundColor:(UIColor *)foregroundColor{
    [self foregroundViewInit];
    self.backgroundColor = backgroundColor;
    self.foregroundColor = foregroundColor;
    self.foregroundView.backgroundColor = foregroundColor;
    [self setNeedsDisplay];
}
- (void)setProgress:(float)progress{
    [self foregroundViewInit];
    if (progress > 1) {
        _progress = 1;
    }
    else if (progress < 0){
        _progress = 0;
    }
    else
        _progress = progress;
    [self updateViewWithProgress:progress];
}
- (void)updateViewWithProgress:(float)progress{
    CGRect foreFrame = self.foregroundView.frame;
    foreFrame.size.height = self.frame.size.height * progress;
    foreFrame.origin.y = self.frame.size.height - foreFrame.size.height;
    self.foregroundView.frame = foreFrame;
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
