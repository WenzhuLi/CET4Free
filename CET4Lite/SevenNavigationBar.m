//
//  SevenNavigationBar.m
//  CET4Lite
//
//  Created by Seven Lee on 12-3-23.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "SevenNavigationBar.h"

@implementation SevenNavigationBar

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

- (void)drawRect:(CGRect)rect{
    UIImage *image = [UIImage imageNamed:@"title.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
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
