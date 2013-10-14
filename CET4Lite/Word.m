//
//  Word.m
//  CET4Lite
//
//  Created by Seven Lee on 12-3-19.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "Word.h"
#import "Sentence.h"
#import "RegexKitLite.h"
#define IyubaWordApi @"http://word.iyuba.com/words/apiWord.jsp?q="

static ASIHTTPRequest * httpRequest;

@implementation Word
@synthesize Definition;
@synthesize Pronunciation;
@synthesize Name;
@synthesize Audio;
@synthesize delegate;
@synthesize SentencesArray = _SentencesArray;

- (id) initWithWord:(NSString *)word Pron:(NSString *)pron Def:(NSString *)def Audio:(NSString *)audio{
    if (self = [super init]) {
        self.Definition = def;
        self.Name = word;
        self.Pronunciation = pron;
        self.Audio = audio;
        self.delegate = nil;
        WordData = NULL;
        _SentencesArray = NULL;
    }
    return self;
}
- (NSError *) FindWordOnInternet:(NSString *)word{
//    WordData = [[NSMutableData alloc] init];
    self.Name = word;
    word = [word stringByReplacingOccurrencesOfString:@"’" withString:@"'"];
    if (![word isMatchedByRegex:@"[a-zA-Z\\s][a-zA-Z \\-'\\s]*"]) {
        NSError * err = [NSError errorWithDomain:@"对不起，这不是个英文单词= =" code:0 userInfo:nil];
        if (delegate && [delegate respondsToSelector:@selector(WordFindInternetExpFailed:witError:)]) {
            [delegate WordFindInternetExpFailed:self witError:err];
        }
        return nil;
    }
    NSString * request = [NSString stringWithFormat:@"%@%@",IyubaWordApi,word];
    if (httpRequest) {
        [httpRequest clearDelegatesAndCancel];
        httpRequest = nil;
    }
    httpRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:request]];
    httpRequest.delegate = self;
    [httpRequest startAsynchronous]; 
    return nil;

}
- (void)cancel{
    if (httpRequest) {
        [httpRequest clearDelegatesAndCancel];
        httpRequest = nil;
    }
    self.delegate = nil;
}

#pragma mark ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request{

    NSData * data = [request responseData];
    
        DDXMLDocument * xml = [[DDXMLDocument alloc] initWithData:data options:0 error:nil];
        NSArray *items = [xml nodesForXPath:kXMLDataPath error:nil];
        
        for (DDXMLElement * obj in items) {
            if ([[[obj elementForName:kXMLResultPath] stringValue] integerValue] == 0) {
                NSError * err = [NSError errorWithDomain:@"查无此词(°_°)" code:0 userInfo:nil];
                [delegate WordFindInternetExpFailed:self witError:err];
            }
            else {
                self.Name = [[obj elementForName:kXMLWordPath] stringValue];
                self.Definition = [[obj elementForName:kXMLDefPath] stringValue];
                self.Pronunciation = [[obj elementForName:kXMLPronPath] stringValue];
                self.Audio = [[obj elementForName:kXMLAudioPath] stringValue];
                NSError * err = nil;
                NSArray *sents = [xml nodesForXPath:kXMLSentencePath error:&err];
                if (!err) {
                    _SentencesArray = [[NSMutableArray alloc] init];
                    for (DDXMLElement * obj in sents) {
                        NSString * en = [[obj elementForName:kXMLOrigPath] stringValue];
//                        NSString * ch = [Word replaceUnicode:[[obj elementForName:kXMLTransPath] stringValue]];
                        NSString * ch = [[obj elementForName:kXMLTransPath] stringValue];
                        Sentence * sentence = [[Sentence alloc] initWithEnglish:en Chinese:ch];
//                        NSLog(@"ch:%@",ch);
                        [_SentencesArray addObject:sentence];
                        
                    }
//                    NSLog(@"sentenceArray:%@",self.SentencesArray);
                }
                
                [delegate WordFindInternetExpSucceed:self];
            }
        }
    
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    NSError * err = [NSError errorWithDomain:@"联网失败(°_°)" code:0 userInfo:nil];
    [delegate WordFindInternetExpFailed:self witError:err];
}
// NSString值为Unicode格式的字符串编码(如\u7E8C)转换成中文
//unicode编码以\u开头
/*
+ (NSString *)replaceUnicode:(NSString *)unicodeStr 
{  
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];  
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];  
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];  
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];  
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData  
                                                          mutabilityOption:NSPropertyListImmutable  
                                                                    format:NULL 
                                                          errorDescription:NULL];  
    NSLog(@"%@",returnStr);
    return returnStr;  
}
 */
@end
