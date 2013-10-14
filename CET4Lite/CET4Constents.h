//
//  CET4Constents.h
//  CET4Lite
//
//  Created by Seven Lee on 12-4-26.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#ifndef CET4Lite_CET4Constents_h
#define CET4Lite_CET4Constents_h


#define kSpeakBackgroundWidth   238
#define kSpeakBackgroundHeight  65
#define kEdgeInsetsTopReal      35
#define kEdgeInsetsTop          6
#define kEdgeInsetsBottom       6
#define kEdgeInsetsLeft         29
#define kEdgeInsetsRight        6
#define kMinContentHeight       55
#define kPictureWidth           40
#define kPictureHeight          65


//数据库中表格名字,做CET6时直接更换
#define kTableNameAnswera   @"answera4"
#define kTableNameAnswerb   @"answerb4"
#define kTableNameAnswerc   @"answerc4"
#define kTableNameTexta     @"texta4"
#define kTableNameTextb     @"textb4"
#define kTableNameTextc     @"textc4"
#define kTableNameExplain   @"explain4"

#define DOCUMENTS_FOLDER [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define CACHES_FOLDER [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]


#define kNumberofKeywords 3         //keywords的个数

#define kUserDefaultKeyLastChosen @"UserLastChosen"
#define kLoggedUserKey @"LoggedUser"
#define kLoggedUserID   @"LoggedUserID"
#define kMyAppService    @"com.seven.CET4Lite"
#define kLoggedUserIsVIP @"LoggedUserIsVIP"
#define kLoggedUserVIPTime @"LoggedUserVIPTime"
#define kLoggedUserXDFCode10 @"LoggedUserXDFCode10"
#define kLoggedUserXDFCode30 @"LoggedUserXDFCode30"

#define kCurrentVersion @"CurrentVersion"
#define kVersionNo 2.1
#define kScoreTableCellReuseID @"ScoreTableCell"
#define kUsrWordCellReuseID @"UserWordCell"
#define kYearChooseCellReuseID @"YearChooseCell"

#define kMyAppleID @"529455490"
#define kMYFLURRY_KEY @"52KADD17BXJCZGPF9V7H"

#define ShareSDKID @"37020099fa2"
#define WB_APP_KEY				@"3971509847"		//CET4
#define WB_APP_SEC			@"2aba79791bb4e0d8f865fc69e8c452ac"		//CET4
#define WB_URI @"http://iyuba.com"
#define REDIRECT_URL_DEFAULT kMyWebLink
#define TCWB_APP_KEY @"801189043"
#define TCWB_APP_SEC @"ab42740987603a13cfbf75bfee7b549f"
#define TCWB_URL @"https://play.google.com/store/apps/details?id=com.iyuba.cet4"
#define WX_APPID @"wx4fdaa74db6aceaff"
#define WX_APPKEY @"346f4751290e781ebf5b78ef37b6501a"
#define RR_APP_ID     @"26202"
#define RR_API_Key    @"6dd31695b4e34a1a8bb477364380f250"
#define RR_APP_SEC     @"41ebb79543ee485592bc122427ef0fd1"
#define kMyAppStoreLink [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@/",kMyAppleID]
#define kMyWebLink @"http://itunes.apple.com/cn/app/ying-yu-si-ji-ting-lifree/id529455490?ls=0&mt=8"
#define kMyAPKLink @"http://api.iyuba.com/data/app/android-apk/CET4.apk"
#define kMyRenRenImage @"http://app.iyuba.com/ios/icons/cet4icon.png"

#define IAPAlertTagText 91
#define IAPAlertTagExplain 92

#define IAPIDText @"com.iyuba.CET4Free.Text"
#define IAPIDExplain @"com.iyuba.CET4Free.Explain"

#define MY_GAD_ID @"a15077d5591473c"
#define MY_IYUBA_APPID @"207"
#define kMyPushTokenKey @"DeviceTokenStringBBCW"
#endif
