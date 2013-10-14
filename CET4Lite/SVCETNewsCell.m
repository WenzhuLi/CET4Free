//
//  SVCETNewsCell.m
//  CET4Free
//
//  Created by Lee Seven on 13-9-23.
//  Copyright (c) 2013年 iyuba. All rights reserved.
//

#import "SVCETNewsCell.h"

@implementation SVCETNewsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        UIImageView * background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, kNewsCellHeight)];
//        background.image = [UIImage imageNamed:@"yearsCellBG.png"];
//        [self.contentView addSubview:background];
//        self.contentView.frame = CGRectMake(0, 0, 320, kNewsCellHeight);
        if (IS_IPAD) {
            self.backgroundColor = [UIColor clearColor];
            self.backgroundView = nil;
            self.textLabel.textColor = [UIColor colorWithRed:0.475 green:0.314 blue:0.286 alpha:1.0];
            self.textLabel.highlightedTextColor = [UIColor colorWithRed:0.820 green:0.290 blue:0.216 alpha:1.0];
            self.detailTextLabel.highlightedTextColor = [UIColor colorWithRed:0.820 green:0.290 blue:0.216 alpha:1.0];
            self.detailTextLabel.textColor = [UIColor colorWithRed:0.667 green:0.471 blue:0.427 alpha:1.0];
            self.highlightedImg = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
            [self insertSubview:self.highlightedImg atIndex:0];
            self.highlightedImg.hidden = YES;
            self.highlightedImg.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        }
        else{
            self.backgroundColor = [UIColor clearColor];
            self.backgroundView = nil;
            self.textLabel.textColor = [UIColor whiteColor];
            self.textLabel.shadowColor = [UIColor brownColor];
            self.textLabel.shadowOffset = CGSizeMake(1, 1);
            self.detailTextLabel.textColor = [UIColor lightGrayColor];
            UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, kNewsCellHeight - 3, 320, 3)];
            line.image = [UIImage imageNamed:@"WordSepLineNew.png"];
            [self.contentView addSubview:line];
        }
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    if (IS_IPAD) {
        self.textLabel.highlighted = selected;
        if (!self.highlightedImg.image) {
            [self.highlightedImg setImage:[[UIImage imageNamed:@"ipad_cell_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(16, 16, 16, 16)]];
        }
        self.detailTextLabel.highlighted = selected;
        self.highlightedImg.hidden = !selected;
        self.accessoryType = selected ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
    }
    // Configure the view for the selected state
}

@end
