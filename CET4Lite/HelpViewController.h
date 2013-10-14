//
//  HelpViewController.h
//  CET4Lite
//
//  Created by Seven Lee on 12-4-27.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController<UIScrollViewDelegate>{
    IBOutlet UIScrollView * scroll;
    IBOutlet UIPageControl * pageControl;
}
@property (nonatomic, strong) IBOutlet UIScrollView * scroll;
@property (nonatomic, strong) IBOutlet UIPageControl * pageControl;

@end
