



//
//  AppDelegate.m
//  What'sThat
//
//  Created by Vibhooti on 5/13/13.
//  Copyright (c) 2013 Vibhooti. All rights reserved.
//

#import "AppDelegate.h"

#import "HomeViewController.h"
#import "VideoPlayViewController.h"
#import "LevelViewController.h"
#import "TestFlight.h"

static NSString *const kTrackingId = @"UA-43130151-5";  //Google Analytics

@implementation AppDelegate
@synthesize window;
@synthesize navigationController,homeVC;
@synthesize isNetworkAvailable;
@synthesize firstTimeNetworkChecked;
@synthesize intTotalScore;
@synthesize isWSCalled;
@synthesize isIphone5,isApplicationStarted;
@synthesize activity;
//@synthesize dicImageInfo;
@synthesize timer1;
@synthesize isDownloadingData;
@synthesize isCustomSVhud;
@synthesize imageQueue;
@synthesize shouldHomeMusicBeMute,shouldSoundEffectsBeMute;
@synthesize intImageDownloadStatusStatus;
@synthesize shouldDownloadDataFromHome,intCurrentDownloadingImageIndex;
@synthesize arrImageInfo;
@synthesize isFromFinishLaunching;
@synthesize windowControllers;
@synthesize isInfoLinkWebViewLoading;
@synthesize arrayProduct,isInSplashViewController;
@synthesize objAudio;
@synthesize isPlayButtonClicked;
@synthesize isInAppHUD;
@synthesize isInFacebookSharing;
@synthesize isFBLike;
@synthesize intTotalSets;
@synthesize arrInitialSetQuestionInfo;
@synthesize arrSetMainInfo;
@synthesize maxLevelSet;
@synthesize currentLevelSet;
#pragma mark - Application Methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"didFinishLaunchingWithOptions");
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [UIApplication sharedApplication].idleTimerDisabled = TRUE;
    [self initializeVariablesOnStarting];
    NSLog(@"method 1");

    [self initializingFunctionalitiesCalled];
    NSLog(@"before calling video play");
    VideoPlayViewController *videoPlayVC = [[VideoPlayViewController alloc]initWithNibName:@"VideoPlayViewController" bundle:nil];
    self.window.rootViewController = videoPlayVC;
//    [self.window addSubview:videoPlayVC.view];
    NSLog(@"before calling video play 2");
    [self.window makeKeyAndVisible];
    
    [TestFlight takeOff:@"beb9bf33-2019-401b-a03f-093504ef93b7"];
  
    [GAI sharedInstance].dispatchInterval = 60;
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    self.tracker = [[GAI sharedInstance] trackerWithName:@"GuessThis"
                                            trackingId:kTrackingId];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  
  NSTimeInterval intervalSincelaunch = [[NSDate date] timeIntervalSinceDate:launchTime];
  NSLog(@"%d",[[NSNumber numberWithDouble:intervalSincelaunch] intValue]);
  NSMutableDictionary *event =
  [[GAIDictionaryBuilder createTimingWithCategory:@"TimeSpent" interval:[NSNumber numberWithDouble:intervalSincelaunch] name:@"VIKAS" label:@""] build];
  [[GAI sharedInstance].defaultTracker send:event];
  [[GAI sharedInstance] dispatch];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"applicationWillEnterForeground");
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"application did become active");
    if(!self.isInFacebookSharing)
    {
        NSLog(@"!self.isInFacebookSharing");
        [self hideActivityIndicator];
    }
    else
    {
        [SVProgressHUD showWithStatus:@"Wait"];
        [self showActivityIndicator];
    }
//    [self callRateIt];
  launchTime = [NSDate date];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    if([objShareKit isSessionValid])
    {
        [objShareKit logout];
    }
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (self.window.hidden==FALSE)
    {
        return UIInterfaceOrientationMaskLandscape;
    }
    
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    //    NSLog(@"isFaceBookAppCalled = TRUE;");
    NSLog(@"handle open url");
    return [objShareKit._facebook handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSLog(@"open url");
    return [objShareKit._facebook handleOpenURL:url];
;
}

#pragma mark - Interface Orientation
-(BOOL) shouldAutorotate
{
    if (self.window.hidden==FALSE)
    {
        return YES;
    }
    
    return NO;
}

#pragma mark - Initialization Functions
-(void)initializeVariablesOnStarting
{
    isInAppHUD = NO;
    self.isInFacebookSharing = FALSE;
    self.isFBLike = FALSE;
    self.isFromFinishLaunching = TRUE;
    self.isInSplashViewController = FALSE;
    self.isNetworkAvailable = FALSE;
    self.isPlayButtonClicked = FALSE;
    self.intImageDownloadStatusStatus = NotStarted;
    self.intCurrentDownloadingImageIndex = 0;
    self.shouldHomeMusicBeMute = [[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULTS_ISHOMEMUSICMUTE];
    self.shouldSoundEffectsBeMute = [[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULTS_ISSOUNDEFFECTSMUTE];//Initially sound effects are there
    self.isDownloadingData = FALSE;//Data is still not downloaded
    self.firstTimeNetworkChecked = FALSE;
    self.isWSCalled = FALSE;
    self.shouldDownloadDataFromHome = FALSE;
    imageQueue = [[NSMutableArray alloc]init];
    self.isInfoLinkWebViewLoading = FALSE;
    isActivityIndicatorSeen = TRUE;
    objDocDir = [[DocDirectory alloc]init];
    objDataBase = [[databaseFile alloc]init];
  
    isAdMobStarted = NO;
}
-(void)initializingFunctionalitiesCalled
{
    self.currentLevelSet=-1;
    self.maxLevelSet = -1;
    [self setAvAudioSession];
    [SVProgressHUD setStatus:@"Checking Net Connection"];
    [objDataBase openDatabase];
    isIphone5 = [self isIphone5];
    
    //In app
    [RageIAPHelper sharedInstance];
    
    
    [[RageIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            self.arrayProduct = products;
            NSLog(@"arrayProduct : %@",[arrayProduct description]);
            //            NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"price" ascending: YES];
            //            [arrayProduct sortedArrayUsingDescriptors: [NSArray arrayWithObject:sortOrder]];
        }
    }];
    
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULTS_IS_ALREADY_INSTALLED])
    {
        NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
		NSDate *startDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
        [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:USERDEFAULTS_CURRENT_SET];
		[[NSUserDefaults standardUserDefaults] setObject:startDate forKey:USERDEFAULTS_RATE_ST_DATE];
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:USERDEFAULTS_IS_ALREADY_INSTALLED];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:USERDEFAULTS_IS_RATED];
		[[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark - Connection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
    self.isNetworkAvailable = TRUE;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
    self.isNetworkAvailable = FALSE;
}

#pragma mark - Custom Methods
-(void)checkInternetConnectionFirstTime
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"]];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

//#pragma mark - Internet Connection Method
-(BOOL)checkInternetConnection
{     
    return [[Reachability sharedReachability] internetConnectionStatus];
}

-(void)callSynchWebService
{
    // NSLog(@"callSynchWebService");
    if([self checkInternetConnection])
    {
        [SVProgressHUD setStatus:@"Loading..."];
         // NSLog(@"checkInternetConnection");
        objWebService = [[CallWebServiceAsync alloc]init];
        objWebService.ws_type = synchQuestion;
        objWebService.delegate=self;
        NSString *strURL;
        
        NSString *strLastTime = [[NSUserDefaults standardUserDefaults]objectForKey:USERDEFAULTS_SYNCHTIME];
        

        if([strLastTime length]==0)
        {
            strURL = WEBSERVICE;
        }
        else
        {
            strURL = [NSString stringWithFormat:@"%@[{\"%@\":\"%@\"}]",WEBSERVICE, WB_TIME_REQUEST,[[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_SYNCHTIME]];
        }
//               strURL = @"http://23.21.226.54/web/whatsthatgame/ver1/api/level/getallquestiondetails/bulkdata/[%7B%22time_request%22:%222013-10-10%2012:51:39%22%7D]";

        [self disableHomeButtons];

        NSLog(@"struurl::%@",strURL);
        [objWebService startDownload:strURL];
    }
    else
    {
        [self enableHomeButtons];
        [self hideActivityIndicator];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ALERT_TITLE message:ALERT_INTERNET delegate:nil cancelButtonTitle:ALERT_OK otherButtonTitles:nil];
        [alert show];
    }
}

- (BOOL)isIphone5
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0)
    {
        if([[UIScreen mainScreen] bounds].size.height == 568.0)
            return YES;
    }
    
    return NO;
}
-(BOOL)isIpod
{
    NSString *deviceType = [UIDevice currentDevice].model;

    if([deviceType isEqualToString:@"iPhone"])
    {
        return FALSE;
    }
    else
    {
        return TRUE;
    }
}

-(void)setAvAudioSession
{
    AVAudioSession *audiosession = [AVAudioSession sharedInstance];
    [audiosession setCategory:AVAudioSessionCategoryPlayback error:nil];
    OSStatus propertySetError = 0;
    
    UInt32 mixingAllow = true;
    propertySetError = AudioSessionSetProperty ( kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof (mixingAllow),&mixingAllow);
    
    NSError *error = nil;
    [audiosession setActive:YES error:&error];
}

-(int)getIndexOfHomeController
{
    NSArray *arrTemp = [self.navigationController viewControllers];
    int intHomeIndex = -1;
    
    for(int i=0;i<[arrTemp count];i++)
    {
        if([[arrTemp objectAtIndex:i] isKindOfClass:[HomeViewController class]])
        {
            intHomeIndex = i;
            break;
        }
    }
    return intHomeIndex;
}

-(void)checkMuteEffectAndPlayMusic
{
    BOOL isMute = [[NSUserDefaults standardUserDefaults]boolForKey:USERDEFAULTS_ISHOMEMUSICMUTE];
    
    if(isMute)
    {
        if ([appDelegate.objAudio.audioPlayer isPlaying])
            [appDelegate.objAudio stopAudio];
    }
    else
    {
        if (![appDelegate.objAudio.audioPlayer isPlaying])
            [appDelegate.objAudio playAudio];
    }
}

-(void)callRateIt
{
	if ([[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_RATE_ST_DATE] == nil && [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_IS_RATED] == nil)
	{
		NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
		NSDate *startDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
		[[NSUserDefaults standardUserDefaults] setObject:startDate forKey:USERDEFAULTS_RATE_ST_DATE];
		[[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:USERDEFAULTS_IS_RATED];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
//        [self stopSliding];
//        isAlertRateShow = TRUE;
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALERT_TITLE
															  message:ALERT_RATEMSG
															 delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ask me later",@"Yes, rate it!",nil];
		
		alert.tag = 1;
		[alert show];		
	}
	else
	{
		NSTimeInterval interval=[[NSDate date] timeIntervalSinceDate:(NSDate *)[[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULTS_RATE_ST_DATE]];
		int days=(int) (interval/(60.0*60.0*24.0));
		
		if (days>=RATE_TIMEINTERVAL && [[[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_IS_RATED] intValue] == 0 )
		{
            
//            [self stopSliding];
//            isAlertRateShow = TRUE;
            
			UIAlertView *alertRating = [[UIAlertView alloc] initWithTitle:ALERT_TITLE
																  message:ALERT_RATEMSG
																 delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ask me later",@"Yes, rate it!",nil];
			
			alertRating.tag = 1;
			[alertRating show];
		}
		else
		{
			/*if ([[[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_IS_RATED] intValue] == 1) 
             {
				NSTimeInterval interval=[[NSDate date] timeIntervalSinceDate:(NSDate *)[[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULTS_RATE_ST_DATE]];
				int days=(int) (interval/(60.0*60.0*24.0));
				if (days>=RATE_TIMEINTERVAL)
				{
                    
//                    [self stopSliding];
//                    isAlertRateShow = TRUE;
                    
					UIAlertView *alertRating = [[UIAlertView alloc] initWithTitle:ALERT_TITLE
																		  message:ALERT_RATEMSG
																		 delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ask me later",@"Yes, rate it!",nil];
					
					alertRating.tag = 10;
					[alertRating show];
				}
				else
                {
					
				}
                
			}*/
			
		}
	}
}

#pragma mark - Database related Methods

-(void)synchDatabaseFromWebservice:(NSMutableDictionary *)dicData
{
    NSLog(@"synchDatabaseFromWebservice");
    int intStatus = [[dicData objectForKey:WB_KEY_STATUS] intValue];
    NSLog(@"intStatus::%d",intStatus);
    if(intStatus)
    {
        NSMutableArray *arrLevels = (NSMutableArray *)[dicData objectForKey:WB_KEY_DATA];    
        NSLog(@"[dicData objectForKey:WB_KEY_DATA]::%@",[[dicData objectForKey:WB_KEY_DATA] description]);
        NSLog(@"arrLevels::%@",arrLevels);
        NSString *strLastTime = [[NSUserDefaults standardUserDefaults]objectForKey:USERDEFAULTS_SYNCHTIME];
        if([strLastTime length]==0)
        {
            NSLog(@"[strLastTime length]==0");
            for(int i=0;i<[arrLevels count];i++)
            {
                NSDictionary *dicLevel = [arrLevels objectAtIndex:i];
                NSLog(@"dicLevel::%@",dicLevel);
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                [dict setObject:[dicLevel objectForKey:WB_BONUS_ANSWER] forKey:DB_BQ_ANS];
                [dict setObject:[dicLevel objectForKey:WB_BONUS_QUE] forKey:DB_BQ_IMG_NM];
                [dict setObject:[dicLevel objectForKey:WB_BONUS_OPTION1] forKey:DB_BQ_OPTION1];
                [dict setObject:[dicLevel objectForKey:WB_BONUS_OPTION2] forKey:DB_BQ_OPTION2];
                [dict setObject:[dicLevel objectForKey:WB_BONUS_OPTION3] forKey:DB_BQ_OPTION3];
                [dict setObject:[dicLevel objectForKey:WB_BONUS_OPTION4] forKey:DB_BQ_OPTION4];
                [dict setObject:[dicLevel objectForKey:WB_LEVEL_ID] forKey:DB_LEVEL_ID];
                [dict setObject:[dicLevel objectForKey:WB_LEVEL_NAME] forKey:DB_LEVEL_NAME];
                [dict setObject:[NSString stringWithFormat:@"%d",PLAYSTATUS_NOTPLAYED] forKey:DB_LEVEL_PLAY];
                [dict setObject:[NSString stringWithFormat:@"%d",i+1] forKey:DB_LEVEL_NO];
                if(i==0)
                {
                    if([[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULTS_IS_DB_REFRESHED])
                    {
                        [dict setObject:[NSString stringWithFormat:@"%d",[[NSUserDefaults standardUserDefaults] integerForKey:USERDEFAULTS_GAMESCORE]] forKey:DB_LEVEL_SCORE];
                        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:USERDEFAULTS_IS_DB_REFRESHED];
                        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:USERDEFAULTS_GAMESCORE];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    else
                    {
                        [dict setObject:[NSString stringWithFormat:@"%d",0] forKey:DB_LEVEL_SCORE];
                    }
                }
                
                [dict setObject:[NSString stringWithFormat:@"%d",0] forKey:DB_BQ_SCORE];
                [dict setObject:[NSString stringWithFormat:@"%d",1] forKey:DB_LEVEL_ACTIVE];                
//                [dict setObject:[dicLevel objectForKey:WB_LEVEL_STATUS] forKey:DB_LEVEL_ACTIVE];
                
                //check addLevelInfoInDatabase function also while editing code for adding in level
                [objDataBase insertData:dict tableName:DB_TABLE_LEVEL];
                
                NSArray *arrQuestions = [dicLevel objectForKey:WB_KEY_QUE];
                NSLog(@"[dicLevel objectForKey:WB_KEY_QUE]::%@",[[dicLevel objectForKey:WB_KEY_QUE] description]);
                
                if(arrQuestions && [arrQuestions isKindOfClass:[NSArray class]])
                {
                    NSLog(@"arrQuestions && [arrQuestions isKindOfClass:[NSArray class]]");
                    int intQuestionNo = 0;
                    for(int i=0;i<[arrQuestions count];i++)
                    {
                        intQuestionNo++;
                        NSDictionary *dicQuestion = [arrQuestions objectAtIndex:i];
                        NSLog(@"dicQuestion::%@",[dicQuestion description]);
                        NSMutableDictionary *dictTemp = [[NSMutableDictionary alloc]init];
                        [dictTemp setObject:[dicQuestion objectForKey:WB_LEVEL_ID] forKey:DB_LEVEL_ID];
                        [dictTemp setObject:[dicQuestion objectForKey:WB_QUESTION_ID] forKey:DB_QUE_ID];
                        [dictTemp setObject:[dicQuestion objectForKey:WB_QUE_HINT1] forKey:DB_QHINT1];
                        [dictTemp setObject:[dicQuestion objectForKey:WB_QUE_HINT2] forKey:DB_QHINT2];
                        [dictTemp setObject:[dicQuestion objectForKey:WB_QUE_HINT3] forKey:DB_QHINT3];
                        [dictTemp setObject:[dicQuestion objectForKey:WB_QUE_ANS] forKey:DB_QANS];
                        [dictTemp setObject:[dicQuestion objectForKey:WB_QUE_IMG] forKey:DB_QIMG_NM];
//                        [dictTemp setObject:[NSString stringWithFormat:@"1"] forKey:DB_QUE_ACTIVE];
                        [dictTemp setObject:[dicQuestion objectForKey:WB_QUE_STATUS] forKey:DB_QUE_ACTIVE];
                        [dictTemp setObject:@"FALSE" forKey:DB_QUE_IMGDOWNSTAT];
                        [dictTemp setObject:[NSString stringWithFormat:@"%d",intQuestionNo] forKey:DB_QUE_NO];
                        
                        //check addQuestionInfoInDatabase function also while editing code for adding in question
                        [objDataBase insertData:dictTemp tableName:DB_TABLE_QUESTION];
                        
//                        [appDelegate downloadImage:[dictTemp objectForKey:DB_QIMG_NM] levelId:[[dictTemp objectForKey:DB_LEVEL_ID]intValue]questionId:[[dictTemp objectForKey:DB_QUE_ID]intValue]];
                        
                    }
                }
                
            }
            
            [[NSUserDefaults standardUserDefaults]setObject:[dicData objectForKey:WB_TIME_REQUEST] forKey:USERDEFAULTS_SYNCHTIME];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {

            if([arrLevels count]==0)
            {
                // NSLog(@"no data updated");
            }
            else
            {
                //Checking if any new levels and updated levels are added ------ *---------
                NSString *queryAllLevels =  [NSString stringWithFormat:@"select %@ from %@ order by %@",DB_LEVEL_ID,DB_TABLE_LEVEL,DB_LEVEL_ID];
                NSLog(@"queryAllLevels::%@",[queryAllLevels description]);
                NSArray *arrAllLevels = [objDataBase selectDataFromTable:queryAllLevels];//all levels from database
                NSLog(@"arrAllLevels::%@",[arrAllLevels description]);
                NSMutableArray *arrNewLevels = [[NSMutableArray alloc]init];
                
                NSMutableArray *arrUpdatedLevels = [[NSMutableArray alloc]init];

				for(int i=0;i<[arrLevels count];i++)
                {
                    NSMutableArray *arrTemp = [[NSMutableArray alloc]initWithArray:arrAllLevels];
                    NSPredicate *predicateLevelId = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ == %@",DB_LEVEL_ID,[[arrLevels objectAtIndex:i] objectForKey:WB_LEVEL_ID]]];
                    [arrTemp filterUsingPredicate:predicateLevelId];		
                    
                    if([arrTemp count]>0)
                    {
                        [arrUpdatedLevels addObject:[arrLevels objectAtIndex:i]];
                    }
                    else
                    {
                        [arrNewLevels addObject:[arrLevels objectAtIndex:i]];
                    }
                    NSLog(@"arrUpdatedLevels::%@",[arrUpdatedLevels description]);
                    NSLog(@"arrNewLevels::%@",[arrNewLevels description]);
                }
                
                //adding new levels in database
                [self addLevelInfoInDatabase:arrNewLevels];
                
                
                //----------------*---------
                
                //now for updated levels
                //checking for new questions in levels
                for(int i=0;i<[arrUpdatedLevels count];i++)
                {
                    //first checking if level is active then only need to change it
                    NSString *queryLevelActive =  [NSString stringWithFormat:@"select %@,%@ from %@ where %@ == %d order by %@",DB_LEVEL_ACTIVE,DB_LEVEL_PLAY,DB_TABLE_LEVEL,DB_LEVEL_ID,[[[arrUpdatedLevels objectAtIndex:i] objectForKey:DB_LEVEL_ID] intValue],DB_LEVEL_ID];
                    NSArray *arrLevelActive = [objDataBase selectDataFromTable:queryLevelActive];
                    
                    if([[[arrLevelActive objectAtIndex:0] objectForKey:DB_LEVEL_ACTIVE] intValue]==1)//if level is active
                    {
                        //first checking for questions
                        NSString *queryAllQuestions =  [NSString stringWithFormat:@"select %@ from %@ where %@ == %d order by %@",DB_QUE_ID,DB_TABLE_QUESTION,DB_LEVEL_ID,[[[arrUpdatedLevels objectAtIndex:i] objectForKey:DB_LEVEL_ID] intValue],DB_QUE_ID];
                        NSArray *arrAllQuestions = [objDataBase selectDataFromTable:queryAllQuestions];// all questions from database
                        
                        NSArray *arrQuestionLevel = [[arrUpdatedLevels objectAtIndex:i] objectForKey:WB_KEY_QUE];// all questions from web service
                        NSLog(@"arrQuestionLevel::%@",[arrQuestionLevel description]);
                        
                        if(arrQuestionLevel && [arrQuestionLevel isKindOfClass:[NSArray class]])
                        {
                            NSMutableArray *arrNewQuestions = [[NSMutableArray alloc]init];
                            NSMutableArray *arrUpdatedQuestions = [[NSMutableArray alloc]init];
                            
                            for(int j=0;j<[arrQuestionLevel count];j++)
                            {
                                NSMutableArray *arrTempQuestion = [[NSMutableArray alloc]initWithArray:arrAllQuestions];
                                NSPredicate *predicateQuestionId = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ == %@",DB_QUE_ID,[[arrQuestionLevel objectAtIndex:j] objectForKey:WB_QUESTION_ID]]];
                                [arrTempQuestion filterUsingPredicate:predicateQuestionId];		
                                
                                if([arrTempQuestion count]>0)
                                {
                                    [arrUpdatedQuestions addObject:[arrQuestionLevel objectAtIndex:j]];
                                }
                                else
                                {
                                    [arrNewQuestions addObject:[arrQuestionLevel objectAtIndex:j]];                        
                                }
                            }
                            NSLog(@"arrUpdatedQuestions::%@",[arrUpdatedQuestions description]);
                            NSLog(@"arrNewQuestions::%@",[arrNewQuestions description]);
                            
                            //adding new questions in database
                            [self addQuestionInfoInDatabase:arrNewQuestions];
                            
                            //now for updated questions
                            for(int j=0;j<[arrUpdatedQuestions count];j++)
                            {
                                if([[[arrLevelActive objectAtIndex:0] objectForKey:DB_LEVEL_PLAY] intValue]==PLAYSTATUS_NOTPLAYED)
                                {
                                    [self updateQuestionInfoInDatabase:[arrUpdatedQuestions objectAtIndex:j]];
                                }
                                else
                                {
                                    NSString *queryQuestionActive =  [NSString stringWithFormat:@"select %@ from %@ where %@ == %d and %@ == %d",DB_QUE_ACTIVE,DB_TABLE_QUESTION,DB_LEVEL_ID,[[[arrUpdatedLevels objectAtIndex:i] objectForKey:DB_LEVEL_ID] intValue],DB_QUE_ID,[[[arrUpdatedQuestions objectAtIndex:0] objectForKey:WB_QUESTION_ID] intValue]];
                                    NSArray *arrQuestionActive = [objDataBase selectDataFromTable:queryQuestionActive];
                                    
                                    //if questions is active then only update it
                                    if([[[arrQuestionActive objectAtIndex:0] objectForKey:DB_QUE_ACTIVE] intValue]==1)
                                    {
                                        [self updateQuestionInfoInDatabase:[arrUpdatedQuestions objectAtIndex:j]];
                                    }                                    
                                }
                            }
                        }
                        
                        //now updating all bonus questions for active level as can't check individually
                        [self updateBonusQuestionInfo:[arrUpdatedLevels objectAtIndex:i]];
                    }
                }
                
                [[NSUserDefaults standardUserDefaults]setObject:[dicData objectForKey:WB_TIME_REQUEST] forKey:USERDEFAULTS_SYNCHTIME];
                [[NSUserDefaults standardUserDefaults] synchronize];


            }
        }
    }
    else
    {
        NSString *strMsg = [dicData objectForKey:WB_KEY_MSG];
        NSLog(@"strMsg::%@",strMsg);
    }
    
    
    [self updateLevelSets];
    NSLog(@"updateLevelSets done");
//    self.intTotalSets = [self calculateTotalSets];
    self.intTotalSets = 4;
    if([self checkIfAnyActiveLevels])
    {
	    [self calculateCurrentScore];
        NSLog(@"calculateCurrentScore done");
    }
    else
    {
        NSLog(@"no active levels");
        [self enableHomeButtons];
        [self hideActivityIndicator];
        NSLog(@"enablehomebuttons done");
    }
    [self getAllSetScore];
    NSLog(@"getAllSetScore");
    [self downloadInitialSetImages];
    NSLog(@"downloadInitialSetImages");
//    [self startDownloadingImages];
}
-(void)updateLevelSets
{
    NSString *queryAllGameLevelIDs =  [NSString stringWithFormat:@"select %@ from %@ where %@ = 1 or (%@ = 0 and %@ == 2) order by %@",DB_LEVEL_ID,DB_TABLE_LEVEL,DB_LEVEL_ACTIVE,DB_LEVEL_ACTIVE,DB_LEVEL_PLAY,DB_LEVEL_ID];
    NSArray *arrAllGameLevelIDs = [objDataBase selectDataFromTable:queryAllGameLevelIDs];
    
    int currentSet=0;
    if([self checkQueryReturnedArrayCondition:arrAllGameLevelIDs])
    {
        for(int i=0;i<[arrAllGameLevelIDs count];i++)
        {
            if(i>=0 && i<=(SET1_LEVEL_INTERVAL-1))
            {
                currentSet = 1;
            }
            else
            {
                int currentLevelCheck = i-SET1_LEVEL_INTERVAL;
                currentSet = (currentLevelCheck/SETOTHER_LEVEL_INTERVAL) + 2;
            }
            NSMutableDictionary *dicUpdate = [[NSMutableDictionary alloc]init];
            [dicUpdate setObject:[NSString stringWithFormat:@"%d",currentSet] forKey:DB_LEVEL_SET];
            
            NSMutableDictionary *dicWhere = [[NSMutableDictionary alloc]init];
            [dicWhere setObject:[[arrAllGameLevelIDs objectAtIndex:i] objectForKey:DB_LEVEL_ID] forKey:DB_LEVEL_ID];

            [objDataBase updateRecordWithMoreConditions:dicUpdate :dicWhere :DB_TABLE_LEVEL];
            
            dicUpdate = nil;
            dicWhere = nil;
        }
    }
}


-(void)getMaxLevelSet
{
    NSString *queryMaxLevelSet =  [NSString stringWithFormat:@"select max(%@) as %@ from %@",DB_LEVEL_SET,DB_LEVEL_SET,DB_TABLE_LEVEL];
    NSArray *arrMaxLevelSet = [objDataBase selectDataFromTable:queryMaxLevelSet];
    if([arrMaxLevelSet count]==0)
    {
        NSLog(@"arrMaxLevelSet received 0");
    }
    else
    {
        self.maxLevelSet = [[[arrMaxLevelSet objectAtIndex:0] objectForKey:DB_LEVEL_SET] intValue];
    }
}
-(void)getAllSetScore
{
    if(!self.arrSetMainInfo)
    {
        self.arrSetMainInfo = [[NSMutableArray alloc]init];
    }
    else
    {
        [self.arrSetMainInfo removeAllObjects];
    }
    for(int i=0;i<intTotalSets;i++)
    {
//        NSString *queryActiveLevel =  [NSString stringWithFormat:@"select min(%@) as %@ from %@ where %@ == 1 and %@ = %d",DB_LEVEL_ID,DB_LEVEL_ID,DB_TABLE_LEVEL,DB_LEVEL_ACTIVE,DB_LEVEL_SET,i+1];
//        NSArray *arrLevelId = [objDataBase selectDataFromTable:queryActiveLevel];
//        if([arrLevelId count]==0)
//        {
//            // NSLog(@"arrLevelId in calculate current score::%@",[arrLevelId description]);
//            // NSLog(@"Derived wrong active level id in calculate score");
//            
//        }
//        else
        {
//            int intActiveLevelId = [[[arrLevelId objectAtIndex:0] objectForKey:DB_LEVEL_ID] intValue];
//            
//            if(intActiveLevelId == 0)
            {
//                NSString *queryInActiveLevel =  [NSString stringWithFormat:@"select %@,%@ from %@ where %@ = %d and ((%@ = 0 and %@ = %d) or (%@ = 1 and %@ = %d))",DB_LEVEL_SCORE,DB_BQ_SCORE,DB_TABLE_LEVEL,DB_LEVEL_SET,i+1,DB_LEVEL_ACTIVE,DB_LEVEL_PLAY,PLAYSTATUS_PLAYED,DB_LEVEL_ACTIVE,DB_LEVEL_PLAY,PLAYSTATUS_PLAYING];
                NSString *queryInActiveLevel =  [NSString stringWithFormat:@"select %@,%@ from %@ where %@ = %d",DB_LEVEL_SCORE,DB_BQ_SCORE,DB_TABLE_LEVEL,DB_LEVEL_SET,i+1];
                NSArray *arrLevelScores = [objDataBase selectDataFromTable:queryInActiveLevel];
                
                int intLevelSetScore = [self calculateScoreOfPreviousLevelsForSet:arrLevelScores];
                
                NSMutableDictionary *dicTemp = [[NSMutableDictionary alloc]init];
                [dicTemp setObject:[NSString stringWithFormat:@"%d",i+1] forKey:DB_LEVEL_SET];
                [dicTemp setObject:[NSString stringWithFormat:@"%d",intLevelSetScore] forKey:DB_LEVEL_SCORE];
                [self.arrSetMainInfo addObject:dicTemp];
                dicTemp = nil;
            }
        }
    }
    
    NSLog(@"arrSetMainInfo::%@",[self.arrSetMainInfo description]);
}

-(int)calculateTotalSets
{
    int intCalculatedSets = 1;
    
    int intTotalQuestionCount = [self getTotalQuestions];
    if(intTotalQuestionCount>=0)
    {
        if(intTotalQuestionCount > (SET1_LEVEL_INTERVAL * LEVEL_QUESTION_COUNT))
        {
            float intRemainingQuestionCount = intTotalQuestionCount - (SET1_LEVEL_INTERVAL * LEVEL_QUESTION_COUNT);
            
            float floatOtherSets = intRemainingQuestionCount/(SETOTHER_LEVEL_INTERVAL * LEVEL_QUESTION_COUNT);
            
            intCalculatedSets = floatOtherSets;
            if(floatOtherSets > intCalculatedSets)
                intCalculatedSets = intCalculatedSets+1;
        }
    }
    else
    {
        NSLog(@"appDelegate calculateTotalSets intTotalQuestionCount = %d",intTotalQuestionCount);
    }
    return intCalculatedSets;
}

-(int)getTotalAnsweredQuestionsForLevelSet:(int)intLevelSet
{
    NSArray *arrActiveLevels = [self fetchActiveLevelId:intLevelSet];
    if([self checkQueryReturnedArrayCondition:arrActiveLevels])
    {
        int intTotalLevels=0;
        int intActiveLevelId = [[[arrActiveLevels objectAtIndex:0] objectForKey:DB_LEVEL_ID] intValue];
        
        NSArray *arrAllLevelID = [self getAllSetLevelIDs:intLevelSet];
        
        for(int i=0;i<[arrAllLevelID count];i++)
        {
            if([[[arrAllLevelID objectAtIndex:i] objectForKey:DB_LEVEL_ID]intValue]<intActiveLevelId)
            {
                intTotalLevels++;
            }
            else
            {
                break;
            }
        }

        NSString *queryCompletedQuestionCount =  [NSString stringWithFormat:@"select count(%@) as %@ from %@ where %@<=%d and %@=0 and %@='TRUE' and %@ in (select %@ from %@ where level_set = %d)",DB_QUE_ID,DB_QUE_ID,DB_TABLE_QUESTION,DB_LEVEL_ID,intActiveLevelId,DB_QUE_ACTIVE,DB_QUE_IMGDOWNSTAT,DB_LEVEL_ID,DB_LEVEL_ID,DB_TABLE_LEVEL,intLevelSet];
        NSArray *arrCompletedQuestions = [objDataBase selectDataFromTable:queryCompletedQuestionCount];
        
        if([self checkQueryReturnedArrayCondition:arrCompletedQuestions])
        {
            int intQuestionsCompletedCount = [[[arrCompletedQuestions objectAtIndex:0] objectForKey:DB_QUE_ID] intValue];
            
            return intQuestionsCompletedCount;
        }
    }
    return -1;
}

-(void)setLeveSetBought:(int)intLevelSet
{
    NSMutableDictionary *dicUpdate = [[NSMutableDictionary alloc]init];
    [dicUpdate setObject:LEVEL_BOUGHT forKey:DB_LEVEL_SET_BOUGHT];
    
    NSMutableDictionary *dicWhere = [[NSMutableDictionary alloc]init];
    [dicWhere setObject:[NSString stringWithFormat:@"%d",intLevelSet] forKey:DB_LEVEL_SET];
    
    [objDataBase updateRecordWithMoreConditions:dicUpdate :dicWhere :DB_TABLE_LEVELSET];
    
    dicUpdate = nil;
    dicWhere = nil;
}



-(NSArray *)getAllSetLevelIDs:(int)intLevelSet
{
    NSString *queryAllSetLevelIDs =  [NSString stringWithFormat:@"select %@ from %@ where (%@ = 1 or (%@ = 0 and %@ == 2)) and %@=%d order by %@",DB_LEVEL_ID,DB_TABLE_LEVEL,DB_LEVEL_ACTIVE,DB_LEVEL_ACTIVE,DB_LEVEL_PLAY,DB_LEVEL_SET,intLevelSet,DB_LEVEL_ID];
    NSArray *arrAllSetLevelIDs = [objDataBase selectDataFromTable:queryAllSetLevelIDs];
    
    return arrAllSetLevelIDs;
}

-(int)getTotalQuestions
{
    NSString *queryTotalQuestions =  [NSString stringWithFormat:@"select count(%@) as %@ from %@ where %@=1",DB_QUE_ID,DB_QUE_ID,DB_TABLE_QUESTION,DB_QUE_ACTIVE];
    NSArray *arrTotalQuestions = [objDataBase selectDataFromTable:queryTotalQuestions];
    
    int intTotalQuestionCount;
    if([self checkQueryReturnedArrayCondition:arrTotalQuestions])
    {
        intTotalQuestionCount = [[[arrTotalQuestions objectAtIndex:0] objectForKey:DB_QUE_ID] intValue];
    }
    else
    {
        intTotalQuestionCount = -1;
    }
    return intTotalQuestionCount;
}

-(BOOL)checkQueryReturnedArrayCondition:(NSArray *)arrTemp
{
    if(arrTemp)
    {
        if([arrTemp count]==0)
        {
            NSLog(@"checkQueryReturnedArrayCondition arrTemp count == 0");
            return FALSE;
        }
        else
        {
            return TRUE;
        }
    }
    else
    {
        NSLog(@"checkQueryReturnedArrayCondition arrTemp nil");
        return FALSE;
    }
}

-(NSArray *)getLevelsBought
{
    NSString *queryLevelsBought =  [NSString stringWithFormat:@"select %@ from %@ where %@ = '%@'",DB_LEVEL_SET,DB_TABLE_LEVELSET,DB_LEVEL_SET_BOUGHT,LEVEL_BOUGHT];
    NSArray *arrLevelBought = [objDataBase selectDataFromTable:queryLevelsBought];
    return arrLevelBought;
}

-(NSArray *)fetchActiveLevelId:(int)intLevelSet
{
    NSString *queryActiveLevel =  [NSString stringWithFormat:@"select b.%@,count(b.%@) as %@ from %@ as b join %@ as a on b.%@ = a.%@ where a.%@ = 1 and b.%@ = 1 and a.%@ = %d group by b.%@ order by b.%@ LIMIT 1",DB_LEVEL_ID,DB_QUE_ID,DB_QUE_ID,DB_TABLE_QUESTION,DB_TABLE_LEVEL,DB_LEVEL_ID,DB_LEVEL_ID,DB_LEVEL_ACTIVE,DB_QUE_ACTIVE,DB_LEVEL_SET,intLevelSet,DB_LEVEL_ID,DB_LEVEL_ID];
    NSArray *arrLevelId = [objDataBase selectDataFromTable:queryActiveLevel];
    return arrLevelId;
}

-(NSArray *)fetchMaxPlayedLevel
{
    NSString *queryPlayedLastLevel =  [NSString stringWithFormat:@"select max(%@) as %@ from %@ where %@ = %d",DB_LEVEL_ID,DB_LEVEL_ID,DB_TABLE_LEVEL,DB_LEVEL_PLAY,PLAYSTATUS_PLAYED];
    NSArray *arrLevelId = [objDataBase selectDataFromTable:queryPlayedLastLevel];
    return arrLevelId;
}

-(NSArray *)fetchFirstLevelId
{
    NSString *queryPlayedFirstLevel =  [NSString stringWithFormat:@"select min(%@) as %@ from %@ where %@ = 1",DB_LEVEL_ID,DB_LEVEL_ID,DB_TABLE_LEVEL,DB_LEVEL_ACTIVE];
    NSArray *arrLevelId = [objDataBase selectDataFromTable:queryPlayedFirstLevel];
    return arrLevelId;    
}

-(BOOL)checkIfAnyActiveLevelsInCurrentSet:(int)intLevelSet
{
    NSString *queryActiveLevel =  [NSString stringWithFormat:@"select b.%@,count(b.%@) as %@ from %@ as b join %@ as a on b.%@ = a.%@ where a.%@ = 1 and b.%@ = 1 and a.%@ = %d group by b.%@ order by b.%@",DB_LEVEL_ID,DB_QUE_ID,DB_QUE_ID,DB_TABLE_QUESTION,DB_TABLE_LEVEL,DB_LEVEL_ID,DB_LEVEL_ID,DB_LEVEL_ACTIVE,DB_QUE_ACTIVE,DB_LEVEL_SET,intLevelSet, DB_LEVEL_ID,DB_LEVEL_ID];
    NSArray *arrLevelInfo = [objDataBase selectDataFromTable:queryActiveLevel];
    
    if([arrLevelInfo count]==0)
    {
        //        NSLog(@"arrLevelId::%@",[arrLevelInfo description]);
        // NSLog(@"Derived wrong active level id");
        return FALSE;
    }
    else
    {
        int intActiveLevelId = [[[arrLevelInfo objectAtIndex:0] objectForKey:DB_LEVEL_ID] intValue];
        if(intActiveLevelId == 0)
        {
            return FALSE;
        }
        else
        {
            int intActiveQuestionsCount= [[[arrLevelInfo objectAtIndex:0] objectForKey:DB_QUE_ID] intValue];
            if(intActiveQuestionsCount == 0)
            {
                return FALSE;
            }
            else
            {
                return TRUE;
            }
        }
    }
}


-(BOOL)checkIfAnyActiveLevels
{
    NSString *queryActiveLevel =  [NSString stringWithFormat:@"select b.%@,count(b.%@) as %@ from %@ as b join %@ as a on b.%@ = a.%@ where a.%@ = 1 and b.%@ = 1 group by b.%@ order by b.%@",DB_LEVEL_ID,DB_QUE_ID,DB_QUE_ID,DB_TABLE_QUESTION,DB_TABLE_LEVEL,DB_LEVEL_ID,DB_LEVEL_ID,DB_LEVEL_ACTIVE,DB_QUE_ACTIVE,DB_LEVEL_ID,DB_LEVEL_ID];
    NSArray *arrLevelInfo = [objDataBase selectDataFromTable:queryActiveLevel];
    
    if([arrLevelInfo count]==0)
    {
//        NSLog(@"arrLevelId::%@",[arrLevelInfo description]);
        // NSLog(@"Derived wrong active level id");
        return FALSE;
    }
    else
    {
        int intActiveLevelId = [[[arrLevelInfo objectAtIndex:0] objectForKey:DB_LEVEL_ID] intValue];
        if(intActiveLevelId == 0)
        {
            return FALSE;
        }
        else
        {
            int intActiveQuestionsCount= [[[arrLevelInfo objectAtIndex:0] objectForKey:DB_QUE_ID] intValue];
            if(intActiveQuestionsCount == 0)
            {
                return FALSE;
            }
            else
            {
                return TRUE;
            }
        }
    }
}

-(void)addLevelInfoInDatabase:(NSMutableArray *)arr
{
    NSString *queryLevelNoMax =  [NSString stringWithFormat:@"select max(%@) as %@ from %@",DB_LEVEL_NO,DB_LEVEL_NO,DB_TABLE_LEVEL];
    NSArray *arrLevelNoMax = [objDataBase selectDataFromTable:queryLevelNoMax];
    
    int intMaxLevelNo = [[[arrLevelNoMax objectAtIndex:0] objectForKey:DB_LEVEL_NO] intValue];
    
    for(int i=0,j=intMaxLevelNo+1;i<[arr count];i++,j++)
    {
        NSDictionary *dicLevel = [arr objectAtIndex:i];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:[dicLevel objectForKey:WB_BONUS_ANSWER] forKey:DB_BQ_ANS];
        [dict setObject:[dicLevel objectForKey:WB_BONUS_QUE] forKey:DB_BQ_IMG_NM];
        [dict setObject:[dicLevel objectForKey:WB_BONUS_OPTION1] forKey:DB_BQ_OPTION1];
        [dict setObject:[dicLevel objectForKey:WB_BONUS_OPTION2] forKey:DB_BQ_OPTION2];
        [dict setObject:[dicLevel objectForKey:WB_BONUS_OPTION3] forKey:DB_BQ_OPTION3];
        [dict setObject:[dicLevel objectForKey:WB_BONUS_OPTION4] forKey:DB_BQ_OPTION4];
        [dict setObject:[dicLevel objectForKey:WB_LEVEL_ID] forKey:DB_LEVEL_ID];
        [dict setObject:[dicLevel objectForKey:WB_LEVEL_NAME] forKey:DB_LEVEL_NAME];
        [dict setObject:[NSString stringWithFormat:@"%d",j] forKey:DB_LEVEL_NO];
        [dict setObject:[NSString stringWithFormat:@"%d",0] forKey:DB_LEVEL_SCORE];
        [dict setObject:[NSString stringWithFormat:@"%d",0] forKey:DB_BQ_SCORE];
        [dict setObject:[NSString stringWithFormat:@"%d",1] forKey:DB_LEVEL_ACTIVE];
//        [dict setObject:[dicLevel objectForKey:WB_LEVEL_STATUS] forKey:DB_LEVEL_ACTIVE];

        [objDataBase insertData:dict tableName:DB_TABLE_LEVEL];
        
        [self addQuestionInfoInDatabase:[dicLevel objectForKey:WB_KEY_QUE]];
    }
}

-(void)updateQuestionInfoInDatabase:(NSMutableDictionary *)dicQuestion
{    
    NSMutableDictionary *dicUpdate = [[NSMutableDictionary alloc]init];
    [dicUpdate setObject:[dicQuestion objectForKey:WB_QUE_HINT1] forKey:DB_QHINT1];
    [dicUpdate setObject:[dicQuestion objectForKey:WB_QUE_HINT2] forKey:DB_QHINT2];
    [dicUpdate setObject:[dicQuestion objectForKey:WB_QUE_HINT3] forKey:DB_QHINT3];
    [dicUpdate setObject:[dicQuestion objectForKey:WB_QUE_ANS] forKey:DB_QANS];
    [dicUpdate setObject:[dicQuestion objectForKey:WB_QUE_IMG] forKey:DB_QIMG_NM];
    [dicUpdate setObject:@"FALSE" forKey:DB_QUE_IMGDOWNSTAT];
//    [dicUpdate setObject:@"1" forKey:DB_QUE_ACTIVE];
    [dicUpdate setObject:[dicQuestion objectForKey:WB_QUE_STATUS] forKey:DB_QUE_ACTIVE];
    
    NSMutableDictionary *dicWhere = [[NSMutableDictionary alloc]init];
    [dicWhere setObject:[dicQuestion objectForKey:WB_LEVEL_ID] forKey:DB_LEVEL_ID];
    [dicWhere setObject:[dicQuestion objectForKey:WB_QUESTION_ID] forKey:DB_QUE_ID];
    
    [objDataBase updateRecordWithMoreConditions:dicUpdate :dicWhere :DB_TABLE_QUESTION];
    
//    [appDelegate downloadImage:[dicUpdate objectForKey:DB_QIMG_NM] levelId:[[dicWhere objectForKey:DB_LEVEL_ID]intValue]questionId:[[dicWhere objectForKey:DB_QUE_ID]intValue]];

    
    dicUpdate = nil;
    dicWhere = nil;
}

-(void)updateBonusQuestionInfo:(NSMutableDictionary *)dicQuestion
{        
    NSMutableDictionary *dicUpdate = [[NSMutableDictionary alloc]init];
    [dicUpdate setObject:[dicQuestion objectForKey:WB_BONUS_ANSWER] forKey:DB_BQ_ANS];
    [dicUpdate setObject:[dicQuestion objectForKey:WB_BONUS_QUE] forKey:DB_BQ_IMG_NM];
    [dicUpdate setObject:[dicQuestion objectForKey:WB_BONUS_OPTION1] forKey:DB_BQ_OPTION1];
    [dicUpdate setObject:[dicQuestion objectForKey:WB_BONUS_OPTION2] forKey:DB_BQ_OPTION2];
    [dicUpdate setObject:[dicQuestion objectForKey:WB_BONUS_OPTION3] forKey:DB_BQ_OPTION3];
    [dicUpdate setObject:[dicQuestion objectForKey:WB_BONUS_OPTION4] forKey:DB_BQ_OPTION4];
    [dicUpdate setObject:[dicQuestion objectForKey:WB_LEVEL_NAME] forKey:DB_LEVEL_NAME];
    
    NSMutableDictionary *dicWhere = [[NSMutableDictionary alloc]init];
    [dicWhere setObject:[dicQuestion objectForKey:WB_LEVEL_ID] forKey:DB_LEVEL_ID];
    
    [objDataBase updateRecordWithMoreConditions:dicUpdate :dicWhere :DB_TABLE_LEVEL];
    
    dicUpdate = nil;
    dicWhere = nil;
}

-(int)retriveCountOfQuestionsInLevel:(int)intLevelID
{
    NSString *queryQuestionCount =  [NSString stringWithFormat:@"select count(%@) as %@ from %@ where %@ = %d",DB_QUE_NO,DB_QUE_NO,DB_TABLE_QUESTION,DB_LEVEL_ID,intLevelID];
    NSArray *arrCountQuestions = [objDataBase selectDataFromTable:queryQuestionCount];
    if(arrCountQuestions)
    {
        if([arrCountQuestions count]==0)
        {
            // NSLog(@"arrCountQuestions count 0");
            return 0;
        }
        else
        {
            int questionCount = [[[arrCountQuestions objectAtIndex:0] objectForKey:DB_QUE_NO] intValue];
            return questionCount;
        }
    }
    else
    {
        // NSLog(@"something wrong in deriving question count");
        return 0;
    }

}
-(int)retriveMaxQuestionNo:(int)intLevelID
{
    NSString *queryMaxActiveQuestionNo =  [NSString stringWithFormat:@"select max(%@) as %@ from %@ where %@ == 1 and %@ = %d",DB_QUE_NO,DB_QUE_NO,DB_TABLE_QUESTION,DB_QUE_ACTIVE,DB_LEVEL_ID,intLevelID];
    NSArray *arrMaxActiveQuestionNo = [objDataBase selectDataFromTable:queryMaxActiveQuestionNo];
    if(arrMaxActiveQuestionNo)
    {
        if([arrMaxActiveQuestionNo count]==0)
        {
            // NSLog(@"arrMaxActiveQuestionNo count 0");
            return 0;
        }
        else
        {
            int maxQuestionNo = [[[arrMaxActiveQuestionNo objectAtIndex:0] objectForKey:DB_QUE_NO] intValue];
            return maxQuestionNo;
        }
    }
    else
    {
        // NSLog(@"something wrong in deriving question no");
        return 0;
    }
}

-(void)addQuestionInfoInDatabase:(NSMutableArray *)arrQuestions
{
    for(int i=0;i<[arrQuestions count];i++)
    {
        NSDictionary *dicQuestion = [arrQuestions objectAtIndex:i];
        int maxQuestionNo = [self retriveMaxQuestionNo:[[dicQuestion objectForKey:WB_LEVEL_ID] intValue]];
        maxQuestionNo++;
        NSMutableDictionary *dictTemp = [[NSMutableDictionary alloc]init];
        [dictTemp setObject:[dicQuestion objectForKey:WB_LEVEL_ID] forKey:DB_LEVEL_ID];
        [dictTemp setObject:[dicQuestion objectForKey:WB_QUESTION_ID] forKey:DB_QUE_ID];
        [dictTemp setObject:[dicQuestion objectForKey:WB_QUE_HINT1] forKey:DB_QHINT1];
        [dictTemp setObject:[dicQuestion objectForKey:WB_QUE_HINT2] forKey:DB_QHINT2];
        [dictTemp setObject:[dicQuestion objectForKey:WB_QUE_HINT3] forKey:DB_QHINT3];
        [dictTemp setObject:[dicQuestion objectForKey:WB_QUE_ANS] forKey:DB_QANS];
        [dictTemp setObject:[dicQuestion objectForKey:WB_QUE_IMG] forKey:DB_QIMG_NM];
        [dictTemp setObject:[NSString stringWithFormat:@"%d",maxQuestionNo] forKey:DB_QUE_NO];
        
        
//        [dictTemp setObject:[NSString stringWithFormat:@"1"] forKey:DB_QUE_ACTIVE];
        [dictTemp setObject:[dicQuestion objectForKey:WB_QUE_STATUS] forKey:DB_QUE_ACTIVE];

        [objDataBase insertData:dictTemp tableName:DB_TABLE_QUESTION];
        
//        [appDelegate downloadImage:[dictTemp objectForKey:DB_QIMG_NM] levelId:[[dictTemp objectForKey:DB_LEVEL_ID]intValue]questionId:[[dictTemp objectForKey:DB_QUE_ID]intValue]];
        dictTemp = nil;
    }
}
/*-(void)calculateCurrentScore
{
    self.intTotalScore = 0;
    NSString *queryActiveLevel =  [NSString stringWithFormat:@"select min(%@) as %@ from %@ where %@ == 1",DB_LEVEL_ID,DB_LEVEL_ID,DB_TABLE_LEVEL,DB_LEVEL_ACTIVE];
    NSArray *arrLevelId = [objDataBase selectDataFromTable:queryActiveLevel];
    if([arrLevelId count]==0)
    {
        // NSLog(@"arrLevelId in calculate current score::%@",[arrLevelId description]);
        // NSLog(@"Derived wrong active level id in calculate score");
        
    }
    else
    {
        int intActiveLevelId = [[[arrLevelId objectAtIndex:0] objectForKey:DB_LEVEL_ID] intValue];
        
        if(intActiveLevelId == 0)
        {
            NSString *queryInActiveLevel =  [NSString stringWithFormat:@"select %@,%@ from %@",DB_LEVEL_SCORE,DB_BQ_SCORE,DB_TABLE_LEVEL];
            NSArray *arrLevelScores = [objDataBase selectDataFromTable:queryInActiveLevel];
            
            [self calculateScoreOfPreviousLevels:arrLevelScores];
        }
        else
        {
            NSString *queryInActiveLevel =  [NSString stringWithFormat:@"select %@,%@ from %@ where %@ < %d",DB_LEVEL_SCORE,DB_BQ_SCORE,DB_TABLE_LEVEL,DB_LEVEL_ID,intActiveLevelId];
            NSArray *arrLevelScores = [objDataBase selectDataFromTable:queryInActiveLevel];
            
            [self calculateScoreOfPreviousLevels:arrLevelScores];
            
            //calculating score for current level
            NSString *queryActiveLevel =  [NSString stringWithFormat:@"select %@,%@ from %@ where %@ == %d",DB_LEVEL_SCORE,DB_BQ_SCORE,DB_TABLE_LEVEL,DB_LEVEL_ID,intActiveLevelId];
            NSArray *arrActiveLevelScore = [objDataBase selectDataFromTable:queryActiveLevel];
            
            self.intTotalScore = self.intTotalScore + [[[arrActiveLevelScore objectAtIndex:0] objectForKey:DB_LEVEL_SCORE] intValue];
            self.intTotalScore = self.intTotalScore + [[[arrActiveLevelScore objectAtIndex:0] objectForKey:DB_BQ_SCORE] intValue];
        }
    }
    //has downloaded all questions data images are remaining
//    [self checkIfAllImagesDownloaded];

}*/
-(void)calculateCurrentScore
{
    self.intTotalScore = 0;
    [self getAllSetScore];
    NSLog(@"arrSetMainInfo::%@",[arrSetMainInfo description]);
    for(int i=0;i<[appDelegate.arrSetMainInfo count];i++)
    {
        self.intTotalScore = self.intTotalScore + [[[self.arrSetMainInfo objectAtIndex:i] objectForKey:DB_LEVEL_SCORE] intValue];
    }
}

-(void)calculateScoreOfPreviousLevels:(NSArray *)arrLevelScores
{
    for(int i=0;i<[arrLevelScores count];i++)
    {
        self.intTotalScore = self.intTotalScore + [[[arrLevelScores objectAtIndex:i] objectForKey:DB_LEVEL_SCORE] intValue];
        self.intTotalScore = self.intTotalScore + [[[arrLevelScores objectAtIndex:i] objectForKey:DB_BQ_SCORE] intValue];
    }
}

-(int)calculateScoreOfPreviousLevelsForSet:(NSArray *)arrLevelScores
{
    int tempScore = 0;
    for(int i=0;i<[arrLevelScores count];i++)
    {
        tempScore = tempScore + [[[arrLevelScores objectAtIndex:i] objectForKey:DB_LEVEL_SCORE] intValue];
        tempScore = tempScore + [[[arrLevelScores objectAtIndex:i] objectForKey:DB_BQ_SCORE] intValue];
    }
    return tempScore;
}

-(int)getExtraPoints
{
    int intPoints = SCORE_INITIAL;
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULTS_ISFB_PAGE_LIKED])
        intPoints = intPoints + SCORE_FACEBOOK;
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_IS_RATED] intValue]==1)
    	intPoints = intPoints + SCORE_RATE;

    return intPoints;
}

#pragma mark - Reset Game related methods

-(void)refreshDatabase
{
    int intDeleteFromLevel = [objDataBase executeQuery:[NSString stringWithFormat:@"delete from %@",DB_TABLE_LEVEL]];
    int intDeleteFromQuestion = [objDataBase executeQuery:[NSString stringWithFormat:@"delete from %@",DB_TABLE_QUESTION]];
    
    NSLog(@"intDeleteFromLevel = %d",intDeleteFromLevel);
    NSLog(@"intDeleteFromQuestion = %d",intDeleteFromQuestion);
}

-(void)stopDownloadingImages
{
    for (int i=0; i<[appDelegate.imageQueue count]; i++)
    {
        [[appDelegate.imageQueue objectAtIndex:i]clearCache];
        [[appDelegate.imageQueue objectAtIndex:i]clearQueue];
    }
    [appDelegate hideActivityIndicator];
    appDelegate.intImageDownloadStatusStatus = NotStarted;
    [appDelegate.arrImageInfo removeAllObjects];
    appDelegate.intCurrentDownloadingImageIndex = 0;
    [appDelegate.imageQueue removeAllObjects];
}

-(void)deleteAllImages
{
    NSFileManager *fileMgr = [[NSFileManager alloc] init];
    NSError *error = nil;
    NSString* cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/"];
    NSString *filePath = [NSString stringWithFormat:@"%@%@",cacheDirectory,@"Images/"];

    NSArray *directoryContents = [fileMgr contentsOfDirectoryAtPath:filePath error:&error];
    if (error == nil)
    {
        for (NSString *path in directoryContents)
        {
            NSString *fullPath = [filePath stringByAppendingPathComponent:path];
            BOOL removeSuccess = [fileMgr removeItemAtPath:fullPath error:&error];
            if (!removeSuccess)
            {
                NSLog(@"!removeSuccess file removal error in delete all images");
            }
        }
    }
    else
    {
        NSLog(@"contents of directoryatpath error");
    }
}

#pragma mark - Image Downlaoding
-(void)downloadInitialSetImages
{
    arrInitialSetQuestionInfo = nil;
    arrInitialSetQuestionInfo = [[NSMutableArray alloc]init];
    NSMutableArray *arrTemp = [self get4SetImages];
    for(int i=0;i<[arrTemp count];i++)
    {
        NSObject *temp = [arrTemp objectAtIndex:i];
        
        if([temp isKindOfClass:[NSMutableDictionary class]])
        {
            NSMutableDictionary *dicTemp = (NSMutableDictionary *)temp;
            NSString *imageName = [dicTemp objectForKey:DIC_IMAGENAME];
            NSString *dirName = @"Images/";
            UIImage *image = [objDocDir getImageIfExistInDir:dirName fileName:imageName];
            if(!image)
            {
                BDMultiDownloader *obj = [[BDMultiDownloader alloc] init];
                obj.uniqueName = imageName;
                obj.dirName = dirName;
                obj.intArrayIndex = i;
//                obj.levelName = [dicTemp objectForKey:DB_LEVEL_ID];
                
                [obj imageWithPath:[dicTemp objectForKey:DIC_IMGURL] completion:^(UIImage * image, BOOL fromCache)
                 {
                     NSLog(@"downloadInitialSetImages obj.uniqueName::%@,intArrayIndex=%d",obj.uniqueName,obj.intArrayIndex);
                     NSArray *arrImageURLInfo = [obj.uniqueName componentsSeparatedByString:@"_"];
                     
                     [self updateImageStatusInDatabase:[[arrImageURLInfo objectAtIndex:0] intValue] QuestionID:[[arrImageURLInfo objectAtIndex:1] intValue]];
                     
                     [self checkIFAllInitialSetImagesDownloaded];
                 }];
                
                
                [imageQueue addObject:obj];
            }
            else
            {
                NSArray *arrImageURLInfo = [imageName componentsSeparatedByString:@"_"];
                
                [self updateImageStatusInDatabase:[[arrImageURLInfo objectAtIndex:0] intValue] QuestionID:[[arrImageURLInfo objectAtIndex:1] intValue]];
                
                [self checkIFAllInitialSetImagesDownloaded];
            }
        }
    }
}

-(NSMutableArray *)get4SetImages
{
    NSMutableArray *arrSet4Images = [[NSMutableArray alloc]init];
    
    //for calculating total set will need change in web service to get total active questions from webservice
    
    //currently it is fixed there are 4 sets
    NSMutableDictionary *dicTemp;

    for(int i=0;i<4;i++)
    {
        //For set i
        
        dicTemp = nil;
        dicTemp = [self getImageURLForInitialSetQuestion:i];
        if(dicTemp)
        {
            [arrSet4Images addObject:dicTemp];
        }
        else
        {
            [arrSet4Images addObject:NOTFOUNDIMAGE];
        }
    }
    return arrSet4Images;
}

-(NSMutableDictionary *)getImageURLForInitialSetQuestion:(int)intSetNo
{
    int intLevelNo,intLevelID,intQueID;
    
    if(intSetNo == 0)
    {
        intLevelNo = 1;
    }
    else
    {
        intLevelNo = (SET1_LEVEL_INTERVAL) + ((intSetNo-1) * SETOTHER_LEVEL_INTERVAL);
        intLevelNo++;
    }

    
    NSString *queryLevelID = [NSString stringWithFormat:@"select %@ from %@ where %@ = %d",DB_LEVEL_ID,DB_TABLE_LEVEL,DB_LEVEL_NO,intLevelNo];
    NSArray *arrLevelId = [objDataBase selectDataFromTable:queryLevelID];
    if([appDelegate checkQueryReturnedArrayCondition:arrLevelId])
    {
        intLevelID = [[[arrLevelId objectAtIndex:0] objectForKey:DB_LEVEL_ID] intValue];
        NSString *queryQueId = [NSString stringWithFormat:@"select min(%@) as %@ from %@ where %@ = %d and (%@=1 or (%@=0 and %@='TRUE'))",DB_QUE_ID,DB_QUE_ID,DB_TABLE_QUESTION,DB_LEVEL_ID,intLevelID,DB_QUE_ACTIVE,DB_QUE_ACTIVE,DB_QUE_IMGDOWNSTAT];
        NSArray *arrQueId = [objDataBase selectDataFromTable:queryQueId];
        if([appDelegate checkQueryReturnedArrayCondition:arrQueId])
        {
            intQueID = [[[arrQueId objectAtIndex:0] objectForKey:DB_QUE_ID] intValue];
            NSString *queryLevelImage = [NSString stringWithFormat:@"select %@ from %@ where %@ == %d",DB_QIMG_NM,DB_TABLE_QUESTION,DB_QUE_ID,intQueID];
            NSArray *arrLevelImage = [objDataBase selectDataFromTable:queryLevelImage];
            if([appDelegate checkQueryReturnedArrayCondition:arrLevelImage])
            {
                NSMutableDictionary *dicTemp = [[NSMutableDictionary alloc]init];
                NSMutableDictionary *dicTempArr = [[NSMutableDictionary alloc]init];
                NSString *strImageURL = [[arrLevelImage objectAtIndex:0] objectForKey:DB_QIMG_NM];
                
                if([strImageURL length]>0)
                {
                    NSString *imageName = [NSString stringWithFormat:@"%@_%@_%@",[NSString stringWithFormat:@"%d",intLevelID],[NSString stringWithFormat:@"%d",intQueID],[[[arrLevelImage objectAtIndex:0] objectForKey:DB_QIMG_NM] lastPathComponent]];
                    
                    [dicTemp setObject:imageName forKey:DIC_IMAGENAME];
                    [dicTemp setObject:strImageURL forKey:DIC_IMGURL];
                    
                    [dicTempArr setObject:[NSString stringWithFormat:@"%d",intLevelID] forKey:DB_LEVEL_ID];
                    [dicTempArr setObject:[NSString stringWithFormat:@"%d",intQueID] forKey:DB_QUE_ID];
                    [dicTempArr setObject:imageName forKey:DIC_IMAGENAME];
                    
                    [arrInitialSetQuestionInfo addObject:dicTempArr];
                    
                    dicTempArr = nil;
                    return dicTemp;
                    
                }
                else
                {
                    return nil;
                }
            }
        }
        else
        {
            NSLog(@"some problem get4SetImages intQueID");
            return nil;
        }
        
    }
    else
    {
        NSLog(@"some problem get4SetImages intLevelID");
        return nil;
    }
    return nil;
}

-(void)checkIFAllInitialSetImagesDownloaded
{
    BOOL areAllImagesDownloaded = TRUE;

    for(int i=0;i<[arrInitialSetQuestionInfo count];i++)
    {
        NSString *queryImageStatus = [NSString stringWithFormat:@"select %@ from %@ where %@ = %d and %@ == %d",DB_QUE_IMGDOWNSTAT,DB_TABLE_QUESTION,DB_LEVEL_ID,[[[arrInitialSetQuestionInfo objectAtIndex:i] objectForKey:DB_LEVEL_ID] intValue],DB_QUE_ID,[[[arrInitialSetQuestionInfo objectAtIndex:i] objectForKey:DB_QUE_ID] intValue]];
        NSArray *arrayImageStatus = [objDataBase selectDataFromTable:queryImageStatus];
        if([self checkQueryReturnedArrayCondition:arrayImageStatus])
        {
            if([[[arrayImageStatus objectAtIndex:0] objectForKey:DB_QUE_IMGDOWNSTAT] isEqualToString:@"FALSE"])
            {
                areAllImagesDownloaded = FALSE;
                break;
            }
        }
    }
    
    if(areAllImagesDownloaded)
    {
        [imageQueue removeAllObjects];
        [self performSelector:@selector(startDownloadingImages) withObject:nil afterDelay:0.1];
    }
}
-(void)initiateDownloadingLevel:(NSString *)strImageName levelId:(int)intLevel questionId:(int)intQuestion
{
    if([strImageName length]>0)
    {
        NSString *imageName = [NSString stringWithFormat:@"%@_%@_%@",[NSString stringWithFormat:@"%d",intLevel],[NSString stringWithFormat:@"%d",intQuestion],[strImageName lastPathComponent]];
        
        NSMutableDictionary *dicImage = [[NSMutableDictionary alloc]init];
        [dicImage setObject:strImageName forKey:DIC_IMGURL];
        [dicImage setObject:imageName forKey:DIC_IMAGENAME];
        [dicImage setObject:[NSString stringWithFormat:@"%d",intLevel] forKey:DB_LEVEL_ID];
        [self.arrImageInfo addObject:dicImage];        
    }
}

-(void)downloadImage
{
    for(int i=0;i<[self.arrImageInfo count];i++)
    {
        NSMutableDictionary *dicTemp = [self.arrImageInfo objectAtIndex:i];
        NSString *imageName = [dicTemp objectForKey:DIC_IMAGENAME];
        NSString *dirName = @"Images/";
        UIImage *image = [objDocDir getImageIfExistInDir:dirName fileName:imageName];
        if(!image)
        {
            BDMultiDownloader *obj = [[BDMultiDownloader alloc] init];
            obj.uniqueName = imageName;
            obj.dirName = dirName;
            obj.intArrayIndex = i;
            obj.levelName = [dicTemp objectForKey:DB_LEVEL_ID];
            
            NSLog(@"%@",[NSString stringWithFormat:@"%@%@",IMAGE_URL_CONSTANT,[dicTemp objectForKey:DIC_IMGURL]]);
            [obj imageWithPath:[dicTemp objectForKey:DIC_IMGURL] completion:^(UIImage * image, BOOL fromCache)
             {
                 NSLog(@"obj.uniqueName::%@,intArrayIndex=%d,levelname::%@",obj.uniqueName,obj.intArrayIndex,obj.levelName);
                 NSArray *arrImageURLInfo = [obj.uniqueName componentsSeparatedByString:@"_"];
                 
                 [self updateImageStatusInDatabase:[[arrImageURLInfo objectAtIndex:0] intValue] QuestionID:[[arrImageURLInfo objectAtIndex:1] intValue]];

                 [self checkIfAllImagesDownloaded];
             }];
            
            
            [imageQueue addObject:obj];
        }
        else
        {
            NSArray *arrImageURLInfo = [imageName componentsSeparatedByString:@"_"];
            
            [self updateImageStatusInDatabase:[[arrImageURLInfo objectAtIndex:0] intValue] QuestionID:[[arrImageURLInfo objectAtIndex:1] intValue]];
            
            [self checkIfAllImagesDownloaded];
        }
    }
}

-(void)setImageDownloadStatus
{
    [SVProgressHUD setStatus:@"Updating levels..."];
}

-(void)startDownloadingImages
{
    // NSLog(@"startDownloadingImages::%d",self.intCurrentDownloadingImageIndex);
    NSString *queryLevelActive =  [NSString stringWithFormat:@"select %@ from %@ where %@ == 1 order by %@",DB_LEVEL_ID,DB_TABLE_LEVEL,DB_LEVEL_ACTIVE,DB_LEVEL_ID];
    NSArray *arrLevelActive = [objDataBase selectDataFromTable:queryLevelActive];
    
    if([arrLevelActive count]==0)
    {
        appDelegate.shouldDownloadDataFromHome = FALSE;
        
        [self enableHomeButtons];
        [self hideActivityIndicator];
    }
    
    // NSLog(@"arrLevelActive::%@",[arrLevelActive description]);
    
    if([arrLevelActive count]>self.intCurrentDownloadingImageIndex)
    {
        if([arrLevelActive count]>2)
        {
            if(self.intCurrentDownloadingImageIndex>1)
            {
                // NSLog(@"two level images downloaded");
                self.intImageDownloadStatusStatus = Downloaded;
                appDelegate.shouldDownloadDataFromHome = FALSE;
                [self enableHomeButtons];
                [self hideActivityIndicator];
            }
            else
            {
                [appDelegate showActivityIndicator];
                [self disableHomeButtons];
                self.intImageDownloadStatusStatus = Downloading;
                [self setImageDownloadStatus];
            }
        }
        else
        {
            [appDelegate showActivityIndicator];
            [self disableHomeButtons];
            self.intImageDownloadStatusStatus = Downloading;
            [self setImageDownloadStatus];
        }
        NSString *queryImageURLS =  [NSString stringWithFormat:@"select %@,%@ from %@ where %@ == %d and %@ == 1",DB_QIMG_NM,DB_QUE_ID,DB_TABLE_QUESTION,DB_LEVEL_ID,[[[arrLevelActive objectAtIndex:self.intCurrentDownloadingImageIndex] objectForKey:DB_LEVEL_ID] intValue],DB_QUE_ACTIVE];
        NSArray *arrImageLevels = [objDataBase selectDataFromTable:queryImageURLS];
        
        self.arrImageInfo = nil;
        
        self.arrImageInfo = [[NSMutableArray alloc] init];

        intCurrentLevelImageDownloading = [[[arrLevelActive objectAtIndex:self.intCurrentDownloadingImageIndex] objectForKey:DB_LEVEL_ID]intValue];
        
        for(int i=0;i<[arrImageLevels count];i++)
        {
            // NSLog(@"arrImageLevels  %d \n self.intCurrentDownloadingImageIndex  %d",i,self.intCurrentDownloadingImageIndex);
            if([arrLevelActive count]>self.intCurrentDownloadingImageIndex)//thread creating problem
            {
                NSDictionary *dicTemp = [arrImageLevels objectAtIndex:i];
//                [appDelegate downloadImage:[dicTemp objectForKey:DB_QIMG_NM] levelId:[[[arrLevelActive objectAtIndex:self.intCurrentDownloadingImageIndex] objectForKey:DB_LEVEL_ID]intValue] questionId:[[dicTemp objectForKey:DB_QUE_ID]intValue]];
                [self initiateDownloadingLevel:[dicTemp objectForKey:DB_QIMG_NM] levelId:[[[arrLevelActive objectAtIndex:self.intCurrentDownloadingImageIndex] objectForKey:DB_LEVEL_ID]intValue] questionId:[[dicTemp objectForKey:DB_QUE_ID]intValue]];
            }
        }
        [self downloadImage];
    }
    else
    {
        NSLog(@"[self checkIFAllLevelImagesDownloaded]");
        if([self checkIFAllLevelImagesDownloaded])
        {
            appDelegate.shouldDownloadDataFromHome = FALSE;
            
            [self enableHomeButtons];
            [self hideActivityIndicator];
        }
    }
}

-(void)goForNextLevelDownloadImage
{
    self.intCurrentDownloadingImageIndex++;
    [self startDownloadingImages];
}

-(BOOL)checkIFAllLevelImagesDownloaded
{
    BOOL areAllImagesDownloaded = TRUE;
    
    NSString *queryQuestions = [NSString stringWithFormat:@"select %@ from %@ where %@ == 1",DB_QUE_IMGDOWNSTAT,DB_TABLE_QUESTION,DB_QUE_ACTIVE];
    NSArray *arrayQuestion = [objDataBase selectDataFromTable:queryQuestions];
    
    NSLog(@"queryQuestions :: %@",queryQuestions);
    NSLog(@"arrayQuestion::%@",[arrayQuestion description]);
    if([arrayQuestion count]==0)
    {
        NSLog(@"query::%@",queryQuestions);
        NSLog(@"probem fetching data while image downloading");
        areAllImagesDownloaded = FALSE;
    }
    else
    {//vibhooti
        NSMutableArray *arrTemp = [[NSMutableArray alloc]initWithArray:arrayQuestion];
        NSPredicate *predicateLevelId = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ == 'FALSE'",DB_QUE_IMGDOWNSTAT]];
        [arrTemp filterUsingPredicate:predicateLevelId];
        if([arrTemp count]>0)
        {
            areAllImagesDownloaded = FALSE;
        }
        
        if(!areAllImagesDownloaded)
        {
            self.intCurrentDownloadingImageIndex = 0;
            [self performSelector:@selector(goForNextLevelDownloadImage) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
        }
    }
    return areAllImagesDownloaded;
}

-(void)checkIfAllImagesDownloaded
{
    BOOL areAllImagesDownloaded = TRUE;
    
    NSString *queryQuestions = [NSString stringWithFormat:@"select %@ from %@ where %@ = %d and %@ == 1",DB_QUE_IMGDOWNSTAT,DB_TABLE_QUESTION,DB_LEVEL_ID,intCurrentLevelImageDownloading,DB_QUE_ACTIVE];
    NSArray *arrayQuestion = [objDataBase selectDataFromTable:queryQuestions];

    NSLog(@"queryQuestions :: %@",queryQuestions);
    NSLog(@"arrayQuestion::%@",[arrayQuestion description]);
    if([arrayQuestion count]==0)
    {
        NSLog(@"query::%@",queryQuestions);
        NSLog(@"probem fetching data while image downloading");
        areAllImagesDownloaded = FALSE;
    }
    else
    {//vibhooti
        NSMutableArray *arrTemp = [[NSMutableArray alloc]initWithArray:arrayQuestion];
        NSPredicate *predicateLevelId = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ == 'FALSE'",DB_QUE_IMGDOWNSTAT]];
        [arrTemp filterUsingPredicate:predicateLevelId];
        if([arrTemp count]>0)
        {
            areAllImagesDownloaded = FALSE;
        }
        
    }
    if(areAllImagesDownloaded)
    {
        [self performSelector:@selector(goForNextLevelDownloadImage) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
    }
}

-(void)updateImageStatusInDatabase:(int)intLevelID QuestionID:(int)intQuestionID
{
    NSMutableDictionary *dicUpdate = [[NSMutableDictionary alloc]init];
    [dicUpdate setObject:@"TRUE" forKey:DB_QUE_IMGDOWNSTAT];
    
    NSMutableDictionary *dicWhere = [[NSMutableDictionary alloc]init];
    [dicWhere setObject:[NSString stringWithFormat:@"%d",intLevelID] forKey:DB_LEVEL_ID];
    [dicWhere setObject:[NSString stringWithFormat:@"%d",intQuestionID] forKey:DB_QUE_ID];
    
    [objDataBase updateRecordWithMoreConditions:dicUpdate :dicWhere :DB_TABLE_QUESTION];
    
    dicUpdate = nil;
    dicWhere = nil;
}

#pragma mark - Cloud Animation Methods
-(void)setCloudInterface:(UIView *)view
{
    // NSLog(@"setCloudInterface");
    if(self.timer1)
    {
        [self.timer1 invalidate];
        self.timer1 = nil;
    }
    imvBigCloud1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bigCloud.png"]];
    CGRect frame = imvBigCloud1.frame;
    frame.origin.x = view.frame.size.width;
    frame.origin.y = 80;
    imvBigCloud1.frame = frame;
    [view addSubview:imvBigCloud1];
    
    imvSmallCloud1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"smallCloud.png"]];
    frame = imvSmallCloud1.frame;
    frame.origin.x = view.frame.size.width + 150;
    frame.origin.y = 80;
    imvSmallCloud1.frame = frame;
    [view addSubview:imvSmallCloud1];
    
    
    imvBigCloud2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bigCloud.png"]];
    frame = imvBigCloud2.frame;
    frame.origin.x = 100;
    frame.origin.y = 150;
    imvBigCloud2.frame = frame;
    [view addSubview:imvBigCloud2];
    
    imvSmallCloud2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"smallCloud.png"]];
    frame = imvSmallCloud2.frame;
    frame.origin.x = 200;
    frame.origin.y = 150;
    imvSmallCloud2.frame = frame;
    [view addSubview:imvSmallCloud2];
    
    imvBigCloud3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bigCloud.png"]];
    frame = imvBigCloud3.frame;
    frame.origin.x = 210;
    if (appDelegate.isIphone5) {
        frame.origin.y = 350;
    }
    else{
        frame.origin.y = 300;
    }
    
    imvBigCloud3.frame = frame;
    [view addSubview:imvBigCloud3];
    
    imvSmallCloud3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"smallCloud.png"]];
    frame = imvSmallCloud3.frame;
    frame.origin.x = 40;
    if (appDelegate.isIphone5) {
        frame.origin.y = 350;
    }
    else{
        frame.origin.y = 300;
    }    imvSmallCloud3.frame = frame;
    [view addSubview:imvSmallCloud3];
    
    imvBigCloud4 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bigCloud.png"]];
    frame = imvBigCloud4.frame;
    frame.origin.x = 80;
    if (appDelegate.isIphone5) {
        frame.origin.y = 500;
    }
    else{
        frame.origin.y = 400;
    }
    
    imvBigCloud4.frame = frame;
    [view addSubview:imvBigCloud4];
    
    imvSmallCloud4 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"smallCloud.png"]];
    frame = imvSmallCloud4.frame;
    frame.origin.x = 270;
    if (appDelegate.isIphone5) {
        frame.origin.y = 500;
    }
    else{
        frame.origin.y = 400;
    }
    imvSmallCloud4.frame = frame;
    [view addSubview:imvSmallCloud4];
    
    self.timer1 = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(cloudAnimation) userInfo:nil repeats:YES];
}

-(void)cloudAnimation
{
    CGRect frame = imvBigCloud1.frame;
    frame.origin.x -=1;
    imvBigCloud1.frame = frame;
    if (frame.origin.x == -frame.size.width) {
        frame.origin.x = self.windowControllers.frame.size.width;
        imvBigCloud1.frame = frame;
    }
    
    frame = imvSmallCloud1.frame;
    frame.origin.x -=1;
    imvSmallCloud1.frame = frame;
    if (frame.origin.x == -frame.size.width) {
        frame.origin.x = self.windowControllers.frame.size.width;
        imvSmallCloud1.frame = frame;
    }
    
    frame = imvBigCloud2.frame;
    frame.origin.x -=1;
    imvBigCloud2.frame = frame;
    if (frame.origin.x == -frame.size.width) {
        frame.origin.x = self.windowControllers.frame.size.width;
        imvBigCloud2.frame = frame;
    }
    
    
    frame = imvSmallCloud2.frame;
    frame.origin.x -=1;
    imvSmallCloud2.frame = frame;
    if (frame.origin.x == -frame.size.width) {
        frame.origin.x = self.windowControllers.frame.size.width;
        imvSmallCloud2.frame = frame;
    }
    
    frame = imvBigCloud3.frame;
    frame.origin.x -=1;
    imvBigCloud3.frame = frame;
    if (frame.origin.x == -frame.size.width) {
        frame.origin.x = self.windowControllers.frame.size.width;
        imvBigCloud3.frame = frame;
    }
    
    frame = imvSmallCloud3.frame;
    frame.origin.x -=1;
    imvSmallCloud3.frame = frame;
    if (frame.origin.x == -frame.size.width) {
        frame.origin.x = self.windowControllers.frame.size.width;
        imvSmallCloud3.frame = frame;
    }
    
    frame = imvBigCloud4.frame;
    frame.origin.x -=1;
    imvBigCloud4.frame = frame;
    if (frame.origin.x == -frame.size.width) {
        frame.origin.x = self.windowControllers.frame.size.width;
        imvBigCloud4.frame = frame;
    }
    
    frame = imvSmallCloud4.frame;
    frame.origin.x -=1;
    imvSmallCloud4.frame = frame;
    if (frame.origin.x == -frame.size.width) {
        frame.origin.x = self.windowControllers.frame.size.width;
        imvSmallCloud4.frame = frame;
    }
}

-(void)invalidateCloudAnimationTimer
{
    if ([self.timer1 isValid]) {
        [self.timer1 invalidate];
        self.timer1 = nil;
    }
    
    [imvBigCloud1 removeFromSuperview];
    [imvSmallCloud1 removeFromSuperview];
    [imvBigCloud2 removeFromSuperview];
    [imvSmallCloud2 removeFromSuperview];
    [imvBigCloud3 removeFromSuperview];
    [imvSmallCloud3 removeFromSuperview];
    [imvBigCloud4 removeFromSuperview];
    [imvSmallCloud4 removeFromSuperview];
}

#pragma mark - Enable Disable Home Buttons

-(void)enableHomeButtons
{
    int intHomeIndex = [self getIndexOfHomeController];
    
    if(intHomeIndex>=0)
    {
        HomeViewController *objHome = (HomeViewController *)[self.navigationController.viewControllers objectAtIndex:intHomeIndex];
        objHome.btnPlay.enabled = TRUE;
        objHome.btnMusic.enabled = TRUE;
        objHome.btnFacebookLike.enabled = TRUE;
        objHome.btnRateApp.enabled = TRUE;
        objHome.btnInfo.enabled = TRUE;
        objHome.btnInstruction.enabled = TRUE;
        if(self.isPlayButtonClicked)
        {
            self.isPlayButtonClicked = FALSE;
            if([self checkInternetConnection])
                [objHome btnPlayAction:objHome.btnPlay];
        }
    }
    else
    {
        NSLog(@"enable buttons Home controller object not found");
    }
  
  if(!isAdMobStarted)
  {
    isAdMobStarted = YES;
//    [self startFetchingAds];  Disabled the featue to get full screen ads after 3 minutes.
  }
}
-(void)disableHomeButtons
{
    int intHomeIndex = [self getIndexOfHomeController];
    if(intHomeIndex>=0)
    {
        HomeViewController *objHome = (HomeViewController *)[self.navigationController.viewControllers objectAtIndex:intHomeIndex];
        objHome.btnPlay.enabled = FALSE;
        objHome.btnMusic.enabled = FALSE;
        objHome.btnFacebookLike.enabled = FALSE;
        objHome.btnRateApp.enabled = FALSE;
        objHome.btnInfo.enabled = FALSE;
        objHome.btnInstruction.enabled = FALSE;
    }
    else
    {
        NSLog(@"disable buttons Home controller object not found");
    }
}
#pragma mark - Activity Methods
-(void)startActivity
{
    [self.activity startAnimating];
    [self.windowControllers bringSubviewToFront:self.activity];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}
-(void)stopActivity
{
    [self.activity stopAnimating];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

#pragma mark - Activity Indicator Related Methods

-(void)showActivityIndicator
{
    isActivityIndicatorSeen = TRUE;
    

//    [SVProgressHUD show];
    self.isCustomSVhud = NO;

    [SVProgressHUD showWithStatus:@"Loading..." maskType:(SVProgressHUDMaskTypeNone)];
}

-(void)hideActivityIndicator
{
    NSLog(@"hideActivityIndicator");
    isActivityIndicatorSeen = FALSE;
    if(!isInfoLinkWebViewLoading && !self.isInAppHUD && !self.isFBLike && !self.isInFacebookSharing){
        [SVProgressHUD dismiss];
    }
}

#pragma mark - Animation Methods
-(void)showViewAnimation:(UIView *)view
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionFromBottom;
    view.hidden = FALSE;
    [[view superview] bringSubviewToFront:view];
    [[view superview].layer addAnimation:transition forKey:nil];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView commitAnimations];    
}
-(void)hideViewAnimation:(UIView *)view
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionFromBottom;
    view.hidden = TRUE;
    [[view superview].layer addAnimation:transition forKey:nil];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView commitAnimations];
}


#pragma mark - Web Service Delegate Methods
-(void)webServiceCallingFinish:(async_ws_type)wsType returnvalue:(NSString*)returnString
{
    NSError* error;
    NSLog(@"returnString::%@",returnString);
    NSMutableDictionary* dicData = [NSJSONSerialization 
                      JSONObjectWithData:[returnString dataUsingEncoding:NSUTF8StringEncoding] //1
                          
                          options:kNilOptions 
                          error:&error];
    self.isDownloadingData = TRUE;//data has been downloaded
    NSLog(@"dicData::%@",[dicData description]);
    [self synchDatabaseFromWebservice:dicData];
}
-(void)webServiceCallingFail:(async_ws_type)wsType returnvalue:(NSString*)returnString
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ALERT_TITLE message:ALERT_INTERNET delegate:nil cancelButtonTitle:ALERT_OK otherButtonTitles: nil];
    [alert show];
    [self enableHomeButtons];
    [self hideActivityIndicator];
}
#pragma mark - Alert View Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        if(buttonIndex == 1)//Yes rate it.
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:USERDEFAULTS_IS_RATED];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            //For calling 30 days again
            NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
            NSDate *startDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
            [[NSUserDefaults standardUserDefaults] setValue:startDate forKey:USERDEFAULTS_RATE_ST_DATE];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSString *reviewURL= [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software",APP_ID];
//            NSString *reviewURL = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@",APP_ID];//[NSURL URLWithString:reviewURL];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
        }
        else
        {
            NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
            NSDate *startDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:USERDEFAULTS_IS_RATED];
            [[NSUserDefaults standardUserDefaults] setValue:startDate forKey:USERDEFAULTS_RATE_ST_DATE];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}
#pragma mark - Reachability Delegate
- (void) reachabilityChanged: (NSNotification* )note
{
//	Reachability* curReach = [note object];
//    NetworkStatus netStatus = [curReach currentReachabilityStatus];
//	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
//    switch (netStatus)
//    {
//        case NotReachable:
//        {
//            NSLog(@"NotReachable");
//            if(self.isDownloadingData)
//            {
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ALERT_TITLE message:@"Internet not available." delegate:nil cancelButtonTitle:ALERT_OK otherButtonTitles: nil];
//                [alert show];
//                [self hideActivityIndicator];
//            }
//            self.firstTimeNetworkChecked = TRUE;
//            self.isNetworkAvailable = FALSE;
//            break;
//        }
//        case ReachableViaWiFi:
//        {
//            self.firstTimeNetworkChecked = TRUE;
//            NSLog(@"ReachableViaWiFi");
//            self.isNetworkAvailable = TRUE;
//            break;
//            
//        }
//        case ReachableViaWWAN:
//        {
//             self.firstTimeNetworkChecked = TRUE;
//            NSLog(@"ReachableViaWWAN");
//            self.isNetworkAvailable = TRUE;
//            break;
//        }
//    }
}

#pragma -mark GADInterestitial Ads

-(void)fetchAds
{
  interstitial_ = [[GADInterstitial alloc] init];
  interstitial_.delegate = self;
  interstitial_.adUnitID = ADMOB_UNIT_ID;
  GADRequest *request = [GADRequest request];
  request.testDevices = [NSArray arrayWithObjects: GAD_SIMULATOR_ID, @"FFFFFFFF4707154B7B294E08B721E26FF479598C", @"347BBFBD16DB2B12978E9F5ED6C90E7441995C98", nil];
  [interstitial_ loadRequest:request];
}

-(void)startFetchingAds
{
  [self fetchAds];
  [NSTimer scheduledTimerWithTimeInterval:180.0
                                   target:self
                                 selector:@selector(fetchAds)
                                 userInfo:nil
                                  repeats:YES];
  
 }

- (void)interstitial:(GADInterstitial *)interstitial
didFailToReceiveAdWithError:(GADRequestError *)error {
  // Alert the error.
  
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
  [interstitial presentFromRootViewController:[self.navigationController topViewController]];
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad
{
    NSMutableDictionary *event =
    [[GAIDictionaryBuilder createEventWithCategory:@"AdMob"
                                          action:@"AdPresented"
                                           label:@"AdPresented"
                                           value:nil] build];
    [[GAI sharedInstance].defaultTracker send:event];
    [[GAI sharedInstance] dispatch];
}

#pragma -mark GADBannerView

-(void)loadAds
{
    // Use predefined GADAdSize constants to define the GADBannerView.
    
    CGPoint origin = CGPointMake(0.0,
                                 [self.navigationController topViewController].view.frame.size.height -
                                 CGSizeFromGADAdSize(kGADAdSizeBanner).height);
    
    self.adBanner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:origin];
    
    // Note: Edit SampleConstants.h to provide a definition for kSampleAdUnitID before compiling.
    self.adBanner.adUnitID = ADMOB_UNIT_ID;
    self.adBanner.delegate = self;
    self.adBanner.rootViewController = [self.navigationController topViewController];
    [self.adBanner loadRequest:[self request]];
    //    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(refreshAd) userInfo:Nil repeats:YES];
    
}

- (GADRequest *)request {
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for the simulator as well as any devices
    // you want to receive test ads.
    request.testDevices = @[
                            // TODO: Add your device/simulator test identifiers here. Your device identifier is printed to
                            // the console when the app is launched.
                            GAD_SIMULATOR_ID
                            ];
    return request;
}

- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"Received ad successfully");
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}

@end
