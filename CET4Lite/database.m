//
//  database.m
//  CET4Lite
//
//  Created by Seven Lee on 12-2-29.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "database.h"

static PLSqliteDatabase * CET4Pointer;
static PLSqliteDatabase * WordsPointer;
static PLSqliteDatabase * UserWordsPointer;
static PLSqliteDatabase * SayingsPointer;
@implementation database

+ (PLSqliteDatabase *) CET4database{
    //返回指向CET4.sqlite数据库的指针
    
    if (CET4Pointer) {
        return CET4Pointer;
    }
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"CET4" ofType:@"sqlite"];
    CET4Pointer = [[PLSqliteDatabase alloc] initWithPath:sourcePath];
    if ([CET4Pointer open]) {
    }
    return CET4Pointer;
}

+ (PLSqliteDatabase *) WordsDatabase{
    if (WordsPointer) {
        return WordsPointer;
    }
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"WORDS" ofType:@"sqlite"];
    WordsPointer = [[PLSqliteDatabase alloc] initWithPath:sourcePath];
    if ([WordsPointer open]) {
        
    }
    return WordsPointer;
}
+ (PLSqliteDatabase *) SayingsDatabase{
    if (SayingsPointer) {
        return SayingsPointer;
    }
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"Sayings" ofType:@"sqlite"];
    SayingsPointer = [[PLSqliteDatabase alloc] initWithPath:sourcePath];
    if ([SayingsPointer open]) {
        
    }
    return SayingsPointer;
}
+ (PLSqliteDatabase *) UserWordsDatabase{
    if (UserWordsPointer) {
        return UserWordsPointer;
    }
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *realPath = [documentPath stringByAppendingPathComponent:@"UserWords.sqlite"];
	
	NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"UserCollection" ofType:@"sqlite"];

	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:realPath]) {
		NSError *error;

		if (![fileManager copyItemAtPath:sourcePath toPath:realPath error:&error]) {
			  
		}
	}
	

    UserWordsPointer = [[PLSqliteDatabase alloc] initWithPath:realPath];
    if ([UserWordsPointer open]) {
        
    }
    return UserWordsPointer;
}
+ (void)close:(PLSqliteDatabase *)db{
    if (db) {
        [db close];
        db = NULL;
    }
}
+ (NSString *) AudioFileDirectory{
    NSString * dir = [DOCUMENTS_FOLDER stringByAppendingPathComponent:@"Audios"];
    return dir;
}
+ (NSString *) oldAudioFileDirectory{
    NSString * dir = [CACHES_FOLDER stringByAppendingPathComponent:@"Audios"];
    return dir;
}
+ (NSString *) CETNewsFilePath{
    NSString * path = [CACHES_FOLDER stringByAppendingPathComponent:@"news"];
    return path;
}
@end
