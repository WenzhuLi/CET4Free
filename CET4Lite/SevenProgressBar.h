//
//  SevenProgressBar.h
//  FinalTest
//
//  Created by Seven Lee on 12-1-31.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIProgressDelegate.h"

@interface SevenProgressBar : UIView<ASIProgressDelegate>{
    UIImageView * backImg;
    UIImageView * frontImg;
}
-(void)setProgress:(float)progress;
-(id)initWithFrame:(CGRect)frame andbackImg:(UIImage*)img frontimg:(UIImage *)fimg;
@end
