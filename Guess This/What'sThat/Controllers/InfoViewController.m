//
//  InfoViewController.m
//  What'sThat
//
//  Created by mac09 on 28/05/13.
//  Copyright (c) 2013 Vibhooti. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController



#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    strInfo = @"<html><body><p align=justify><font face=\"Helvetica\" size=\"1.0\">50 App Street Limited <br><br>Guess This!<br><br>The fun brain teasing quiz game which will get you testing your brain to the max! With over 100 levels of phrases, sayings and words, you will be scrambling to try remember what that saying is. Our little tip is to breakdown what you see....that's all! The answer is staring you in the face! (Literally!) Good luck and happy guessing!<br><br>We would like too thank you for downloading Guess This and hope you have hours of fun trying to work out our puzzles.If you can spare a minute, we would love to hear a review from you on the App Store, to show your support for the game please.If you have any questions, ideas, queries or trouble with the app, please contact <a href=\"http:\\matt@50appstreet.co.uk\">matt@50appstreet.co.uk</a> we take all emails into consideration.<br><br>Copyright<br>All images and themes are copyright of 50 App Street Limited. </font> </p></body></html>";
    
    [webView loadHTMLString:strInfo baseURL:nil];

    interceptLinks = FALSE;
    // NSLog(@"WillAppear");
    [appDelegate performSelector:@selector(setCloudInterface:) withObject:self.view afterDelay:0.0];
    
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

#pragma mark - Alert View Methods
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        [appDelegate calculateCurrentScore];
        [[NSUserDefaults standardUserDefaults] setInteger:appDelegate.intTotalScore forKey:USERDEFAULTS_GAMESCORE];
        [[NSUserDefaults standardUserDefaults]setBool:TRUE forKey:USERDEFAULTS_IS_DB_REFRESHED];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:USERDEFAULTS_SYNCHTIME];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [appDelegate refreshDatabase];
        [appDelegate deleteAllImages];
        appDelegate.isDownloadingData = FALSE;
        appDelegate.shouldDownloadDataFromHome = TRUE;
        [appDelegate stopDownloadingImages];
//        [appDelegate deleteAllImages];
    }
}

#pragma mark - Button Click Methods
-(IBAction)btnResetClicked:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ALERT_TITLE message:@"Are you sure do you want to reset?" delegate:self cancelButtonTitle:ALERT_YES otherButtonTitles:ALERT_NO,nil];
    alert.tag = 1;
    [alert show];
}
-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //You might need to set up a interceptLinks-Bool since you don't want to intercept the initial loading of the content
    if (interceptLinks) {
        NSURL *url = request.URL;
        //This launches your custom ViewController, replace it with your initialization-code
//        [[UIApplication sharedApplication] openURL:url];
        if(!objInfoLink){
            objInfoLink = nil;
        }
        objInfoLink = [[InfoLinkViewController alloc]initWithNibName:@"InfoLinkViewController" bundle:nil];
        objInfoLink.isFacebookPage = NO;
        objInfoLink.urlInfoLink = url;
        [appDelegate.navigationController pushViewController:objInfoLink animated:NO];
        interceptLinks = FALSE;
        return NO;
    }
    //No need to intercept the initial request to fill the WebView
    else {
        interceptLinks = TRUE;
        return YES;
    }
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}


-(IBAction)btnInstructionClicked:(id)sender
{
    if(!objInstruction)
    {
        objInstruction = [[InstructionViewController alloc]initWithNibName:@"InstructionViewController" bundle:nil];
    }

    [appDelegate.navigationController pushViewController:objInstruction animated:TRUE];
}

-(IBAction)btnFacebookClicked:(id)sender
{
    if(!objInfoLink){
        objInfoLink = nil;
    
    }
    objInfoLink = [[InfoLinkViewController alloc]initWithNibName:@"InfoLinkViewController" bundle:nil];
    objInfoLink.isFacebookPage = YES;
    objInfoLink.urlInfoLink = [NSURL URLWithString:@"https://www.facebook.com/50AppStreet"];
//    [appDelegate.navigationController pushViewController:objInfoLink animated:NO];
    [self presentModalViewController:objInfoLink animated:YES];
}
#pragma mark - Memory Management
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
