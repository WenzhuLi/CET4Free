//
//  SevenLabel.m
//  CET4Lite
//
//  Created by Seven Lee on 12-3-14.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "SevenLabel.h"
#import "RegexKitLite.h"

static UIView * wordBack;
@implementation SevenLabel
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _width = frame.size.width;
        self.numberOfLines = 0;
        self.backgroundColor = [UIColor clearColor];
        self.lineBreakMode = UILineBreakModeWordWrap;
//        self.userInteractionEnabled = YES;
        UITapGestureRecognizer * tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PickTheWord:)];
        self.font = [UIFont systemFontOfSize:17];
        self.backgroundColor = [UIColor clearColor];
        //        tapRec.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapRec];
        
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    _width = self.frame.size.width;
    self.numberOfLines = 0;
}
- (void)setText:(NSString *)text{
    [super setText:text];
    [self FitFrame];
}
- (void)FitFrame{
    if (self.text) {
        CGSize maxSize = CGSizeMake(_width, CGFLOAT_MAX);
        CGSize strSize = [self.text sizeWithFont:self.font constrainedToSize:maxSize lineBreakMode:self.lineBreakMode];
        CGRect newFrame = self.frame;
        newFrame.size.height = strSize.height;
        self.frame = newFrame;
    }  
}
- (void)setNumberOfLines:(NSInteger)numberOfLines{
    if (numberOfLines == 0) {
        [super setNumberOfLines:numberOfLines];
    }
    return;
}
- (void)setLineBreakMode:(UILineBreakMode)lineBreakMode{
    [super setLineBreakMode:UILineBreakModeWordWrap];
    [self FitFrame];
}
- (void)setFont:(UIFont *)font{
    [super setFont:font];
    [self FitFrame];
}

- (void)PickTheWord:(UITapGestureRecognizer *)gesture{
    /*
     一行的高度：int lineHeight = self.font.ascender - self.font.descender +1;
     定位行：int line = ceilf(point.y/(self.font.ascender - self.font.descender +1));
     */
    NSString * WordIFind = nil;
    CGPoint point = [gesture locationInView:self];
    float lineHeight = self.font.ascender - self.font.descender +1;
    int LineStartlocation = 0;
//    int numberoflines = self.frame.size.height / lineHeight;
    int tagetline = ceilf(point.y/lineHeight);
    NSString * sepratorString = @", ，。.?!:\"“”-()'’‘";
//    NSString * text = @"...idowrhu wpe gre dddd.. 'eow.ei, we u";
    NSCharacterSet * sepratorSet = [NSCharacterSet characterSetWithCharactersInString:sepratorString];
    NSArray * splitStr = [self.text componentsSeparatedByCharactersInSet:sepratorSet];
//    NSArray * splitStr = [self.text componentsSeparatedByString:@" "];
    int WordIndex = 0;
    int count = [splitStr count];
    BOOL WordFound = NO;
    NSString * string = @"";
    NSString * string2 = @"";
    CGSize maxSize = CGSizeMake(_width, CGFLOAT_MAX);

    for (int i = 0; i < count && !WordFound; i++) {

        string = [string stringByAppendingString:[NSString stringWithFormat:@"%@.",[splitStr objectAtIndex:i]]];

        NSString * substr = [self.text substringWithRange:NSMakeRange(LineStartlocation, [string length])];
        CGSize mysize = [substr sizeWithFont:self.font constrainedToSize:maxSize lineBreakMode:self.lineBreakMode];

        if (round(mysize.height/lineHeight)  == tagetline && !WordFound) {
            LineStartlocation = [string length] - [[splitStr objectAtIndex:i] length] - 1;
            for (; i < count; i++) {

                string2 = [string2 stringByAppendingString:[NSString stringWithFormat:@"%@.",[splitStr objectAtIndex:i]]];
                NSString * substr2 = nil;
                @try {
                     substr2 = [self.text substringWithRange:NSMakeRange(LineStartlocation, [string2 length])];
                }
                @catch (NSException *exception) {
                    
                    return;
                }


                CGSize thissize = [substr2 sizeWithFont:self.font constrainedToSize:maxSize lineBreakMode:self.lineBreakMode];
                if (thissize.height/lineHeight > 1) {
                    return;
                }

                if (thissize.width > point.x) {
                    
                    WordIndex = i;
                    WordFound = YES;
                    break;
                }
            }
        }
        
    }
    if (WordFound) {
        @try {
            WordIFind = [splitStr objectAtIndex:WordIndex];
            
            CGFloat pointY = (tagetline -1 ) * lineHeight;
            CGFloat width = [[splitStr objectAtIndex:WordIndex] sizeWithFont:self.font].width;
            
            NSRange Range1 = [string2 rangeOfString:[splitStr objectAtIndex:WordIndex] options:NSBackwardsSearch];
            
            
            NSString * str = [string2 substringToIndex:Range1.location];
            int i = 0;
            while ([[str substringToIndex:i] isEqual:@"."]) {
                str = [str substringFromIndex:i+1];
                i++;
                
            }
            CGFloat pointX = [str sizeWithFont:self.font].width;
            //            CGFloat pointX = [substr 
            if (wordBack) {
                [wordBack removeFromSuperview];
                wordBack = nil;
            }
            wordBack = [[UIView alloc] initWithFrame:CGRectMake(pointX, pointY, width, lineHeight)];
            wordBack.backgroundColor = [UIColor colorWithRed:1.0 green:0.651 blue:0.098 alpha:0.5];
            [self insertSubview:wordBack atIndex:0];
            [self GetExplain:WordIFind];
        }
        @catch (NSException *exception) {
            NSLog(@"exception:%@",exception);
            return;
        }
        
    }
}
- (void) GetExplain:(NSString *)wordname{

    if ([delegate respondsToSelector:@selector(SevenLabel:CatchAWord:)]) {
        [delegate SevenLabel:self CatchAWord:wordname];
    }
}
+(void)RemoveBackground{
    if (wordBack) {
        [wordBack removeFromSuperview];
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
