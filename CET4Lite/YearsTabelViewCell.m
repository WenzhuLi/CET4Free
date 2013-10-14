//
//  YearsTabelViewCell.m
//  CET4Lite
//
//  Created by Seven Lee on 12-3-21.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "YearsTabelViewCell.h"

@implementation YearsTabelViewCell
//@synthesize yearLabel;
@synthesize logo=_logo;
@synthesize title=_title;
//@synthesize subTtile=_subTtile;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LittleTableBG.png"]];
        UIImageView * background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, kYearsTabelViewCellHeight)];
        background.image = [UIImage imageNamed:@"yearsCellBG.png"];
        [self.contentView addSubview:background];
        self.contentView.frame = CGRectMake(0, 0, 320, kYearsTabelViewCellHeight);
        self.logo = [[UIImageView alloc] initWithFrame:CGRectMake(70, 10, 28, 32)];
        self.logo.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.logo];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, 160, 32)];
        self.title.font = [UIFont systemFontOfSize:18.0f];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.textColor = [UIColor whiteColor];
        self.title.opaque = NO;
        [self.contentView addSubview:self.title];
        
//        self.subTtile = [[UILabel alloc] initWithFrame:CGRectMake(80, 40, 230, 14)];
//        self.subTtile.font = [UIFont systemFontOfSize:12.0f];
//        self.subTtile.textColor = [UIColor colorWithRed:158/255.0
//                                                  green:158/255.0
//                                                   blue:158/255.0
//                                                  alpha:1.0];
//        self.subTtile.backgroundColor = [UIColor clearColor];
//        self.subTtile.opaque = NO;
//        [self.contentView addSubview:self.subTtile];
        
//        [self.contentView addSubview:sLine1];
//        [self.contentView addSubview:sLine2];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
