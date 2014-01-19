//
//  InAppPurchaseCell.m
//  What'sThat
//
//  Created by Vibhooti on 5/20/13.
//  Copyright (c) 2013 Vibhooti. All rights reserved.
//

#import "InAppPurchaseCell.h"

@implementation InAppPurchaseCell
@synthesize btn;
@synthesize lblStar;

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
}

@end
