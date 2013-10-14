//
//  Explain.m
//  CET4Lite
//
//  Created by Seven Lee on 12-3-14.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "Explain.h"

@implementation Explain
@synthesize Keys;
@synthesize Explains;
@synthesize Knownledge;

- (id)init{
    self = [super init];
    if (self) {
        self.Knownledge = NULL;
        self.Keys = NULL;
        self.Explains = NULL;
    }
    return self;
}
@end
