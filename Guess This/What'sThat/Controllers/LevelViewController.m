//
//  LevelViewController.m
//  What'sThat
//
//  Created by Vibhooti on 5/13/13.
//  Copyright (c) 2013 Vibhooti. All rights reserved.
//

#import "LevelViewController.h"
#import <Social/Social.h>

#define FIXLABELHEIGHT 100
#define OPTION_IMAGE_HEIGHT 29

#define TAG_VIEW_FOR_AD 121

@implementation LevelViewController

#pragma mark - 
#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    Completed = FALSE;

    
    
    
    NSLog(@"level level view controller");
    [super viewDidLoad];
    isFirstLoad = YES;
    
    viewQuestion.hidden = NO;
    viewAnswer.hidden = NO;
    
   
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    txtAnswer.leftView = paddingView;
    txtAnswer.leftViewMode = UITextFieldViewModeAlways;

    UIView *paddingViewRight = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    txtAnswer.rightView = paddingViewRight;
    txtAnswer.rightViewMode = UITextFieldViewModeAlways;

    [self performSelector:@selector(changeViewFrameOnTextEditing) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScoreAdMobVideo) name:kVideoFinished object:nil];

    [self initializeHints];
    [self flushOldDataFromInterface];
    [self changeViewFrameOnTextEditing];
    [self retriveCurrentLevel];
    [appDelegate setCloudInterface:self.view];
    [self setInterface];
    [appDelegate calculateCurrentScore];
    [self updateTotalStars];
    
    if (!appDelegate.adBanner) {
        [appDelegate loadAds];
    }
    [self.view addSubview:appDelegate.adBanner];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if([arrayQuestion count]==0)
    {
        [self updateLevel];
    }
    
    [appDelegate invalidateCloudAnimationTimer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kVideoFinished object:nil];
}

#pragma mark - Interface Orientaion
- (BOOL)shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - TextField Delegate Methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return TRUE;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self changeViewFrameOnTextEditing];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string   // return NO to not change text

{
    if ([string length]==0)
    {
        return YES;
    }
    NSString *reg = @"[A-Za-z0-9 ]";
    NSPredicate *rangeValid=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",reg];
    if([rangeValid evaluateWithObject:string])
    {

        return YES;
    }
    else
    {
        return NO;
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
/*    if(Completed)
        return TRUE;

    [self proceedToNextQuestion];*/

    if ([[textField.text stringByReplacingOccurrencesOfString:@" " withString:@""]length]>0)
    {
        if([arrayQuestion count]>0)
        {
            NSString *strUserAnswer = [[textField.text lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSArray *arrAnswers = [[[arrayQuestion objectAtIndex:0] objectForKey:DB_QANS] componentsSeparatedByString:@","];
            BOOL isAnswerCorrect = FALSE;
            
            for(int i=0;i<[arrAnswers count];i++)
            {
                NSString *strActualAnswer = [[[arrAnswers objectAtIndex:i] lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
                
                if([strActualAnswer length]>0)
                {
                    if([strUserAnswer isEqualToString:strActualAnswer])
                    {
                        isAnswerCorrect = TRUE;
                    }
                }
            }
            if(isAnswerCorrect)
            {
                [self proceedToNextQuestion];
            }
            else
            {
                appDelegate.isCustomSVhud = YES;
                [SVProgressHUD showErrorWithStatus:@"" duration:0.5];
            }
        }
    }
    
    [textField resignFirstResponder];
    [self changeViewFrameOnTextEditing];
    

    return TRUE;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return TRUE;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
   
}

#pragma mark -
#pragma mark - Button Click Methods
-(IBAction)btnBackClicked:(id)sender
{
	[appDelegate.navigationController popViewControllerAnimated:TRUE];
}

-(IBAction)btnFaceBookClicked:(id)sender
{
/*
    [appDelegate showActivityIndicator];
    [SVProgressHUD showWithStatus:@"Wait"];
    if([appDelegate checkInternetConnection])
    {
        appDelegate.isInFacebookSharing = TRUE;
        NSLog(@"btnFacebookClicked");
        [self shareFacebook];
        
    }
    else
    {
        [appDelegate hideActivityIndicator];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ALERT_TITLE message:ALERT_INTERNET delegate:nil cancelButtonTitle:ALERT_OK otherButtonTitles: nil];
        [alert show];
    }
 */
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:@"Does anyone know what this picture is? I'm playing Guess this Image on iOS!"];
        [controller addURL:[NSURL URLWithString:@"http://goo.gl/Z1tukU"]];
        [controller addImage:questionImv.image];
        
        [self presentViewController:controller animated:YES completion:Nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ALERT_TITLE message:@"Please setup Facebook in settings." delegate:nil cancelButtonTitle:ALERT_OK otherButtonTitles: nil];
        [alert show];
    }
}

-(IBAction)btnNextLevelOkButtonClicked:(id)sender
{
        [self activateInterface];
    if(Completed)
    {
        Completed = FALSE;
        viewNextLevel.hidden = TRUE;
        [self.navigationController popViewControllerAnimated:TRUE];
    }
    else
    {
        if([[dicLevelInfo objectForKey:DB_BQ_IMG_NM] length]>0)
        {
            viewNextLevel.hidden = TRUE;
            [self retriveBonusInfo];
            [self showBonusView];
        }
        else
        {
            [appDelegate hideViewAnimation:viewNextLevel];
            [self checkForNextLevel];
        }
    }
}

-(void)checkForNextLevel
{    
    if([appDelegate checkIfAnyActiveLevelsInCurrentSet:appDelegate.currentLevelSet])
    {
        [self proceedToNextLevel];    
    }
    else
    {
        Completed = TRUE;

        if(![appDelegate checkIfAnyActiveLevels])
        {
            [self showNextLevelConfirmationView:@"Congratulations you have completed all levels."
                           areAllLevelsComplete:TRUE];
        }
        else
        {
            [self showNextLevelConfirmationView:[NSString stringWithFormat:@"Congratulations you have completed set %d.",appDelegate.currentLevelSet]
                           areAllLevelsComplete:TRUE];
        }
    }
}

-(void)setCurrentSetUserDefaults
{
    int intCurrentSet = [[NSUserDefaults standardUserDefaults] integerForKey:USERDEFAULTS_CURRENT_SET];
    intCurrentSet = intCurrentSet + 1;
    
    [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:USERDEFAULTS_DECR_SETSCORE];
    [[NSUserDefaults standardUserDefaults] setInteger:intCurrentSet forKey:USERDEFAULTS_CURRENT_SET];
    [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:USERDEFAULTS_CURRENT_SET_LEVEL_COUNT];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(IBAction)BtnStarClicked:(id)sender
{
    [self showInAppPurchaseView];
}

-(IBAction)btnBonusOk:(id)sender
{
    [self invalidateBonusTimer];
    NSString *strBonusAnswer = [dicLevelInfo objectForKey:DB_BQ_ANS];
    NSArray *arrBonusAnswer = [strBonusAnswer componentsSeparatedByString:@"_"];
    if([arrBonusAnswer count]>1)
    {
        if([[arrBonusAnswer objectAtIndex:1] length]>0)
        {
            int intAnswer = [[arrBonusAnswer objectAtIndex:1] intValue];
            if(intAnswer == intBounsOptionSelected)
            {
                [self updateScore:SCORE_BONUS];
                [self updateLevelScore];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ALERT_TITLE message:[NSString stringWithFormat:@"Awesome you gave the right answer! You have won an extra %d stars!",SCORE_BONUS] delegate:self cancelButtonTitle:ALERT_OK otherButtonTitles:nil];
                alert.tag = 6;
                [alert show];
            }
            else
            {
                appDelegate.isCustomSVhud = YES;
                [SVProgressHUD showErrorWithStatus:@"" duration:0.5];
                [self hideBonusView:FALSE];
            }
        }
        else
        {
            
            appDelegate.isCustomSVhud = YES;
            [SVProgressHUD showErrorWithStatus:@"" duration:0.5];
            [self hideBonusView:FALSE];
        }
    }
    else
    {
        [self hideBonusView:TRUE];
        NSLog(@"something wrong with bonus answer");
    }
}

-(IBAction)btnBonusOption:(id)sender
{
    UIButton *btnTemp = (UIButton *)sender;
    int intTag = btnTemp.tag;
    
    intBounsOptionSelected = intTag;
    [self updateBonusOptionSelected];
}

#pragma mark - Hints
-(IBAction)hintClicked:(id)sender
{
    UIButton *btnTemp = (UIButton *)sender;
    
    intCurrentHint = btnTemp.tag;
    
    switch (intCurrentHint)
    {
        case 0:
//            NSLog(@"hint btntemp tag::%d",btnTemp.tag);
            break;
        case 1:
            [self btnHint1Clicked];
            break;
        case 2:
            [self btnHint2Clicked];
            break;
        case 3:
            [self btnHint3Clicked];
            break;
        default:
           // NSLog(@"hint btntemp tag::%d",btnTemp.tag);
            NSLog(@"sadfasdf");
            break;
    }
}

-(void)btnHint1Clicked
{
       
    intCurrentHint = 1;
    [self showHintView];

   /* if(isHint1Used)
        [self showHintView];
    else
    {
        if(![[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULTS_HINT1])
        {
            [self showHintView];
        }
        else
        {
            if(!isHint1AlertShown)
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ALERT_TITLE message:[NSString stringWithFormat:@"%@ %d stars.",MSG_HINT1,SCORE_HINT_1] delegate:self cancelButtonTitle:ALERT_CANCEL otherButtonTitles:ALERT_CONTINUE,nil];
                alert.tag = 2;
                [alert show];
            }
            else
            {
                [self checkIfEnoughStars:SCORE_HINT_1];
            }
        }
    }
    */
}
-(void)btnHint2Clicked
{
       
    intCurrentHint = 2;

    if(!isHint1Used)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ALERT_TITLE message:MSG_HINT1_NOT_USED delegate:self cancelButtonTitle:ALERT_OK otherButtonTitles:nil];
        [alert show];
    }
    else
      [self showHintView];

  
/*    else
    {
        if(![[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULTS_HINT2])
        {
            [self showHintView];
        }
        else
        {
            if(!isHint2AlertShown)
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ALERT_TITLE message:[NSString stringWithFormat:@"%@ %d stars.",MSG_HINT2,SCORE_HINT_2] delegate:self cancelButtonTitle:ALERT_CANCEL otherButtonTitles:ALERT_CONTINUE,nil];
                alert.tag = 2;
                [alert show];
            }
            else
            {
                [self checkIfEnoughStars:SCORE_HINT_2];
            }
        }
    }
   */
}
-(void)btnHint3Clicked
{
    
    intCurrentHint = 3;

    if(!isHint1Used)
    {
      UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ALERT_TITLE message:MSG_HINT1_NOT_USED delegate:self cancelButtonTitle:ALERT_OK otherButtonTitles:nil];
      [alert show];
    }
    else if(!isHint2Used)
    {
      UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ALERT_TITLE message:MSG_HINT2_NOT_USED delegate:self cancelButtonTitle:ALERT_OK otherButtonTitles:nil];
      [alert show];
    }
    else
      [self showHintView];


 /*    else
    {
        if(![[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULTS_HINT3])
        {
            [self showHintView];
        }
        else
        {
            if(!isHint3AlertShown)
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ALERT_TITLE message:[NSString stringWithFormat:@"%@ %d stars.",MSG_HINT3,SCORE_HINT_3] delegate:self cancelButtonTitle:ALERT_CANCEL otherButtonTitles:ALERT_CONTINUE,nil];
                alert.tag = 2;
                [alert show];
            }
            else
            {
                [self checkIfEnoughStars:SCORE_HINT_3];
            }
        }
    }
 */
}


-(IBAction)btnHintOkClicked:(id)sender
{
    intCurrentHint = 0;
    [appDelegate hideViewAnimation:viewHint];
}

#pragma mark - More Stars Button

-(IBAction)btnMoreStarsContinueClicked:(id)sender
{
    viewMoreStars.hidden = TRUE;
    [self showInAppPurchaseView];
}
-(IBAction)btnMoreStarsCancelClicked:(id)sender
{
	[self hideMoreStarsView];
}

#pragma mark - In App View Delegate Methods
-(void)inAppCancelButtonClicked
{
    [appDelegate hideViewAnimation:viewInAppPur];
    [self activateInterface];
    imgViewTransparentBackground.hidden = TRUE;
}
-(void)inAppContinueButtonClicked:(int)intStars
{
    [self updateScore:intStars];
    [self updateLevelScore];
    
    [self activateInterface];
    
    viewInAppPur.hidden = TRUE;
   

    imgViewTransparentBackground.hidden = TRUE;
    

    [SVProgressHUD dismiss];
   

     appDelegate.isInAppHUD = NO;
   

    [self performSelectorOnMainThread:@selector(inAppHideViews) withObject:nil waitUntilDone:YES];
//    [self performSelector:@selector(inAppHideViews)];
}

-(void)inAppHideViews
{
    NSLog(@"inAppHideViews");

    switch (intCurrentHint)
    {
        case 1:
            [self btnHint1Clicked];
            break;
        case 2:
            [self btnHint2Clicked];
            break;
        case 3:
            [self btnHint3Clicked];
            break;
        default:
            break;
    }
    NSLog(@"inAppHideViews end");

}

#pragma mark - Alert View Methods
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        if(buttonIndex == 1)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"sdf" message:@"showing in app purchase view" delegate:nil cancelButtonTitle:ALERT_OK otherButtonTitles:nil];
            [alert show];
        }
    }
    else if(alertView.tag == 2)
    {
        if(buttonIndex == 1)
        {
            switch (intCurrentHint)
            {
                case 1:
                    isHint1AlertShown = TRUE;
                    [self checkIfEnoughStars:SCORE_HINT_1];
                    break;
                case 2:
                    isHint2AlertShown = TRUE;
                    [self checkIfEnoughStars:SCORE_HINT_2];
                    break;
                case 3:
                    isHint3AlertShown = TRUE;
                    [self checkIfEnoughStars:SCORE_HINT_3];
                    break;
                default:
                    break;
            }
        }
        else
        {
            intCurrentHint = 0;
        }
    }
    else if(alertView.tag == 3)
    {
        [self.navigationController popViewControllerAnimated:TRUE];
    }
    else if(alertView.tag == 4)
    {
        [self.navigationController popViewControllerAnimated:TRUE];
    }
    else if(alertView.tag == 5)
    {
        [self hideBonusView:TRUE];
    }
    else if(alertView.tag == 6)
    {
        [self hideBonusView:TRUE];
    }
    else if(alertView.tag == 7)
    {
      if(buttonIndex == 0)
        [self goToNextLevel];
      else
      {
        
      }
    }
}

#pragma mark - Facebook related methods
-(void)shareFacebook
{
    if(!objShareKit)
        objShareKit = [[ShareKitFile alloc] init];
    objShareKit.delegate = self;
    
    if(![objShareKit isSessionValid])
    {
        [objShareKit doFaceBookLogn];
    }
    else
    {
        [objShareKit sharePostFaceBookParameters:[self setUpFaceBookDictionary]];
    }
}

-(NSMutableDictionary *)setUpFaceBookDictionary
{
    NSMutableDictionary *dicParameters = [[NSMutableDictionary alloc]init];
    [dicParameters setObject:@"Does anyone know what this picture is? I'm playing Guess this Image on iOS! goo.gl/Z1tukU" forKey:@"message"];
    [dicParameters setObject:questionImv.image forKey:@"picture"];
    return dicParameters;
}

#pragma mark - ShareKit Delegate Methods
-(void)shareFBMessageStatus:(BOOL)postMessageStatus Error:(NSString *)postError
{
    appDelegate.isInFacebookSharing = NO;
	if(postMessageStatus)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ALERT_TITLE message:@"Post Successful." delegate:nil cancelButtonTitle:ALERT_OK otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ALERT_TITLE message:postError delegate:nil cancelButtonTitle:ALERT_OK otherButtonTitles:nil];
        [alert show];
    }
    [appDelegate hideActivityIndicator];
}

-(void)shareFBLoginStatus:(BOOL)loginSatus Error:(NSString *)loginError
{
    NSLog(@"shareFBLoginStatus");
    if(loginSatus)
    {
        [objShareKit sharePostFaceBookParameters:[self setUpFaceBookDictionary]];
    }
    else
    {
         appDelegate.isInFacebookSharing = NO;
        [appDelegate hideActivityIndicator];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ALERT_TITLE message:loginError delegate:nil cancelButtonTitle:ALERT_OK otherButtonTitles:nil];
        [alert show];
    }
}


#pragma mark - Custom Methods

#pragma mark - Interface Method
-(void)setInterface
{
    lblLevelNo.font = [UIFont fontWithName:@"Comic Sans MS" size:24];
    lblLevelNo.shadowColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:190.0/255.0 alpha:1.0];
    lblLevelNo.shadowOffset = CGSizeMake(0.1, 0.1);
    
    if([appDelegate isIphone5])
    {
        imgViewTransparentBackground.frame = CGRectMake(0, 0, 320, 568);
    }
    
    [self.view bringSubviewToFront:viewQuestion];
    [self.view bringSubviewToFront:viewAnswer];
}

#pragma mark - Show Hide View
-(void)showBonusView
{
    intBonusTimer = TIMER_BONUS;
    intBounsOptionSelected = 0;
    [self updateBonusOptionSelected];
    [self displayBonusTime];
    [self invalidateBonusTimer];
    timerBonus = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerBonusMethod) userInfo:nil repeats:YES];
    [btnBonusViewOk setTitle:ALERT_OK forState:UIControlStateNormal];
    [btnBonusViewOk setTitle:ALERT_OK forState:UIControlStateHighlighted];
    [self.view bringSubviewToFront:imgViewTransparentBackground];
    [appDelegate showViewAnimation:viewBonus];
}

-(void)hideBonusView:(BOOL)doAnimation
{
    intBounsOptionSelected = 0;
    [self updateBonusOptionSelected];
    [self invalidateBonusTimer];
    if(doAnimation)
        [appDelegate hideViewAnimation:viewBonus];
    else
        viewBonus.hidden = TRUE;
    
    [self checkForNextLevel];
/*    if([appDelegate checkIfAnyActiveLevels])
        [self proceedToNextLevel];
    else
    {
        [self showNextLevelConfirmationView:@"Congratulations you have completed all levels."
                       areAllLevelsComplete:TRUE];
    }*/
}


-(void)showInAppPurchaseView
{
    CGRect frame = viewInAppPur.frame;
    frame.origin.y = (self.view.frame.size.height - frame.size.height)/2;
    frame.origin.x = (self.view.frame.size.width - frame.size.width)/2;
    viewInAppPur.frame = frame;
    [viewInAppPur setFrame];

//    viewInAppPur.arrayInApp = arrayInAppPur;
//    viewInAppPur.arrStar = arrStar;
//    
//    viewInAppPur.arrProductIdentifire = arrProductIdentifire;
    
    viewInAppPur.intRow = 0;
    [self deactivateInterface];
    [txtAnswer resignFirstResponder];
    [viewInAppPur.tblMain reloadData];
    [appDelegate showViewAnimation:viewInAppPur];
}


-(void)showNextLevelConfirmationView:(NSString *)strMsg areAllLevelsComplete:(BOOL)boolComplete
{
    if (boolComplete) {
        [btnNextLevel setTitle:ALERT_OK forState:UIControlStateNormal];
        [btnNextLevel setTitle:ALERT_OK forState:UIControlStateHighlighted];
    }
    else{
        [btnNextLevel setTitle:ALERT_CONTINUE forState:UIControlStateNormal];
        [btnNextLevel setTitle:ALERT_CONTINUE forState:UIControlStateHighlighted];
    }
    lblNextLevelMsg.text = strMsg;
    lblNextLevelTitle.text = ALERT_TITLE;
    [txtAnswer resignFirstResponder];
    [self changeViewFrameOnTextEditing];
    [appDelegate showViewAnimation:viewNextLevel];
    [self deactivateInterface];
}


-(void)showHintView
{
	switch (intCurrentHint)
    {
        case 1:
            [self loadAds];

            imgHintBackground.image = [UIImage imageNamed:@"hint1Bg.png"];
            [btnHintView setBackgroundImage:[UIImage imageNamed:@"okBtnBg-hint1.png"] forState:UIControlStateNormal];
            [btnHintView setBackgroundImage:[UIImage imageNamed:@"okBtnBg-hint1.png"] forState:UIControlStateHighlighted];
            lblHintTitle.text = @"Hint 1";
            lblHintMsg.text = [NSString stringWithFormat:@"Total words and letters: %@",[[arrayQuestion objectAtIndex:0] objectForKey:DB_QHINT1]];
            
            if(![[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULTS_HINT1])
            {
                [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:USERDEFAULTS_HINT1];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            else
            {
                if(!isHint1Used)
                {
//                    [self updateScoreForUsingHint:SCORE_HINT_1];
                    [self updateLevelScore];
                }
            }
            isHint1Used = TRUE;

            
            break;
        case 2:
            [self loadAds];

			imgHintBackground.image = [UIImage imageNamed:@"hint2Bg.png"];
            [btnHintView setBackgroundImage:[UIImage imageNamed:@"okBtnBg-hint2.png"] forState:UIControlStateNormal];
            [btnHintView setBackgroundImage:[UIImage imageNamed:@"okBtnBg-hint2.png"] forState:UIControlStateHighlighted];
            lblHintTitle.text = @"Hint 2";
            lblHintMsg.text = [NSString stringWithFormat:@"%@",[[arrayQuestion objectAtIndex:0] objectForKey:DB_QHINT2]];
            if(![[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULTS_HINT2])
            {
                [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:USERDEFAULTS_HINT2];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            else
            {
                if(!isHint2Used)
                {
//                    [self updateScoreForUsingHint:SCORE_HINT_2];
                    [self updateLevelScore];
                }
            }
            isHint2Used = TRUE;


            
            break;            
        case 3:
            [appDelegate showAdColonyVideo];

            imgHintBackground.image = [UIImage imageNamed:@"hint3Bg.png"];
            [btnHintView setBackgroundImage:[UIImage imageNamed:@"okBtnBg-hint3.png"] forState:UIControlStateNormal];
            [btnHintView setBackgroundImage:[UIImage imageNamed:@"okBtnBg-hint3.png"] forState:UIControlStateHighlighted];
            lblHintTitle.text = @"Hint 3";
            lblHintMsg.text = [NSString stringWithFormat:@"Answer : %@",[[arrayQuestion objectAtIndex:0] objectForKey:DB_QHINT3]];
            if(![[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULTS_HINT3])
            {
                [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:USERDEFAULTS_HINT3];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            else
            {
                if(!isHint3Used)
                {
//                    [self updateScoreForUsingHint:SCORE_HINT_3];
                    [self updateLevelScore];
                }
            }
            isHint3Used = TRUE;


            
            break;
        default:
            break;
    }
    [txtAnswer resignFirstResponder];
     [self changeViewFrameOnTextEditing];
    [appDelegate showViewAnimation:viewHint];
  
}

-(void)showMoreStarsView
{
    switch (intCurrentHint)
    {
        case 1:
            imgMoreStarsBackground.image = [UIImage imageNamed:@"hint1Bg.png"];
            [btnMoreStarsCancel setBackgroundImage:[UIImage imageNamed:@"CancelBtnBg-hint1.png"] forState:UIControlStateNormal];
            [btnMoreStarsCancel setBackgroundImage:[UIImage imageNamed:@"CancelBtnBg-hint1.png"] forState:UIControlStateHighlighted];
            [btnMoreStarsContinue setBackgroundImage:[UIImage imageNamed:@"okBtnBg-hint1.png"] forState:UIControlStateNormal];
            [btnMoreStarsContinue setBackgroundImage:[UIImage imageNamed:@"okBtnBg-hint1.png"] forState:UIControlStateHighlighted];            
            break;
        case 2:
			imgMoreStarsBackground.image = [UIImage imageNamed:@"hint2Bg.png"];            
            [btnMoreStarsCancel setBackgroundImage:[UIImage imageNamed:@"CancelBtnBg-hint2.png"] forState:UIControlStateNormal];
            [btnMoreStarsCancel setBackgroundImage:[UIImage imageNamed:@"CancelBtnBg-hint2.png"] forState:UIControlStateHighlighted];
            [btnMoreStarsContinue setBackgroundImage:[UIImage imageNamed:@"okBtnBg-hint2.png"] forState:UIControlStateNormal];
            [btnMoreStarsContinue setBackgroundImage:[UIImage imageNamed:@"okBtnBg-hint2.png"] forState:UIControlStateHighlighted];
            
            break;            
        case 3:
            imgMoreStarsBackground.image = [UIImage imageNamed:@"hint3Bg.png"];
            [btnMoreStarsCancel setBackgroundImage:[UIImage imageNamed:@"CancelBtnBg-hint3.png"] forState:UIControlStateNormal];
            [btnMoreStarsCancel setBackgroundImage:[UIImage imageNamed:@"CancelBtnBg-hint3.png"] forState:UIControlStateHighlighted];
            [btnMoreStarsContinue setBackgroundImage:[UIImage imageNamed:@"okBtnBg-hint3.png"] forState:UIControlStateNormal];
            [btnMoreStarsContinue setBackgroundImage:[UIImage imageNamed:@"okBtnBg-hint3.png"] forState:UIControlStateHighlighted];
            
            break;
        default:
            break;
    }
    
    [txtAnswer resignFirstResponder];
//    [txtAnswerIphone4 resignFirstResponder];
    [self changeViewFrameOnTextEditing];
    lblMoreStarsMsg.text = INAPP_MSG;
    lblMoreStarsTitle.text = ALERT_TITLE;
    
	[appDelegate showViewAnimation:viewMoreStars];
}

-(void)hideMoreStarsView
{
    [appDelegate hideViewAnimation:viewMoreStars];
}

#pragma mark - Cloud Animation

-(void)cloudAnimation
{
    CGRect frame = imvBigCloud1.frame;
    frame.origin.x -=1;
    imvBigCloud1.frame = frame;
    if (frame.origin.x == -frame.size.width) {
        frame.origin.x = self.view.frame.size.width;
        imvBigCloud1.frame = frame;
    }
    
    frame = imvSmallCloud1.frame;
    frame.origin.x -=1;
    imvSmallCloud1.frame = frame;
    if (frame.origin.x == -frame.size.width) {
        frame.origin.x = self.view.frame.size.width;
        imvSmallCloud1.frame = frame;
    }
    
    frame = imvBigCloud2.frame;
    frame.origin.x -=1;
    imvBigCloud2.frame = frame;
    if (frame.origin.x == -frame.size.width) {
        frame.origin.x = self.view.frame.size.width;
        imvBigCloud2.frame = frame;
    }
    
    
    frame = imvSmallCloud2.frame;
    frame.origin.x -=1;
    imvSmallCloud2.frame = frame;
    if (frame.origin.x == -frame.size.width) {
        frame.origin.x = self.view.frame.size.width;
        imvSmallCloud2.frame = frame;
    }
    
    frame = imvBigCloud3.frame;
    frame.origin.x -=1;
    imvBigCloud3.frame = frame;
    if (frame.origin.x == -frame.size.width) {
        frame.origin.x = self.view.frame.size.width;
        imvBigCloud3.frame = frame;
    }
    
    frame = imvSmallCloud3.frame;
    frame.origin.x -=1;
    imvSmallCloud3.frame = frame;
    if (frame.origin.x == -frame.size.width) {
        frame.origin.x = self.view.frame.size.width;
        imvSmallCloud3.frame = frame;
    }
    
    frame = imvBigCloud4.frame;
    frame.origin.x -=1;
    imvBigCloud4.frame = frame;
    if (frame.origin.x == -frame.size.width) {
        frame.origin.x = self.view.frame.size.width;
        imvBigCloud4.frame = frame;
    }
    
    frame = imvSmallCloud4.frame;
    frame.origin.x -=1;
    imvSmallCloud4.frame = frame;
    if (frame.origin.x == -frame.size.width) {
        frame.origin.x = self.view.frame.size.width;
        imvSmallCloud4.frame = frame;
    }
}

#pragma mark - Level Logic related Methods

-(void)level
{
    NSDictionary *dictQuestion = [arrayQuestion objectAtIndex:0];
    NSString *imageName = [NSString stringWithFormat:@"%@_%@_%@",[dictQuestion objectForKey:@"level_id"],[dictQuestion objectForKey:@"que_id"],[[dictQuestion objectForKey:@"que_imageName"]lastPathComponent]];
    NSString *dirName = @"Images/";
    UIImage *image = [objDocDir getImageIfExistInDir:dirName fileName:imageName];
    if (image)
    {
        questionImv.image = image;
  
        
    }
    else{
        BDMultiDownloader *obj = [BDMultiDownloader shared];
        obj.uniqueName = imageName;
        obj.dirName = dirName;
        [obj imageWithPath:[dictQuestion objectForKey:@"que_imageName"]
                completion:^(UIImage * image, BOOL fromCache)
         {
             questionImv.image = image;
             NSLog(@"Image 2 is from cache: %@", fromCache?@"YES":@"NO");
        }];
        
    }
}

-(void)proceedToNextQuestion
{
    [self updateLocalQuestionScore];
    [self updateLevelScore];

    [self updateQuestionStatus];
    
    [self initializeHints];
    [self flushOldDataFromInterface];
    
    [arrayQuestion removeObjectAtIndex:0];

    if([arrayQuestion count]==0)
    {
        [self updateLevel];
        if(![appDelegate checkIfAnyActiveLevels])
        {
            [self activateInterface];

            Completed = TRUE;

            if([[dicLevelInfo objectForKey:DB_BQ_IMG_NM] length]>0)
            {
                [txtAnswer resignFirstResponder];
//                [txtAnswerIphone4 resignFirstResponder];
                viewNextLevel.hidden = TRUE;
                [self retriveBonusInfo];
                [self showBonusView];
            }
            else
            {
                [self showNextLevelConfirmationView:@"Congratulations you have completed all levels."
                               areAllLevelsComplete:TRUE];
            }
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setInteger:[[dicLevelInfo objectForKey:DB_LEVEL_NO] intValue] forKey:USERDEFAULTS_COMP_LEVEL];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            int intCountLevel = [[NSUserDefaults standardUserDefaults]integerForKey:USERDEFAULTS_CURRENT_SET_LEVEL_COUNT];
            
            intCountLevel = intCountLevel + 1;
            
            [[NSUserDefaults standardUserDefaults]setInteger:intCountLevel forKey:USERDEFAULTS_CURRENT_SET_LEVEL_COUNT];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self showNextLevelConfirmationView:[NSString stringWithFormat:@"Awesome you have completed level %@ ! You have won an extra 20 stars !",[dicLevelInfo objectForKey:DB_LEVEL_NO]] areAllLevelsComplete:FALSE];
        }
        [self playSound:TRUE];
        
    }
    else
    {
        [self displayRoundLevel];
        appDelegate.isCustomSVhud = YES;
        [SVProgressHUD showSuccessWithStatus:@"" duration:0.5];
        [self playSound:FALSE];
        [self level];
    }    
}

-(void)updateLevel
{
    [self updateLocalLevelScore];//increment level points
    [self updateLevelScore];
    
    NSMutableDictionary *dicUpdate = [[NSMutableDictionary alloc]init];
    [dicUpdate setObject:@"0" forKey:DB_LEVEL_ACTIVE];
    [dicUpdate setObject:[NSString stringWithFormat:@"%d",PLAYSTATUS_PLAYED] forKey:DB_LEVEL_PLAY];
    
    NSMutableDictionary *dicWhere = [[NSMutableDictionary alloc]init];
    [dicWhere setObject:[NSString stringWithFormat:@"%d",[[dicLevelInfo objectForKey:DB_LEVEL_ID] intValue]] forKey:DB_LEVEL_ID];
    
    [objDataBase updateRecordWithMoreConditions:dicUpdate :dicWhere :DB_TABLE_LEVEL];
    
    dicUpdate = nil;
    dicWhere = nil;
}

-(void)goToNextLevel
{
  [self updateLevel];
  [self retriveCurrentLevel];
}

-(void)proceedToNextLevel
{
  NSLog(@"Level : %d", [[dicLevelInfo objectForKey:DB_LEVEL_NO] intValue]);

    if ((3 == [[dicLevelInfo objectForKey:DB_LEVEL_NO] intValue]) || (9 == [[dicLevelInfo objectForKey:DB_LEVEL_NO] intValue])) {
      
      UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ALERT_TITLE message:ALERT_REMOVE_ADS delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
      alert.tag = 7;
      [alert show];

    }
    else {
      [self goToNextLevel];
    }
        

}

-(void)updateQuestionStatus
{
    NSMutableDictionary *dicUpdate = [[NSMutableDictionary alloc]init];
    [dicUpdate setObject:@"0" forKey:DB_QUE_ACTIVE];
    
    NSMutableDictionary *dicWhere = [[NSMutableDictionary alloc]init];
    [dicWhere setObject:[NSString stringWithFormat:@"%d",[[dicLevelInfo objectForKey:DB_LEVEL_ID] intValue]] forKey:DB_LEVEL_ID];
    [dicWhere setObject:[NSString stringWithFormat:@"%d",[[[arrayQuestion objectAtIndex:0] objectForKey:DB_QUE_ID] intValue]] forKey:DB_QUE_ID];
    
    [objDataBase updateRecordWithMoreConditions:dicUpdate :dicWhere :DB_TABLE_QUESTION];
    
    dicUpdate = nil;
    dicWhere = nil;
}

-(void)retriveCurrentLevel
{
//    NSString *queryActiveLevel =  [NSString stringWithFormat:@"select min(%@) as %@ from %@ where %@ == 1",DB_LEVEL_ID,DB_LEVEL_ID,DB_TABLE_LEVEL,DB_LEVEL_ACTIVE];
    
    NSArray *arrLevelId = [appDelegate fetchActiveLevelId:appDelegate.currentLevelSet];
    
    if([arrLevelId count]==0)
    {
        NSLog(@"arrLevelId::%@",[arrLevelId description]);
        NSLog(@"Derived wrong active level id");
    }
    else
    {
        int intActiveLevelId = [[[arrLevelId objectAtIndex:0] objectForKey:DB_LEVEL_ID] intValue];
        
        if(intActiveLevelId == 0)
        {
            NSString *queryMaxLevel =  [NSString stringWithFormat:@"select count(%@) as %@ from %@",DB_LEVEL_ID,DB_LEVEL_ID,DB_TABLE_LEVEL];
            NSArray *arrMaxLevelId = [objDataBase selectDataFromTable:queryMaxLevel];
            
            if([arrMaxLevelId count]==0)
            {
                NSLog(@"arrMaxLevelId::%@",[arrLevelId description]);
                NSLog(@"Derived wrong max level id");
                lblRoundNo.text = @"";
                lblLevelNo.text = @"";
            }
            else if([[[arrMaxLevelId objectAtIndex:0] objectForKey:DB_LEVEL_ID] intValue]==0)
            {
                NSLog(@"arrMaxLevelId::%@",[arrLevelId description]);
                NSLog(@"Derived wrong max level id");
                lblRoundNo.text = @"";
                lblLevelNo.text = @"";
            }
            else
            {
                int intRound = [appDelegate retriveCountOfQuestionsInLevel:[[dicLevelInfo objectForKey:DB_LEVEL_ID] intValue]];
                lblRoundNo.text = [NSString stringWithFormat:@"%d",intRound];
                lblLevelNo.text = [NSString stringWithFormat:@"Level %d",[[[arrMaxLevelId objectAtIndex:0] objectForKey:DB_LEVEL_ID] intValue]];
            }
            
            [self flushOldDataFromInterface];
            [self deactivateInterface];

            return;
        }

        NSString *queryLevelInformation = [NSString stringWithFormat:@"select * from %@ where %@ == %d",DB_TABLE_LEVEL,DB_LEVEL_ID,intActiveLevelId];
        NSArray *arrLevelInformation = [objDataBase selectDataFromTable:queryLevelInformation];
        
        if([arrLevelInformation count]>0)
        {
            if(dicLevelInfo)
            {
                dicLevelInfo = nil;
            }
            dicLevelInfo = [[NSMutableDictionary alloc]initWithDictionary:[arrLevelInformation objectAtIndex:0]];
            
            NSString *queryActiveQuestion = [NSString stringWithFormat:@"select min(%@) as %@ from %@ where %@ == 1 and %@ == %d",DB_QUE_ID,DB_QUE_ID,DB_TABLE_QUESTION,DB_QUE_ACTIVE,DB_LEVEL_ID,intActiveLevelId];
            
            NSArray *arrActiveQuestionID = [objDataBase selectDataFromTable:queryActiveQuestion];
            
            if([arrActiveQuestionID count]==0)
            {
                [self flushOldDataFromInterface];
                [self deactivateInterface];
                NSLog(@"arrActiveQuestionID::%@",[arrActiveQuestionID description]);
                NSLog(@"Derived wrong active question id");
            }
            
            int intActiveQuestionId = [[[arrActiveQuestionID objectAtIndex:0] objectForKey:DB_QUE_ID] intValue];
            
            if(intActiveQuestionId==0)
            {
                [self flushOldDataFromInterface];
                [self deactivateInterface];

                NSLog(@"arrActiveQuestionID::%@",[arrActiveQuestionID description]);
                NSLog(@"Derived wrong active question id");
            }
            else
            {
				NSString *queryQuestions = [NSString stringWithFormat:@"select * from %@ where %@ >= %d and %@ = %d and %@ = 1 order by %@",DB_TABLE_QUESTION,DB_QUE_ID,intActiveQuestionId,DB_LEVEL_ID,intActiveLevelId,DB_QUE_ACTIVE,DB_QUE_ID];
                arrayQuestion = [objDataBase selectDataFromTable:queryQuestions];
//                NSLog(@"arrayQuestion=%@",[arrayQuestion description]);
                if([arrayQuestion count]==0)
                {
                    [self flushOldDataFromInterface];
                    [self deactivateInterface];

	                NSLog(@"arrayQuestion=%@",[arrayQuestion description]);
                    NSLog(@"no active question arrived for level %d",intActiveQuestionId);
                }
                else
                {//vibhooti
                    NSMutableArray *arrTemp = [[NSMutableArray alloc]initWithArray:arrayQuestion];
                    NSPredicate *predicateLevelId = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ == 'FALSE'",DB_QUE_IMGDOWNSTAT]];
                    [arrTemp filterUsingPredicate:predicateLevelId];
                    
                    if([arrTemp count]>0)
                    {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ALERT_TITLE message:@"All level info not downloaded. Please update data." delegate:self cancelButtonTitle:ALERT_OK otherButtonTitles:nil];
                        alert.tag = 4;
                        [alert show];
                        
                        appDelegate.shouldDownloadDataFromHome = TRUE;
                        return;
                    }

//                    NSLog(@"round no :: %d",[[[arrayQuestion objectAtIndex:0] objectForKey:DB_QUE_NO] intValue]);
                    [self displayRoundLevel];
                    questionIndex = 0;
                    [self level];
                }
            }
            
            arrActiveQuestionID = nil;
            arrLevelInformation = nil;
            
            if(!appDelegate.isApplicationStarted)//not while user first starts the game that is in first level
            {
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ALERT_TITLE message:@"Congratulations you are in next level." delegate:nil cancelButtonTitle:ALERT_OK otherButtonTitles: nil];
//                [alert show];
            }
            else
            {
                appDelegate.isApplicationStarted = FALSE;
            }
        }
        else
        {
            NSLog(@"arrLevelInformation::%@",[arrLevelInformation description]);
            NSLog(@"Error retriving data of Level Information");
        }
    }
    
    arrLevelId = nil;
}

#pragma mark - Update Score

-(void)updateLevelScore
{
    NSMutableDictionary *dicUpdate = [[NSMutableDictionary alloc]init];
    [dicUpdate setObject:[NSString stringWithFormat:@"%d",[[dicLevelInfo objectForKey:DB_LEVEL_SCORE] intValue]] forKey:DB_LEVEL_SCORE];
    [dicUpdate setObject:[NSString stringWithFormat:@"%d",PLAYSTATUS_PLAYING] forKey:DB_LEVEL_PLAY];
    
    NSMutableDictionary *dicWhere = [[NSMutableDictionary alloc]init];
    [dicWhere setObject:[NSString stringWithFormat:@"%d",[[dicLevelInfo objectForKey:DB_LEVEL_ID] intValue]] forKey:DB_LEVEL_ID];
    
	[objDataBase updateRecordWithMoreConditions:dicUpdate :dicWhere :DB_TABLE_LEVEL];
    
    dicUpdate = nil;
    dicWhere = nil;
}

-(void)updateScore:(int)intScore
{
    int intCurrentLevelScore = [[dicLevelInfo objectForKey:DB_LEVEL_SCORE] intValue];
    
    intCurrentLevelScore = intCurrentLevelScore+intScore;
    appDelegate.intTotalScore = appDelegate.intTotalScore + intScore;//total stars have to be updated as they are used for hint purpose
    [self updateTotalStars];
    [dicLevelInfo setObject:[NSString stringWithFormat:@"%d",intCurrentLevelScore] forKey:DB_LEVEL_SCORE];
}

-(void)updateScoreForUsingHint:(int)intScore
{
    int intCurrentLevelScore = [[dicLevelInfo objectForKey:DB_LEVEL_SCORE] intValue];
    
    intCurrentLevelScore = intCurrentLevelScore-intScore;
    appDelegate.intTotalScore = appDelegate.intTotalScore - intScore;//total stars have to be updated as they are used for hint purpose
    [self updateTotalStars];
    [dicLevelInfo setObject:[NSString stringWithFormat:@"%d",intCurrentLevelScore] forKey:DB_LEVEL_SCORE];
}

-(void)updateLocalQuestionScore
{
    if(!isHint3Used)
    {
        [self updateScore:SCORE_ROUND];
    }
}

-(void)updateLocalLevelScore
{
    int intCurrentLevelScore = [[dicLevelInfo objectForKey:DB_LEVEL_SCORE] intValue];
    
	intCurrentLevelScore = intCurrentLevelScore+SCORE_LEVEL;
    appDelegate.intTotalScore = appDelegate.intTotalScore + SCORE_LEVEL;//total stars have to be updated as they are used for hint purpose
    [self updateTotalStars];
    
    [dicLevelInfo setObject:[NSString stringWithFormat:@"%d",intCurrentLevelScore] forKey:DB_LEVEL_SCORE];
}

-(void)updateTotalStars
{
	intTotalStars = appDelegate.intTotalScore;
    
    intTotalStars = intTotalStars + [appDelegate getExtraPoints];
    
    [btnInAppPurchase setTitle:[NSString stringWithFormat:@"%d",intTotalStars] forState:UIControlStateNormal];
    [btnInAppPurchase setTitle:[NSString stringWithFormat:@"%d",intTotalStars] forState:UIControlStateHighlighted];
}

-(void)updateScoreAdMobVideo
{
    [self updateScore:0];
}

#pragma mark - Bonus Timer Related Methods
-(void)invalidateBonusTimer
{
    if(timerBonus)
    {
        [timerBonus invalidate];
        timerBonus = nil;
    }
}

-(void)updateBonusOptionSelected
{
    switch (intBounsOptionSelected)
    {
        case 0:
            btnOption1.selected = NO;
            btnOption2.selected = NO;
            btnOption3.selected = NO;
            btnOption4.selected = NO;
            break;
        case 1:
            btnOption1.selected = YES;
            btnOption2.selected = NO;
            btnOption3.selected = NO;
            btnOption4.selected = NO;
            break;
        case 2:
            btnOption1.selected = NO;
            btnOption2.selected = YES;
            btnOption3.selected = NO;
            btnOption4.selected = NO;
            break;
        case 3:
            btnOption1.selected = NO;
            btnOption2.selected = NO;
            btnOption3.selected = YES;
            btnOption4.selected = NO;
            break;
        case 4:
            btnOption1.selected = NO;
            btnOption2.selected = NO;
            btnOption3.selected = NO;
            btnOption4.selected = YES;
            break;
        default:
            btnOption1.selected = NO;
            btnOption2.selected = NO;
            btnOption3.selected = NO;
            btnOption4.selected = NO;
            break;
    }
}

-(void)retriveBonusInfo
{
    lblBonusQuestion.text = [dicLevelInfo objectForKey:DB_BQ_IMG_NM];
    lblOption1.text = [dicLevelInfo objectForKey:DB_BQ_OPTION1];
    lblOption2.text = [dicLevelInfo objectForKey:DB_BQ_OPTION2];
    lblOption3.text = [dicLevelInfo objectForKey:DB_BQ_OPTION3];
    lblOption4.text = [dicLevelInfo objectForKey:DB_BQ_OPTION4];
    [self setInterfaceForBonusView];
}

-(void)setInterfaceForBonusView
{
    CGSize sizeLabelQuestino  = [lblBonusQuestion.text sizeWithFont:lblBonusQuestion.font constrainedToSize:CGSizeMake(lblBonusQuestion.frame.size.width, FIXLABELHEIGHT) lineBreakMode:lblBonusQuestion.lineBreakMode];
    lblBonusQuestion.frame = CGRectMake(lblBonusQuestion.frame.origin.x, lblBonusQuestion.frame.origin.y, lblBonusQuestion.frame.size.width, sizeLabelQuestino.height);

    CGSize sizeLabelOption1  = [lblOption1.text sizeWithFont:lblOption1.font constrainedToSize:CGSizeMake(lblOption1.frame.size.width, FIXLABELHEIGHT) lineBreakMode:lblOption1.lineBreakMode];
    
    int intButtonOption1Width = lblOption1.frame.size.width+(btnOption1.frame.size.width+(lblOption1.frame.origin.y-(btnOption1.frame.size.width+btnOption1.frame.origin.x)));
    
    int intFinalHeightOption1;
    if(sizeLabelOption1.height > OPTION_IMAGE_HEIGHT)
    {
        intFinalHeightOption1 = sizeLabelOption1.height;
    }
    else
    {
        intFinalHeightOption1 = OPTION_IMAGE_HEIGHT;
    }
    lblOption1.frame = CGRectMake(lblOption1.frame.origin.x, lblOption1.frame.origin.y, lblOption1.frame.size.width, intFinalHeightOption1);
    btnOption1.frame = CGRectMake(btnOption1.frame.origin.x, lblOption1.frame.origin.y, intButtonOption1Width, intFinalHeightOption1);
    
    CGSize sizeLabelOption2  = [lblOption2.text sizeWithFont:lblOption2.font constrainedToSize:CGSizeMake(lblOption2.frame.size.width, FIXLABELHEIGHT) lineBreakMode:lblOption2.lineBreakMode];
    int intButtonOption2Width = lblOption2.frame.size.width+(btnOption2.frame.size.width+(lblOption2.frame.origin.y-(btnOption2.frame.size.width+btnOption2.frame.origin.x)));
    
    int intFinalHeightOption2;
    if(sizeLabelOption2.height > OPTION_IMAGE_HEIGHT)
    {
        intFinalHeightOption2 = sizeLabelOption2.height;
    }
    else
    {
        intFinalHeightOption2 = OPTION_IMAGE_HEIGHT;
    }

    lblOption2.frame = CGRectMake(lblOption2.frame.origin.x, lblOption1.frame.origin.y+lblOption1.frame.size.height+5, lblOption2.frame.size.width, intFinalHeightOption2);
    btnOption2.frame = CGRectMake(btnOption2.frame.origin.x, lblOption2.frame.origin.y, intButtonOption2Width, intFinalHeightOption2);
    
    CGSize sizeLabelOption3  = [lblOption3.text sizeWithFont:lblOption3.font constrainedToSize:CGSizeMake(lblOption3.frame.size.width, FIXLABELHEIGHT) lineBreakMode:lblOption3.lineBreakMode];
    int intButtonOption3Width = lblOption3.frame.size.width+(btnOption3.frame.size.width+(lblOption3.frame.origin.y-(btnOption3.frame.size.width+btnOption3.frame.origin.x)));
    
    int intFinalHeightOption3;
    if(sizeLabelOption3.height > OPTION_IMAGE_HEIGHT)
    {
        intFinalHeightOption3 = sizeLabelOption3.height;
    }
    else
    {
        intFinalHeightOption3 = OPTION_IMAGE_HEIGHT;
    }

    lblOption3.frame = CGRectMake(lblOption3.frame.origin.x, lblOption2.frame.origin.y+lblOption2.frame.size.height+5, lblOption3.frame.size.width, intFinalHeightOption3);
    btnOption3.frame = CGRectMake(btnOption3.frame.origin.x, lblOption3.frame.origin.y, intButtonOption3Width, intFinalHeightOption3);
    
    CGSize sizeLabelOption4  = [lblOption4.text sizeWithFont:lblOption4.font constrainedToSize:CGSizeMake(lblOption4.frame.size.width, FIXLABELHEIGHT) lineBreakMode:lblOption4.lineBreakMode];
    int intButtonOption4Width = lblOption3.frame.size.width+(btnOption3.frame.size.width+(lblOption3.frame.origin.y-(btnOption3.frame.size.width+btnOption3.frame.origin.x)));
    
    int intFinalHeightOption4;
    if(sizeLabelOption4.height > OPTION_IMAGE_HEIGHT)
    {
        intFinalHeightOption4 = sizeLabelOption4.height;
    }
    else
    {
        intFinalHeightOption4 = OPTION_IMAGE_HEIGHT;
    }

    lblOption4.frame = CGRectMake(lblOption4.frame.origin.x, lblOption3.frame.origin.y+lblOption3.frame.size.height+5, lblOption4.frame.size.width, intFinalHeightOption4);
    btnOption4.frame = CGRectMake(btnOption4.frame.origin.x, lblOption4.frame.origin.y, intButtonOption4Width, intFinalHeightOption4);

    int totalHeightBonusOptionView = lblOption4.frame.origin.y + lblOption4.frame.size.height + 10;

    scrBonusView.frame = CGRectMake(scrBonusView.frame.origin.x, lblBonusQuestion.frame.origin.y+lblBonusQuestion.frame.size.height+10, scrBonusView.frame.size.width, totalHeightBonusOptionView);
    viewBonusOptionView.frame = CGRectMake(0, 0, viewBonusOptionView.frame.size.width, totalHeightBonusOptionView);

    scrBonusView.contentSize = CGSizeMake(viewBonusOptionView.frame.size.width, totalHeightBonusOptionView);
}
-(void)displayBonusTime
{
    if(intBonusTimer<10)
    {
        lblBonusTime.text = [NSString stringWithFormat:@"00:0%d",intBonusTimer];
    }
    else
    {
        lblBonusTime.text = [NSString stringWithFormat:@"00:%d",intBonusTimer];
    }
}

-(void)timerBonusMethod
{
    if(intBonusTimer>0)
    {
        intBonusTimer--;
        [self displayBonusTime];
    }
    else
    {
        [self invalidateBonusTimer];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ALERT_TITLE message:@"Time Over!" delegate:self cancelButtonTitle:ALERT_OK otherButtonTitles:nil];
        alert.tag = 5;
        [alert show];
    }
}
#pragma mark - Other Methods
-(void)displayRoundLevel
{
    int intLevelNo,intRoundNo;
    if(dicLevelInfo)
    {
        intLevelNo = [[dicLevelInfo objectForKey:DB_LEVEL_NO] intValue];
    }
    else
    {
        NSLog(@"something wrong in displaying level no if(dicLevelInfo)");
        intLevelNo = 0;
    }
    
    if([arrayQuestion count]>0)
    {
        intRoundNo = [[[arrayQuestion objectAtIndex:0] objectForKey:DB_QUE_NO] intValue];
    }
    else
    {
        NSLog(@"something wrong in displaying round no");
        intRoundNo = 0;
    }
    lblRoundNo.text = [NSString stringWithFormat:@"%d",intRoundNo];
    lblLevelNo.text = [NSString stringWithFormat:@"Level %d",intLevelNo];
}
-(void)playSound:(BOOL)isLevel
{    
    if(appDelegate.shouldSoundEffectsBeMute)
    {
        if(objAudio)
        {
            if ([objAudio.audioPlayer isPlaying])
            {
                [objAudio stopAudio];
            }
        }
    }
    else
    {
        NSString *strSoundFile;
        if(isLevel)
            strSoundFile  = @"level.wav";
        else
            strSoundFile  = @"round.wav";

        objAudio = [[AudioPlay alloc]init];
        objAudio.strAudioFile = strSoundFile;
        if ([objAudio.audioPlayer isPlaying])
        {
            [objAudio stopAudio];
        }
        else
        {
            [objAudio playAudio];
        }        
    }
}
-(void)checkIfEnoughStars:(int)intStarsRequired
{
    if(intTotalStars>=intStarsRequired)
    {
        [self showHintView];
    }
    else//if want to purchase more stars
    {
		[self showMoreStarsView];   
    }
}

-(void)changeViewFrameOnTextEditing
{    
    [UIView beginAnimations:@"" context:nil];
    if (isFirstLoad) 
    {
        isFirstLoad = NO;
        [UIView setAnimationDuration:0.0];
    }
    else
    {
        [UIView setAnimationDuration:0.3];
    }
    
    if (appDelegate.isIphone5) {
        CGRect frame = viewQuestion.frame;
        if ([txtAnswer isFirstResponder])
        {
            frame.origin.y = 70;
            viewQuestion.frame = frame;
            frame.origin.y += frame.size.height;
            
            frame.origin.x = viewAnswer.frame.origin.x;
            frame.size.width = viewAnswer.frame.size.width;
            frame.size.height = viewAnswer.frame.size.height;
            
            viewAnswer.frame = frame;
        }
        else
        {
            
            frame.origin.y = 125;
            viewQuestion.frame = frame;
            frame.origin.y += frame.size.height+70;
            
            frame.origin.x = viewAnswer.frame.origin.x;
            frame.size.width = viewAnswer.frame.size.width;
            frame.size.height = viewAnswer.frame.size.height;
            
            viewAnswer.frame = frame;
        }
    }
    else{
        CGRect frame = viewQuestion.frame;
        if ([txtAnswer isFirstResponder])
        {
            if (!appDelegate.isIphone5)
            {
                CGRect frame1 = viewTopBar.frame;
                frame1.origin.y = - frame1.size.height;
                viewTopBar.frame = frame1;
                //                viewTopBar.hidden = YES;
            }
            
            frame.origin.y = 3;
            viewQuestion.frame = frame;
            frame.origin.y += frame.size.height-17;
            
            frame.origin.x = viewAnswer.frame.origin.x;
            frame.size.width = viewAnswer.frame.size.width;
            frame.size.height = viewAnswer.frame.size.height;
            
            viewAnswer.frame = frame;
        }
        else
        {
            if (!appDelegate.isIphone5)
            {
                CGRect frame1 = viewTopBar.frame;
                frame1.origin.y = 0;
                viewTopBar.frame = frame1;
                //               viewTopBar.hidden = NO;
            }
            frame.origin.y = 100;
            viewQuestion.frame = frame;
            frame.origin.y += frame.size.height+40;
            
            frame.origin.x = viewAnswer.frame.origin.x;
            frame.size.width = viewAnswer.frame.size.width;
            frame.size.height = viewAnswer.frame.size.height;
            
            viewAnswer.frame = frame;
        }
    }
    
    [UIView commitAnimations];
}

-(void)initializeHints
{
    intCurrentHint = 0;
    isHint1Used = FALSE;
    isHint2Used = FALSE;
    isHint3Used = FALSE;
    isHint1AlertShown = FALSE;
    isHint2AlertShown = FALSE;
    isHint3AlertShown = FALSE;
}
-(void)flushOldDataFromInterface
{
    txtAnswer.text = @"";
}

-(void)deactivateInterface
{
    btnHint1.enabled = FALSE;
    btnHint2.enabled = FALSE;
    btnHint3.enabled = FALSE;
    txtAnswer.userInteractionEnabled = FALSE;
    btnFacebook.enabled = FALSE;
}

-(void)activateInterface
{
    btnHint1.enabled = TRUE;
    btnHint2.enabled = TRUE;
    btnHint3.enabled = TRUE;

    txtAnswer.userInteractionEnabled = TRUE;
    btnFacebook.enabled = TRUE;
}

#pragma mark - Memory Management
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark GADBannerView


-(void)loadAds
{
  // Use predefined GADAdSize constants to define the GADBannerView.
  
  CGPoint origin = CGPointMake(0, 0);
  
  self.adBanner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:origin];
  
  // Note: Edit SampleConstants.h to provide a definition for kSampleAdUnitID before compiling.
  self.adBanner.adUnitID = ADMOB_UNIT_ID;
  self.adBanner.adSize = kGADAdSizeMediumRectangle;
  self.adBanner.delegate = self;
  self.adBanner.rootViewController = self;
//  [self.view addSubview:self.adBanner];
  [self.adBanner loadRequest:[self request]];
  //    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(refreshAd) userInfo:Nil repeats:YES];
  
}

- (GADRequest *)request {
  GADRequest *request = [GADRequest request];
  
  // Make the request for a test ad. Put in an identifier for the simulator as well as any devices
  // you want to receive test ads.
  request.testDevices = @[
                          // TODO: Add your device/simulator test identifiers here. Your device identifier is printed to
                          // the console when the app is launched.
                          GAD_SIMULATOR_ID
                          ];
  return request;
}

- (void)adViewDidReceiveAd:(GADBannerView *)adView {
  NSLog(@"Received ad successfully");
    
    CGRect frame = CGRectMake((self.view.frame.size.width - kGADAdSizeMediumRectangle.size.width)/2,
                              (self.view.frame.size.height - kGADAdSizeMediumRectangle.size.height)/2,
                              300,
                              250);
    UIView *viewForAd = [[UIView alloc] initWithFrame:frame];
    viewForAd.tag = TAG_VIEW_FOR_AD;
    [viewForAd addSubview:adView];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(-10, -10, 30, 30)];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(adCloseBtnClicked) forControlEvents:UIControlEventAllEvents];
    [viewForAd addSubview:closeButton];
    
    [self.view addSubview:viewForAd];
}

- (void)adCloseBtnClicked
{
    [[self.view viewWithTag:TAG_VIEW_FOR_AD] removeFromSuperview];
}


- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
  NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}

@end
