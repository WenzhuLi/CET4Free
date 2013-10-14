//
//  FillingTheBlank.h
//  CET4Lite
//
//  Created by Seven Lee on 12-2-27.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"
#import "CET4Constents.h"


@interface FillingTheBlank : Question{
    NSArray * keywords;             //保存三个关键词
}

@property (nonatomic, strong) NSArray * keywords;

@end
