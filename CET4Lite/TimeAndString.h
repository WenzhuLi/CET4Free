//
//  TimeAndString.h
//  CET4Lite
//
//  Created by Seven Lee on 12-2-29.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <Foundation/Foundation.h>

//时间句子类,存放着句子和与其对应的时间
@interface TimeAndString : NSObject{
    NSInteger Time;             //对应时间
    NSString * String;          //句子
}

@property (nonatomic, strong) NSString * String;
@property (nonatomic, assign) NSInteger Time;

//初始化
- (id) initWithTime:(NSInteger)time String:(NSString *)string;
@end
