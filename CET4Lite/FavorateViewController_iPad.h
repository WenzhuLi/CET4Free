//
//  FavorateViewController_iPad.h
//  CET4Lite
//
//  Created by Seven Lee on 12-9-24.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavorateViewController_iPad : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    NSArray * _sectionArray;
    NSMutableArray * _numberArray;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
