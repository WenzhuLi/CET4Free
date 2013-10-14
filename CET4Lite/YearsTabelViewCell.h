//
//  YearsTabelViewCell.h
//  CET4Lite
//
//  Created by Seven Lee on 12-3-21.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CET4Constents.h"

#define kYearsTabelViewCellHeight 55
@interface YearsTabelViewCell : UITableViewCell{
//    IBOutlet UILabel * yearLabel;
}
//@property (nonatomic, strong) IBOutlet UILabel * yearLabel;
@property (strong, nonatomic) UIImageView *logo;
@property (strong, nonatomic) UILabel *title;
@end
