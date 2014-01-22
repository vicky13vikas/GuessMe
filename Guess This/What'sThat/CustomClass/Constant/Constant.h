
#import <Foundation/Foundation.h>

#pragma mark - Database Constants

#define DB_TABLE_LEVEL @"level"
#define DB_TABLE_QUESTION @"Question"
#define DB_TABLE_LEVELSET @"levelSet"

#define DB_LEVEL_ID @"level_id"
#define DB_LEVEL_NAME @"level_name"
#define DB_LEVEL_ACTIVE @"level_active"
#define DB_LEVEL_SET @"level_set"
#define DB_LEVEL_SCORE @"level_score"
#define DB_LEVEL_NO @"level_no"
#define DB_LEVEL_PLAY @"level_localPlayStatus"

#define DB_LEVEL_SET_BOUGHT @"levelSet_bought"

#define DB_QANS @"que_answer"
#define DB_QHINT1 @"que_hint1"
#define DB_QHINT2 @"que_hint2"
#define DB_QHINT3 @"que_hint3"
#define DB_QUE_ID @"que_id"
#define DB_QUE_ACTIVE @"que_active"
#define DB_QIMG_NM @"que_imageName"
#define DB_QUE_NO @"que_no"
#define DB_QUE_IMGDOWNSTAT @"downloaded_image"

#define DB_BQ_ANS @"bonusQue_Answer"
#define DB_BQ_OPTION1 @"bonusQue_Option1"
#define DB_BQ_OPTION2 @"bonusQue_Option2"
#define DB_BQ_OPTION3 @"bonusQue_Option3"
#define DB_BQ_OPTION4 @"bonusQue_Option4"
#define DB_BQ_IMG_NM @"bonusQue_imageName"
#define DB_BQ_SCORE @"bonusQue_score"

#pragma mark - Play Status
#define PLAYSTATUS_PLAYING 1
#define PLAYSTATUS_PLAYED 2
#define PLAYSTATUS_NOTPLAYED 3

#pragma mark - Webservice Constant
//#define WEBSERVICE @"http://23.21.226.54/web/whatsthatgame/ver1/api/level/getallquestiondetails/bulkdata/" // current live version
//#define WEBSERVICE @"http://23.21.226.54/web/whatsthatgame/ver2/api/level/getallquestiondetails/bulkdata/" // new version 2
#define WEBSERVICE @"http://www.50appstreet.co.uk/game/ver1/api/level/getallquestiondetails/bulkdata/"
#define IMAGE_URL_CONSTANT @"http://www.50appstreet.co.uk/game"

#define WB_TIME_REQUEST @"time_request"
#define WB_KEY_DATA @"data"
#define WB_KEY_QUE @"questions"
#define WB_KEY_STATUS @"status"
#define WB_KEY_MSG @"message"

#define DIC_STATUS @"imgStatus"
#define DIC_IMAGENAME @"imgnm"
#define DIC_IMGURL  @"imgURL"

#define arrayInAppPur [NSArray arrayWithObjects: @"500 Stars - $0.99",@"1500 Stars - $1.99",@"4000 Stars - $2.99",@"10,000 Stars - $5.99",@"25,000 Stars - $9.99",@"35,000 Stars - $12.99",nil]
#define arrStar [NSArray arrayWithObjects: @"500",@"1500",@"4000",@"10000",@"25000",@"35000",nil]
#define arrProductIdentifire [NSArray arrayWithObjects: @"com.mobile.guesswhat.500Star",@"com.mobile.guesswhat.1500Stars",@"com.mobile.guesswhat.4000Stars",@"com.mobile.guesswhat.10000Stars",@"com.mobile.guesswhat.25000Stars",@"com.mobile.guesswhat.35000Stars",nil]


#define WB_LEVEL_ID @"level_id"
#define WB_LEVEL_NAME @"name"
#define WB_LEVEL_STATUS @"status"

#define WB_BONUS_QUE @"bonus_question"
#define WB_BONUS_OPTION1 @"option_1"
#define WB_BONUS_OPTION2 @"option_2"
#define WB_BONUS_OPTION3 @"option_3"
#define WB_BONUS_OPTION4 @"option_4"
#define WB_BONUS_ANSWER @"bonus_question_answer"

#define WB_QUESTION_ID @"id"
#define WB_QUE_IMG @"question_image_name"
#define WB_QUE_ANS @"answer"
#define WB_QUE_HINT1 @"hint_1"
#define WB_QUE_HINT2 @"hint_2"
#define WB_QUE_HINT3 @"hint_3"
#define WB_QUE_STATUS @"status"

#pragma mark - Alert Constants

#define ALERT_OK @"OK"//view hint ok button in level xib
#define ALERT_YES @"Yes"
#define ALERT_NO @"No"
#define ALERT_TITLE @"Guess This!"//change in in app screen
#define ALERT_CANCEL @"Cancel"
#define ALERT_MORESTARS @"More Stars"
#define ALERT_CONTINUE @"Continue"
#define ALERT_INTERNET @"Internet not available."
#define ALERT_RATEMSG @"We'd really appreciate it if you could take a moment to rate this application. If you've done it in the past, update your rating for this current release. \n\nThanks for your support!"

#pragma mark - NSUserDefaults Constants
#define USERDEFAULTS_SYNCHTIME @"lastSynchTime"
#define USERDEFAULTS_ISFB_PAGE_LIKED @"fbpageLiked"
#define USERDEFAULTS_ISHOMEMUSICMUTE @"isMusicMute"
#define USERDEFAULTS_ISSOUNDEFFECTSMUTE @"isEffectMute"
#define USERDEFAULTS_HINT1 @"hint1"
#define USERDEFAULTS_HINT2 @"hint2"
#define USERDEFAULTS_HINT3 @"hint3"
#define USERDEFAULTS_HINT1ALERT @"hint1Alert"
#define USERDEFAULTS_HINT2ALERT @"hint2Alert"
#define USERDEFAULTS_HINT3ALERT @"hint3Alert"
#define USERDEFAULTS_GAMESCORE @"score"
#define USERDEFAULTS_IS_DB_REFRESHED @"db_refreshed"
#define USERDEFAULTS_IS_RATED @"israted"
#define USERDEFAULTS_COMP_LEVEL @"levelCompleted"
#define USERDEFAULTS_CURRENT_SET_LEVEL_COUNT @"currentSetLevelCount"
#define USERDEFAULTS_CURRENT_SET @"currentSet"
#define USERDEFAULTS_DECR_SETSCORE @"isSetScoreDecremented"
#define USERDEFAULTS_RATE_ST_DATE @"rt_st_dt"
#define USERDEFAULTS_IS_ALREADY_INSTALLED @"isfirsttime"


#pragma mark - Score Constants
#define SCORE_INITIAL 20
#define SCORE_FACEBOOK 50
#define SCORE_HINT_1 100
#define SCORE_HINT_2 150
#define SCORE_HINT_3 250
#define SCORE_LEVEL 20
#define SCORE_ROUND 10
#define SCORE_BONUS 10
#define SCORE_RATE 50
#define SCORE_SET 500

#pragma mark - Set Intervals
#define SET1_LEVEL_INTERVAL 10
#define SETOTHER_LEVEL_INTERVAL 5
#define LEVEL_QUESTION_COUNT 10

#define NOTFOUNDIMAGE @"noImage"
#define RATE_TIMEINTERVAL 5

#define LEVEL_BOUGHT @"yes"
#define LEVEL_UNBOUGHT @"no"

#define TIMER_BONUS 30

#define INAPP_MSG @"You do not have enough stars, you can get some more stars here."
#define MSG_HINT1 @"We will reveal how many letters and words are in this answer for" 
#define MSG_HINT2 @"We will give you a written clue about the answer for"
#define MSG_HINT3 @"We will reveal the WHOLE answer for" 

#pragma mark - Facebook
//Try Calendar
//#define FB_APPID @"135545959981952"
//#define FB_APP_SECRET @"2ccd1353acef3f29e581f15920d27310"

//Client
#define FB_APPID @"170313943139707"
#define FB_APP_SECRET @"2b9cbdae069732d13bba4926e2cfc28f"
#define APP_ID @"657293868"


//GONO
//#define FB_APPID  @"250940308357307"
//#define FB_APP_SECRET  @"20b1cf814566e38b5a39e5b4cc66b5ff"

#define ADMOB_UNIT_ID @"a152dcc1c74d58e"     //AdMob
//#define ADMOB_UNIT_ID @"ca-app-pub-5402296631424108/3536544879"     //DFP



@interface Constant : NSObject 
{

}

@end
