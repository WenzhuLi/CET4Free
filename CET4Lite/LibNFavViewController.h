//
//  LibNFavViewController.h
//  CET4Lite
//
//  Created by Seven Lee on 12-9-20.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
    LibViewControllerTypeLib,
    LibViewControllerTypeFav
} LibViewControllerType;
@interface LibNFavViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    LibViewControllerType _type;
    NSArray * _array;
    NSInteger _section;
    NSArray * _sections;
}
@property (strong, nonatomic) IBOutlet UIButton *sectionC;
@property (strong, nonatomic) IBOutlet UIButton *sectionA;
@property (strong, nonatomic) IBOutlet UIButton *sectionB;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *AButton;
@property (strong, nonatomic) IBOutlet UIButton *BButton;
@property (strong, nonatomic) IBOutlet UIButton *CButton;
- (IBAction)SectionSelect:(UIButton *)sender;
- (id)initWithType:(LibViewControllerType) type;
@end
