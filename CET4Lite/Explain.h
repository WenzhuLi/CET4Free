//
//  Explain.h
//  CET4Lite
//
//  Created by Seven Lee on 12-3-14.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Explain : NSObject{
    NSInteger Number;
    NSInteger Type;
    NSString * Keys;
    NSString * Explains;
    NSString * Knownledge;
}
@property (nonatomic, strong) NSString * Keys;
@property (nonatomic, strong) NSString * Explains;
@property (nonatomic, strong) NSString * Knownledge;
@end
