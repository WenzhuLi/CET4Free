//
//  FavQuesViewController.h
//  CET4Lite
//
//  Created by Seven Lee on 12-4-5.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExplainView.h"
#import "TextView.h"
#import "QuestionCView.h"
#import "Question.h"
#import "CETAdapter.h"
#import "DownloaderView.h"
//#import "YouMiView.h"
#import "SVStoreKit.h"
#import "MBProgressHUD.h"
#import "GADBannerView.h"

@interface FavQuesViewController : UIViewController<UIScrollViewDelegate,DownloaderViewDelegate,UINavigationControllerDelegate,AnswerCDelegate,UITextFieldDelegate,SVStoreKitDelegate,GADBannerViewDelegate>{
    NSInteger Section;
    IBOutlet UIButton * QNobtn;             //显示题号的Button
    IBOutlet UIScrollView * scroll;         //题目所在的Scrollview
    NSString * navTitle;                    //Navigation上显示的标题
    NSInteger currentPage;                  //当前Page号
    TextView * textView;                   //原文View
//    CETAdapter * adpter;                    //与数据库和各个子View之间的连接类,功能集中处
    ExplainView * expView;
//    QuestionCView * QCView;
    IBOutlet UILabel * NoLabel;
//    IBOutlet UIButton * AnswerC;            //SectionC答题
    IBOutlet UIButton * ExplainBtn;
    IBOutlet UIButton * CollectButton;
    IBOutlet UIImageView * RoundBack;
    NSMutableArray * QuestionArray;
    CETAdapter * adpter;
    NSDictionary * DisplayDic;
    NSMutableArray * AnswerViewArray;
    IBOutlet UIImageView * flowerBack;
    IBOutlet UIButton * TextBTN;
    DownloaderView * down;
    IBOutlet UIButton * RightArrowImg;
    IBOutlet UIButton * LeftArrowImg;
    BOOL isPad;
    UIPopoverController * iPadPop;
//    YouMiView * youmiView;
    GADBannerView * adView;
    BOOL _adRemoved;
    IBOutlet UIView *titleView;
    SVStoreKit * storeKit;
    MBProgressHUD * HUD;
    UIButton * adclosebutton;
    NSTimer * adViewTimer;
    BOOL firstAppear;
}
@property (nonatomic, strong) IBOutlet UIButton * QNobtn;
@property (nonatomic, strong) IBOutlet UIButton * ExplainBtn;
@property (nonatomic, strong) IBOutlet UIScrollView * scroll;
@property (nonatomic, strong) IBOutlet UILabel * NoLabel;
@property (nonatomic, strong) NSString * navTitle;
//@property (nonatomic, strong) IBOutlet UIButton * AnswerC;
@property (nonatomic, strong) IBOutlet UIButton * CollectButton;
@property (nonatomic, strong) IBOutlet IBOutlet UIImageView * RoundBack;
@property (nonatomic, strong) NSMutableArray * QuestionArray;
@property (nonatomic, strong) CETAdapter * adpter;
@property (nonatomic, strong) IBOutlet UIButton * RightArrowImg;
@property (nonatomic, strong) IBOutlet UIButton * LeftArrowImg;

- (id)initWithSection:(NSInteger)sec;
- (IBAction)SeeTheText:(UIButton *)sender;
- (IBAction)DeleteCollection:(UIButton *)sender;
- (IBAction)RollScroll:(UIButton *)sender;
- (IBAction)SeeTheTextPad:(UIButton *)sender;
@end
