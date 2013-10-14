//
//  SVSingleBlogViewController.h
//  iyuba
//
//  Created by Lee Seven on 12-12-21.
//  Copyright (c) 2012年 Lee Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "IyubaUser.h"
#import "SVBlog.h"
#import "MBProgressHUD.h"
#import "WordExplainView.h"

//#import "ASIHTTPRequest.h"

@interface SVSingleBlogViewController : UIViewController<UIWebViewDelegate,WordDelegate,ASIHTTPRequestDelegate>{
//    IyubaUser * _author;
    SVBlog * _myBlog;
    IBOutlet UIWebView * _webView;
//    DTAttributedTextContentView * _blogView;
    MBProgressHUD * HUD;
//    UIBarButtonItem * commentItem;
    BOOL _firstAppear;
    WordExplainView * _wordExplainView;
//    ASIHTTPRequest * blogRequest;
}
//@property (nonatomic, strong)IyubaUser * author;
@property (nonatomic, strong)SVBlog * myBlog;
- (id)initWithBlog:(SVBlog *)blog;
//- (id)initWithAuthor:(IyubaUser *)author andBlogID:(NSString *)blogid;

- (IBAction)markHighlightedString:(id)sender;
- (IBAction)getHighlightedString:(id)sender;


@end



