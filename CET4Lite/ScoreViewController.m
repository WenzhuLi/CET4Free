//
//  ScoreViewController.m
//  CET4Lite
//
//  Created by Seven Lee on 12-4-18.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "ScoreViewController.h"
#import "database.h"
#import "ScoreInfo.h"
#import "AppDelegate.h"

@interface ScoreViewController ()

@end

@implementation ScoreViewController
@synthesize AScoreLabel;
@synthesize BScoreLabel;
@synthesize CScoreLabel;
@synthesize scoretable;
@synthesize ScoreInfoArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)init{
    if ([AppDelegate isPad]) {
        return [self initWithNibName:@"ScoreViewController_iPad" bundle:nil];
    }
    else {
        return [self initWithNibName:@"ScoreViewController" bundle:nil];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"成绩统计";
    if (IS_IPAD) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wood_pattern"]];
    }
}

- (void)viewDidUnload
{
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.scoretable = nil;
    self.AScoreLabel = nil;
    self.BScoreLabel = nil;
    self.CScoreLabel = nil;
    self.ScoreInfoArray = nil;
    NSLog(@"viewDidUnload");
//    HUD = nil;
    [super viewDidUnload];
}
- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear");
//    HUD = [[MBProgressHUD alloc] initWithWindow:self.view.window];
////    HUD.mode = MBProgressHUDModeDeterminate;
//    HUD.labelText = @"正在统计您的成绩";
//    [self.view.window addSubview:HUD];
////    HUD.dimBackground = YES;
//    
//    // Regiser for HUD callbacks so we can remove it from the window at the right time
//    HUD.delegate = nil;
//    HUD.removeFromSuperViewOnHide = YES;
    // Show the HUD while the provided method executes in a new thread
//    [HUD showWhileExecuting:@selector(CalculateTheScore) onTarget:self withObject:nil animated:YES];
//    [HUD showWhileExecuting:@selector(CalculateTheScore) onTarget:self withObject:nil animated:YES];
//    [self performSelector:@selector(CalculateTheScore) withObject:nil afterDelay:0.7];
    [self CalculateTheScore];
}
- (void)CalculateTheScore{
    PLSqliteDatabase * db = [database UserWordsDatabase];
    NSString * sql = @"SELECT * FROM Scores ORDER BY CreateDate DESC, TestTime DESC, Type";
    id<PLResultSet> result = [db executeQuery:sql];
    self.ScoreInfoArray = [[NSMutableArray alloc] initWithCapacity:0];
    while ([result next]) {
        ScoreInfo * si = [[ScoreInfo alloc] init];
        si.TestTime = [result intForColumn:@"TestTime"];
        si.TestType = [result intForColumn:@"Type"];
        si.Score = [result floatForColumn:@"Score"];
        si.NumberOfRight = [result intForColumn:@"NumberOfRight"];
        si.NumberOfQuestions = [result intForColumn:@"NumberOfQuestions"];
        si.Date = [result objectForColumn:@"CreateDate"];
        [self.ScoreInfoArray addObject:si];
        NSLog(@"info added number: %d",[self.ScoreInfoArray count]);
    }
    float scoreA = 0.0;
    float scoreB = 0.0;
    float scoreC = 0.0;
    float numberA = 0.0;
    float numberB = 0.0;
    float numberC = 0.0;
    for(ScoreInfo * info in self.ScoreInfoArray){
        switch(info.TestType){
            case 1:
                numberA += 1.0;
                scoreA += [info myCorrectRate];
                break;
            case 2:
                numberB += 1.0;
                scoreB += [info myCorrectRate];
                break;
            case 3:
                numberC += 1.0;
                scoreC += [info myCorrectRateC];
                break;
        }
    }
    numberA = numberA > 0.0 ? numberA : 1.0;
    numberB = numberB > 0.0 ? numberB : 1.0;
    numberC = numberC > 0.0 ? numberC : 1.0;
    float rateA = scoreA / numberA;
    float rateB = scoreB / numberB;
    float rateC = scoreC / numberC;
    self.AScoreLabel.text = [NSString stringWithFormat:@"%.2f%%",rateA * 100];
    self.BScoreLabel.text = [NSString stringWithFormat:@"%.2f%%",rateB * 100];
    self.CScoreLabel.text = [NSString stringWithFormat:@"%.2f%%",rateC * 100];
    if (IS_IPAD) {
        [self.AProgressBar setBackgroundColor:[UIColor colorWithRed:0.906 green:0.898 blue:0.847 alpha:1.0] foregroundColor:[UIColor colorWithRed:0.890 green:0.561 blue:0.443 alpha:1.0]];
        [self.BProgressBar setBackgroundColor:[UIColor colorWithRed:0.906 green:0.898 blue:0.847 alpha:1.0] foregroundColor:[UIColor colorWithRed:0.890 green:0.561 blue:0.443 alpha:1.0]];
        [self.CProgressBar setBackgroundColor:[UIColor colorWithRed:0.906 green:0.898 blue:0.847 alpha:1.0] foregroundColor:[UIColor colorWithRed:0.890 green:0.561 blue:0.443 alpha:1.0]];
        [self.AProgressBar setProgress:rateA];
        [self.BProgressBar setProgress:rateB];
        [self.CProgressBar setProgress:rateC];
    }
    self.scoretable.delegate = self;
    self.scoretable.dataSource = self;
//    [HUD hide:YES];
//    [HUD removeFromSuperview];
    [self.scoretable reloadData ];
//    sleep(1);
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark -
#pragma UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ScoreTableCell * cell = (ScoreTableCell *)[tableView dequeueReusableCellWithIdentifier:kScoreTableCellReuseID];
    if (!cell){ 
        cell = [[ScoreTableCell alloc] init];
        cell = (ScoreTableCell *)[[[NSBundle mainBundle] loadNibNamed:@"ScoreTableCellView" 
                                                                    owner:self 
                                                                  options:nil] objectAtIndex:0];
    }
    
    ScoreInfo * info = [self.ScoreInfoArray objectAtIndex:indexPath.row];
    cell.TestTimeLabel.text = [info myTitle];
    cell.DateLabel.text = [NSString stringWithFormat:@"测试时间：%@",info.Date];
    cell.RateLabel.text = [NSString stringWithFormat:@"%.0f%%",[info myCorrectRate] *100];
    
    cell.backgroundColor = [UIColor clearColor];
    if ([AppDelegate isPad]) {
        cell.DateLabel.textColor = [UIColor colorWithRed:0.839 green:0.584 blue:0.251 alpha:1.0];
        cell.TestTimeLabel.textColor = [UIColor colorWithRed:0.522 green:0.376 blue:0.345 alpha:1.0];
        cell.TestTimeLabel.font = [UIFont boldSystemFontOfSize:17];
        cell.RateLabel.textColor = [UIColor colorWithRed:0.890 green:0.561 blue:0.443 alpha:1.0];
        cell.DateLabel.shadowColor = [UIColor clearColor];
        cell.RateLabel.shadowColor = [UIColor clearColor];
        cell.TestTimeLabel.shadowColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.ScoreInfoArray) {
        return [self.ScoreInfoArray count];
    }
    else {
        return 0;
    }
    
}
#pragma mark -
#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
@end
