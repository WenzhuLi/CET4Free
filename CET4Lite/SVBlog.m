//
//  SVBlog.m
//  iyuba
//
//  Created by Lee Seven on 12-12-17.
//  Copyright (c) 2012年 Lee Seven. All rights reserved.
//

#import "SVBlog.h"

static NSString * titleKey = @"subject";
static NSString * tagKey = @"tag";
static NSString * privacyKey = @"friend";
static NSString * contentKey = @"message";

#define kBlogIDKey @"blogId"
#define kMessageKey @"message"
#define kSubjectKey @"subject"
#define kViewNumberKey @"viewNumber"
#define kReplyNumberKey @"replyNumber"
#define kDateLineKey @"dateLine"
#define kFavTimesKey @"favTimes"
#define kShareTimesKey @"shareTimes"
#define kIDsKey @"ids"
#define kReadKey @"read"
#define kNoReplyKey @"noReply"
#define kPrivacyKey @"privacy"



@implementation SVBlog
@synthesize blogId = _blogId;
@synthesize message = _message;
@synthesize subject = _subject;
@synthesize viewNumber = _viewNumber;
@synthesize replyNumber = _replyNumber;
@synthesize dateLine = _dateLine;
@synthesize favTimes = _favTimes;
@synthesize shareTimes = _shareTimes;
@synthesize ids = _ids;
@synthesize read = _read;
+ (id)blogWithID:(NSString *)blogid{
    return [[self alloc] initWithID:blogid];
}
- (id)initWithID:(NSString *)blogid{
    self = [super init];
    if (self) {
        self.blogId = [blogid copy];
        self.viewNumber = 0;
        self.replyNumber = 0;
        self.noReply = NO;
        self.privacy = BlogPrivacyNone;
        self.favTimes = 0;
        self.shareTimes = 0;
        self.read = NO;
    }
    return self;
}
- (NSDictionary *)blogDictionary{
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:self.message,contentKey,self.subject,titleKey,[NSNumber numberWithInteger:BlogPrivacyNone],privacyKey,@"",tagKey, nil];
    return dic;
}
- (id)copyWithZone:(NSZone *)zone{
    SVBlog * newCopy = [[SVBlog alloc] initWithID:self.blogId];
    newCopy.viewNumber = self.viewNumber;
    newCopy.message = [self.message copyWithZone:zone];
    newCopy.subject = [self.subject copyWithZone:zone];
    newCopy.replyNumber = self.replyNumber;
    newCopy.dateLine = [self.dateLine copyWithZone:zone];
    newCopy.noReply = self.noReply;
    newCopy.privacy = self.privacy;
    newCopy.favTimes = self.favTimes;
    newCopy.shareTimes = self.shareTimes;
    newCopy.ids = [self.ids copyWithZone:zone];
    newCopy.read = self.read;
    return newCopy;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.blogId = [aDecoder decodeObjectForKey:kBlogIDKey];
        self.message = [aDecoder decodeObjectForKey:kMessageKey];
        self.subject = [aDecoder decodeObjectForKey:kSubjectKey];
        self.viewNumber = [aDecoder decodeIntegerForKey:kViewNumberKey];
        self.replyNumber = [aDecoder decodeIntegerForKey:kReplyNumberKey];
        self.dateLine = [aDecoder decodeObjectForKey:kDateLineKey];
        self.noReply = [aDecoder decodeBoolForKey:kNoReplyKey];
        self.privacy = [aDecoder decodeIntegerForKey:kPrivacyKey];
        self.favTimes = [aDecoder decodeIntegerForKey:kFavTimesKey];
        self.shareTimes = [aDecoder decodeIntegerForKey:kShareTimesKey];
        self.ids = [aDecoder decodeObjectForKey:kIDsKey];
        self.read = [aDecoder decodeBoolForKey:kReadKey];
    }
    
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.blogId forKey:kBlogIDKey];
    [aCoder encodeObject:self.message forKey:kMessageKey];
    [aCoder encodeObject:self.subject forKey:kSubjectKey];
    [aCoder encodeInteger:self.viewNumber forKey:kViewNumberKey];
    [aCoder encodeInteger:self.replyNumber forKey:kReplyNumberKey];
    [aCoder encodeObject:self.dateLine forKey:kDateLineKey];
    [aCoder encodeBool:self.noReply forKey:kNoReplyKey];
    [aCoder encodeInteger:self.privacy forKey:kPrivacyKey];
    [aCoder encodeInteger:self.favTimes forKey:kFavTimesKey];
    [aCoder encodeInteger:self.shareTimes forKey:kShareTimesKey];
    [aCoder encodeObject:self.ids forKey:kIDsKey];
    [aCoder encodeBool:self.read forKey:kReadKey];
}
@end
