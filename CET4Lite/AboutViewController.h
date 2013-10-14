//
//  AboutViewController.h
//  CET4Lite
//
//  Created by Seven Lee on 12-4-23.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InforController.h"
#import "Reachability.h"
#import "MBProgressHUD.h"

@interface AboutViewController : UIViewController{
    MBProgressHUD * HUD;
}

@property (strong, nonatomic) IBOutlet UILabel *versionLabel;
- (IBAction)goUrl:(id)sender;
- (BOOL) isExistenceNetwork:(NSInteger)choose;
- (IBAction)OtherApps:(UIButton *)sender;
- (IBAction)followWeibo:(UIButton *)sender;
@end
