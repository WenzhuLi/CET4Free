//
//  CETAdapter.m
//  CET4Lite
//
//  Created by Seven Lee on 12-2-29.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "CETAdapter.h"
#import "TAndSForA.h"
#import "ScoreTableCell.h"
#import "AppDelegate.h"

@implementation CETAdapter
@synthesize scroll;
@synthesize Player;
@synthesize delegate = _delegate;
//@synthesize AutoNext;

//初始化
- (id) initWithYear:(NSInteger)y andSec:(NSInteger)sec scroll:(UIScrollView *)scr{
    if (self = [super init]) {
        year = y;
        section = sec;
        self.scroll = scr;
        QuestionArray = NULL;
        Player = nil;
        CurrentPage = 0;
//        AutoNext = NO;
        QuestionSoundPlayer = nil;
        AudioNeedToContinue = YES;
        CAudioPlayTime = 0;
        ShowRightAnswer = NO;
        ShowBackAlert = NO;
        self.delegate = nil;
        _shouldPlayQuestionSound = NO;
        //初始化时即从数据库中读取相应数据
        [self readFromDatabase];
    }
    return self;
}
- (id) initWithUserCollectionSection:(NSInteger)sec scroll:(UIScrollView *)scr{
    if (self = [super init]) {
        year = 0;
        section = sec;
        self.scroll = scr;
        QuestionArray = NULL;
        Player = nil;
        CurrentPage = 0;
        ShowBackAlert = NO;
        //        AutoNext = NO;
        QuestionSoundPlayer = nil;
        AudioNeedToContinue = YES;
        CAudioPlayTime = 0;
        ShowRightAnswer = YES;
        _shouldPlayQuestionSound = NO;
        [self readUserCollectionQuestions];
    }
    return self;
}
- (void) readUserCollectionQuestions{
    switch (section) {
        case 1:
            //SectionA
            [self readUserQuestionsABFromTable:kTableNameAnswera];
            [self FillTheScrollViewAB];
            break;
        case 2:
            //SectionB
            [self readUserQuestionsABFromTable:kTableNameAnswerb];
            [self FillTheScrollViewAB];
            break;
        case 3:
            //SectionC
            [self readUserQuestionsC:kTableNameAnswerc];
//            [self FillTheScrollViewCwithString:textCwithQuestions];
            
            break;
            
        default:
            break;
    }
}
- (void)readUserQuestionsC:(NSString *)tableName{
    //初始化数组
    QuestionArray = [[NSMutableArray alloc] init ];
    
    //建立数据库连接
    PLSqliteDatabase * data = [database CET4database];
    PLSqliteDatabase * userdb = [database UserWordsDatabase];
    
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM \"FavQues\" WHERE Type = %d ORDER BY id DESC",section];
    id<PLResultSet> result1 = [userdb executeQuery:query];
    while ([result1 next]) {
        //执行SQL语句，先将题目都读出来，用answerc表
        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM \"%@\" WHERE TestTime = %d AND Number = %d;",tableName,[result1 intForColumn:@"TestTime"],[result1 intForColumn:@"Number"]];
        id<PLResultSet> result = [data executeQuery:sql];
        [result next];
        @try {
            FillingTheBlank * ftb = [[FillingTheBlank alloc] init];
            ftb.question = [result objectForColumn:@"Question"];
            ftb.Year = [result intForColumn:@"TestTime"];
            ftb.Number = [result intForColumn:@"Number"];
            ftb.answer = [result objectForColumn:@"Answer"];
            ftb.QuestionSound = [result objectForColumn:@"Sound"];
            ftb.keywords = [result isNullForColumn:@"KeyWord1"] ? nil : [NSArray arrayWithObjects:[result objectForColumn:@"KeyWord1"],[result objectForColumn:@"KeyWord2"],[result objectForColumn:@"KeyWord3"], nil];
            ftb.audio = ftb.QuestionSound;
            [QuestionArray addObject:ftb];
        }
        @catch (NSException *exception) {
            
        }
    }      
}
+ (NSInteger) numberOfCollectionsInSection:(NSInteger) sec{
    //建立数据库连接
//    PLSqliteDatabase * data = [database CET4database];
    PLSqliteDatabase * userdb = [database UserWordsDatabase];
    
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM \"FavQues\" WHERE Type = %d ORDER BY id DESC",sec];
    id<PLResultSet> result1 = [userdb executeQuery:query];
    int number = 0;
    while ([result1 next]) {
        number++;
    }
    return number;
}
- (void)readUserQuestionsABFromTable:(NSString *)tableName{
    //初始化数组
    QuestionArray = [[NSMutableArray alloc] init ];
    
    //建立数据库连接
    PLSqliteDatabase * data = [database CET4database];

    PLSqliteDatabase * userDB = [database UserWordsDatabase];
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM \"FavQues\" WHERE Type = %d ORDER BY id DESC",section];
    id<PLResultSet> result1 = [userDB executeQuery:query];
    //分析结果,题目表中没有空的,故不分析字段为空的情况
    while ([result1 next]) {
        //执行SQL语句
        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM \"%@\" WHERE TestTime = %d AND Number = %d;",tableName,[result1 intForColumn:@"TestTime"],[result1 intForColumn:@"Number"]];
        id<PLResultSet> result = [data executeQuery:sql];
        [result next];
        SingleChoice * single = [[SingleChoice alloc]init];
        single.Year = [result intForColumn:@"TestTime"];
        single.Number = [result intForColumn:@"Number"];
        single.question = [result objectForColumn:@"Question"];
        single.audio = [result objectForColumn:@"Sound"];
        single.answer = [result objectForColumn:@"Answer"];
        single.ForChoices = [NSArray arrayWithObjects:[result objectForColumn:@"AnswerA"], [result objectForColumn:@"AnswerB"],[result objectForColumn:@"AnswerC"],[result objectForColumn:@"AnswerD"],nil];
        single.QuestionSound = [NSString stringWithFormat:@"Q%d.mp3",single.Number];
        
        [QuestionArray addObject:single];
    }
}
//从数据库中读取,读取问题、解析、原文等
- (void) readFromDatabase{
    
    //读取题目
    [self readQuestions];
    
    //读取解析
//    [self readExplains];
}

//initPlayer
- (void) initPlayer{
    self.Player = [[AudioPlayerView alloc] initWithFrame:CGRectMake(0,325, 320, 51 )];
    Player.delegate = self;
    Player.SynchroID = textView;
    NSString *DocumentPath = [database AudioFileDirectory];

    NSString *DirPath = [DocumentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d/",[[QuestionArray objectAtIndex:0] Year]]];
    NSString * Q = [[QuestionArray objectAtIndex:0] audio];
    NSString * FilePath = [DirPath stringByAppendingPathComponent:Q];
    [self.Player playAudio:Q URL:FilePath];
    
}

//从数据库中读取题目，根据不同的Section调用不同的读取方法
- (void) readQuestions{
    switch (section) {
        case 1:
            //SectionA
            [self readQuestionsABFromTable:kTableNameAnswera];
            [self FillTheScrollViewAB];
            break;
        case 2:
            //SectionB
            [self readQuestionsABFromTable:kTableNameAnswerb];
            [self FillTheScrollViewAB];
            break;
        case 3:
            //SectionC
//            scroll.frame = CGRectMake(0, scroll.frame.origin.y, 320, scroll.frame.size.height*0.5);
            [self readQuestionsC:kTableNameTextc quesTable:kTableNameAnswerc];
            [self FillTheScrollViewCwithString:textCwithQuestions];
            break;
            
        default:
            break;
    }
}

- (TextView *) readTexts:(NSInteger) cuurentNumber{
//    CGRect frame = CGRectMake(scroll.frame.origin.x, scroll.frame.origin.y, scroll.frame.size.width, scroll.frame.size.height / 0.5);
    switch (section) {
        case 1:
            return [self readTextsAFromTable:kTableNameTexta number:cuurentNumber];
            break;
        case 2:
            return [self readTextsBFromTable:kTableNameTextb number:cuurentNumber];
        case 3:
//            TextBC = [[TextBCView alloc]initWithFrame:scroll.frame array:TextsArray];
//            TextBC.PlayTimeForC = 0;
            textView = [[TextBCView alloc]initWithFrame:scroll.frame array:TextsArray];
            textView.PlayTimeForC = 0;
            return textView;
        default:
            return NULL;
            break;
    }

}


//根据题号Number读取对应SectionA原文，并绘制一个TextAView返回
- (TextView *) readTextsAFromTable:(NSString *)tableName number:(NSInteger)number{
    
    //先从数据库中读取原文的时间\内容\性别等
    TextsArray = [[NSMutableArray alloc] init];
    PLSqliteDatabase * data = [database CET4database];
    
/*   
    此处数据库非常不规范，短对话好说，搜题号没问题，但长对话把所有对话的题号都标成此对话开始的第一个题，如22到25题共用一篇短文，则所有的内容题号都
    标为22，而23、24、25的NumberIndex为0，用于区分，但有些写了0，有些干脆没有此条数据，即搜题号为25的题没有结果，故用了一个isFound标记，若搜此题
    目为0或没结果，就将题号减1，即搜前一题，直到isFound为YES结束。
*/
    BOOL isFound = NO;
    year = [[QuestionArray objectAtIndex:CurrentPage] Year];
    while (!isFound) {
        
        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM \"%@\" WHERE TestTime = %d AND Number = %d ORDER BY NumberIndex;",tableName,year,number];
        id<PLResultSet> result = [data executeQuery:sql];
        while ([result next]) {
            @try {
                if ([result intForColumn:@"NumberIndex"] != 0) {
                    TAndSForA * tas = [[TAndSForA alloc] init];
                    tas.Sex = [result objectForColumn:@"Sex"];
                    tas.Time = [result intForColumn:@"Timing"];
                    tas.String = [result objectForColumn:@"Sentence"];
                    [TextsArray addObject:tas];
                    isFound = YES;
                }
            }
            @catch (NSException *exception) {
                TAndSForA * tas = [[TAndSForA alloc] init];
                tas.Sex = [result objectForColumn:@"Sex"];
                tas.Time = 0;
                tas.String = [result objectForColumn:@"Sentence"];
                [TextsArray addObject:tas];
                isFound = YES;
            }
            
        }
        if (!isFound) {
            number --;
        }
    }
    
    //分析完后创建一个TextAView并返回
    textView = [[TextAView alloc] initWithFrame:scroll.frame array:TextsArray];
    return textView;
}

- (TextView *) readTextsBFromTable:(NSString *)tableName number:(NSInteger)number{
    //先从数据库中读取原文的时间\内容\性别等
    TextsArray = [[NSMutableArray alloc] init];
    PLSqliteDatabase * data = [database CET4database];
    
    /*   
     此处数据库非常不规范，短对话好说，搜题号没问题，但长对话把所有对话的题号都标成此对话开始的第一个题，如22到25题共用一篇短文，则所有的内容题号都
     标为22，而23、24、25的NumberIndex为0，用于区分，但有些写了0，有些干脆没有此条数据，即搜题号为25的题没有结果，故用了一个isFound标记，若搜此题
     目为0或没结果，就将题号减1，即搜前一题，直到isFound为YES结束。
     */
    BOOL isFound = NO;
    year = [[QuestionArray objectAtIndex:CurrentPage] Year];
    while (!isFound) {
        
        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM \"%@\" WHERE TestTime = %d AND Number = %d ORDER BY NumberIndex;",tableName,year,number];
        id<PLResultSet> result = [data executeQuery:sql];
        while ([result next]) {
            if ([result intForColumn:@"NumberIndex"] != 0) {
                @try //数据库有错，Timing字段为空，若有空将其Time设为0
                {
                    TimeAndString * tas = [[TimeAndString alloc] init];
                    tas.Time = [result intForColumn:@"Timing"];
                    tas.String = [result objectForColumn:@"Sentence"];
                    [TextsArray addObject:tas];
                    isFound = YES;
                }
                @catch (NSException *exception) {
                    TimeAndString * tas = [[TimeAndString alloc] init];
                    tas.Time = 0;
                    tas.String = [result objectForColumn:@"Sentence"];
                    [TextsArray addObject:tas];
                    isFound = YES;
                }     
            }
        }
        if (!isFound) {
            number --;
        }
    }
    
    //分析完后创建一个TextAView并返回
    textView = [[TextBCView alloc] initWithFrame:scroll.frame array:TextsArray];
    return textView;
}
- (ExplainView *) readExplains:(NSInteger)number{
    //TODO
    Explain * exp = [[Explain alloc] init];
    year = [[QuestionArray objectAtIndex:CurrentPage] Year];
    PLSqliteDatabase * data = [database CET4database];
    NSString * tableName = kTableNameExplain;
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM \"%@\" WHERE TestTime = %d AND Number = %d;",tableName,year,number];
    id<PLResultSet> result = [data executeQuery:sql];
    while ([result next]) {
        if (![result isNullForColumn:@"Keyss"]) {
            exp.Keys = [result objectForColumn:@"Keyss"];
        }
        if (![result isNullForColumn:@"Explains"]) {
            exp.Explains = [result objectForColumn:@"Explains"];
        }
        if (![result isNullForColumn:@"Knowledge"]) {
            exp.Knownledge = [result objectForColumn:@"Knowledge"];
        }
    }
    
    ExplainView * ev = [[ExplainView alloc] initWithFrame:scroll.frame andExplain:exp];
    return ev;
}

//从表tableName中读取题目并分析，结果保存在QuestionArray中
- (void) readQuestionsABFromTable:(NSString *)tableName{
    
    //初始化数组
    QuestionArray = [[NSMutableArray alloc] init ];
    
    //建立数据库连接
    PLSqliteDatabase * data = [database CET4database];
    
    //执行SQL语句
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM \"%@\" WHERE TestTime = %d ORDER BY Number;",tableName,year];
    id<PLResultSet> result = [data executeQuery:sql];
    
    //分析结果,题目表中没有空的,故不分析字段为空的情况
    while ([result next]) {
        SingleChoice * single = [[SingleChoice alloc]init];
        single.Year = [result intForColumn:@"TestTime"];
        single.Number = [result intForColumn:@"Number"];
        single.question = [result objectForColumn:@"Question"];
        single.audio = [result objectForColumn:@"Sound"];
        single.answer = [result objectForColumn:@"Answer"];
        single.ForChoices = [NSArray arrayWithObjects:[result objectForColumn:@"AnswerA"], [result objectForColumn:@"AnswerB"],[result objectForColumn:@"AnswerC"],[result objectForColumn:@"AnswerD"],nil];
        single.QuestionSound = [NSString stringWithFormat:@"Q%d.mp3",single.Number];
        
        [QuestionArray addObject:single];
    }
    
}
- (void) readQuestionsC:(NSString *)texttableName quesTable:(NSString *)anstableName{

    
    //初始化数组
    QuestionArray = [[NSMutableArray alloc] init ];
    
    //建立数据库连接
    PLSqliteDatabase * data = [database CET4database];
    
    //执行SQL语句，先将题目都读出来，用answerc表
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM \"%@\" WHERE TestTime = %d ORDER BY Number;",anstableName,year];
    id<PLResultSet> result = [data executeQuery:sql];
    
    //先把题目数组读出来,问题又来了，SectionC的音频文件数据库里压根儿没有。。第一遍叫c1，第二遍叫c2，第三遍叫c3.。。囧。NO，是大写C
    int c = 0;
    while ([result next]) {
        @try {
            FillingTheBlank * ftb = [[FillingTheBlank alloc] init];
            ftb.question = [result objectForColumn:@"Question"];
            ftb.Year = year;
            ftb.Number = [result intForColumn:@"Number"];
            ftb.answer = [result objectForColumn:@"Answer"];
            ftb.QuestionSound = [result objectForColumn:@"Sound"];
            ftb.keywords = [result isNullForColumn:@"KeyWord1"] ? nil : [NSArray arrayWithObjects:[result objectForColumn:@"KeyWord1"],[result objectForColumn:@"KeyWord2"],[result objectForColumn:@"KeyWord3"], nil];
            c = c%3 +1;
            ftb.audio = [NSString stringWithFormat:@"C%d.mp3",c];
            
            [QuestionArray addObject:ftb];
        }
        @catch (NSException *exception) {
            
        }
    }
    
    //再读原文句子
    [self readTextsCFromTable:texttableName year:year];
    
    //再把原文和问题结合起来，结合成要显示的题目T_T
    textCwithQuestions = @"";
    int i = 0;
    int j = 0;
    int count = [QuestionArray count];
    int count2 = [TextsArray count];
    for (i = 0; i < count2; i++) {
        if ([[TextsArray objectAtIndex:i] Qwords] > 0 && j < count) {
            textCwithQuestions = [textCwithQuestions stringByAppendingString:[[QuestionArray objectAtIndex:j] question]];
            j++;
        }
        else {
            textCwithQuestions = [textCwithQuestions stringByAppendingString:[[TextsArray objectAtIndex:i] String]];
            
        }
    }

}

//根据年份读取对应SectionC的原文，保存在TextsArray中
- (void) readTextsCFromTable:(NSString *)tableName year:(NSInteger)thisyear{
    //初始化数组
    TextsArray = [[NSMutableArray alloc] init ];
    
    //建立数据库连接
    PLSqliteDatabase * data = [database CET4database];
    
    //执行SQL语句，先将题目都读出来，用answerc表
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM \"%@\" WHERE TestTime = %d ORDER BY Number , NumberIndex;",tableName,thisyear];
    id<PLResultSet> result = [data executeQuery:sql];
    while ([result next]) {
        TTTAndSForC * ttt = [[TTTAndSForC alloc] init];
        @try {
            
            ttt.Time = 0;
            ttt.String = [result objectForColumn:@"Sentence"];
            ttt.Qwords = [result intForColumn:@"QWords"];
            ttt.Times = [NSArray arrayWithObjects:[NSNumber numberWithInt:[result intForColumn:@"Timing1"]],[NSNumber numberWithInt:[result intForColumn:@"Timing2"]],[NSNumber numberWithInt:[result intForColumn:@"Timing3"]], nil];
            [TextsArray addObject:ttt];
        }
        @catch (NSException *exception) {
            ttt.Time = 0;
            ttt.String = [result objectForColumn:@"Sentence"];
            ttt.Qwords = [result intForColumn:@"QWords"];
            ttt.Times = [NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0], nil];
            [TextsArray addObject:ttt];
        }

    }
}

//根据QuestionArray填充题目Scroll
- (void) FillTheScrollViewAB{
    
    //几个基本数值
    int count = [QuestionArray count];
    ABViewArray = [[NSMutableArray alloc] init];
    scroll.pagingEnabled = YES;
//    CGFloat pointX = 0;
    CGFloat pointY = 0;
    CGFloat width = scroll.frame.size.width;
    CGFloat height = scroll.frame.size.height;
    
    //对数组中的每一个元素生成一个QuestioinABView,加入到scroll中,同时加入ABViewArray数组
    for (int i = 0; i < count; i++) {
        QuestioinABView * abView = [[QuestioinABView alloc] initWithFrame:CGRectMake(width * i, pointY, width, height) andQ:[QuestionArray objectAtIndex:i]];
        abView.answerHandler = self;
        abView.delegate = self;
        [scroll addSubview:abView];
        [ABViewArray addObject:abView];
    }
//    ScoreTable = [[UITableView alloc] initWithFrame:CGRectMake(width * count, 0, width, height) style:UITableViewStylePlain];
//    ScoreTable.delegate = self;
//    ScoreTable.dataSource = self;
//    ScoreTable.backgroundColor = [UIColor clearColor];
//    [scroll addSubview:ScoreTable];
//    scroll.contentSize = CGSizeMake(width * (count + 1), height);
     scroll.contentSize = CGSizeMake(width * count, height);
    NSLog(@"scrollSize:(%.1f,%.1f) in adapter",width,height);
    NSLog(@"scrollContentSize:(%.1f,%.1f) in adapter",scroll.contentSize.width,scroll.contentSize.height);
}

//根据大长句子填充题目的scroll
- (void) FillTheScrollViewCwithString:(NSString *)content{
    CGFloat width =  scroll.frame.size.width;
    
//    CGSize maxSize = CGSizeMake(width, CGFLOAT_MAX);
//    CGSize strSize = [content sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:maxSize lineBreakMode:UILineBreakModeWordWrap];
//    
//    CGFloat height = scroll.frame.size.height;
//    scroll.frame = CGRectMake(0, scroll.frame.origin.y, 320, height);
    scroll.pagingEnabled = NO;
//    int lines = strSize.width / width + 1;
    SevenLabel * label = [[SevenLabel alloc] initWithFrame:CGRectMake(10, 0, width-20, 0)];
//    label.numberOfLines = 0;
    label.text = content;
    label.textColor = [UIColor whiteColor];
    if ([AppDelegate isPad]) {
        label.font = [UIFont systemFontOfSize:24];
        label.textColor = [UIColor brownColor];
    }
    
//    label.lineBreakMode = UILineBreakModeWordWrap;
    
//    label.backgroundColor = [UIColor clearColor];

    [scroll addSubview:label];
    scroll.contentSize = CGSizeMake(scroll.frame.size.width, label.frame.size.height);
}
//返回QuestionArray[index]的题号，进行了超范围判断
- (NSInteger)QuestioinNumberofIndex:(int)index{
    if (index >= [QuestionArray count])
        return [self LastNumber];
    else 
        if (index < 0) 
            return [[QuestionArray objectAtIndex:0] Number];

    return [[QuestionArray objectAtIndex:index] Number];
}

//返回QuestionArray最后一个元素的题号
- (NSInteger)LastNumber{
    int count = [QuestionArray count];
    return [[QuestionArray objectAtIndex:count - 1] Number];
}

- (void) CurrentPageChanged:(NSInteger)nowPage{
    if (nowPage >= [QuestionArray count]) {
        return;
    }
    
    if (QuestionSoundPlayer && [QuestionSoundPlayer isPlaying]) {
        [QuestionSoundPlayer stop];
        QuestionSoundPlayer = nil;
        @try {
            QuestioinABView * currentABView = [ABViewArray objectAtIndex:CurrentPage];
            [currentABView stopQuestionButtonAimation];
        }
        @catch (NSException *exception) {
            NSLog(@"currentABView exception:%@",exception);
        }
    }
    CurrentPage = nowPage;
    if (section == 3) {
        return;
    }
    NSString * au = [[QuestionArray objectAtIndex:CurrentPage] audio];
    if ([au compare:Player.CurrentAudio] == NSOrderedSame) {
        if (_shouldPlayQuestionSound) {
            [self PlayCurrentQuestionSound:nil];
        }
        return;
    }
    NSString *documentPath = [database AudioFileDirectory];
    year = [[QuestionArray objectAtIndex:CurrentPage] Year];
    NSString *dirPath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d/",year]];
    NSString * filePath = [dirPath stringByAppendingPathComponent:au];
    _shouldPlayQuestionSound = NO;
    [Player playAudio:au URL:filePath];
//    if (AutoNext) {
//        [Player start];
//    }
}
- (void)setYear:(NSInteger) y{
    year = y;
}
- (void)QuestionNumberChanged:(NSInteger)newNumber{
    int count = [QuestionArray count];
    for (int i = 0; i < count; i++) {
        Question * q = [QuestionArray objectAtIndex:i];
        if (q.Number == newNumber) {
            [self CurrentIndexChanged:i];
            break;
        }
    }
}
//收藏当前试题，成功返回YES，失败返回NO
- (NSError *)NewCollection{
    PLSqliteDatabase * userDB = [database UserWordsDatabase];
    NSInteger number = [self QuestioinNumberofIndex:CurrentPage];
    year = [[QuestionArray objectAtIndex:CurrentPage] Year];
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM \"FavQues\" WHERE TestTime = %d AND Number = %d",year,number];
    id<PLResultSet> result = nil;
    result = [userDB executeQuery:query];
    if ([result next]) {
        NSError * err = [NSError errorWithDomain:@"收藏已存在！" code:0 userInfo:nil];
        return err;
    }
    else {
        NSString* date;
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        date = [formatter stringFromDate:[NSDate date]];
        NSString * insertsql = [NSString stringWithFormat:@"INSERT INTO \"FavQues\" (TestTime,Number,CreateDate,Type) VALUES (%d,%d,'%@',%d)",year,number,date,section];
        NSError * err = nil;
        [userDB executeUpdateAndReturnError:&err statement:insertsql];
        return err;
    }  
}
//删除当前收藏的试题，成功返回YES，失败返回NO
- (NSError *)DeleteCollection{
    PLSqliteDatabase * userDB = [database UserWordsDatabase];
    NSInteger number = [self QuestioinNumberofIndex:CurrentPage];
    NSInteger TestTime = [[QuestionArray objectAtIndex:CurrentPage] Year];
    NSString * query = [NSString stringWithFormat:@"DELETE FROM \"FavQues\" WHERE TestTime = %d AND Number = %d",TestTime,number];
    NSError * err;
    BOOL result = [userDB executeUpdateAndReturnError:&err statement:query];
    if (result) 
        return nil;
    else
        return err;
 
}
- (float)HandInAnswerSheet{
    int count = [QuestionArray count];
    int NumberOfRight = 0;
    float score = 0;
    if (section != 3) {
        for (int i = 0; i < count; i++) {
            QuestioinABView * abview = [ABViewArray objectAtIndex:i];
            [abview ShowRightOrWrongAndDisable];
        }
    }
    for (int i = 0; i < count; i++) {
        Question * question = [QuestionArray objectAtIndex:i];
        float questionscore = [question GiveMeTheScore];
        if (questionscore > 0) 
            NumberOfRight ++;
        score += questionscore;
    }
    PLSqliteDatabase * userDB = [database UserWordsDatabase];
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    date = [formatter stringFromDate:[NSDate date]];
    NSString * insertsql = [NSString stringWithFormat:@"INSERT INTO \"Scores\" (TestTime,NumberOfQuestions,NumberOfRight,Score,CreateDate,Type) VALUES (%d,%d,%d,%f,'%@',%d)",year,count,NumberOfRight,score,date,section];
    NSError * err = nil;
    [userDB executeUpdateAndReturnError:&err statement:insertsql];
    ShowBackAlert = NO;
    //estTime integer not null,NumberOfQuestions integer,NumberOfRight integer, Score float not null,CreateDate TEXT, Type integer)
    return score;
}
//存储当前答案，主要用于C的答题部分，若不按上一题下一题按钮，则无法存储答案
- (void)restoreCurrentAnswer:(NSString *)answer{
    [[QuestionArray objectAtIndex:CurrentPage] setYourAnswer:answer];

}
- (BOOL) NeedAttention{
    return ShowBackAlert;
}
#pragma mark AudioPlayerViewDelegate
- (void) AudioPlayerView:(AudioPlayerView *)playerView PlayerDidFinishPlayingSuccessfully:(BOOL)flag{
    [textView clearAllHighlight];
    _shouldPlayQuestionSound = YES;
    if (section == 3) {
        CAudioPlayTime++;
        CAudioPlayTime %= 3;
        textView.PlayTimeForC = CAudioPlayTime;
        NSString *DocumentPath = [database AudioFileDirectory];
        NSString *DirPath = [DocumentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d/",year]];
        NSString * Q = [[QuestionArray objectAtIndex:CAudioPlayTime] audio];
        NSString * FilePath = [DirPath stringByAppendingPathComponent:Q];
        [self.Player playAudio:Q URL:FilePath];
        if (CAudioPlayTime != 0) {
            _shouldPlayQuestionSound = NO;
            [Player start];
        }        
    }
}

#pragma mark QuestionABViewDelegate
- (void)PlayCurrentQuestionSound:(UIButton *)sender{
    if (sender) {
        [self CurrentPageChanged:sender.tag];
    }
    if (QuestionSoundPlayer) {
        if ([QuestionSoundPlayer isPlaying]) {
            return;
        }
        [QuestionSoundPlayer stop];
        QuestionSoundPlayer = nil;
    }
    if (Player.AudioPlayer && [Player isPlaying]) {
        [Player pause];
        AudioNeedToContinue = YES;
    }
    else {
        AudioNeedToContinue = NO;
    }
    NSError * err;
    Question * question = [QuestionArray objectAtIndex:CurrentPage];
    NSString * QS = question.QuestionSound;
    NSString *documentPath = [database AudioFileDirectory];
    NSString *dirPath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d/",question.Year]];
    NSString * filePath = [dirPath stringByAppendingPathComponent:QS];
    QuestionSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:&err];
    QuestionSoundPlayer.delegate = self;
    QuestionSoundPlayer.numberOfLoops = 0;
    if (ABViewArray && CurrentPage < [ABViewArray count]) {
        QuestioinABView * abview = [ABViewArray objectAtIndex:CurrentPage];
        [abview startQuestionButtonAimation];
    }
    if (QuestionSoundPlayer) {
        [QuestionSoundPlayer play];
    }
}
- (void)AddCurrentQuestionToFav{
    
}
#pragma mark AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (player == QuestionSoundPlayer) {
        QuestionSoundPlayer = nil;
        if (AudioNeedToContinue)
            [Player start]; 
    }
    if (section != 3) {
        @try {
            QuestioinABView * currentABView = [ABViewArray objectAtIndex:CurrentPage];
            [currentABView stopQuestionButtonAimation];
        }
        @catch (NSException *exception) {
            NSLog(@"currentABView exception:%@",exception);
        }
    }
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    if (section != 3) {
        @try {
            QuestioinABView * currentABView = [ABViewArray objectAtIndex:CurrentPage];
            [currentABView stopQuestionButtonAimation];
        }
        @catch (NSException *exception) {
            NSLog(@"currentABView exception:%@",exception);
        }
    }
}
#pragma mark AnserSectionCData
- (NSString *)QuestionToNumber:(NSInteger)number{
    return [self findQuestionToNumber:number];
}
#pragma mark AnswerHandler
- (void)restoreCustomAnswer:(NSString *)answer ofNumber:(NSInteger)number{
    int count = [QuestionArray count];
    ShowBackAlert = YES;
    for (int i = 0; i < count; i++) {
        Question * q = [QuestionArray objectAtIndex:i];
        if (q.Number == number) {
            q.YourAnswer = answer;
            if (section < 3 && ShowRightAnswer) {
                QuestioinABView * abView = [ABViewArray objectAtIndex:i];
                [abView ShowRightOrWrongAndDisable];
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(Answer:ofNumberStored:)]) {
                [self.delegate Answer:answer ofNumberStored:number];
            }
            return;
        }
    }
}
- (void) CurrentIndexChanged:(NSInteger)nowIndex{
    if (nowIndex < 0 || nowIndex >= [QuestionArray count]) {
        return;
    }
    [self CurrentPageChanged:nowIndex];
}
//停止播放器并清除
- (void)StopPlayer{
    if (QuestionSoundPlayer) {
        [QuestionSoundPlayer stop];
        QuestionSoundPlayer = nil;
    }
    [Player DestroyPlayer];
}

//根据题号返回题目
- (NSString *)findQuestionToNumber:(NSInteger)number{
    int count = [QuestionArray count];
    for (int i = 0; i < count; i++) {
        Question * fllb = [QuestionArray objectAtIndex:i];
        if (fllb.Number == number) {
            return fllb.question;
        }
    }
    return NULL;
}

- (NSArray *)myQuestionArray{
    return self->QuestionArray;
}
//#pragma mark -
//#pragma mark UITableViewDatasource
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    ScoreTableCell * cell = (ScoreTableCell *)[tableView dequeueReusableCellWithIdentifier:kScoreTableCellReuseID];
//    if (!cell) {
//        cell = [[ScoreTableCell alloc] init];
//        cell = (ScoreTableCell *)[[[NSBundle mainBundle] loadNibNamed:@"ScoreTableCellView" 
//                                                              owner:self 
//                                                            options:nil] objectAtIndex:0];
//    }
//    Question * ques = [QuestionArray objectAtIndex:indexPath.row];
//    cell.ChoiceLabel.text = ques.YourAnswer;
//    cell.ChoiceLabel.textColor = [UIColor colorWithRed:1 green:0.98 blue:0.44 alpha:1Color];
//    cell.ChoiceLabel.font = [UIFont systemFontOfSize:14];
//    cell.RightAnswerLabel.hidden = !ShowRightAnswer;
//    cell.RightAnswerLabel.font = [UIFont systemFontOfSize:14];
//    cell.QuestionNoLabel.text = [NSString stringWithFormat:@"第%d题",ques.Number];
//    cell.QuestionLabel.font = [UIFont systemFontOfSize:10];
//    cell.QuestionLabel.text = ques.question;
//    return cell;
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return [QuestionArray count];
//}
//
//#pragma mark -
//#pragma mark UITabelViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 53;
//}

@end
