//
//  HomeViewController.m
//  What'sThat
//
//  Created by Vibhooti on 5/13/13.
//  Copyright (c) 2013 Vibhooti. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize btnPlay,btnMusic,btnFacebookLike,btnInfo,btnInstruction,btnRateApp;

#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [appDelegate performSelector:@selector(showActivityIndicator) withObject:nil afterDelay:0.2];
    [self setInterface];
}
-(void)viewWillAppear:(BOOL)animated
{
    [appDelegate performSelector:@selector(setCloudInterface:) withObject:self.view afterDelay:0.0];
    appDelegate.isApplicationStarted = TRUE;
    viewMusic.hidden = TRUE;
    [self setMusicSetting];
    [self setFbButtonInterface];
    [self setRateButtonInterface];
    [self downloadRemainingImages];
}

-(void)viewDidAppear:(BOOL)animated
{
    [appDelegate callRateIt];
    if(appDelegate.isFromFinishLaunching)
    {
        appDelegate.isFromFinishLaunching = FALSE;
    }
    if (!appDelegate.isWSCalled)
    {
        appDelegate.isWSCalled =YES;
       [appDelegate performSelector:@selector(callSynchWebService) withObject:nil afterDelay:0.2];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [appDelegate invalidateCloudAnimationTimer];
}

#pragma mark - Interface Orientaion
- (BOOL)shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - INTERFACE METHOD

-(void)setInterface
{
    if([appDelegate isIphone5])
    {
        imgTransparentBackgound.frame = CGRectMake(0, 0, 320, 568);
    }
    CGRect frame = btnPlay.frame;
    if (appDelegate.isIphone5) {
        
        frame.origin.y = 217;
    }
    else{
        frame.origin.y = 190;
    }
    btnPlay.frame = frame;
}


#pragma mark - UIButton Action
-(IBAction)btnPlayAction:(id)sender
{
    if(appDelegate.isDownloadingData)//check whether data has been downloaded and saved in database
    {
        [self performSelector:@selector(downloadRemainingImages) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
        if(!appDelegate.shouldDownloadDataFromHome)//then check for images
        {
            if ([appDelegate checkIfAnyActiveLevels])
            {
                LevelSetsViewController *objLevelSets = [[LevelSetsViewController alloc]initWithNibName:@"LevelSetsViewController" bundle:nil];                
                [self.navigationController pushViewController:objLevelSets animated:YES];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ALERT_TITLE message:@"You have no further levels to play." delegate:nil cancelButtonTitle:ALERT_OK otherButtonTitles:nil];
                [alert show];
            }
        }
        else
        {
            appDelegate.isPlayButtonClicked = TRUE;
        }
    }
    else
    {
        appDelegate.isPlayButtonClicked = TRUE;
        [appDelegate showActivityIndicator];
        [appDelegate callSynchWebService];
    }
}

-(IBAction)btnHomeMusicAction:(id)sender
{
    BOOL isMute = [[NSUserDefaults standardUserDefaults]boolForKey:USERDEFAULTS_ISHOMEMUSICMUTE];

    [[NSUserDefaults standardUserDefaults] setBool:!isMute forKey:USERDEFAULTS_ISHOMEMUSICMUTE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [appDelegate checkMuteEffectAndPlayMusic];
    appDelegate.shouldHomeMusicBeMute = !isMute;
    
    [self setMusicSetting];
}
-(IBAction)btnSoundEffectsAction:(id)sender
{
    BOOL isMute = [[NSUserDefaults standardUserDefaults]boolForKey:USERDEFAULTS_ISSOUNDEFFECTSMUTE];
    [[NSUserDefaults standardUserDefaults] setBool:!isMute forKey:USERDEFAULTS_ISSOUNDEFFECTSMUTE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    appDelegate.shouldSoundEffectsBeMute = !isMute;
    [self setMusicSetting];
}

-(IBAction)btnMusicAction:(id)sender
{
    imgTransparentBackgound.hidden = FALSE;
    [self.view bringSubviewToFront:imgTransparentBackgound];
    [appDelegate showViewAnimation:viewMusic];
}

-(IBAction)btnMusicCloseAction:(id)sender
{
    imgTransparentBackgound.hidden = TRUE;
    [appDelegate hideViewAnimation:viewMusic];
}

-(IBAction)btnInfoAction:(id)sender
{
    if(!objInfo)
        objInfo = [[InfoViewController alloc]initWithNibName:@"InfoViewController" bundle:nil];
    [self.navigationController pushViewController:objInfo animated:TRUE];
}

-(void)startActivityForRequest
{
    [appDelegate showActivityIndicator];
    [SVProgressHUD showWithStatus:@"Wait..." maskType:(SVProgressHUDMaskTypeNone)];
}
-(IBAction)btnFacebookLike:(id)sender
{
    appDelegate.isFBLike = TRUE;

    [appDelegate performSelector:@selector(showActivityIndicator) withObject:nil afterDelay:0.5];
    if([appDelegate checkInternetConnection])
    {
        [self LikePageInWeb];
    }
    else
    {
        appDelegate.isFBLike = FALSE;
        [appDelegate hideActivityIndicator];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ALERT_TITLE message:ALERT_INTERNET delegate:nil cancelButtonTitle:ALERT_OK otherButtonTitles: nil];
        [alert show];
    }
}

-(IBAction)btnRateApp:(id)sender
{
    if([appDelegate checkInternetConnection])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:USERDEFAULTS_IS_RATED];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSString *reviewURL= [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software",APP_ID];
//        NSString *reviewURL = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@",APP_ID];
        NSLog(@"%@",reviewURL);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
        [self setRateButtonInterface];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ALERT_TITLE message:ALERT_INTERNET delegate:nil cancelButtonTitle:ALERT_OK otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark - Custom Methods
-(void)setMusicSetting
{
    if (appDelegate.shouldSoundEffectsBeMute)
    {
        [btnSoundEffect setImage:[UIImage imageNamed:@"SoundIconMute.png"] forState:UIControlStateNormal];
        [btnSoundEffect setImage:[UIImage imageNamed:@"SoundIconMute.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        [btnSoundEffect setImage:[UIImage imageNamed:@"SoundIconNormal.png"] forState:UIControlStateNormal];
        [btnSoundEffect setImage:[UIImage imageNamed:@"SoundIconNormal.png"] forState:UIControlStateHighlighted];
    }
    if (appDelegate.shouldHomeMusicBeMute)
    {
        [btnHomeMusic setImage:[UIImage imageNamed:@"musicIconMute.png"] forState:UIControlStateNormal];
        [btnHomeMusic setImage:[UIImage imageNamed:@"musicIconMute.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        [btnHomeMusic setImage:[UIImage imageNamed:@"musicIconNormal.png"] forState:UIControlStateNormal];
        [btnHomeMusic setImage:[UIImage imageNamed:@"musicIconNormal.png"] forState:UIControlStateHighlighted];
    }
}

-(void)downloadRemainingImages
{
    if(appDelegate.shouldDownloadDataFromHome)
    {
        if([appDelegate checkInternetConnection])
        {
            appDelegate.intCurrentDownloadingImageIndex = 0;
            [appDelegate startDownloadingImages];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ALERT_TITLE message:ALERT_INTERNET delegate:nil cancelButtonTitle:ALERT_OK otherButtonTitles:nil];
            [alert show];
        }
    }
}

#pragma mark - FB Like related methods
-(void)setFbButtonInterface
{
   if([[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULTS_ISFB_PAGE_LIKED])
    {
        btnFacebookLike.hidden = TRUE;
    }
    else
    {
        btnFacebookLike.hidden = FALSE;
    }
}

-(void)setRateButtonInterface
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULTS_IS_RATED])
    {
        btnRateApp.hidden = TRUE;
    }
    else
    {
        btnRateApp.hidden = FALSE;
    }
}
-(void) LikePageInWeb
{
    NSString *fblink = [NSString stringWithFormat:@"https://www.facebook.com/GuessThisGame"];
    NSURL *url = [NSURL URLWithString:fblink];

    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    [webViewFBlike loadRequest:request];
    [self.view bringSubviewToFront:viewFBlike];
    CGRect frame = viewFBlike.frame;
    frame.origin.y = self.view.frame.size.height;
    viewFBlike.frame =frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    frame.origin.y =0;
    viewFBlike.frame = frame;
    [UIView commitAnimations];
    
    
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:USERDEFAULTS_ISFB_PAGE_LIKED];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setFbButtonInterface];
}


-(IBAction)btnCloseFBview:(id)sender
{
    CGRect frame = viewFBlike.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    frame.origin.y = self.view.frame.size.height;
    viewFBlike.frame = frame;
    appDelegate.isFBLike = FALSE;
    [appDelegate hideActivityIndicator];
    [UIView commitAnimations];
}

#pragma mark - Web View Delegate Method

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    appDelegate.isFBLike = FALSE;
    [appDelegate hideActivityIndicator];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    appDelegate.isFBLike = FALSE;
    [appDelegate hideActivityIndicator];
}

#pragma mark - ShareKit Delegate Methods
-(void)shareFBLoginStatus:(BOOL)loginSatus Error:(NSString *)loginError
{
    if(loginSatus == TRUE)
    {
        [self LikePageInWeb];
    }
    else
    {
        appDelegate.isFBLike = FALSE;
        [appDelegate hideActivityIndicator];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ALERT_TITLE message:loginError delegate:nil cancelButtonTitle:ALERT_OK otherButtonTitles:nil];
        [alert show];
    }
}


#pragma mark - Memory Management
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
