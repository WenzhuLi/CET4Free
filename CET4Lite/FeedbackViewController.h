//
//  FeedbackViewController.h
//  CET4Lite
//
//  Created by Seven Lee on 12-4-23.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "RegexKitLite.h"

@interface FeedbackViewController : UIViewController<ASIHTTPRequestDelegate,UITextViewDelegate>{
    IBOutlet UITextView * ContentText;
    IBOutlet UITextField * EmailField;
}
@property (nonatomic, strong) IBOutlet UITextField * EmailField;
@property (nonatomic, strong) IBOutlet UITextView * ContentText;

- (void)sendFeedback;

@end
