//
//  MenuRootViewController.h
//  CET4Lite
//
//  Created by Seven Lee on 12-9-14.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SVSlideInView.h"

@interface MenuRootViewController : UIViewController<SVSlideInViewDelegate>{
    SVSlideInView * _slideIn;
    UINavigationController * _settingsNav;
    BOOL Tapped;
}
@property (strong, nonatomic) IBOutlet UIButton *scoreButton;
@property (strong, nonatomic) IBOutlet UIButton *wordsButton;
@property (strong, nonatomic) IBOutlet UIButton *favButton;
@property (strong, nonatomic) IBOutlet UIButton *libButton;
@property (strong, nonatomic) IBOutlet UIButton *newsButton;
@property (strong, nonatomic) IBOutlet UIImageView *userPicture;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (nonatomic,strong) SVSlideInView * slideIn;
//@property (strong, nonatomic) IBOutlet UIImageView *helpImgView;
@property (nonatomic, strong)UINavigationController * settingsNav;
@property (strong, nonatomic) IBOutlet UILabel *userName;
- (IBAction)wordsTapped:(id)sender;
- (IBAction)libraryTapped:(id)sender;
- (IBAction)favorateTapped:(id)sender;
- (IBAction)scoreTapped:(id)sender;
- (IBAction)accountTapped:(id)sender;
- (IBAction)feedbackTapped:(id)sender;
- (IBAction)settingTapped:(id)sender;
- (IBAction)newsTapped:(UIButton *)sender;
- (void)setNewsBadgeText:(NSString *)text;

@end
