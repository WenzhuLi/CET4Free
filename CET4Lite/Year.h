//
//  Year.h
//  CET4Lite
//
//  Created by Seven Lee on 12-2-29.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Year : NSObject{
    NSString * text;            //显示的中文string，如@“2011年12月”
    NSInteger intValue;         //对应的int值，如201112
}
@property (nonatomic, strong) NSString * text;
@property (nonatomic, assign) NSInteger intValue;

- (id) initWithText:(NSString *)t andInt:(NSInteger)value;
- (NSString *) myText;
- (NSInteger) myValue;
- (NSComparisonResult)compare:(Year *)year;
@end
