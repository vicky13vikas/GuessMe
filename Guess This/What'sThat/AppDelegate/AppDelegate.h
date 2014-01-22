//
//  AppDelegate.h
//  What'sThat
//
//  Created by Vibhooti on 5/13/13.
//  Copyright (c) 2013 Vibhooti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "CallWebServiceAsync.h"
#import "BDMultiDownloader.h"
#import "SplashViewController.h"
#import "AudioPlay.h"
#import "GADInterstitial.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"


typedef enum
{
    Downloading = 1,
    Downloaded = 2,
    NotStarted = 3,
}firstTwoLevelImageDownloadStatus;

@class HomeViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,CallWebServiceAsyncDelegate,GADInterstitialDelegate>
{
    IBOutlet UIWindow *window;
    IBOutlet UIWindow *windowControllers;
    
    IBOutlet UINavigationController *navigationController;   
    HomeViewController *homeVC;
    SplashViewController *objSplash;
    Reachability* hostReachable;
    CallWebServiceAsync *objWebService;
    
    IBOutlet UIActivityIndicatorView *activity;
    
    int intTotalScore;
    
    BOOL isNetworkAvailable;
    BOOL firstTimeNetworkChecked;
    BOOL isIphone5;
    BOOL isWSCalled;
    BOOL isInfoLinkWebViewLoading;
    
    BOOL isApplicationStarted;// so first time congratulations alert is not seen
//    NSMutableDictionary *dicImageInfo;
    
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
    
    BOOL isDownloadingData;//is web service data downloaded
    BOOL isCustomSVhud;//right wrong and activity indicator are in same hud so background color yellow or not
    
    BOOL shouldHomeMusicBeMute;
    BOOL shouldSoundEffectsBeMute;
    BOOL shouldDownloadDataFromHome;//whether next level images are yet to be downloaded from level mainly
    
    NSMutableArray *imageQueue;
    AudioPlay *objAudio;
    
    int intCurrentDownloadingImageIndex;//used while downloading images
    firstTwoLevelImageDownloadStatus intImageDownloadStatusStatus;
//    MPMoviePlayerViewController *mpMovieView;
    NSMutableArray *arrImageInfo;
    
    NSMutableArray *arrInitialSetQuestionInfo;
   
    NSMutableArray *arrSetMainInfo;
    BOOL isActivityIndicatorSeen;
    
    BOOL isFromFinishLaunching;//for playing first time video
    
    int intCurrentLevelImageDownloading;
    int intTotalSets;
    int maxLevelSet;
    int currentLevelSet;
    
    //In app
    NSArray *arrayProduct;
    BOOL isInSplashViewController;
    BOOL isPlayButtonClicked;
    
    BOOL isInAppHUD;
    BOOL isInFacebookSharing;
    BOOL isFBLike;//for not showing activity indicator while fb like
  
    BOOL isAdMobStarted;
    GADInterstitial *interstitial_;
  
    NSDate *launchTime;
}
@property (retain, nonatomic)  NSMutableArray *imageQueue;
@property (retain, nonatomic) NSMutableArray *arrInitialSetQuestionInfo;
@property (retain, nonatomic) UIWindow *window;
@property(nonatomic,retain)UIWindow *windowControllers;
@property (nonatomic,retain)UINavigationController *navigationController;
@property (retain, nonatomic) HomeViewController *homeVC;

@property(nonatomic,retain)NSMutableArray *arrImageInfo;
@property(nonatomic,retain)NSMutableArray *arrSetMainInfo;
@property(nonatomic,retain) UIActivityIndicatorView *activity;
@property(nonatomic,readwrite) BOOL isInAppHUD;
@property(nonatomic,readwrite)BOOL isNetworkAvailable;
@property(nonatomic,readwrite)BOOL firstTimeNetworkChecked;
@property(nonatomic,readwrite)BOOL isApplicationStarted;
@property (nonatomic,assign)BOOL isIphone5;
@property (nonatomic,assign) BOOL isWSCalled;
@property(nonatomic,readwrite)BOOL isDownloadingData;
@property(nonatomic,assign) BOOL isCustomSVhud;
@property(nonatomic,readwrite)BOOL shouldHomeMusicBeMute;
@property(nonatomic,readwrite)BOOL shouldSoundEffectsBeMute;
@property(nonatomic,readwrite)BOOL shouldDownloadDataFromHome;
@property(nonatomic,readwrite)BOOL isFromFinishLaunching;
@property(nonatomic,readwrite)BOOL isInfoLinkWebViewLoading;
@property(nonatomic,readwrite)BOOL isInSplashViewController;
@property(nonatomic,readwrite)BOOL isPlayButtonClicked;
@property(nonatomic,readwrite)BOOL isInFacebookSharing;
@property(nonatomic,readwrite)BOOL isFBLike;
@property(nonatomic,readwrite)firstTwoLevelImageDownloadStatus intImageDownloadStatusStatus;

@property(nonatomic,readwrite)int intTotalScore;
@property(nonatomic,readwrite)int intCurrentDownloadingImageIndex;
@property(nonatomic,readwrite)int intTotalSets;
@property(nonatomic,readwrite)int maxLevelSet;
@property(nonatomic,readwrite)int currentLevelSet;
@property(nonatomic,retain)AudioPlay *objAudio;

//@property(nonatomic,retain)NSMutableDictionary *dicImageInfo;

@property(nonatomic,retain)NSTimer *timer1;
@property(nonatomic, strong) id<GAITracker> tracker;

//In App
@property(nonatomic,retain)NSArray *arrayProduct;
-(NSArray *)fetchFirstLevelId;
-(BOOL)checkIfAnyActiveLevelsInCurrentSet:(int)intLevelSet;
-(BOOL)checkInternetConnection;
-(void)callSynchWebService;
-(void)synchDatabaseFromWebservice:(NSMutableDictionary *)dicData;
-(void)calculateCurrentScore;
-(void)initializeVariablesOnStarting;
-(void)initializingFunctionalitiesCalled;
- (BOOL)isIphone5;
-(void)calculateScoreOfPreviousLevels:(NSArray *)arrLevelScores;
-(void)refreshDatabase;
-(void)deleteAllImages;
-(void)getMaxLevelSet;
-(NSArray *)fetchMaxPlayedLevel;
-(void)stopDownloadingImages;
-(void)addLevelInfoInDatabase:(NSMutableArray *)arr;
-(void)addQuestionInfoInDatabase:(NSMutableArray *)arrQuestions;
-(void)updateQuestionInfoInDatabase:(NSMutableDictionary *)dicQuestionInfo;
-(void)updateBonusQuestionInfo:(NSMutableDictionary *)dicQuestion;
-(int)retriveMaxQuestionNo:(int)intLevelID;
-(int)retriveCountOfQuestionsInLevel:(int)intLevelID;
-(void)setAvAudioSession;
-(void)initiateDownloadingLevel:(NSString *)strImageName levelId:(int)intLevel questionId:(int)intQuestion;
-(void)initiateDownloadingLevel;
-(void)updateImageStatusInDatabase:(int)intLevelID QuestionID:(int)intQuestionID;
//-(void)downloadImage:(NSString *)strImageName levelId:(int)intLevel questionId:(int)intQuestion;
-(void)downloadImage;
-(BOOL)checkIFAllLevelImagesDownloaded;
-(void)checkIfAllImagesDownloaded;
-(void)goForNextLevelDownloadImage;
-(int)getIndexOfHomeController;
-(void)startActivity;
-(void)stopActivity;
-(void)checkMuteEffectAndPlayMusic;
-(void)showViewAnimation:(UIView *)view;
-(void)hideViewAnimation:(UIView *)view;
-(NSArray *)getLevelsBought;
-(void)setCloudInterface:(UIView *)view;
-(void)cloudAnimation;
-(void)invalidateCloudAnimationTimer;
-(BOOL)checkIfAnyActiveLevels;

-(void)startDownloadingImages;
-(void)checkInternetConnectionFirstTime;
-(NSArray *)fetchActiveLevelId:(int)intLevelSet;
-(void)callRateIt;
-(void)enableHomeButtons;
-(void)disableHomeButtons;
-(int)getExtraPoints;
-(BOOL)isIpod;
-(int)getTotalAnsweredQuestionsForLevelSet:(int)intLevelSet;
-(BOOL)checkQueryReturnedArrayCondition:(NSArray *)arrTemp;
-(int)getTotalQuestions;
-(void)setLeveSetBought:(int)intLevelSet;
-(BOOL)checkIFAllImagesDownloaded;
#pragma mark - Activity Indicator Related Methods
-(void)showActivityIndicator;
-(void)hideActivityIndicator;
-(void)alterTable;
//Downloading Initial Set Images
-(void)downloadInitialSetImages;
-(NSMutableArray *)get4SetImages;
-(NSMutableDictionary *)getImageURLForInitialSetQuestion:(int)intSetNo;
-(void)checkIFAllInitialSetImagesDownloaded;
@end
