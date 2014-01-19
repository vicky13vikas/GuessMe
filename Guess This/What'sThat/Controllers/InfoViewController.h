//
//  InfoViewController.h
//  What'sThat
//
//  Created by mac09 on 28/05/13.
//  Copyright (c) 2013 Vibhooti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoLinkViewController.h"
#import "InstructionViewController.h"

@interface InfoViewController : UIViewController<UIWebViewDelegate>
{
    InfoLinkViewController *objInfoLink;
    InstructionViewController *objInstruction;
    IBOutlet UIWebView *webView;
    NSString *strInfo;
    BOOL interceptLinks;
}

-(IBAction)btnBackClicked:(id)sender;
-(IBAction)btnResetClicked:(id)sender;
-(IBAction)btnInstructionClicked:(id)sender;
-(IBAction)btnFacebookClicked:(id)sender;


@end
