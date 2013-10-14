//
//  FavorateViewController_iPad.m
//  CET4Lite
//
//  Created by Seven Lee on 12-9-24.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "FavorateViewController_iPad.h"
#import "CETAdapter.h"
#import "FavQuesViewController.h"
#import "AppDelegate.h"

@interface FavorateViewController_iPad ()

@end

@implementation FavorateViewController_iPad
@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _sectionArray = [NSArray arrayWithObjects:@"Section A",@"Section B",@"Section C", nil];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IS_IOS7 && !IS_IPAD) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        
    }
    self.navigationController.navigationBar.translucent = NO;
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wood_pattern"]];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"iPadFavViewCell"];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"iPadFavViewCell"];
    
//    Year * y = [_sectionArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [_sectionArray objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"共收藏 %d 道题目",[CETAdapter numberOfCollectionsInSection:indexPath.row + 1]];
//    cell.textLabel.textColor = [UIColor whiteColor];
//    cell.textLabel.shadowColor = [UIColor grayColor];
//    cell.textLabel.shadowOffset = CGSizeMake(0, -1);
    cell.textLabel.textColor = [UIColor colorWithRed:0.475 green:0.314 blue:0.286 alpha:1.0];
    cell.textLabel.highlightedTextColor = [UIColor colorWithRed:0.820 green:0.290 blue:0.216 alpha:1.0];
    cell.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:0.667 green:0.471 blue:0.427 alpha:1.0];
    cell.detailTextLabel.highlightedTextColor = [UIColor colorWithRed:0.820 green:0.290 blue:0.216 alpha:1.0];
//    cell.detailTextLabel.textColor = [UIColor colorWithRed:1.0 green:0.965 blue:0.906 alpha:1.0];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_sectionArray count];
}

#pragma mark UITabelViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 35;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",[_sectionArray objectAtIndex:indexPath.row]);
    if ([CETAdapter numberOfCollectionsInSection:indexPath.row + 1] == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"这部分还没有收藏任何题目哦～" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
    else {
        FavQuesViewController * fav = [[FavQuesViewController alloc] initWithSection:indexPath.row + 1];
        [XAppDelegate.navigationController pushViewController:fav animated:YES];
    }
}
@end
