//
//  LevelSetsCustomCell.m
//  What'sThat
//
//  Created by mac16 on 30/08/13.
//  Copyright (c) 2013 Vibhooti. All rights reserved.
//

#import "LevelSetsCustomCell.h"

@implementation LevelSetsCustomCell

@synthesize btnBackground,btnSetNo,btnScore,imgQuestionImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
