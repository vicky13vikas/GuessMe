//
//  HomeViewController.h
//  What'sThat
//
//  Created by Vibhooti on 5/13/13.
//  Copyright (c) 2013 Vibhooti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioPlay.h"
#import "OBShapedButton.h"
#import "InfoViewController.h"
#import "ShareKitFile.h"
#import "LevelSetsViewController.h"

@interface HomeViewController : UIViewController<ShareKitDelegate>
{
    InfoViewController *objInfo;
    
    
    IBOutlet UIView *viewMusic;
    
    IBOutlet UIButton *btnFacebookLike;
    IBOutlet UIButton *btnInfo;
    IBOutlet OBShapedButton *btnPlay;
    IBOutlet UIButton *btnMusic;

    
    IBOutlet UIImageView *imgTransparentBackgound;
    IBOutlet UIButton *btnHomeMusic;
    IBOutlet UIButton *btnSoundEffect;
    
    IBOutlet UILabel *label;
    
    IBOutlet UIWebView *webViewFBlike;
    IBOutlet UIView *viewFBlike;
    
    IBOutlet UIButton *btnInstruction;
    IBOutlet UIButton *btnRateApp;

}

@property(nonatomic,retain)OBShapedButton *btnPlay;
@property(nonatomic,retain)UIButton *btnMusic;
@property(nonatomic,retain)UIButton *btnFacebookLike;
@property(nonatomic,retain)UIButton *btnInfo;
@property(nonatomic,retain)UIButton *btnRateApp;

@property(nonatomic,retain) UIButton *btnInstruction;

-(IBAction)btnInfoAction:(id)sender;
-(IBAction)btnPlayAction:(id)sender;
-(IBAction)btnMusicAction:(id)sender;
-(IBAction)btnHomeMusicAction:(id)sender;
-(IBAction)btnSoundEffectsAction:(id)sender;
-(IBAction)btnMusicCloseAction:(id)sender;
-(IBAction)btnFacebookLike:(id)sender;
-(IBAction)btnRateApp:(id)sender;
-(IBAction)btnCloseFBview:(id)sender;

-(void)downloadRemainingImages;

- (BOOL)openSessionWithAllowLoginUIWithoutPermission:(BOOL)allowLoginUI Data:(NSMutableDictionary *)dic;
-(void) LikePageInWeb;
-(void)setInterface;
-(void)setFbButtonInterface;
-(void)setRateButtonInterface;
@end
