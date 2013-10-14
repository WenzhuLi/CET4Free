//
//  ScoreTableCell.h
//  CET4Lite
//
//  Created by Seven Lee on 12-3-29.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CET4Constents.h"

@interface ScoreTableCell : UITableViewCell{
    IBOutlet UILabel * TestTimeLabel;
    IBOutlet UILabel * DateLabel;
    IBOutlet UILabel * RateLabel;
}
@property (nonatomic, strong) IBOutlet UILabel * TestTimeLabel;
@property (nonatomic, strong) IBOutlet UILabel * DateLabel;
@property (nonatomic, strong) IBOutlet UILabel * RateLabel;
@end
