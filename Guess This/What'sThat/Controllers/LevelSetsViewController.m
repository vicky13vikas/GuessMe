//
//  LevelSetsViewController.m
//  What'sThat
//
//  Created by mac16 on 28/08/13.
//  Copyright (c) 2013 Vibhooti. All rights reserved.
//

#import "LevelSetsViewController.h"
#define EmptyBoughtBackground @"set1EmptyBackground.png"
#define EmptyUnBoughtBackground @"setOtherEmptyBackround"
#define BoughtBackground @"set1Background.png"
#define UnBoughtBackground @"setOtherBackground.png"
#define BoughtTransparentBackground @"set1TransparentBackground.png"
#define UnBoughtTransparentBackground @"setOtherTransparentBackground.png"



@interface LevelSetsViewController ()

@end

@implementation LevelSetsViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    lblTitle.font = [UIFont fontWithName:@"Comic Sans MS" size:24];
    arrNumberOfSets = [[NSMutableArray alloc]init];
    
    for(int i=0;i<appDelegate.intTotalSets;i++)
    {
        [arrNumberOfSets addObject:[NSString stringWithFormat:@"Set %d",i+1]];
    }
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    lblScore.text = [NSString stringWithFormat:@"%d",[self getTotalScore]];
    [appDelegate performSelector:@selector(setCloudInterface:) withObject:self.view afterDelay:0.0];
    intCurrentSet = [[NSUserDefaults standardUserDefaults]integerForKey:USERDEFAULTS_CURRENT_SET];
    intCurrentSet = intCurrentSet-1;

    [tblLevelSets reloadData];
    if (![appDelegate checkIfAnyActiveLevels])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ALERT_TITLE message:@"You have no further levels to play." delegate:self cancelButtonTitle:ALERT_OK otherButtonTitles:nil];
        alert.tag = 2;
        [alert show];
    }
    arrSetsBought = [appDelegate getLevelsBought];
    if(appDelegate.maxLevelSet == -1)
    {
        [appDelegate getMaxLevelSet];
    }
    
    NSLog(@"arrSetsBought :: %@",[arrSetsBought description]);
    if (!appDelegate.adBanner) {
        [appDelegate loadAds];
    }
    [self.view addSubview:appDelegate.adBanner];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [appDelegate invalidateCloudAnimationTimer];
}
#pragma mark - Alert View Methods
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        if(buttonIndex==1)
        {
            [self showInAppPurchaseView];
        }
    }
    else if(alertView.tag == 2)
    {
        [self btnHomeClicked:nil];
    }
}

#pragma mark - Table View Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrNumberOfSets count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 103;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    LevelSetsCustomCell *cell = (LevelSetsCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LevelSetsCustomCell" owner:self options:nil];
        cell = (LevelSetsCustomCell *)[nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    intCurrentTableRow = indexPath.row;
    
    cell.btnSetNo.titleLabel.font = [UIFont fontWithName:@"Myriad Pro" size:22];
    cell.btnScore.titleLabel.font = [UIFont fontWithName:@"Myriad Pro" size:15];
    
    int intNoOfLevels;
    if(indexPath.row==0)
    {
        intNoOfLevels= SET1_LEVEL_INTERVAL;
    }
    else
    {
        intNoOfLevels = SETOTHER_LEVEL_INTERVAL;
    }
    
    if(indexPath.row+1 > appDelegate.maxLevelSet)
    {
        [self setCellForLevelUnBought:cell];
        [self disableCellButtons:cell];
    }
    else
    {
        if([self isLevelSetBought:indexPath.row+1])
        {
            [self setCellForLevelBought:cell];
            int intTotalAnsweredQuestion = [appDelegate getTotalAnsweredQuestionsForLevelSet:indexPath.row+1];
            if(intTotalAnsweredQuestion == -1)
            {
                [cell.btnScore setTitle:[NSString stringWithFormat:@"%d/%d",(intNoOfLevels * LEVEL_QUESTION_COUNT),(intNoOfLevels * LEVEL_QUESTION_COUNT)] forState:UIControlStateNormal];
                [cell.btnScore setTitle:[NSString stringWithFormat:@"%d/%d",(intNoOfLevels * LEVEL_QUESTION_COUNT),(intNoOfLevels * LEVEL_QUESTION_COUNT)] forState:UIControlStateHighlighted];
                [self disableCellButtons:cell];
            }
            else
            {
                [cell.btnScore setTitle:[NSString stringWithFormat:@"%d/%d",intTotalAnsweredQuestion,(intNoOfLevels * LEVEL_QUESTION_COUNT)] forState:UIControlStateNormal];
                [cell.btnScore setTitle:[NSString stringWithFormat:@"%d/%d",intTotalAnsweredQuestion,(intNoOfLevels * LEVEL_QUESTION_COUNT)] forState:UIControlStateHighlighted];
                [self enableCellButtons:cell];
            }
        }
        else
        {
            [self setCellForLevelUnBought:cell];
            [self enableCellButtons:cell];
        }
        
        
    }

    
        
    cell.btnBackground.tag = indexPath.row;
    [cell.btnSetNo setTitle:[arrNumberOfSets objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    [cell.btnSetNo setTitle:[arrNumberOfSets objectAtIndex:indexPath.row] forState:UIControlStateHighlighted];
    
    [cell.btnBackground addTarget:self action:@selector(btnPlayClicked:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - In App View Delegate Methods
-(void)inAppCancelButtonClicked
{
    [appDelegate hideViewAnimation:viewInAppPur];
}
-(void)inAppContinueButtonClicked:(int)intStars
{
    [self updateScore:intStars];
    [self decrementNextSetScore];
    [appDelegate setLeveSetBought:intLevelSetSelected];
    viewInAppPur.hidden = TRUE;
    
    [SVProgressHUD dismiss];
    
    appDelegate.isInAppHUD = NO;
    [self goToLevelController];
}
#pragma mark - Button Click Methods
-(IBAction)btnHomeClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

-(IBAction)btnPlayClicked:(id)sender
{
    if ([appDelegate checkIfAnyActiveLevels])
    {
        UIButton *btnTemp = (UIButton *)sender;
        intLevelSetSelected = btnTemp.tag+1;
        
        if(btnTemp.tag > 0)
        {
            if([self isLevelSetBought:btnTemp.tag+1])
            {
                [self goToLevelController];
            }
            else
            {
                if([self getTotalScore]>=500)
                {
                    [self decrementNextSetScore];
                    [appDelegate setLeveSetBought:btnTemp.tag+1];
                    [self goToLevelController];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ALERT_TITLE message:[NSString stringWithFormat:@"You need to have %d stars to play set %d. Please click on More Stars to buy more stars",SCORE_SET,btnTemp.tag+1] delegate:self cancelButtonTitle:ALERT_CANCEL otherButtonTitles:ALERT_MORESTARS,nil];
                    alert.tag = 1;
                    [alert show];
                }
            }
        }
        else
        {
            [self goToLevelController];
        }        
    }
}
#pragma mark - Custom Methods
-(BOOL)isLevelSetBought:(int)intLevelSet
{
    NSMutableArray *arrTemp = [[NSMutableArray alloc]initWithArray:arrSetsBought];
    NSPredicate *predicateLevelBought = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ = '%d'",DB_LEVEL_SET,intLevelSet]];
    [arrTemp filterUsingPredicate:predicateLevelBought];
    if([arrTemp count]>0)
    {
        arrTemp = nil;
        return TRUE;
    }
    else
    {
        arrTemp = nil;
        return FALSE;
    }
}
-(void)enableCellButtons :(LevelSetsCustomCell *)cell
{
    cell.btnBackground.enabled = TRUE;
    cell.btnScore.alpha = 1.0;
    cell.btnSetNo.alpha = 1.0;
    cell.imgQuestionImage.alpha = 1.0;
}

-(void)disableCellButtons:(LevelSetsCustomCell *)cell
{
    cell.btnBackground.enabled = FALSE;
    cell.btnScore.alpha = 0.5;
    cell.btnSetNo.alpha = 0.5;
    cell.imgQuestionImage.alpha = 0.5;
}
-(void)setCellForLevelUnBought:(LevelSetsCustomCell *)cell
{
    [cell.btnBackground setImage:[UIImage imageNamed:EmptyUnBoughtBackground] forState:UIControlStateNormal];
    [cell.btnBackground setImage:[UIImage imageNamed:EmptyUnBoughtBackground] forState:UIControlStateHighlighted];
    cell.btnScore.frame = CGRectMake(36, 43, cell.btnScore.frame.size.width, cell.btnScore.frame.size.height);
    cell.btnSetNo.frame = CGRectMake(11, 22, cell.btnSetNo.frame.size.width, cell.btnSetNo.frame.size.height);
    
    [cell.btnScore setTitle:@"500"  forState:UIControlStateNormal];
    [cell.btnScore setTitle:@"500"  forState:UIControlStateHighlighted];
    
    [self setImageInCloud:cell];
}
-(void)setCellForLevelBought:(LevelSetsCustomCell *)cell
{
    [cell.btnBackground setImage:[UIImage imageNamed:EmptyBoughtBackground] forState:UIControlStateNormal];
    [cell.btnBackground setImage:[UIImage imageNamed:EmptyBoughtBackground] forState:UIControlStateHighlighted];
    
    cell.btnSetNo.frame = CGRectMake(11, 28, cell.btnSetNo.frame.size.width, cell.btnSetNo.frame.size.height);
    cell.btnScore.frame = CGRectMake(11, 48, cell.btnScore.frame.size.width, cell.btnScore.frame.size.height);
    
    [self setImageInCloud:cell];
}

-(void)goToLevelController
{
    appDelegate.currentLevelSet = intLevelSetSelected;
    if(!objLevel)
        objLevel = [[LevelViewController alloc]initWithNibName:@"LevelViewController" bundle:nil];
    [self.navigationController pushViewController:objLevel animated:TRUE];
}

-(int)getTotalScore
{
    return appDelegate.intTotalScore + [appDelegate getExtraPoints];
}

-(void)setImageInAbsenceOfQuestionImage:(int)intCurrentSet cell:(LevelSetsCustomCell *)cell
{
    if([cell.btnBackground imageForState:UIControlStateNormal]==[UIImage imageNamed:EmptyBoughtBackground])
    {
        NSIndexPath* pathOfTheCell = [tblLevelSets indexPathForCell:cell];
        if(pathOfTheCell.row == 0)
        {
            [cell.btnBackground setImage:[UIImage imageNamed:BoughtBackground] forState:UIControlStateNormal];
            [cell.btnBackground setImage:[UIImage imageNamed:BoughtBackground] forState:UIControlStateHighlighted];
        }
        else
        {
            [cell.btnBackground setImage:[UIImage imageNamed:UnBoughtBackground] forState:UIControlStateNormal];
            [cell.btnBackground setImage:[UIImage imageNamed:UnBoughtBackground] forState:UIControlStateHighlighted];
            
            cell.btnScore.hidden = TRUE;
            cell.btnSetNo.frame = CGRectMake(14, 40, cell.btnSetNo.frame.size.width, cell.btnSetNo.frame.size.height);
        }
    }
    else
    {
        [cell.btnBackground setImage:[UIImage imageNamed:UnBoughtBackground] forState:UIControlStateNormal];
        [cell.btnBackground setImage:[UIImage imageNamed:UnBoughtBackground] forState:UIControlStateHighlighted];
        
        cell.btnScore.hidden = TRUE;
        cell.btnSetNo.frame = CGRectMake(14, 43, cell.btnSetNo.frame.size.width, cell.btnSetNo.frame.size.height);

    }
}

-(void)setImageInPresenceOfQuestionImage:(LevelSetsCustomCell *)cell
{
    if([cell.btnBackground imageForState:UIControlStateNormal]==[UIImage imageNamed:EmptyBoughtBackground])
    {
        NSIndexPath* pathOfTheCell = [tblLevelSets indexPathForCell:cell];
        if(pathOfTheCell.row == 0)
        {
            [cell.btnBackground setImage:[UIImage imageNamed:BoughtTransparentBackground] forState:UIControlStateNormal];
            [cell.btnBackground setImage:[UIImage imageNamed:BoughtTransparentBackground] forState:UIControlStateHighlighted];
        }
        else
        {
            [cell.btnBackground setImage:[UIImage imageNamed:UnBoughtTransparentBackground] forState:UIControlStateNormal];
            [cell.btnBackground setImage:[UIImage imageNamed:UnBoughtTransparentBackground] forState:UIControlStateHighlighted];
        }
    }
}
-(void)setImageInCloud:(LevelSetsCustomCell *)cell
{
    NSLog(@"appDelegate.arrInitialSetQuestionInfo::%@",appDelegate.arrInitialSetQuestionInfo);
    
    if(intCurrentTableRow>=[appDelegate.arrInitialSetQuestionInfo count])
    {
        [self setImageInAbsenceOfQuestionImage:1 cell:cell];
    }
    else
    {
        NSString *imageName = [[appDelegate.arrInitialSetQuestionInfo objectAtIndex:intCurrentTableRow] objectForKey:DIC_IMAGENAME];
        int intLevelID = [[[appDelegate.arrInitialSetQuestionInfo objectAtIndex:intCurrentTableRow] objectForKey:DB_LEVEL_ID] intValue];
        NSString *dirName = @"Images/";
        UIImage *image = [objDocDir getImageIfExistInDir:dirName fileName:imageName];
        if (image)
        {
            if(intLevelID == 1)
            {
                [self setImageInPresenceOfQuestionImage:cell];//as in these function it is just used to check whether first cell or not
            }
            else
            {
                [self setImageInPresenceOfQuestionImage:cell];
            }
            
            cell.imgQuestionImage.image = image;
        }
        else
        {
            if(intLevelID == 1)
            {
                [self setImageInAbsenceOfQuestionImage:0 cell:cell];//as in these function it is just used to check whether first cell or not
            }
            else
            {
                [self setImageInAbsenceOfQuestionImage:1 cell:cell];
            }
        }   
    }
}

-(void)decrementNextSetScore
{
    NSArray *arrLevelInfo = [appDelegate fetchMaxPlayedLevel];
    int intLevelID = 0;
    if([appDelegate checkQueryReturnedArrayCondition:arrLevelInfo])
    {
        intLevelID = [[[arrLevelInfo objectAtIndex:0] objectForKey:DB_LEVEL_ID] intValue];
        
        if(intLevelID == 0)
        {
            arrLevelInfo = [appDelegate fetchFirstLevelId];
            
            if([appDelegate checkQueryReturnedArrayCondition:arrLevelInfo])
            {
                intLevelID = [[[arrLevelInfo objectAtIndex:0] objectForKey:DB_LEVEL_ID] intValue];
            }
        }
    }
    if(intLevelID == 0)
    {
        NSLog(@"something wrong");
    }
    else
    {
        NSString *queryLevelScore = [NSString stringWithFormat:@"select %@ from %@ where %@ == %d",DB_LEVEL_SCORE,DB_TABLE_LEVEL,DB_LEVEL_ID,intLevelID];
        NSArray *arrLevelScore = [objDataBase selectDataFromTable:queryLevelScore];
        
        if([appDelegate checkQueryReturnedArrayCondition:arrLevelScore])
        {
            int intScore = [[[arrLevelScore objectAtIndex:0] objectForKey:DB_LEVEL_SCORE] intValue];
            intScore = intScore - SCORE_SET;
            
            NSMutableDictionary *dicUpdate = [[NSMutableDictionary alloc]init];
            [dicUpdate setObject:[NSString stringWithFormat:@"%d",intScore] forKey:DB_LEVEL_SCORE];
            
            NSMutableDictionary *dicWhere = [[NSMutableDictionary alloc]init];
            [dicWhere setObject:[NSString stringWithFormat:@"%d",intLevelID] forKey:DB_LEVEL_ID];
            
            [objDataBase updateRecordWithMoreConditions:dicUpdate :dicWhere :DB_TABLE_LEVEL];
            
            [[NSUserDefaults standardUserDefaults]setBool:TRUE forKey:USERDEFAULTS_DECR_SETSCORE];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            dicUpdate = nil;
            dicWhere = nil;
            
            [appDelegate calculateCurrentScore];
        }
    }
}

-(void)updateScore:(int)intStars
{
    NSArray *arrLevelInfo = [appDelegate fetchMaxPlayedLevel];
    int intLevelID = 0;
    if([appDelegate checkQueryReturnedArrayCondition:arrLevelInfo])
    {
        intLevelID = [[[arrLevelInfo objectAtIndex:0] objectForKey:DB_LEVEL_ID] intValue];
        
        if(intLevelID == 0)
        {
            arrLevelInfo = [appDelegate fetchFirstLevelId];
            
            if([appDelegate checkQueryReturnedArrayCondition:arrLevelInfo])
            {
                intLevelID = [[[arrLevelInfo objectAtIndex:0] objectForKey:DB_LEVEL_ID] intValue];
            }
        }
    }
    if(intLevelID == 0)
    {
        NSLog(@"something wrong");
    }
    else
    {
        NSString *queryLevelScore = [NSString stringWithFormat:@"select %@ from %@ where %@ == %d",DB_LEVEL_SCORE,DB_TABLE_LEVEL,DB_LEVEL_ID,intLevelID];
        NSArray *arrLevelScore = [objDataBase selectDataFromTable:queryLevelScore];
        
        if([appDelegate checkQueryReturnedArrayCondition:arrLevelScore])
        {
            int intScore = [[[arrLevelScore objectAtIndex:0] objectForKey:DB_LEVEL_SCORE] intValue];
            intScore = intScore + intStars;
            
            NSMutableDictionary *dicUpdate = [[NSMutableDictionary alloc]init];
            [dicUpdate setObject:[NSString stringWithFormat:@"%d",intScore] forKey:DB_LEVEL_SCORE];
            
            NSMutableDictionary *dicWhere = [[NSMutableDictionary alloc]init];
            [dicWhere setObject:[NSString stringWithFormat:@"%d",intLevelID] forKey:DB_LEVEL_ID];
            
            [objDataBase updateRecordWithMoreConditions:dicUpdate :dicWhere :DB_TABLE_LEVEL];
            
            dicUpdate = nil;
            dicWhere = nil;
            
            [appDelegate calculateCurrentScore];
        }
    }
}

-(void)showInAppPurchaseView
{
    CGRect frame = viewInAppPur.frame;
    frame.origin.y = (self.view.frame.size.height - frame.size.height)/2;
    frame.origin.x = (self.view.frame.size.width - frame.size.width)/2;
    viewInAppPur.frame = frame;
    [viewInAppPur setFrame];
    
    viewInAppPur.intRow = 0;
    [viewInAppPur.tblMain reloadData];
    [appDelegate showViewAnimation:viewInAppPur];
}

#pragma mark - Memory Management
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
