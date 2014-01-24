//
//  LevelViewController.h
//  What'sThat
//
//  Created by Vibhooti on 5/13/13.
//  Copyright (c) 2013 Vibhooti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InAppPurchase.h"
#import "AudioPlay.h"

typedef enum
{
    PhotoPost = 1,
    PhotoData = 2,
    FeedUser = 3,
}currentFacebookCall;

@interface LevelViewController : UIViewController<UITextFieldDelegate,InAppViewDelegate,ShareKitDelegate, GADBannerViewDelegate, IAPHelperDelegate>
{
    AudioPlay *objAudio;
    
    IBOutlet UIButton *btnInAppPurchase;
    
    IBOutlet UIImageView *imgViewTransparentBackground;
    
//    Top View
    IBOutlet UILabel *lblRoundNo;
    IBOutlet UILabel *lblLevelNo;

    IBOutlet UIView *viewQuestion;
    IBOutlet UIView *viewAnswer;
    IBOutlet UIView *viewTopBar;
    IBOutlet UIButton *btnHint1;
    IBOutlet UIButton *btnHint2;
    IBOutlet UIButton *btnHint3;
    
    IBOutlet UIButton *btnFacebook;

    IBOutlet UIButton *btnHint1Iphone4;
    IBOutlet UIButton *btnHint2Iphone4;
    IBOutlet UIButton *btnHint3Iphone4;
    
    IBOutlet UITextField *txtAnswerIphone4;
    IBOutlet UITextField *txtAnswer;
    
    IBOutlet UIImageView *questionImv;
    IBOutlet UIImageView *questionImvIphone4;
    
    //Hint View
    IBOutlet UIView *viewHint;
    IBOutlet UILabel *lblHintTitle;
    IBOutlet UILabel *lblHintMsg;
    IBOutlet UIButton *btnHintView;
    IBOutlet UIImageView *imgHintBackground;
    
    //More Stars View
    IBOutlet UIView *viewMoreStars;
    IBOutlet UIImageView *imgMoreStarsBackground;
    IBOutlet UILabel *lblMoreStarsMsg;
    IBOutlet UILabel *lblMoreStarsTitle;
    IBOutlet UIButton *btnMoreStarsCancel;
    IBOutlet UIButton *btnMoreStarsContinue;
    
    //Bonus View
    IBOutlet UIView *viewBonus;
    IBOutlet UIView *viewBonusOptionView;
    IBOutlet UILabel *lblBonusQuestion;
    IBOutlet UIButton *btnOption1;
    IBOutlet UIButton *btnOption2;
    IBOutlet UIButton *btnOption3;
    IBOutlet UIButton *btnOption4;
    IBOutlet UILabel *lblOption1;
    IBOutlet UILabel *lblOption2;
    IBOutlet UILabel *lblOption3;
    IBOutlet UILabel *lblOption4;
    IBOutlet UIButton *btnBonusViewOk;
    IBOutlet UIScrollView *scrBonusView;
    IBOutlet UILabel *lblBonusTime;
    int intBonusTimer;
    int intBounsOptionSelected;
    NSTimer *timerBonus;
    
    IBOutlet InAppPurchase *viewInAppPur;
//    NSMutableArray *arrayInAppPur;
    
    //Cloud Animation
    NSTimer *timer1;
    
    UIImageView *imvBigCloud1;
    UIImageView *imvSmallCloud1;
    
    UIImageView *imvBigCloud2;
    UIImageView *imvSmallCloud2;
    
    UIImageView *imvBigCloud3;
    UIImageView *imvSmallCloud3;
    
    UIImageView *imvBigCloud4;
    UIImageView *imvSmallCloud4;
    
    //Next Level Confirmation View
    IBOutlet UIView *viewNextLevel;
    IBOutlet UILabel *lblNextLevelMsg;
    IBOutlet UILabel *lblNextLevelTitle;
    IBOutlet UIButton *btnNextLevel;
   
    
    
    //Variables
    NSMutableDictionary *dicLevelInfo;
    NSMutableArray *arrayQuestion;
    
    BOOL isFirstLoad;
    
    BOOL isHint1Used;
    BOOL isHint2Used;
    BOOL isHint3Used;
    BOOL isHint1AlertShown;
    BOOL isHint2AlertShown;
    BOOL isHint3AlertShown;

    
    int intTotalStars;
    
    
    int intCurrentHint;
    
    int questionIndex;
    
    currentFacebookCall currentCall;
    BOOL Completed;

}

@property(nonatomic, strong) GADBannerView *adBanner;

#pragma mark - Button Click Methods
-(IBAction)btnBackClicked:(id)sender;
-(IBAction)btnFaceBookClicked:(id)sender;
-(IBAction)btnHintOkClicked:(id)sender;
-(IBAction)hintClicked:(id)sender;
-(IBAction)btnMoreStarsContinueClicked:(id)sender;
-(IBAction)btnMoreStarsCancelClicked:(id)sender;
-(IBAction)BtnStarClicked:(id)sender;
-(IBAction)btnNextLevelOkButtonClicked:(id)sender;
-(IBAction)btnBonusOk:(id)sender;
-(IBAction)btnBonusOption:(id)sender;


#pragma mark - Custom Methods
-(void)btnHint1Clicked;
-(void)btnHint2Clicked;
-(void)btnHint3Clicked;
-(void)changeViewFrameOnTextEditing;
-(void)retriveCurrentLevel;
-(void)proceedToNextQuestion;
-(void)proceedToNextLevel;
-(void)updateLevelScore;
-(void)updateQuestionStatus;
-(void)updateLocalQuestionScore;
-(void)updateLocalLevelScore;
-(void)initializeHints;
-(void)updateTotalStars;
-(void)level;
-(void)updateScore:(int)intScore;
-(void)updateScoreForUsingHint:(int)intScore;
-(void)updateBonusOptionSelected;
-(void)checkIfEnoughStars:(int)intStarsRequired;
-(void)showMoreStarsView;
-(void)hideMoreStarsView;
-(void)showHintView;
-(void)showNextLevelConfirmationView:(NSString *)strMsg areAllLevelsComplete:(BOOL)boolComplete;
-(void)setInterface;
-(void)showInAppPurchaseView;
-(void)showBonusView;;
-(void)invalidateBonusTimer;
-(void)flushOldDataFromInterface;
-(void)timerBonusMethod;
-(void)deactivateInterface;
-(void)activateInterface;
-(void)hideBonusView:(BOOL)doAnimation;
-(void)updateLevel;
-(void)retriveBonusInfo;
-(void)playSound:(BOOL)isLevel;
-(void)displayRoundLevel;
-(void)displayBonusTime;
-(void)setInterfaceForBonusView;
-(void)checkForNextLevel;
- (void)sendRequests;
-(void)inAppHideViews;
-(NSMutableDictionary *)setUpFaceBookDictionary;
@end
