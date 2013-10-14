//
//  WordDetailViewController.h
//  CET4Lite
//
//  Created by Seven Lee on 12-9-14.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Word.h"
#import "MBProgressHUD.h"

@interface WordDetailViewController : UIViewController{
    Word * _word;
    MBProgressHUD * HUD;
}

- (id) initWithWord:(Word *) word;
@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;
@property (nonatomic, strong) Word * word;
@property (strong, nonatomic) IBOutlet UILabel *wordNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *wordDefLabel;
@property (strong, nonatomic) IBOutlet UILabel *pronounceLabel;
- (IBAction)playSound:(id)sender;
- (IBAction)close:(id)sender;

@end
