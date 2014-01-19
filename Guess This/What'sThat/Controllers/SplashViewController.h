//
//  SplashViewController.h
//  What'sThat
//
//  Created by mac16 on 06/06/13.
//  Copyright (c) 2013 Vibhooti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

@interface SplashViewController : UIViewController
{
    HomeViewController *objHome;
    IBOutlet UIImageView *imgSplash;
    NSTimer *timerSplash;
}
-(void)goToHomeController;

@end
