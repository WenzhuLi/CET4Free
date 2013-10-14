//
//  BoyOrGirlLabelView.m
//  CET4Lite
//
//  Created by Seven Lee on 12-3-23.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "BoyOrGirlLabelView.h"
#import "CET4Constents.h"
#import "AppDelegate.h"
//#define kSpeakBackgroundWidth   238
//#define kSpeakBackgroundHeight  65
//#define kEdgeInsetsTopReal      35
//#define kEdgeInsetsTop          6
//#define kEdgeInsetsBottom       6
//#define kEdgeInsetsLeft         29
//#define kEdgeInsetsRight        6
//#define kMinContentHeight       55
//#define kPictureWidth           40
//#define kPictureHeight          65

@implementation BoyOrGirlLabelView
@synthesize Saying;
@synthesize Sex;
@synthesize ContentLabel;
- (id)initWithFrame:(CGRect)frame Sex:(NSString *)boyorgirl Content:(NSString *)content
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.Sex = boyorgirl;
        self.Saying = content;
        [self drawView];
    }
    return self;
}
- (void)drawView{
    ContentLabel = [[SevenLabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - kPictureWidth - kEdgeInsetsLeft - kEdgeInsetsRight, 0)];
    ContentLabel.userInteractionEnabled = YES;
    ContentLabel.text = self.Saying;
    ContentLabel.textColor = (IS_IOS7 && IS_IPAD) ? [UIColor colorWithRed:0.922 green:0.682 blue:0.357 alpha:1.0] : [UIColor whiteColor];
    ContentLabel.highlightedTextColor = (IS_IOS7 && IS_IPAD) ? [UIColor colorWithRed:0.604 green:0.400 blue:0.176 alpha:1.0] :[UIColor colorWithRed:1 green:0.98 blue:0.44 alpha:1];
//    ContentLabel.textColor = [UIColor whiteColor];
//    ContentLabel.highlightedTextColor = [UIColor colorWithRed:1 green:0.98 blue:0.44 alpha:1];
    if ([AppDelegate isPad]) {
        ContentLabel.font = [UIFont systemFontOfSize:24];
    }
    if ([Sex isEqual:[NSNull null]] || Sex == nil) {
        Sex = @"W";
    }
    @try {
        if ([Sex isEqualToString:@"W"]) {//Girl Speaking
            BoyOrGirlIMG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kPictureWidth, kPictureHeight)];
            BoyOrGirlIMG.image = [UIImage imageNamed:@"girl.png"];
            [self addSubview:BoyOrGirlIMG];
            CGFloat height = ContentLabel.frame.size.height;
            if (height >= kMinContentHeight) {
                ContentBackground = [[UIImageView alloc] initWithFrame:CGRectMake(kPictureWidth, 0, self.frame.size.width - kPictureWidth, height + kEdgeInsetsTop + kEdgeInsetsBottom)];
            }
            else {
                ContentBackground = [[UIImageView alloc] initWithFrame:CGRectMake(kPictureWidth, 0, self.frame.size.width - kPictureWidth, kMinContentHeight + kEdgeInsetsTop + kEdgeInsetsBottom)];
            }
            UIImage * img = [UIImage imageNamed:@"GirlSpeaking.png"];
            UIImage * imgHigh = [UIImage imageNamed:@"GirlSpeakingHigh.png"];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0){
                img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(kEdgeInsetsTopReal, kEdgeInsetsLeft, kEdgeInsetsBottom, kEdgeInsetsRight)];
                imgHigh = [imgHigh resizableImageWithCapInsets:UIEdgeInsetsMake(kEdgeInsetsTopReal, kEdgeInsetsLeft, kEdgeInsetsBottom, kEdgeInsetsRight)];
            }
            else {
                img = [img stretchableImageWithLeftCapWidth:kEdgeInsetsLeft topCapHeight:kEdgeInsetsTopReal];
                imgHigh = [imgHigh stretchableImageWithLeftCapWidth:kEdgeInsetsLeft topCapHeight:kEdgeInsetsTopReal];
            }
            ContentBackground.image = img;
            ContentBackground.highlightedImage = imgHigh;
            //        ContentBackground.image = [[UIImage alloc] resizableImageWithCapInsets:UIEdgeInsetsMake(kEdgeInsetsTop, kEdgeInsetsLeft, kEdgeInsetsBottom, kEdgeInsetsRight)];
            //        ContentBackground.image = [UIImage imageNamed:@"GirlSpeaking.png"];
            [self addSubview:ContentBackground];
            [ContentLabel setCenter:CGPointMake(ContentLabel.frame.size.width / 2 + kPictureWidth + kEdgeInsetsLeft, ContentLabel.frame.size.height / 2 +kEdgeInsetsTop)];
            [self addSubview:ContentLabel];   
        }
        else {//Boy Speaking
            CGFloat height = ContentLabel.frame.size.height;
            if (height >= kMinContentHeight) {
                ContentBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - kPictureWidth, height + kEdgeInsetsTop + kEdgeInsetsBottom)];
            }
            else {
                ContentBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - kPictureWidth, kMinContentHeight + kEdgeInsetsTop + kEdgeInsetsBottom)];
            }
            UIImage * img = [UIImage imageNamed:@"BoySpeaking.png"];
            UIImage * imgHigh = [UIImage imageNamed:@"BoySpeakingHigh.png"];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0){
                img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(kEdgeInsetsTopReal, kEdgeInsetsRight, kEdgeInsetsBottom, kEdgeInsetsLeft)];
                imgHigh = [imgHigh resizableImageWithCapInsets:UIEdgeInsetsMake(kEdgeInsetsTopReal, kEdgeInsetsRight, kEdgeInsetsBottom, kEdgeInsetsLeft)];
            }
            else {
                img = [img stretchableImageWithLeftCapWidth:kEdgeInsetsRight topCapHeight:kEdgeInsetsTopReal];
                imgHigh = [imgHigh stretchableImageWithLeftCapWidth:kEdgeInsetsRight topCapHeight:kEdgeInsetsTopReal];
            }
            ContentBackground.image = img;
            ContentBackground.highlightedImage = imgHigh;
            //        ContentBackground.image = [[UIImage alloc] resizableImageWithCapInsets:UIEdgeInsetsMake(kEdgeInsetsTop, kEdgeInsetsLeft, kEdgeInsetsBottom, kEdgeInsetsRight)];
            //        ContentBackground.image = [UIImage imageNamed:@"BoySpeaking.png"];
            [self addSubview:ContentBackground];
            [ContentLabel setCenter:CGPointMake(ContentLabel.frame.size.width / 2 + kEdgeInsetsRight, ContentLabel.frame.size.height / 2 + kEdgeInsetsTop)];
            [self addSubview:ContentLabel]; 
            BoyOrGirlIMG = [[UIImageView alloc] initWithFrame:CGRectMake(ContentBackground.frame.size.width, 0, kPictureWidth, kPictureHeight)];
            BoyOrGirlIMG.image = [UIImage imageNamed:@"boy.png"];
            [self addSubview:BoyOrGirlIMG];
        }
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, ContentBackground.frame.size.height);
    }
    @catch (NSException *exception) {
    }
    
}
- (void) setHighlighted:(BOOL)highlighted{
    ContentLabel.highlighted = highlighted;
    ContentBackground.highlighted = highlighted;
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
