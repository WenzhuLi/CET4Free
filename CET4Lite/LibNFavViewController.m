//
//  LibNFavViewController.m
//  CET4Lite
//
//  Created by Seven Lee on 12-9-20.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "LibNFavViewController.h"
#import "Year.h"
#import "TestViewController_iPad.h"
#import "AppDelegate.h"
#import "QuestionsViewController.h"

@interface LibNFavViewController ()

@end

@implementation LibNFavViewController
@synthesize sectionC;
@synthesize sectionA;
@synthesize sectionB;
@synthesize tableView;
@synthesize AButton;
@synthesize BButton;
@synthesize CButton;

- (IBAction)SectionSelect:(UIButton *)sender {
    _section = sender.tag;
    [self unSelectAll];
    sender.selected = YES;
    [self.view bringSubviewToFront:sender];
}
- (void)unSelectAll{
    self.sectionA.selected = NO;
    self.sectionB.selected = NO;
    self.sectionC.selected = NO;
}
- (void)viewDidAppear:(BOOL)animated{
    [self.tableView reloadData];
}
- (id)initWithType:(LibViewControllerType) type
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        _type = type;
        _section = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IS_IOS7 && !IS_IPAD) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.translucent = NO;
    }
    // Do any additional setup after loading the view from its nib.
    NSDictionary * yeadDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"libarary" ofType:@"plist"]];
    NSEnumerator * enu = [yeadDictionary keyEnumerator];
    NSMutableArray * arry = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSString * key in enu) {
        Year * year = [[Year alloc] initWithText:key andInt:[[yeadDictionary objectForKey:key] integerValue]];
        [arry addObject:year];
    }
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wood_pattern"]];
    _array = [[NSArray alloc] initWithArray:[arry sortedArrayUsingSelector:@selector(compare:)]];
    _sections = [NSArray arrayWithObjects:@"Section A",@"Section B",@"Section C", nil];
    [self SectionSelect:sectionA];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setAButton:nil];
    [self setBButton:nil];
    [self setCButton:nil];
    _array = nil;
    [self setSectionA:nil];
    [self setSectionB:nil];
    [self setSectionC:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"iPadLibViewCell"];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"iPadLibViewCell"];
    
    Year * y = [_array objectAtIndex:indexPath.row];
    cell.textLabel.text = y.text;
    cell.textLabel.textColor = [UIColor colorWithRed:0.475 green:0.314 blue:0.286 alpha:1.0];
    cell.textLabel.highlightedTextColor = [UIColor colorWithRed:0.820 green:0.290 blue:0.216 alpha:1.0];
//    cell.textLabel.shadowColor = [UIColor grayColor];
//    cell.textLabel.shadowOffset = CGSizeMake(0, -1);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor clearColor];
//    cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sectionABCBG.png"]];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_array count];
}

#pragma mark UITabelViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 35;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    TestViewController_iPad * test = [[TestViewController_iPad alloc] init];
//    [XAppDelegate.navigationController pushViewController:test animated:YES];
    Year *y = [_array objectAtIndex:indexPath.row];
    QuestionsViewController * test = [[QuestionsViewController alloc] initWithYear:y.intValue andSec:_section];
    test.navTitle = [NSString stringWithFormat:@"%@ %@",y.text, [_sections objectAtIndex:_section - 1]];
    [XAppDelegate.navigationController pushViewController:test animated:YES];
}
@end
