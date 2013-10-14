//
//  SVBlog.h
//  iyuba
//
//  Created by Lee Seven on 12-12-17.
//  Copyright (c) 2012年 Lee Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    BlogPrivacyNone = 0,        //全站可见
    BlogPrivacyFriends = 1,     //好友可见
    BlogPrivacyIDs = 2,         //指定id可见
    BlogPrivacyPassword = 3     //密码可见
}BlogPrivacy;
@interface SVBlog : NSObject<NSCoding,NSCopying>{
    //日志id
    NSString * _blogId;
    
    //日志内容
    NSString * _message;
    
    //日志标题
    NSString * _subject;
    
    //被查看次数
    NSInteger _viewNumber;
    
    //回复数
    NSInteger _replyNumber;
    
    //发布时间
    NSDate * _dateLine;
    
    //是否允许回复
    BOOL _noReply;
    
    //权限
    BlogPrivacy _privacy;
    
    //被收藏次数
    NSInteger _favTimes;
    
    //被分享次数
    NSInteger _shareTimes;
    
    //指定可见的id
    NSArray * _ids;
    
    //已读
    BOOL _read;
}
@property (nonatomic, strong)NSString * blogId;
@property (nonatomic, strong)NSString * message;
@property (nonatomic, strong)NSString * subject;
@property (nonatomic, assign)NSInteger viewNumber;
@property (nonatomic, assign)NSInteger replyNumber;
@property (nonatomic, strong)NSDate * dateLine;
@property (nonatomic, assign)BOOL noReply;
@property (nonatomic, assign)BlogPrivacy privacy;
@property (nonatomic, assign)NSInteger favTimes;
@property (nonatomic, assign)NSInteger shareTimes;
@property (nonatomic, strong)NSArray * ids;
@property (nonatomic, assign)BOOL read;

+ (id)blogWithID:(NSString *)blogid;
- (id)initWithID:(NSString *)blogid;
- (NSDictionary *)blogDictionary;
@end
