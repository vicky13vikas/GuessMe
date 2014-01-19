//
//  LevelSetsCustomCell.h
//  What'sThat
//
//  Created by mac16 on 30/08/13.
//  Copyright (c) 2013 Vibhooti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LevelSetsCustomCell : UITableViewCell
{
    IBOutlet UIButton *btnBackground;
    IBOutlet UIButton *btnSetNo;
    IBOutlet UIButton *btnScore;
    IBOutlet UIImageView *imgQuestionImage;

}

@property(nonatomic,retain)UIButton *btnBackground;
@property(nonatomic,retain)UIButton *btnSetNo;
@property(nonatomic,retain)UIButton *btnScore;
@property(nonatomic,retain)UIImageView *imgQuestionImage;
@end
