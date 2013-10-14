//
//  TextBCView.h
//  CET4Lite
//
//  Created by Seven Lee on 12-3-1.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextView.h"
#import "TTTAndSForC.h"

@interface TextBCView : TextView{
    NSMutableArray * TASArray;          //TimeAndString Array
    NSMutableArray * LabelArray;        //LabelArray
    int currentIndex;
//    NSTimeInterval nowTime;
//    NSTimeInterval nextTime;
//    NSInteger PlayTimeForC;             
}
//@property (nonatomic, assign) NSInteger PlayTimeForC;
- (id) initWithFrame:(CGRect)frame array:(NSMutableArray *)array;
@end
