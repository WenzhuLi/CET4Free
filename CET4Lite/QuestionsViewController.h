//
//  QuestionsViewController.h
//  CET4Lite
//
//  Created by Seven Lee on 12-2-29.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PlausibleDatabase/PlausibleDatabase.h>
#import "CETAdapter.h"
#import "TextAView.h"
#import "DownloaderView.h"
#import "AudioPlayerView.h"
#import "ExplainView.h"
#import "QuestionCView.h"
#import "WordExplainView.h"
#import "AnswerSheetAB.h"
#import "AnswerSheetC.h"
#import "LoginViewController.h"
#import "SevenNavigationBar.h"
//#import "SVShareTool.h"
//#import "ROConnect.h"
#import "SVSlideInView.h"
#import "AnswerCViewController_iPad.h"
#import "SVStoreKit.h"
//#import "YouMiView.h"
#import "GADBannerView.h"

//显示题目页面的Controller
@interface QuestionsViewController : UIViewController<UIScrollViewDelegate,UIAlertViewDelegate,DownloaderViewDelegate,UINavigationControllerDelegate,AnswerSheetDelegate,QuestionCViewCollectDlegate,MBProgressHUDDelegate,UIActionSheetDelegate,CETAdapterDelegate,UITextFieldDelegate,SVSlideInViewDelegate,SVStoreKitDelegate,ASIHTTPRequestDelegate,GADBannerViewDelegate>{
    NSInteger year;                         //当前选中的年份
    NSInteger section;                      //当前选中的Section
    IBOutlet UIButton * QNobtn;             //显示题号的Button
    IBOutlet UIScrollView * scroll;         //题目所在的Scrollview
    NSString * navTitle;                    //Navigation上显示的标题
    NSInteger currentPage;                  //当前Page号
    TextView * textView;                   //原文View
    CETAdapter * adpter;                    //与数据库和各个子View之间的连接类,功能集中处
    ExplainView * expView;
    QuestionCView * QCView;
    IBOutlet UILabel * NoLabel;
    IBOutlet UIButton * AnswerC;            //SectionC答题
    IBOutlet UIButton * ExplainBtn;
    IBOutlet UIButton * CollectButton;
    IBOutlet UIImageView * RoundBack;
    IBOutlet UIButton *textButton;
    AnswerSheet * answerSheet;
    IBOutlet UIButton * ShowButton;
    DownloaderView * down;
    BOOL FirstAppear;
    IBOutlet UIButton * RightArrowImg;
    IBOutlet UIButton * LeftArrowImg;
    BOOL iPad;
    SVSlideInView * slidIn;
    UINavigationController * navBar;
    UIPopoverController * iPadPop;
    AnswerCViewController_iPad * cview;
    SVStoreKit * storeKit;
    MBProgressHUD * HUD;
    IBOutlet UIView *titleView;
    BOOL _adRemoved;
    GADBannerView * adView;
    ASIHTTPRequest * shareRequest;
    UIButton * shareButton;
    UIButton * adclosebutton;
    NSTimer * adViewTimer;
//    YouMiView * youmiView;
//    BOOL ipadTextReturn;
//    AudioPlayerView * PlayerView;
}
@property (nonatomic, strong)SVSlideInView * slidIn;
@property (nonatomic, strong) IBOutlet UIButton * QNobtn;
@property (nonatomic, strong) IBOutlet UIButton * ExplainBtn;
@property (nonatomic, strong) IBOutlet UIScrollView * scroll;
@property (nonatomic, strong) IBOutlet UILabel * NoLabel;
@property (nonatomic, strong) NSString * navTitle;
@property (nonatomic, strong) IBOutlet UIButton * AnswerC;
@property (nonatomic, strong) IBOutlet UIButton * CollectButton;
@property (nonatomic, strong) IBOutlet IBOutlet UIImageView * RoundBack;
@property (nonatomic, strong) AnswerSheet * answerSheet;
@property (nonatomic, strong) IBOutlet UIButton * ShowButton;
@property (nonatomic, strong) IBOutlet UIButton * RightArrowImg;
@property (nonatomic, strong) IBOutlet UIButton * LeftArrowImg;
//@property (nonatomic, strong) AudioPlayerView * PlayerView;
@property (strong, nonatomic) IBOutlet UIScrollView *AnswerCScrollview_iPad;

- (void) popController;
- (id) initWithYear:(NSInteger)y andSec:(NSInteger)sec;

//点下原文按钮时触发的事件
- (IBAction)SeeTheText:(UIButton *)sender;
- (IBAction)RollScroll:(UIButton *)sender;
- (IBAction)NewCollection:(UIButton *)sender;
- (IBAction)HideOrShowAnswerSheet:(UIButton *)sender;
- (IBAction)SeeTheTextIPAD:(UIButton *)sender;
//- (void)BackbarbuttonItemPressed:(UIBarButtonItem *)item;
- (IBAction)playQuestionSound:(UIButton *)sender;

@end
