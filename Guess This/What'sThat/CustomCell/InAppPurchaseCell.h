//
//  InAppPurchaseCell.h
//  What'sThat
//
//  Created by Vibhooti on 5/20/13.
//  Copyright (c) 2013 Vibhooti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InAppPurchaseCell : UITableViewCell
{
    IBOutlet UIButton *btn;
    IBOutlet UILabel  *lblStar;
}
@property(nonatomic,retain)UIButton *btn;
@property(nonatomic,retain)UILabel *lblStar;
@end
