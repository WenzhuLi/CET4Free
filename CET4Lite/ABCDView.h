//
//  ABCDView.h
//  CET4Lite
//
//  Created by Seven Lee on 12-3-23.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SevenLabel.h"
//@class ABCDView;
//@protocol ABCDViewDelegate <NSObject>
//
//- (void) ABCDView:(ABCDView *)abcdView isTouched:(UITouch *)touch;
//
//@end
@interface ABCDView : UIView{
    NSString * ChoiceName;
    NSString * Content;
    UILabel * abcdLabel;
    SevenLabel * choice;
//    id<ABCDViewDelegate> delegate;
}
@property (nonatomic, strong) NSString * ChoiceName;
@property (nonatomic, strong) NSString * Content;
//@property (nonatomic, strong) id<ABCDViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame ChoiceNo:(NSString *)choiceno Content:(NSString *)content;

- (void)setHighlighted:(BOOL)highlighted;
@end
