//
//  DeleteDataViewController.h
//  CET4Lite
//
//  Created by Seven Lee on 12-4-18.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CET4Constents.h"

@interface DeleteDataViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    NSMutableArray * DirectoryArray;
    IBOutlet UITableView * table;
}
@property (nonatomic, strong) NSMutableArray * DirectoryArray;
@property (nonatomic, strong) IBOutlet UITableView * table;
@end
