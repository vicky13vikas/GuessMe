//
//  InstructionViewController.m
//  What'sThat
//
//  Created by mac16 on 14/06/13.
//  Copyright (c) 2013 Vibhooti. All rights reserved.
//

#import "InstructionViewController.h"


@implementation InstructionViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (appDelegate.isIphone5)
    {
        if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
//            CGFloat scale = [[UIScreen mainScreen] scale];
            imvInst.image = [UIImage imageNamed:@"infoPlayLarge@2x.png"];
        }
    }
}

#pragma mark - Custom Methods
-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

#pragma mark - Memory Management
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
