//
//  SVSlideInView.m
//  CET4Lite
//
//  Created by Seven Lee on 12-9-24.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "SVSlideInView.h"

@implementation SVSlideInView
@synthesize theSuperView = _theSuperView;
@synthesize backgroundView = _backgroundView;
@synthesize contentView = _contentView;
@synthesize delegate = _delegate;

- (id) initWithSuperView:(UIView*)_super ContentView:(UIView *)content
{
    self = [super initWithFrame:_super.bounds];
    if (self) {
        // Initialization code
        self.contentView = content;
        self.theSuperView = _super;
        _oriBounds = content.bounds;
        self.backgroundColor = [UIColor clearColor];
        _showCenter = self.center;
//        CGFloat widthMax = self.frame.size.width > self.frame.size.height ? self.frame.size.width : self.frame.size.height;
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 1024)];
        //    background.alpha = 0.5;
        self.backgroundView.backgroundColor = [UIColor blackColor];
//        self.backgroundView.center = self.center;
        self.backgroundView.alpha = 0.0;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmiss:)];
        tap.numberOfTapsRequired = 1;
        [self.backgroundView addGestureRecognizer:tap];
        [self addSubview:self.backgroundView];
        [self addSubview:self.contentView];
//        [self addSubview:self.theSuperView];
    }
    return self;
}
- (void)showWithType:(SVSlideInType) type{
    switch (type) {
        case SVSlideInTypeTop:
            _hideCenter = CGPointMake(self.center.x, 0 - self.contentView.frame.size.height / 2);
            break;
        case SVSlideInTypeBottom:
            _hideCenter = CGPointMake(self.center.x, self.frame.size.height + self.contentView.frame.size.height / 2);
            break;
        case SVSlideInTypeLeft:
            _hideCenter = CGPointMake(0 - self.contentView.frame.size.width / 2, self.center.y);
            break;
        case SVSlideInTypeRight:
            _hideCenter = CGPointMake(self.frame.size.width + self.contentView.frame.size.width / 2, self.center.y);
            break;
            
        default:
            break;
    }
    self.contentView.center = _hideCenter;
    [self.theSuperView addSubview:self];
    [self showAnimation];
}

- (void)setCenter:(CGPoint)center{
    [super setCenter:center];
//    self.backgroundView.frame = CGRectMake(0, 0, self.backgroundView.frame.size.width, self.backgroundView.frame.size.height);
    self.backgroundView.center = center;
    
}
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
//    self.backgroundView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.backgroundView.frame = CGRectMake(0, 0, frame.size.width   , frame.size.height);
//    self.backgroundView.center = CGPointMake(frame.size.width / 2, frame.size.height / 2) ;
    self.contentView.center = self.center;
    self.contentView.bounds = _oriBounds;

}
- (void)showAnimation{
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundView.alpha = 0.5;
        self.contentView.center = self.center;
    }];
//    [UIView beginAnimations:@"show" context:nil];
//    self.backgroundView.alpha = 0.5;
//    self.contentView.center = self.center;
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:1.0];
//    [UIView commitAnimations];
}
- (void) hideAnimation{
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundView.alpha = 0.0;
        self.contentView.center = _hideCenter;
    } completion:^(BOOL finished){
        NSLog(@"animationStopped");
        if ([_delegate respondsToSelector:@selector(SVSlideInViewDidDisapper:)]) {
            [_delegate SVSlideInViewDidDisapper:self];
        }
        [self.backgroundView removeFromSuperview];
        [self.contentView removeFromSuperview];
        [self removeFromSuperview];
    }];
//    [UIView beginAnimations:@"hide" context:nil];
//    self.backgroundView.alpha = 0.0;
//    self.contentView.center = _hideCenter;
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:1.0];
//    [UIView setAnimationDidStopSelector:@selector(animationStopped)];
//    [UIView commitAnimations];
}
- (void)animationStopped{
    NSLog(@"animationStopped");
    if ([_delegate respondsToSelector:@selector(SVSlideInViewDidDisapper:)]) {
        [_delegate SVSlideInViewDidDisapper:self];
    }
    [self.backgroundView removeFromSuperview];
    [self.contentView removeFromSuperview];
    [self removeFromSuperview];
}
- (void)dissmiss:(UIGestureRecognizer *) gest{
    [self hideAnimation];
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
