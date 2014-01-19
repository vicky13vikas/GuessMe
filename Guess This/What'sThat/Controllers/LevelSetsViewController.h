//
//  LevelSetsViewController.h
//  What'sThat
//
//  Created by mac16 on 28/08/13.
//  Copyright (c) 2013 Vibhooti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InAppPurchase.h"
#import "LevelSetsCustomCell.h"

@interface LevelSetsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *tblLevelSets;
    
    //In App Purchase View
    IBOutlet InAppPurchase *viewInAppPur;
    
    NSMutableArray *arrNumberOfSets;
    
    IBOutlet UILabel *lblScore;
    IBOutlet UILabel *lblTitle;
    
    int intCurrentTableRow;
    int intCurrentSet;
    NSArray *arrSetsBought;
    int intLevelSetSelected;
}
#pragma mark - Button Click Methods
-(IBAction)btnHomeClicked:(id)sender;
-(IBAction)btnPlayClicked:(id)sender;

#pragma mark - Custom Methods
-(void)goToLevelController;
-(int)getTotalScore;
-(void)showInAppPurchaseView;
-(void)updateScore:(int)intStars;
-(void)decrementNextSetScore;
-(void)disableCellButtons:(LevelSetsCustomCell *)cell;
-(void)enableCellButtons :(LevelSetsCustomCell *)cell;
-(void)setCellForLevelUnBought:(LevelSetsCustomCell *)cell;
-(void)setCellForLevelBought:(LevelSetsCustomCell *)cell;
-(void)setImageInCloud:(LevelSetsCustomCell *)cell;
-(void)setImageInPresenceOfQuestionImage:(LevelSetsCustomCell *)cell;
@end
