//
//  CETNewsViewController_iPad.h
//  CET4Free
//
//  Created by Lee Seven on 13-9-30.
//  Copyright (c) 2013年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "SVBlog.h"
@interface CETNewsViewController_iPad : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSInteger _newsPage;
    BOOL _shouldLoadMore;
}
@property (strong, nonatomic) IBOutlet UIButton *closeButton;

- (IBAction)closeWeb:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITableView *newsTable;

@end
