//
//  InfoLinkViewController.h
//  What'sThat
//
//  Created by mac16 on 06/06/13.
//  Copyright (c) 2013 Vibhooti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoLinkViewController : UIViewController
{
    NSURL *urlInfoLink;
    
    IBOutlet UIWebView *webview;
    BOOL isFacebookPage;

}
@property(nonatomic,assign)BOOL isFacebookPage;
-(IBAction)btnBackClicked:(id)sender;
-(void)hideActivityOFInfoWebView;

-(IBAction)btnInstructionClicked:(id)sender;

@property(nonatomic,retain)NSURL *urlInfoLink;



@end
