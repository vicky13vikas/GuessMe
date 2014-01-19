//
//  SplashViewController.m
//  What'sThat
//
//  Created by mac16 on 06/06/13.
//  Copyright (c) 2013 Vibhooti. All rights reserved.
//

#import "SplashViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController


#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    appDelegate.isInSplashViewController = TRUE;
    if([appDelegate isIphone5])
    {
        imgSplash.image = [UIImage imageNamed:@"splashLarge.png"];
    }
    else
    {
        imgSplash.image = [UIImage imageNamed:@"splash.png"];
    }
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    if(timerSplash)
    {
        timerSplash = nil;
        [timerSplash invalidate];
    }
    
    timerSplash = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(goToHomeController) userInfo:nil repeats:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    appDelegate.isInSplashViewController = FALSE;
}

#pragma mark - Interface Orientaion
- (BOOL)shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Custom Methods
-(void)goToHomeController
{
    if(!objHome)
        objHome = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
    [self.navigationController pushViewController:objHome animated:NO];
}

-(void)checkMuteEffectAndPlayMusic
{
    BOOL isMute = [[NSUserDefaults standardUserDefaults]boolForKey:USERDEFAULTS_ISHOMEMUSICMUTE];
    
    if(isMute)
    {
        if ([appDelegate.objAudio.audioPlayer isPlaying])
            [appDelegate.objAudio stopAudio];
    }
    else
    {
        if (![appDelegate.objAudio.audioPlayer isPlaying])
            [appDelegate.objAudio playAudio];
    }
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
