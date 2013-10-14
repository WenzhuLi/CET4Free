//
//  SVSlideInView.h
//  CET4Lite
//
//  Created by Seven Lee on 12-9-24.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    SVSlideInTypeLeft,
    SVSlideInTypeRight,
    SVSlideInTypeBottom,
    SVSlideInTypeTop,
}SVSlideInType;
@class SVSlideInView;
@protocol SVSlideInViewDelegate <NSObject>

- (void)SVSlideInViewDidDisapper:(SVSlideInView *)slideInView;
- (void)SVSlideInViewWillDisapper:(SVSlideInView *)slideInView;

@end
@interface SVSlideInView : UIView{
    UIView * _contentView;
    UIView * _backgroundView;
    UIView * _theSuperView;
    SVSlideInType _slideInType;
    CGPoint _hideCenter;
    CGPoint _showCenter;
    CGRect _oriBounds;
    id<SVSlideInViewDelegate> _delegate;
}
@property (nonatomic, strong)UIView * contentView;
@property (nonatomic, strong)UIView * backgroundView;
@property (nonatomic, strong)UIView * theSuperView;
@property (nonatomic, strong)id<SVSlideInViewDelegate> delegate;

- (id) initWithSuperView:(UIView*)_super ContentView:(UIView *)content;
- (void)showWithType:(SVSlideInType) type;
- (void)dissmiss:(UIGestureRecognizer *) gest;
@end
