//
//  CETNewsViewController.h
//  CET4Free
//
//  Created by Lee Seven on 13-9-11.
//  Copyright (c) 2013年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "SVBlog.h"

@interface CETNewsViewController : UITableViewController{
    NSInteger _newsPage;
    BOOL _shouldLoadMore;
}
+ (NSMutableArray *)getSavedNewsFromDisk;
+ (SVBlog *)theNewestBlogSaved;
+ (void) setHasNew:(BOOL)_hasnew;
+ (BOOL) hasNew;
@end
