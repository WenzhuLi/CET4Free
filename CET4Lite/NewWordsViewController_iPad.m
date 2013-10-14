//
//  NewWordsViewController_iPad.m
//  CET4Lite
//
//  Created by Seven Lee on 12-9-14.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "NewWordsViewController_iPad.h"
#import "UserWordCell.h"
#import "Word.h"
#import "database.h"
#import "Reachability.h"
#import "LoginViewController.h"
#import "database.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"
#import <AVFoundation/AVFoundation.h>
#import "WordDetailViewController.h"
#import "AppDelegate.h"
#import "UserInfo.h"
#import "MenuRootViewController.h"
@interface NewWordsViewController_iPad ()
@property (nonatomic, strong) WordDetailViewController * wordDetailViewController;
@end
static AVPlayer * player;
@implementation NewWordsViewController_iPad
@synthesize jjjjjjArray;
@synthesize tabelView;
@synthesize ToDeleteArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wood_pattern"]];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)viewWillAppear:(BOOL)animated{
    [self readFromDatabase];
    [self.tabelView reloadData];
}
- (void)readFromDatabase{
    PLSqliteDatabase * words = [database UserWordsDatabase];
    NSString * sql = @"SELECT * FROM Words ORDER BY id DESC";
    id<PLResultSet> result = [words executeQuery:sql];
    Word * thisword = NULL;
    NSString * name = @"";
    NSString * defi = @"词义未找到 (°_°)";
    NSString * pron = @"";
    NSString * audio = @"";
    self.jjjjjjArray = [[NSMutableArray alloc] init];
    
    while ([result next]) {
        if (![result isNullForColumn:@"Word"]) {
            name = [result objectForColumn:@"Word"];
        }
        if (![result isNullForColumn:@"def"]) {
            defi = [result objectForColumn:@"def"];
        }
        if (![result isNullForColumn:@"pron"]) {
            pron = [result objectForColumn:@"pron"];
            pron = [pron stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
        }
        if (![result isNullForColumn:@"audio"]) {
            audio = [result objectForColumn:@"audio"];
        }
        thisword = [[Word alloc] initWithWord:name Pron:pron Def:defi Audio:audio];
        [self.jjjjjjArray addObject:thisword];
    }
}
- (IBAction)doSeg:(UISegmentedControl *)sender
{
    
    if (sender.selectedSegmentIndex == 0) {
        if (![UserInfo userLoggedIn]) {
            MenuRootViewController * menu = (MenuRootViewController * )XAppDelegate.stackController.rootViewController;
            [menu accountTapped:nil];
            
        }
        else {
            HUD = [[MBProgressHUD alloc] initWithView:self.view.window];
            [self.view.window addSubview:HUD];
            
            HUD.dimBackground = YES;
            
            // Regiser for HUD callbacks so we can remove it from the window at the right time
            HUD.delegate = nil;
            
            // Show the HUD while the provided method executes in a new thread
            [HUD showWhileExecuting:@selector(SynchoWithCloud) onTarget:self withObject:nil animated:YES];
        }
        
    }else
    {
        [self BeginEditing:sender];
    }
}

- (IBAction)buttonAction:(UIButton *)sender {
    if (sender.tag == 1) {//同步
        if (![UserInfo userLoggedIn]) {
            MenuRootViewController * menu = (MenuRootViewController * )XAppDelegate.stackController.rootViewController;
            [menu accountTapped:nil];
            
        }
        else {
            HUD = [[MBProgressHUD alloc] initWithView:self.view.window];
            [self.view.window addSubview:HUD];
            
            HUD.dimBackground = YES;
            
            // Regiser for HUD callbacks so we can remove it from the window at the right time
            HUD.delegate = nil;
            
            // Show the HUD while the provided method executes in a new thread
            [HUD showWhileExecuting:@selector(SynchoWithCloud) onTarget:self withObject:nil animated:YES];
        }
    }
    else if (sender.tag == 2){//编辑
        [self.tabelView setEditing:!self.tabelView.editing animated:YES];
        if (self.tabelView.editing)
            sender.selected = YES;
        else
            sender.selected = NO;
    }
}
- (void)SynchoWithCloud{
    
    BOOL succeed = YES;
    //过程分三步
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.labelText = @"同步中...";
    float progress = 0.0f;
    HUD.progress = progress;
    
    //第一步，将之前记录的要删除的词读出来，上传至服务器，将其删除delete
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *realPath = [documentPath stringByAppendingPathComponent:@"Deletlog"];
    self.ToDeleteArray = [NSArray arrayWithContentsOfFile:realPath];
    if (self.ToDeleteArray) {
        NSInteger count = [self.ToDeleteArray count];
        for (int i = 0; i < count; i++) {
            NSString * url = [NSString stringWithFormat:@"http://word.iyuba.com/words/updateWord.jsp?userId=%@&mod=delete&groupName=Iyuba&word=%@",[UserInfo loggedUserID],[ToDeleteArray objectAtIndex:i]];
            NSString * response = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
            if (response) {
                DDXMLDocument *doc = [[DDXMLDocument alloc] initWithXMLString:response options:0 error:nil];
                NSArray *items = [doc nodesForXPath:@"response" error:nil];
                if (items) {
                    for (DDXMLElement *obj in items) {
                        NSInteger res = [[[obj elementForName:@"result"] stringValue] integerValue];
                        NSString * w = [[obj elementForName:@"word"] stringValue];
                    }
                }
            }
            else {
                succeed = NO;
            }
        }
    }
    if (succeed) {
        NSFileManager * fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:realPath error:nil];
        //第一步完成，更新进度显示
        progress = 0.1;
        HUD.progress = progress;
        
        //第二步，将用户数据库中现有的单词上传到服务器，insert，每成功插入一个单词，就从本地数据库中将其删除
        PLSqliteDatabase * data = [database UserWordsDatabase];
        NSString * sql = [NSString stringWithFormat:@"SELECT Word FROM Words"];
        id<PLResultSet> result = [data executeQuery:sql];
        NSMutableArray * wordArray = [[NSMutableArray alloc] init ];
        while ([result next]) {
            NSString * word = [result objectForColumn:@"Word"];
            [wordArray addObject:word];
        }
        NSInteger count = [wordArray count];
        float progressStep = 0.5/count;
        for (int i = 0; i < count; i++) {
            NSString * url = [NSString stringWithFormat:@"http://word.iyuba.com/words/updateWord.jsp?userId=%@&mod=insert&groupName=Iyuba&word=%@",[UserInfo loggedUserID],[wordArray objectAtIndex:i]];
            NSString * response = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
            if (response) {
                DDXMLDocument *doc = [[DDXMLDocument alloc] initWithXMLString:response options:0 error:nil];
                NSArray *items = [doc nodesForXPath:@"response" error:nil];
                if (items) {
                    for (DDXMLElement *obj in items) {
                        NSInteger res = [[[obj elementForName:@"result"] stringValue] integerValue];
                        NSString * w = [[obj elementForName:@"word"] stringValue];
                        if (res == 1) {
                            NSString * delet = [NSString stringWithFormat:@"DELETE FROM Words WHERE Word = '%@'",w];
                            if ([data executeUpdate:delet]) {
                                
                            }
                        }
                    }
                }
            }
            else {
                
            }
            progress += progressStep;
            HUD.progress = progress;
        }
        
        //第三步，从服务器获取所有单词，插入数据库
        NSString *url = [NSString stringWithFormat:@"http://word.iyuba.com/words/wordListService.jsp?u=%@&pageNumber=%d&pageCounts=%d",[UserInfo loggedUserID],1,NSIntegerMax];
        NSString * response = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
        if (response) {
            DDXMLDocument *doc = [[DDXMLDocument alloc] initWithXMLString:response options:0 error:nil];
            DDXMLElement * element = [doc rootElement];
            NSInteger number = [[[element elementForName:@"counts"] stringValue] integerValue];
            progressStep = 0.4/number;
            NSArray *items = [doc nodesForXPath:@"response/row" error:nil];
            if (items) {
                for (DDXMLElement *obj in items) {
                    
                    
                    NSString *key = [[obj elementForName:@"Word"] stringValue];
                    NSString *audio = [[obj elementForName:@"Audio"] stringValue];
                    NSString *pron = [[obj elementForName:@"Pron"] stringValue];
                    NSString *def = [[obj elementForName:@"Def"] stringValue];
                    
                    NSString* date;
                    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
                    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
                    date = [formatter stringFromDate:[NSDate date]];
                    NSString * sql = [NSString stringWithFormat:@"INSERT INTO Words (Word,audio,pron,def,CreateDate) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",key,audio,pron,def,date];
                    NSError * err;
                    if (![data executeUpdateAndReturnError:&err statement:sql]) {
                        
                    }
                    else {
                        
                    }
                    progress += progressStep;
                    HUD.progress = progress;
                }
            }
            
        }
        else {
            succeed = NO;
        }
    }
    
    HUD.progress = 1.0;
    if (succeed) {
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"同步完成";
    }
    else {
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-X.png"]];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"同步失败，网络不给力啊";
    }
    sleep(1);
    [self readFromDatabase];
    [self.tabelView reloadData];
}
- (void)BeginEditing:(UISegmentedControl *)seg{
    [self.tabelView setEditing:!self.tabelView.editing animated:YES];
    seg.selected = NO;
    if (self.tabelView.editing) 
        [seg setTitle:@"完成" forSegmentAtIndex:1];
    else 
        [seg setTitle:@"编辑" forSegmentAtIndex:1];
}
#pragma mark -
#pragma mark UITableViewDatasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserWordCell * cell = (UserWordCell *)[tableView dequeueReusableCellWithIdentifier:kUsrWordCellReuseID];
    if (!cell) {
        cell = [[UserWordCell alloc] init];
        cell = (UserWordCell *)[[[NSBundle mainBundle] loadNibNamed:@"UserWordCellView" 
                                                              owner:self 
                                                            options:nil] objectAtIndex:0];
    }
    Word * word = [jjjjjjArray objectAtIndex:indexPath.row];
    cell.WordLabel.text = [NSString stringWithFormat:@"%@  [%@]",word.Name,word.Pronunciation];
    cell.WordLabel.font = [UIFont boldSystemFontOfSize:17];
    cell.DefLabel.text = word.Definition;
    cell.PlaySoundButton.tag = indexPath.row;
    [cell.PlaySoundButton addTarget:self action:@selector(PlayWordSound:) forControlEvents:UIControlEventTouchUpInside];
    cell.sepLine.hidden = YES;
    cell.WordLabel.textColor = [UIColor colorWithRed:0.475 green:0.314 blue:0.286 alpha:1.0];
    cell.WordLabel.highlightedTextColor = [UIColor colorWithRed:0.820 green:0.290 blue:0.216 alpha:1.0];
    cell.WordLabel.shadowColor = [UIColor clearColor];
    cell.DefLabel.textColor = [UIColor colorWithRed:0.667 green:0.471 blue:0.427 alpha:1.0];
    cell.DefLabel.highlightedTextColor = [UIColor colorWithRed:0.820 green:0.290 blue:0.216 alpha:1.0];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.jjjjjjArray count];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * Thisword = [[jjjjjjArray objectAtIndex:indexPath.row] Name];
    
    PLSqliteDatabase * db = [database UserWordsDatabase];
    NSString * sql = [NSString stringWithFormat:@"DELETE FROM Words WHERE Word = '%@'",Thisword];
    if ([db executeUpdate:sql]) {
        
    }
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *realPath = [documentPath stringByAppendingPathComponent:@"Deletlog"];
    NSFileManager * fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:realPath]) {
        self.ToDeleteArray = [NSMutableArray arrayWithContentsOfFile:realPath];
    }
    else {
        self.ToDeleteArray = [[NSMutableArray alloc] init];
        [fm createFileAtPath:realPath contents:NULL attributes:nil];
    }
    [self.ToDeleteArray addObject:Thisword];
    if ([self.ToDeleteArray writeToFile:realPath atomically:YES]) {
        
    }
    [self.jjjjjjArray removeObjectAtIndex:indexPath.row];
    [self.tabelView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
- (void) PlayWordSound:(UIButton *)button{
    NSString * pro = [[jjjjjjArray objectAtIndex:button.tag] Audio];
    if ([pro isEqualToString:@""]) {
        return;
    }
    else {
        NetworkStatus ns = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
        if (ns == NotReachable ) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"发音失败" message:@"当前未联网" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [alert show];
        }
        else {
            //            wordPlayer = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:pro]];
            //            [wordPlayer play];
            player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:pro]];
            [player play];
        }
    }
}
#pragma mark UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    WordDetailViewController * wordDetail = [[WordDetailViewController alloc] initWithWord:[jjjjjjArray objectAtIndex:indexPath.row]];
    [XAppDelegate.stackController pushViewController:wordDetail fromViewController:self animated:YES];
     */
    if (!self.wordDetailViewController) {
        self.wordDetailViewController = [[WordDetailViewController alloc] initWithWord:[jjjjjjArray objectAtIndex:indexPath.row]];
        CGRect frame = self.wordDetailViewController.view.frame;
        frame.origin = CGPointMake(354, 30);
        self.wordDetailViewController.view.frame = frame;
        [self.view addSubview:self.wordDetailViewController.view];
    }
    else{
        [self.wordDetailViewController setWord:[jjjjjjArray objectAtIndex:indexPath.row]];
        self.wordDetailViewController.view.hidden = NO;
    }
}
@end
