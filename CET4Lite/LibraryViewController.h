//
//  LibraryViewController.h
//  CET4Lite
//
//  Created by Seven Lee on 12-2-24.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Year.h"
#import "UIFolderTableView.h"
#import "QuestionsViewController.h"

@interface LibraryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIFolderTableViewDelegate>
{
//    UIPickerView * picker;
    IBOutlet UIFolderTableView * LittleTable;
//    IBOutlet UIButton * pickButton;
//    IBOutlet UIImageView * EarPhoneIMG;
    NSArray * years;                //Year数组，包括年份string，如@“2011年12月”和int值，如201112
    NSArray * sections;             //要在picker中显示的Section，如@“SectionA”
    Year * chosedYear;              //选中的年份
    NSInteger chosedSection;        //选中的Section：1代表SectionA，2代表SectionB，3代表SectionC
//    CGRect TableHiddenFrame;
    IBOutlet UIImageView * TableBG;
//    IBOutlet UIButton * Arrow;
//    IBOutlet UIImageView * Hawk;
}
//@property (nonatomic, strong) UIPickerView * picker;
//@property (nonatomic, strong) IBOutlet UIButton * pickButton;
//@property (nonatomic, assign) CGRect TableHiddenFrame;
//@property (nonatomic, strong) IBOutlet UIButton * Arrow;
//@property (nonatomic, strong) IBOutlet UIImageView * EarPhoneIMG;
@property (nonatomic, strong) IBOutlet UIFolderTableView * LittleTable;
@property (strong, nonatomic) IBOutlet UIView *subFolderView;
@property (nonatomic, strong) NSArray * years;
@property (nonatomic, strong) NSArray * sections;
@property (nonatomic, strong) IBOutlet UIImageView * TableBG;
//@property (nonatomic, strong) IBOutlet UIImageView * Hawk;

//- (IBAction)buttonPressed:(UIButton *)button;
- (IBAction)beginExc:(UIButton *)sender;

@end
