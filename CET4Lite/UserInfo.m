//
//  UserInfo.m
//  CET4Lite
//
//  Created by Seven Lee on 12-9-25.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "UserInfo.h"
#import "CET4Constents.h"
#import "SDImageCache.h"

@implementation UserInfo
+(BOOL)userLoggedIn{
    NSString * username = [[NSUserDefaults standardUserDefaults] objectForKey:kLoggedUserKey];
    
    if ( username && ![username isEqualToString:@""]) {
        return YES;
    }
    else {
        return NO;
    }
}
+ (NSString *)xdfCoupons10{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kLoggedUserXDFCode10];
}
+ (NSString *)xdfCoupons30{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kLoggedUserXDFCode30];
}
+ (void)setXDFCoupons10:(NSString *)coupon{
    [[NSUserDefaults standardUserDefaults] setObject:coupon forKey:kLoggedUserXDFCode10];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)setXDFCoupons30:(NSString *)coupon{
    [[NSUserDefaults standardUserDefaults] setObject:coupon forKey:kLoggedUserXDFCode30];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)isVIPValid{
    if ([UserInfo isVIP]) {
        NSDate * receiver = [NSDate date];
        NSDate * anotherDate = [NSDate dateWithTimeIntervalSince1970:[UserInfo VIPExpireTime]];
        /*
         The receiver and anotherDate are exactly equal to each other, NSOrderedSame
         The receiver is later in time than anotherDate, NSOrderedDescending
         The receiver is earlier in time than anotherDate, NSOrderedAscending.
         */
        if ([receiver compare:anotherDate] != NSOrderedDescending) {
            return YES;
        }
        else
            return NO;
    }
    else{
        return NO;
    }
}
+ (NSString *)loggedUserAvatarURL{
    NSString * uid = [self loggedUserID];
    if (uid && uid.length > 0) {
        NSString * address = [NSString stringWithFormat:@"http://api.iyuba.com.cn/v2/api.iyuba?protocol=10005&size=big&uid=%@",uid];
        
        NSLog(@"avatar:%@",address);
        return address;
    }
    return nil;
}
+(BOOL)isVIP{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kLoggedUserIsVIP];
}
+(double)VIPExpireTime{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:kLoggedUserVIPTime];
}
+(NSString*)loggedUserName{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kLoggedUserKey];
}
+(NSString*)loggedUserID{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kLoggedUserID];
}
+(void)setLoggedUserName:(NSString *)name{
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:kLoggedUserKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)setLoggedUserID:(NSString *)_id{
    [[NSUserDefaults standardUserDefaults] setObject:_id forKey:kLoggedUserID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)logOut{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kLoggedUserID];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kLoggedUserKey];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLoggedUserIsVIP ];
    [[NSUserDefaults standardUserDefaults] setDouble:0.0 forKey:kLoggedUserVIPTime];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kLoggedUserXDFCode10];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kLoggedUserXDFCode30];
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)setIsVIP:(BOOL)vip{
    [[NSUserDefaults standardUserDefaults] setBool:vip forKey:kLoggedUserIsVIP ];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)setVIPExpireTime:(double)time{
    [[NSUserDefaults standardUserDefaults] setDouble:time forKey:kLoggedUserVIPTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
