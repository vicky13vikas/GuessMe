//
//  VideoPlayViewController.m
//  WOWmeg
//
//  Created by Vibhooti Kundaliya on 31/07/12.
//  Copyright (c) 2012 Mac 21. All rights reserved.
//

#import "VideoPlayViewController.h"
#import "HomeViewController.h"

@implementation VideoPlayViewController


#pragma mark - View lifecycle

- (void)viewDidLoad
{    
    [super viewDidLoad];
    
//    [[UIApplication sharedApplication]setStatusBarHidden:NO];
//    [[UIApplication sharedApplication]setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
  
    NSLog(@"video controller view did load");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self goToSplashView];
}

#pragma mark - Interface Orientation Methods

-(BOOL) shouldAutorotate
{
     return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
	return  YES;
}


#pragma mark - Custom Methods

-(void)eventVideoPlay{
    
    [appDelegate  performSelector:@selector(hideActivityIndicator) withObject:nil afterDelay:0.5];

    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"FinalLogo" ofType:@"mov"];
    
    NSURL *movieURL = [NSURL fileURLWithPath:filePath];
   
    
    movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
    CGRect frame = self.view.frame;
    
    if (appDelegate.isIphone5) {
//        frame.size.height = 588;
///        frame.size.height = 340;
    }
    else{
//        frame.size.height = 480;
    }
    frame.size.height = 600;
//    frame.origin.y = -20;
//    self.view.frame = frame;
    movieController.view.backgroundColor=[UIColor orangeColor];
    self.view.backgroundColor=[UIColor purpleColor];
    movieController.view.frame  = frame;
    [self.view addSubview:movieController.view];
    appDelegate.window.backgroundColor = [UIColor redColor];
    [movieController.moviePlayer play];
    [movieController.moviePlayer setControlStyle:MPMovieControlStyleNone];
    
    NSLog(@"video controller movie play frame::%@::movieurl::%@",NSStringFromCGRect(movieController.view.frame),movieURL);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerLoadStateChanged)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doneButtonClick)
                                                 name:MPMoviePlayerWillExitFullscreenNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishPlayback) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
       

}
-(void)moviePlayerLoadStateChanged
{
    NSLog(@"moviePlayerLoadStateChanged");
    [moviplayerController play];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerLoadStateDidChangeNotification
                                                  object:nil];

}

-(void)doneButtonClick{
//    [[UIApplication sharedApplication]setStatusBarOrientation:UIInterfaceOrientationPortrait];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerWillExitFullscreenNotification
                                                  object:nil];

   [self.navigationController popViewControllerAnimated:NO];
        
    [self goToSplashView];
}


-(void)didFinishPlayback
{
    NSLog(@"didFinishPlayback");
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:nil];

    
    [self.navigationController popViewControllerAnimated:NO];
    
    [self goToSplashView];
}

-(void)playAudio
{
    if(!appDelegate.objAudio)
        appDelegate.objAudio = [[AudioPlay alloc]init];
    appDelegate.objAudio.strAudioFile = @"playStart.wav";
    [appDelegate checkMuteEffectAndPlayMusic];    
}

-(void)goToSplashView
{
    [self performSelector:@selector(playAudio)];
    appDelegate.window.hidden = TRUE;
    appDelegate.windowControllers.hidden = FALSE;

    objSplash = [[SplashViewController alloc]initWithNibName:@"SplashViewController" bundle:nil];
    appDelegate.navigationController = [[UINavigationController alloc]initWithRootViewController:objSplash];
    appDelegate.navigationController.navigationBarHidden = YES;
    appDelegate.windowControllers.hidden = TRUE;
    appDelegate.windowControllers.rootViewController = appDelegate.navigationController;

    [appDelegate.windowControllers makeKeyAndVisible];
    [[UIApplication sharedApplication]setStatusBarOrientation:UIInterfaceOrientationPortrait];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
