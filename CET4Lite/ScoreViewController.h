//
//  ScoreViewController.h
//  CET4Lite
//
//  Created by Seven Lee on 12-4-18.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ScoreTableCell.h"
#import "SVVerticalProgressBar.h"
@interface ScoreViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UILabel * AScoreLabel;
    IBOutlet UILabel * BScoreLabel;
    IBOutlet UILabel * CScoreLabel;
    IBOutlet UITableView * scoretable;
//    MBProgressHUD * HUD;
    NSMutableArray * ScoreInfoArray;
}
@property (nonatomic, strong) IBOutlet UILabel * AScoreLabel;
@property (nonatomic, strong) IBOutlet UILabel * BScoreLabel;
@property (nonatomic, strong) IBOutlet UILabel * CScoreLabel;
@property (nonatomic, strong) IBOutlet UITableView * scoretable;
@property (strong, nonatomic) IBOutlet SVVerticalProgressBar *AProgressBar;
@property (strong, nonatomic) IBOutlet SVVerticalProgressBar *BProgressBar;
@property (strong, nonatomic) IBOutlet SVVerticalProgressBar *CProgressBar;
@property (nonatomic, strong) NSMutableArray * ScoreInfoArray;
@end
