//
//  LeaderViewCell.h
//  What'sThat
//
//  Created by Vikas kumar on 26/01/14.
//  Copyright (c) 2014 Vibhooti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaderViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblRank;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblScore;

@end
