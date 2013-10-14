//
//  NewWordsViewController_iPad.h
//  CET4Lite
//
//  Created by Seven Lee on 12-9-14.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface NewWordsViewController_iPad : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray * jjjjjjArray;
    IBOutlet UITableView * tabelView;
    MBProgressHUD * HUD;
    NSMutableArray * ToDeleteArray;

}
@property (nonatomic, strong) NSMutableArray * jjjjjjArray;
@property (nonatomic, strong) IBOutlet UITableView * tabelView;
@property (nonatomic, strong) NSMutableArray * ToDeleteArray;
- (IBAction)doSeg:(UISegmentedControl *)sender;
- (IBAction)buttonAction:(UIButton *)sender;
@end
