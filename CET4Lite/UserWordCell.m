//
//  UserWordCell.m
//  CET4Lite
//
//  Created by Seven Lee on 12-3-21.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "UserWordCell.h"

@implementation UserWordCell
@synthesize WordLabel;
@synthesize DefLabel;
@synthesize PlaySoundButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (IS_IPAD) {
        self.WordLabel.highlighted = selected;
        if (!self.highlightedImg.image) {
            [self.highlightedImg setImage:[[UIImage imageNamed:@"ipad_cell_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(16, 16, 16, 16)]];
        }
        self.DefLabel.highlighted = selected;
        self.highlightedImg.hidden = !selected;
    }
}

@end
