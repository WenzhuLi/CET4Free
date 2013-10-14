//
//  CETNewsViewController_iPad.m
//  CET4Free
//
//  Created by Lee Seven on 13-9-30.
//  Copyright (c) 2013年 iyuba. All rights reserved.
//

#import "CETNewsViewController_iPad.h"
#import "SVPullToRefresh.h"
#import "SBJSON.h"
#import "AppDelegate.h"
#import "database.h"
#import "NSString+MD5.h"
#import "NSString+SBJSON.h"
#import "SVPullToRefresh.h"
#import "ALAlertBanner.h"
#import "SVCETNewsCell.h"
#import "SVSingleBlogViewController.h"
#import "CETNewsViewController.h"
#define PROTOCOLSUFFIX @"http://api.iyuba.com.cn/v2/api.iyuba?protocol=20006"
#define kPageCounts @"20"
#define kCET4UserID @"242141"  //@"242141"
@interface CETNewsViewController_iPad ()
@property (nonatomic, strong)NSMutableArray * newsArray;
@property (nonatomic, strong)ASIHTTPRequest * newsRequest;
@property (nonatomic, assign)NSInteger newsPage;
@property (nonatomic, assign)BOOL shouldLoadMore;
@property (nonatomic, strong) SVSingleBlogViewController * blogDetail;
@end

@implementation CETNewsViewController_iPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.newsPage = 1;
        self.shouldLoadMore = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadNewsFromDisk];
    __weak CETNewsViewController_iPad * weakSelf = self;
    [self.newsTable addPullToRefreshWithActionHandler:^{
        [weakSelf reloadNews];
    }];
    [self.newsTable addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadNewsPage];
    }];
    self.newsTable.infiniteScrollingView.enabled = NO;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wood_pattern"]];
}
- (void)viewDidAppear:(BOOL)animated{
    if (!self.newsArray || [CETNewsViewController hasNew]) {
        [self.newsTable triggerPullToRefresh];
        [CETNewsViewController setHasNew:NO];
//        [XAppDelegate.tabbarController setBadgeValue:@"" atIndex:3];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadNewsFromDisk{
    self.newsArray = [CETNewsViewController getSavedNewsFromDisk];
    [self.newsTable reloadData];
}
- (void)reloadNews{
    _newsPage = 1;
    [self loadNewsPage];
}
- (void)showError:(NSString *)err{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.newsTable animated:YES];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-X.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = err;
    [hud show:YES];
    [hud hide:YES afterDelay:2];
}
- (void)showNewNumber:(NSInteger)newNumber{
    NSString * message = newNumber > 0 ?[NSString stringWithFormat:@"%d条新资讯",newNumber] : @"暂时没有新资讯哦^_^";
    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.newsTable
                                                        style:ALAlertBannerStyleSuccess
                                                     position:ALAlertBannerPositionTop
                                                        title:message
                                                     subtitle:nil];
    
    [banner show];
}
- (void)loadNewsPage{
    if (self.newsRequest) {
        [self.newsRequest clearDelegatesAndCancel];
        [self.newsRequest setCompletionBlock:nil];
        self.newsRequest = nil;
    }
    NSString * protocol = PROTOCOLSUFFIX;
    NSString * sign = [[NSString stringWithFormat:@"20006%@iyubaV2",kCET4UserID] MD5String];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:sign forKey:@"sign"];
    [params setObject:kCET4UserID forKey:@"id"];
    [params setObject:[NSString stringWithFormat:@"%d",_newsPage] forKey:@"pageNumber"];
    [params setObject:kPageCounts forKey:@"pageCounts"];
    NSEnumerator * keys = [params keyEnumerator];
    for (NSString * key in keys) {
        NSString * value = [params objectForKey:key];
        NSLog(@"key:%@,value:%@",key,value);
        protocol = [protocol stringByAppendingFormat:@"&%@=%@",key,value];
    }
    protocol = [protocol stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"protocol:%@",protocol);
    self.newsRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:protocol]];
    
    __weak CETNewsViewController_iPad * weakSelf = self;
    [self.newsRequest setFailedBlock:^{
        [weakSelf doneLoadingTableViewData];
        [weakSelf showError:@"网络不给力啊"];
    }];
    
    [self.newsRequest setCompletionBlock:^{
        NSString * result = [weakSelf.newsRequest responseString];
        NSDictionary * jsonDict = [result JSONValue];
        NSInteger resultCode = [[jsonDict objectForKey:@"result"] integerValue];
        NSLog(@"result:%@",jsonDict);
        if (resultCode == 251) {
            
            NSArray * dataArray = [jsonDict objectForKey:@"data"];
            NSInteger count = [dataArray count];
            NSMutableArray * blogArray = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i < count; i++) {
                NSDictionary * blogData = [dataArray objectAtIndex:i];
                SVBlog * blog = [SVBlog blogWithID:[blogData objectForKey:@"blogid"]];
                blog.message = [blogData objectForKey:@"message"];
                blog.subject = [blogData objectForKey:@"subject"];
                blog.dateLine = [NSDate dateWithTimeIntervalSince1970:[[blogData objectForKey:@"dateline"] integerValue]];
                blog.favTimes = [[blogData objectForKey:@"favtimes"] integerValue];
                blog.shareTimes = [[blogData objectForKey:@"sharetimes"] integerValue];
                blog.replyNumber = [[blogData objectForKey:@"replynum"] integerValue];
                blog.privacy = [[blogData objectForKey:@"friend"] integerValue];
                blog.viewNumber = [[blogData objectForKey:@"viewnum"] integerValue];
                blog.noReply = [[blogData objectForKey:@"noreply"] integerValue];
                [blogArray addObject:blog];
            }
            NSInteger numberOfNews = 0;
            if (weakSelf.newsArray.count > 0) {
                SVBlog * newest = [weakSelf.newsArray objectAtIndex:0];
                for (int i = 0; i < blogArray.count; i++) {
                    SVBlog * current = [blogArray objectAtIndex:i];
                    if (![newest.blogId isEqualToString:current.blogId]) {
                        numberOfNews++;
                    }
                    else
                        break;
                }
            }
            else
                numberOfNews = blogArray.count;
            
            if (weakSelf.newsPage == 1) {
                weakSelf.newsArray = blogArray;
                weakSelf.newsTable.infiniteScrollingView.enabled = YES;
                [weakSelf showNewNumber:numberOfNews];
            }
            else{
                [weakSelf.newsArray addObjectsFromArray:blogArray];
                //                weakSelf.tableView.infiniteScrollingView.enabled = NO;
            }
            weakSelf.newsPage++;
            NSInteger lastPage = [[jsonDict objectForKey:@"lastPage"] integerValue];
            if (weakSelf.newsPage > lastPage) {
                weakSelf.newsTable.infiniteScrollingView.enabled = NO;
            }
            [weakSelf.newsTable reloadData];
            [weakSelf saveNewsData];
        }
        else{
            [weakSelf showError:@"服务器正忙，请稍候再试"];
        }
        [weakSelf performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5];
        
    }];
    self.newsRequest.timeOutSeconds = 30;
    self.newsRequest.numberOfTimesToRetryOnTimeout = 2;
    [self.newsRequest startAsynchronous];
}
- (void)saveNewsData{
    NSMutableData *data = [[NSMutableData alloc] init];
    /*
     NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
     [archiver encodeObject:dataDictionary forKey:key];
     */
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.newsArray forKey:@"news"];
    [archiver finishEncoding];
    [data writeToFile:[database CETNewsFilePath] atomically:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.newsArray.count;
}
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kNewsCellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CETNewsCell";
    SVCETNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SVCETNewsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    SVBlog * blog = [self.newsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = blog.subject;
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    cell.detailTextLabel.text = [formatter stringFromDate:blog.dateLine];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    SVBlog * blog = [self.newsArray objectAtIndex:indexPath.row];
    if (!self.blogDetail) {
        self.blogDetail =[[SVSingleBlogViewController alloc] initWithBlog:blog];
        CGRect frame = CGRectMake(354, 55, 440, 670);
        self.blogDetail.view.frame = frame;
        
        [self.view addSubview:self.blogDetail.view];
        self.blogDetail.view.autoresizingMask = UIViewAutoresizingNone;
    }
    else{
        self.blogDetail.myBlog = blog;
        self.blogDetail.view.hidden = NO;
    }
    self.closeButton.hidden = NO;
//    [self.navigationController pushViewController:blogController animated:YES];
}
#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    //	_reloading = YES;
    [self reloadNews];
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
    //	_reloading = NO;
	[self.newsTable.infiniteScrollingView stopAnimating];
    [self.newsTable.pullToRefreshView stopAnimating];
	
}
- (IBAction)closeWeb:(UIButton *)sender {
    self.closeButton.hidden = YES;
    self.blogDetail.view.hidden = YES;
}
@end
