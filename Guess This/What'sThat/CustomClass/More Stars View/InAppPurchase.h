//
//  InAppPurchase.h
//  What'sThat
//
//  Created by Vibhooti on 5/20/13.
//  Copyright (c) 2013 Vibhooti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InAppPurchaseCell.h"
#import "IAPHelper.h"
@protocol InAppViewDelegate;

@interface InAppPurchase : UIView <UITableViewDataSource, UITableViewDelegate,IAPHelperDelegate>
{
    IBOutlet id <InAppViewDelegate> delegate;
    UITableView *tblMain;
    UIImageView *imvBg;
    UILabel *lblTitle;
    
    UIButton *btnCancel;
    UIButton *btnContinue;
//    NSMutableArray *arrayInApp;
    int intRow;
//    NSArray *arrProductIdentifire;
//    NSArray *arrStar;
}
@property (nonatomic, retain) id <InAppViewDelegate> delegate;
@property(nonatomic,retain)UITableView *tblMain;
//@property(nonatomic,retain)NSMutableArray *arrayInApp;
//@property(nonatomic,retain)NSArray *arrProductIdentifire;
//@property(nonatomic,retain)NSArray *arrStar;
@property(nonatomic,readwrite)int intRow;
-(void)makeView;
-(void)setFrame;
@end

@protocol InAppViewDelegate

-(void)inAppCancelButtonClicked;
-(void)inAppContinueButtonClicked:(int)intStarsBought;

@end
