//
//  DeleteDataViewController.m
//  CET4Lite
//
//  Created by Seven Lee on 12-4-18.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "DeleteDataViewController.h"
#import "database.h"
#import "SevenLabel.h"
#import "AppDelegate.h"
@interface DeleteDataViewController ()

@end

@implementation DeleteDataViewController
@synthesize DirectoryArray;
@synthesize table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self readDirectoryArray];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"删除数据";
    if ([AppDelegate isPad]) {
        self.view.backgroundColor = [UIColor colorWithRed:0.682 green:0.329 blue:0.0 alpha:1.0];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.table = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)readDirectoryArray{
    self.DirectoryArray = [[NSMutableArray alloc] init];
    NSFileManager *fM = [NSFileManager defaultManager];
    NSArray * array = [fM contentsOfDirectoryAtPath:[database AudioFileDirectory] error:nil];
    for(NSString *file in array) {
        NSString *path = [[database AudioFileDirectory] stringByAppendingPathComponent:file];
        BOOL isDir = NO;
        [fM fileExistsAtPath:path isDirectory:(&isDir)];
        if(isDir) {
            //                NSString * year = [NSString stringWithFormat:@"%@年%@月",[file substringToIndex:4],[file substringFromIndex:4]];
            
            [self.DirectoryArray addObject:file];
        }
    }
}
- (float)folderSize:(NSString *)folderPath {
    NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    unsigned long long int fileSize = 0;
    
    while (fileName = [filesEnumerator nextObject]) {
//        NSDictionary *fileDictionary = [[NSFileManager defaultManager] fileAttributesAtPath:[folderPath stringByAppendingPathComponent:fileName] traverseLink:YES];
        NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:fileName] error:nil];
        fileSize += [fileDictionary fileSize];
    }
    float mb = fileSize / 1024.0 / 1024.0;
    return mb;
}
#pragma mark -
#pragma UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DirectoryCell"];
    if (!cell) 
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DirectoryCell"];
        
    NSString * number = [self.DirectoryArray objectAtIndex:indexPath.row];
    NSString * year = [NSString stringWithFormat:@"%@年%@月",[number substringToIndex:4],[number substringFromIndex:4]];
    cell.textLabel.text = year;
    NSString * path = [[database AudioFileDirectory] stringByAppendingPathComponent:[self.DirectoryArray objectAtIndex:indexPath.row]];
    float mb = [self folderSize:path];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fMB",mb];
    cell.backgroundColor = [UIColor colorWithRed:0.984 green:0.635 blue:0.055 alpha:1];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.DirectoryArray count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"请选择要删除的数据";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    float total = 0.0;
    for (int i = 0; i < [self.DirectoryArray count]; i++) {
        NSString * path = [[database AudioFileDirectory] stringByAppendingPathComponent:[DirectoryArray objectAtIndex:i]];
        total += [self folderSize:path];
    }
    return [NSString stringWithFormat:@"共计 %.2fMB",total];
}
#pragma mark -
#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 70;
}
/*
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 22)];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 22)];
    label.textAlignment = UITextAlignmentCenter;
    label.text = [self tableView:tableView titleForFooterInSection:section];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(1, 1);
    label.shadowColor = [UIColor grayColor];
    view.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    SevenLabel * tips = [[SevenLabel alloc] initWithFrame:CGRectMake(10, 28, 300, 0)];
    tips.textAlignment = UITextAlignmentCenter;
    tips.text = @"提示：当您的磁盘存储空间不足时，系统会自动删除这些数据。";
    tips.backgroundColor = [UIColor clearColor];
    tips.textColor = [UIColor whiteColor];
    tips.shadowOffset = CGSizeMake(1, 1);
    tips.shadowColor = [UIColor grayColor];
    [view addSubview:tips];
    return view;
}
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(20, 10, 100, 40)];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 320, 22)];
    label.textAlignment = UITextAlignmentLeft;
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(1, 1);
    label.shadowColor = [UIColor grayColor];
    view.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * number = [self.DirectoryArray objectAtIndex:indexPath.row];
    NSString * year = [NSString stringWithFormat:@"%@年%@月",[number substringToIndex:4],[number substringFromIndex:4]];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"确认" message:[NSString stringWithFormat:@"您确定要删除%@的所有音频文件吗？",year] delegate:self cancelButtonTitle:nil otherButtonTitles:@"删除",@"取消", nil];
    alert.tag = indexPath.row;
    [alert show];
}

#pragma mark -
#pragma UIAlartViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSString * path = [[database AudioFileDirectory] stringByAppendingPathComponent:[DirectoryArray objectAtIndex:alertView.tag]];
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        [self readDirectoryArray];
        [self.table reloadData];
    }
}
@end
