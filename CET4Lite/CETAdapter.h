//
//  CETAdapter.h
//  CET4Lite
//
//  Created by Seven Lee on 12-2-29.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestioinABView.h"
#import "database.h"
#import "SingleChoice.h"
#import "FillingTheBlank.h"
#import "QuestioinABView.h"
#import "TextAView.h"
#import "TextBCView.h"
#import "FillingTheBlank.h"
#import "TTTAndSForC.h"
#import "AudioPlayerView.h"
#import "SevenLabel.h"
#import "Explain.h"
#import "ExplainView.h"
#import "QuestionCView.h"
#import "CET4Constents.h"

////数据库中表格名字,做CET6时直接更换
//#define kTableNameAnswera   @"answera4"
//#define kTableNameAnswerb   @"answerb4"
//#define kTableNameAnswerc   @"answerc4"
//#define kTableNameTexta     @"texta4"
//#define kTableNameTextb     @"textb4"
//#define kTableNameTextc     @"textc4"
//#define kTableNameExplain   @"explain4"
@protocol CETAdapterDelegate <NSObject>

- (void) Answer:(NSString *)answer ofNumberStored:(NSInteger)number;

@end

@interface CETAdapter : NSObject<AnswerHandler,AudioPlayerViewDelegate,QuestionABViewDelegate,AVAudioPlayerDelegate>{
    NSInteger year;                         //要处理的年份,即用户选中的年份及月,如201112
    NSInteger section;                      //Section,1为A,2为B,3为C
    UIScrollView * scroll;                  //题目scroll,要在这个上面绘制题目
    NSMutableArray * QuestionArray;         //题目数组
    NSMutableArray * ABViewArray;           //题目View数组
    NSMutableArray * TextsArray;            //SectionA原文View数组
    NSString * textCwithQuestions;          //SectionC的文章，带问题
    NSInteger CurrentPage;
    AudioPlayerView * Player;               //AudioPlayer
//    BOOL AutoNext;                        //是否自动播放下一首
    BOOL AudioNeedToContinue;               //只有一个作用，判断播放完QuestionSound是否需要让Audio开始播放
    AVAudioPlayer * QuestionSoundPlayer;    //用来播放问题的AVAudioPlayer
    NSInteger CAudioPlayTime;               //若为SectionC，统计播放次数，即C1，C2.。。
//    TextBCView * TextBC;                  //textBCView
    TextView * textView;
    UITableView * ScoreTable;               //成绩列表，交卷前显示用户所选答案，交卷后显示成绩
    BOOL ShowRightAnswer;                   //是否显示正确答案（交卷前为NO，交卷后为YES）
//    NSURL * url;
    QuestionCView * QCView;
    BOOL    ShowBackAlert;
    BOOL _shouldPlayQuestionSound;
    id<CETAdapterDelegate> _delegate;
}
@property (nonatomic, strong) UIScrollView * scroll;
@property (nonatomic, strong) AudioPlayerView * Player;
@property (nonatomic, strong)id<CETAdapterDelegate> delegate;
//@property (nonatomic, assign) BOOL AutoNext;
//@property (nonatomic, strong) NSURL


//初始化
- (id) initWithYear:(NSInteger)y andSec:(NSInteger)sec scroll:(UIScrollView *)scr;

- (id) initWithUserCollectionSection:(NSInteger)sec scroll:(UIScrollView *)scr;
//initPlayer
- (void) initPlayer;

+ (NSInteger) numberOfCollectionsInSection:(NSInteger) sec;

//从数据库中读取,读取问题、解析、原文等
- (void) readFromDatabase;

//从数据库中读取题目，根据不同的Section调用不同的读取方法
- (void) readQuestions;

//从表tableName中读取题目并分析，结果保存在QuestionArray中，由readQuestions调用
- (void) readQuestionsABFromTable:(NSString *)tableName;


- (void) readQuestionsC:(NSString *)texttableName quesTable:(NSString *)anstableName;


//根据QuestionArray填充题目Scroll
- (void) FillTheScrollViewAB;

//根据大长句子填充题目的scroll
- (void) FillTheScrollViewCwithString:(NSString *)content;

- (TextView *) readTexts:(NSInteger) cuurentNumber;

//根据题号Number读取对应SectionA原文，并绘制一个TextAView返回
- (TextView *) readTextsAFromTable:(NSString *)tableName number:(NSInteger)number;

//根据题号Number读取对应SectionA原文，并绘制一个TextBView返回
- (TextView *) readTextsBFromTable:(NSString *)tableName number:(NSInteger)number;

//根据年份读取对应SectionC的原文，保存在TextsArray中
- (void) readTextsCFromTable:(NSString *)tableName year:(NSInteger)thisyear;

- (ExplainView *) readExplains:(NSInteger)number;
//pageChanged
- (void) CurrentPageChanged:(NSInteger)nowPage;

//根据题号返回题目
- (NSString *)findQuestionToNumber:(NSInteger)number;

//返回QuestionArray[index]的题号
- (NSInteger)QuestioinNumberofIndex:(int)index;

//返回QuestionArray最后一个元素的题号
- (NSInteger)LastNumber;

//返回QuestionArray
- (NSArray *)myQuestionArray;

//停止播放器并清除
- (void)StopPlayer;

//收藏当前试题，成功返回nil，失败返回error
- (NSError *)NewCollection;
- (NSError *)DeleteCollection;

//交卷，统计分数，将选项设为不可选
- (float)HandInAnswerSheet;
- (void)QuestionNumberChanged:(NSInteger)newNumber;

//存储当前答案，主要用于C的答题部分，若不按上一题下一题按钮，则无法存储答案
- (void)restoreCurrentAnswer:(NSString *)answer;

- (void)setYear:(NSInteger) y;
- (BOOL) NeedAttention;
@end
