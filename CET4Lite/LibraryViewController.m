//
//  LibraryViewController.m
//  CET4Lite
//
//  Created by Seven Lee on 12-2-24.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "LibraryViewController.h"
#import "YearsTabelViewCell.h"
#import "CET4Constents.h"



@interface LibraryViewController ()

@end

@implementation LibraryViewController
//@synthesize picker;
@synthesize LittleTable;
//@synthesize pickButton;
@synthesize years;
@synthesize sections;
@synthesize TableBG;
//@synthesize Arrow;
//@synthesize Hawk;
//@synthesize TableHiddenFrame;
//@synthesize EarPhoneIMG;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.TableHiddenFrame = CGRectMake(64, 118, 192, 0);
    }
    return self;
}
//- (void)viewWillAppear:(BOOL)animated{
//    
//}
//- (void)viewDidDisappear:(BOOL)animated{
//    self.navigationItem.title = @"返回";
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.navigationItem.backBarButtonItem setTitle:@"返回"];
    self.navigationItem.title = @"英语四级真题";
    if (IS_IOS7 && !IS_IPAD) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        
    }
    self.navigationController.navigationBar.translucent = NO;
//    label.lineBreakMode = UILineBreakModeWordWrap;
//    label.numberOfLines = 0;
    /*
    Year * y14 = [[Year alloc] initWithText:@"2013年6月" andInt:201306];
    Year * y13 = [[Year alloc] initWithText:@"2012年12月" andInt:201212];
    Year * y0 = [[Year alloc] initWithText:@"2012年6月" andInt:201206];
    Year * y1 = [[Year alloc] initWithText:@"2011年12月" andInt:201112];
    Year * y2 = [[Year alloc] initWithText:@"2011年6月" andInt:201106];
    Year * y3 = [[Year alloc] initWithText:@"2010年12月" andInt:201012];
    Year * y4 = [[Year alloc] initWithText:@"2010年6月" andInt:201006];
    Year * y5 = [[Year alloc] initWithText:@"2009年12月" andInt:200912];
    Year * y6 = [[Year alloc] initWithText:@"2009年6月" andInt:200906];
    Year * y7 = [[Year alloc] initWithText:@"2008年12月" andInt:200812];
    Year * y8 = [[Year alloc] initWithText:@"2008年6月" andInt:200806];
    Year * y9 = [[Year alloc] initWithText:@"2007年12月" andInt:200712];
    Year * y10 = [[Year alloc] initWithText:@"2007年6月" andInt:200706];
    Year * y11 = [[Year alloc] initWithText:@"2006年12月" andInt:200612];
    Year * y12 = [[Year alloc] initWithText:@"2006年6月" andInt:200606];
    years = [[NSArray alloc] initWithObjects:y14,y13,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9,y10,y11,y12, nil ];
     */
    NSDictionary * yeadDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"libarary" ofType:@"plist"]];
    NSEnumerator * enu = [yeadDictionary keyEnumerator];
    NSMutableArray * arry = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSString * key in enu) {
        Year * year = [[Year alloc] initWithText:key andInt:[[yeadDictionary objectForKey:key] integerValue]];
        [arry addObject:year];
    }
    years = [[NSArray alloc] initWithArray:[arry sortedArrayUsingSelector:@selector(compare:)]];
    sections = [[NSArray alloc] initWithObjects:@"SectionA",@"SectionB",@"SectionC",nil];  
    chosedYear = [years objectAtIndex:0];
    chosedSection = 1;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultKeyLastChosen] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:12] forKey:kUserDefaultKeyLastChosen];
    }
    NSInteger intg = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultKeyLastChosen] intValue];
    chosedYear = [years objectAtIndex:intg];
//    [pickButton setTitle:chosedYear.text forState:UIControlStateNormal];
    self.LittleTable.rowHeight = kYearsTabelViewCellHeight;
    [self.LittleTable reloadData];
//    [self.Hawk setAnimationImages:[NSArray arrayWithObjects:[UIImage imageNamed:@"Hawk0.png"],[UIImage imageNamed:@"Hawk1.png"], nil]];
//    [self.Hawk setAnimationDuration:1];
//    [self.Hawk setAnimationRepeatCount:-1 ];
//    [self.Hawk startAnimating];
/*
    if (picker == nil) {
		picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 460, 320, 216)];
		picker.delegate = self;
		picker.dataSource = self;
		picker.showsSelectionIndicator = YES;
		[self.view addSubview:picker];
	}
 */

}
- (void)viewDidAppear:(BOOL)animated{
//    self.TableHiddenFrame = CGRectMake(64, 118, 192, 0);
    [self.LittleTable reloadData];
//    self.LittleTable.frame = self.TableHiddenFrame;
//    self.TableBG.frame = self.TableHiddenFrame;
//    self.Arrow.selected = NO;
//    self.EarPhoneIMG.alpha = 1;
}
- (void)viewWillDisappear:(BOOL)animated{
//    self.TableHiddenFrame = CGRectMake(64, 118, 192, 0);
//    self.LittleTable.frame = TableHiddenFrame;
//    self.TableBG.frame = TableHiddenFrame;
//    self.Arrow.selected = NO;
//    self.EarPhoneIMG.alpha = 1;
}
- (void)viewDidUnload
{
    [self setSubFolderView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
//    self.picker = nil;
//    self.pickButton = nil;
    self.LittleTable = nil;
//    self.label = nil;
//    self.EarPhoneIMG = nil;
    self.TableBG = nil;
//    self.Arrow = nil;
//    self.Hawk = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
/*
#pragma mark year and section select

- (IBAction)buttonPressed:(UIButton *)button{
    //show pickerView
//    self.TableHiddenFrame = CGRectMake(64, 118, 192, 0);
    if (!Arrow.selected) {
        [UIView beginAnimations: @"Animation" context:nil];
        [UIView setAnimationDuration:0.3]; 
//        picker.frame = CGRectMake(0, 152, 320, 216);
        LittleTable.frame = CGRectMake(TableHiddenFrame.origin.x, TableHiddenFrame.origin.y, TableHiddenFrame.size.width, 100);
        self.EarPhoneIMG.alpha =0;
        TableBG.frame = LittleTable.frame;
        Arrow.selected = !Arrow.selected;
        [UIView commitAnimations];
        [LittleTable flashScrollIndicators];
//        button.tag = 1;
//        Arrow.tag = 1;
//        [button setTitle:@"完成" forState:UIControlStateNormal];
    }
    else {
        [UIView beginAnimations:@"Animation" context:nil];
        [UIView setAnimationDuration:0.3];
//        picker.frame = CGRectMake(0, 460, 320, 216);
        LittleTable.frame = TableHiddenFrame;
        TableBG.frame = TableHiddenFrame;
        Arrow.selected = !Arrow.selected;
        self.EarPhoneIMG.alpha = 1;
        [UIView commitAnimations];
//        button.tag = 0;
//        Arrow.tag = 0;
//        [button setTitle:@"点我选题" forState:UIControlStateNormal];
//        label.text = [NSString stringWithFormat:@"您选择了%@的%@，点击下面的按钮开始做题吧^_^",[chosedYear myText],[sections objectAtIndex:chosedSection-1]];
    }
    
}
*/

- (IBAction)beginExc:(UIButton *)sender{
    chosedSection = sender.tag;
    QuestionsViewController * quesView = [[QuestionsViewController alloc] initWithYear:chosedYear.intValue andSec:chosedSection];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    quesView.navTitle = [NSString stringWithFormat:@"%@ %@",chosedYear.text, [sections objectAtIndex:chosedSection-1]];
    [quesView setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:quesView animated:YES];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YearsTabelViewCell * cell = (YearsTabelViewCell *)[tableView dequeueReusableCellWithIdentifier:kYearChooseCellReuseID];
    if (!cell) {
        cell = [[YearsTabelViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kYearChooseCellReuseID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell = (YearsTabelViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"YearsTableViewCellView" 
//                                                              owner:self 
//                                                            options:nil] objectAtIndex:0];
    }
    Year * y = [years objectAtIndex:indexPath.row];
//    cell.yearLabel.text = y.text;
    cell.title.text = y.text;
    cell.logo.image = [UIImage imageNamed:@"yearCellLogo0.png"];
    cell.backgroundColor = [UIColor blueColor];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [years count];
}

#pragma mark UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kYearsTabelViewCellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.LittleTable.scrollEnabled = NO;
    UIFolderTableView *folderTableView = (UIFolderTableView *)tableView;
    [folderTableView openFolderAtIndexPath:indexPath WithContentView:self.subFolderView
                                 openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                     // opening actions
                                 }
                                closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                    // closing actions
                                }
                           completionBlock:^{
                               // completed actions
                               self.LittleTable.scrollEnabled = YES;
                           }];
//    [UIView beginAnimations:@"Animation" context:nil];
//    [UIView setAnimationDuration:0.3];
    //        picker.frame = CGRectMake(0, 460, 320, 216);
//    LittleTable.frame = TableHiddenFrame;
//    TableBG.frame = TableHiddenFrame;
//    Arrow.selected = !Arrow.selected;
//    self.EarPhoneIMG.alpha = 1;
//    [UIView commitAnimations];
//    pickButton.tag = 0;
    //        [button setTitle:@"点我选题" forState:UIControlStateNormal];
//    label.text = [NSString stringWithFormat:@"您选择了%@的%@，点击下面的按钮开始做题吧^_^",[chosedYear myText],[sections objectAtIndex:chosedSection-1]];
    chosedYear = [years objectAtIndex:indexPath.row];
//    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:indexPath.row] forKey:kUserDefaultKeyLastChosen];
//    [pickButton setTitle:chosedYear.text forState:UIControlStateNormal];
    
}

@end
