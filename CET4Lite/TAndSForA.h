//
//  TAndSForA.h
//  CET4Lite
//
//  Created by Seven Lee on 12-2-29.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeAndString.h"

//时间、句子、性别类，继承自TimeAndString，增加了性别
@interface TAndSForA : TimeAndString{
    NSString * Sex;         //性别，W为女，M为男
}
@property (nonatomic, strong) NSString * Sex;

//初始化
- (id) initWithTime:(NSInteger)time String:(NSString *)string Sex:(NSString *)sex;
@end
