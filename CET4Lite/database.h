//
//  database.h
//  CET4Lite
//
//  Created by Seven Lee on 12-2-29.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PlausibleDatabase/PlausibleDatabase.h>
#import "CET4Constents.h"
@interface database : NSObject

+ (PLSqliteDatabase *) CET4database;
+ (PLSqliteDatabase *) WordsDatabase;
+ (PLSqliteDatabase *) UserWordsDatabase;
+ (void)close:(PLSqliteDatabase *)db;
+ (PLSqliteDatabase *) SayingsDatabase;
+ (NSString *) AudioFileDirectory;
+ (NSString *) oldAudioFileDirectory;
+ (NSString *) CETNewsFilePath;
@end
