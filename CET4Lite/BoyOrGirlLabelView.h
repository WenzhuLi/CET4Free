//
//  BoyOrGirlLabelView.h
//  CET4Lite
//
//  Created by Seven Lee on 12-3-23.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SevenLabel.h"

@interface BoyOrGirlLabelView : UIView{
    NSString * Sex;
    NSString * Saying;
    UIImageView * ContentBackground;
    SevenLabel * ContentLabel;
    UIImageView * BoyOrGirlIMG;
}
@property (nonatomic, strong) NSString * Saying;
@property (nonatomic, strong) NSString * Sex;
@property (nonatomic, strong) SevenLabel * ContentLabel;
- (id)initWithFrame:(CGRect)frame Sex:(NSString *)boyorgirl Content:(NSString *)content;
- (void) setHighlighted:(BOOL)highlighted;
@end
