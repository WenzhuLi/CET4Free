//
//  SingleChoice.h
//  CET4Lite
//
//  Created by Seven Lee on 12-2-27.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"

//单选题，继承自Question类

@interface SingleChoice : Question{
    NSMutableArray * ForChoices;            //选项数组，顺序保存A、B、C、D，四个选项

}
@property (nonatomic, strong) NSMutableArray * ForChoices;

@end
