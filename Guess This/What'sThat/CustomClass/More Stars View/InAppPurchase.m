//
//  InAppPurchase.m
//  What'sThat
//
//  Created by Vibhooti on 5/20/13.
//  Copyright (c) 2013 Vibhooti. All rights reserved.
//

#import "InAppPurchase.h"

@interface InAppPurchase ()

@end

@implementation InAppPurchase
@synthesize tblMain;
//@synthesize arrayInApp;
@synthesize delegate;
@synthesize intRow;
//@synthesize arrProductIdentifire;
//@synthesize arrStar;

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self makeView];
    }
    return self;
}

-(void)makeView{
    CGRect frame = self.frame;
    frame.size.height -=40;
    frame.origin.y =40;
    frame.origin.x = 0;

    self.tblMain = [[UITableView alloc]initWithFrame:frame];
    self.tblMain.dataSource = self;
    self.tblMain.delegate = self;
    self.tblMain.separatorStyle = UITableViewCellSeparatorStyleNone;
    tblMain.backgroundColor = [UIColor clearColor];
    tblMain.scrollEnabled = NO;
    
    frame =self.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    imvBg = [[UIImageView alloc]initWithFrame:self.frame];
    imvBg.image = [UIImage imageNamed:@"inappBg.png"];
    
    frame = self.frame;
    frame.size.height = 40;
    frame.origin.y = 5;
    lblTitle = [[UILabel alloc]initWithFrame:frame];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor colorWithRed:0.702 green:0.2078 blue:0.1647 alpha:1];
    lblTitle.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    lblTitle.textAlignment = UITextAlignmentCenter;
    lblTitle.text = @"Guess This - In App";
    
    
    btnCancel = [[UIButton alloc]initWithFrame:CGRectMake(5, self.frame.size.height-55, 128, 43)];
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"btnCancleBg.png"] forState:UIControlStateNormal];
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"btnCancleBg.png"] forState:UIControlStateHighlighted];
    [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [btnCancel setTitle:@"Cancel" forState:UIControlStateHighlighted];
    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btnCancel addTarget:self action:@selector(btnCancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnCancel.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    
    
    btnContinue = [[UIButton alloc]initWithFrame:CGRectMake(5, self.frame.size.height-55, 128, 43)];
    [btnContinue setBackgroundImage:[UIImage imageNamed:@"btnContinueBg.png"] forState:UIControlStateNormal];
    [btnContinue setBackgroundImage:[UIImage imageNamed:@"btnContinueBg.png"] forState:UIControlStateHighlighted];
    [btnContinue setTitle:@"Continue" forState:UIControlStateNormal];
    [btnContinue setTitle:@"Continue" forState:UIControlStateHighlighted];
    [btnContinue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnContinue setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btnContinue addTarget:self action:@selector(btnContinueClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnContinue.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    self.intRow = 0;
    
    [self addSubview:imvBg];
    [self addSubview:tblMain];
    [self addSubview:lblTitle];
    [self addSubview:btnCancel];
    [self addSubview:btnContinue];
}


-(void)setFrame{
    CGRect frame = self.frame;
    frame.size.height -=40;
    frame.origin.y =40;
    frame.origin.x =0;
    self.tblMain.frame =frame;

    frame =self.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    imvBg.frame =frame;
    
    frame = self.frame;
    frame.size.height = 40;
    frame.origin.y = 5;
    frame.origin.x = 0;

    lblTitle.frame = frame;
    

    btnCancel.frame = CGRectMake(12, self.frame.size.height-65, 127, 43);
    
    frame = btnCancel.frame;
    frame.origin.x = btnCancel.frame.origin.x + btnCancel.frame.size.width +12;
    frame.size.width = 128;
    btnContinue.frame = frame;
}
    
#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 2;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayInAppPur count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    static NSString *CellIdentifier = @"Cell";
    
    InAppPurchaseCell *cell = (InAppPurchaseCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"InAppPurchaseCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
       
    }
    cell.lblStar.text = [arrayInAppPur objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        cell.btn.selected = YES;
    }
    cell.btn.tag = indexPath.row;
    [cell.btn addTarget:self action:@selector(btnStarClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"stars :: %@",[arrayInApp objectAtIndex:indexPath.row]);
    InAppPurchaseCell *cellTemp = (InAppPurchaseCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self btnStarClicked:cellTemp.btn];
//    intRow = indexPath.row;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 38;
}


-(void)btnStarClicked:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    
    self.intRow = btn.tag;

    for (int i=0;i<[arrayInAppPur count]; i++) {
       InAppPurchaseCell  *cell = (InAppPurchaseCell *)[tblMain cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (cell.btn.tag == btn.tag) {
            cell.btn.selected = YES;
        }
        else{
            cell.btn.selected = NO;
        }
    }
}

-(void)btnCancelClicked:(id)sender
{
 	[delegate inAppCancelButtonClicked]; 
}

-(void)btnContinueClicked:(id)sender
{
/*    int intStar = [[arrStar objectAtIndex:self.intRow]intValue];
    [delegate inAppContinueButtonClicked:intStar];*/

    NSLog(@"btnContinueClicked");
   self.userInteractionEnabled = NO;
    NSString *prodIndtif = [arrProductIdentifire objectAtIndex:self.intRow];
    
    appDelegate.isCustomSVhud = NO;
    [SVProgressHUD showWithStatus:@"Wait"];
    appDelegate.isInAppHUD = YES;
    
    SKProduct *productToBuy;
    NSLog(@"appDelegate.arrayProduct::%@",[appDelegate.arrayProduct description]);
    if([appDelegate.arrayProduct count]>0)
    {
        for (SKProduct *product in appDelegate.arrayProduct)
        {
            if ([prodIndtif isEqualToString: product.productIdentifier]) {
                productToBuy = product;
                break;
            }
        }
        
        //    NSLog(@"Buying %@", productToBuy.productIdentifier);
        RageIAPHelper *objRage = [RageIAPHelper sharedInstance];
        objRage._delegate = self;
        [objRage buyProduct:productToBuy];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ALERT_TITLE message:@"No products loaded." delegate:nil cancelButtonTitle:ALERT_OK otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - IAPHelperDelegate Method

-(void)completeTransaction:(SKPaymentTransaction *)transaction
{
     NSLog(@"completeTransaction transaction");
    self.userInteractionEnabled = YES;
    
    int intStar = [[arrStar objectAtIndex:self.intRow]intValue];
    [delegate inAppContinueButtonClicked:intStar];
} 
-(void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"restore transaction");
    [SVProgressHUD dismiss];
    appDelegate.isInAppHUD = NO;
    self.userInteractionEnabled = YES;
}
-(void)failedTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"failedTransaction transaction");
    
     if (transaction.error.code != SKErrorPaymentCancelled)
     {
         if ([transaction.error.localizedDescription length]>0) {
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:transaction.error.localizedDescription delegate:nil cancelButtonTitle:ALERT_OK otherButtonTitles:nil];
             [alert show];
         }
         else{
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Receipt validation failed." delegate:nil cancelButtonTitle:ALERT_OK otherButtonTitles:nil];
             [alert show];
         }
         
         
    }
    [SVProgressHUD dismiss];
    appDelegate.isInAppHUD = NO;
    self.userInteractionEnabled = YES;
}

@end
