//
//  TTTAndSForC.h
//  CET4Lite
//
//  Created by Seven Lee on 12-3-1.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeAndString.h"

@interface TTTAndSForC : TimeAndString{
    NSArray * Times;            //时间数组，三个时间
    NSInteger Qwords;           //此句中有几个单词是问题
}
@property (nonatomic, strong) NSArray * Times;
@property (nonatomic, assign) NSInteger Qwords;
- (id)initWithTime:(NSArray *)times String:(NSString *)string;
@end
