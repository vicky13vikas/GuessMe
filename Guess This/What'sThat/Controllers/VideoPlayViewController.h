//
//  VideoPlayViewController.h
//  WOWmeg
//
//  Created by Vibhooti Kundaliya on 31/07/12.
//  Copyright (c) 2012 Mac 21. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SplashViewController.h"


@interface VideoPlayViewController : UIViewController
{
    SplashViewController *objSplash;
     MPMoviePlayerController *moviplayerController;
    MPMoviePlayerViewController *movieController;
    
}
-(void)eventVideoPlay;
-(void)goToSplashView;
@end
