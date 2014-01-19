//
//  InfoLinkViewController.m
//  What'sThat
//
//  Created by mac16 on 06/06/13.
//  Copyright (c) 2013 Vibhooti. All rights reserved.
//

#import "InfoLinkViewController.h"

@interface InfoLinkViewController ()

@end

@implementation InfoLinkViewController

@synthesize urlInfoLink,isFacebookPage;

#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [appDelegate performSelector:@selector(showActivityIndicator) withObject:nil afterDelay:0.5];
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{    
    appDelegate.isInfoLinkWebViewLoading = TRUE;
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:self.urlInfoLink];
    [webview loadRequest:request];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self hideActivityOFInfoWebView];
}
#pragma mark - Button Click Methods
-(IBAction)btnBackClicked:(id)sender
{
    if (self.isFacebookPage) {
        [self dismissModalViewControllerAnimated:YES];
    }
    else{
      [appDelegate.navigationController popViewControllerAnimated:FALSE];
    }

}

#pragma mark - Custom Methods
-(void)hideActivityOFInfoWebView
{
    appDelegate.isInfoLinkWebViewLoading = FALSE;
    [appDelegate hideActivityIndicator];
}


#pragma mark - Web View Delegate Method

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideActivityOFInfoWebView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [appDelegate hideActivityIndicator];
}
#pragma mark - Memory Management
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
