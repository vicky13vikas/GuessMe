//
//  ShareKitFile.m
//  ShareKit
//
//  Created by Anjani Trivedi on 01/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShareKitFile.h"



@implementation ShareKitFile

@synthesize delegate;
@synthesize _facebook;

@synthesize friendlistarray = _friendlistarray;
#pragma mark ----------------------------------------------------------------------
#pragma mark FaceBook Methods----------------------------------------------------------

-(void)doFaceBookLogn
{
    if(!_facebook)
    {
		_facebook = [[Facebook alloc] initWithAppId:FB_APPID];
    }
//    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
//    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];

    _facebook.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"FBAccessTokenKey"];
    _facebook.expirationDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"FBExpirationDateKey"];

    if([_facebook isSessionValid])
    {
        NSLog(@"isValid");
    }
    else
    {
        NSLog(@"Not Valid");
    }
    [_facebook authorize:[NSArray arrayWithObjects:@"publish_stream",@"offline_access",nil] delegate:self];

}

-(void)getGoNoPageLikes
{
//    NSLog(@"getGoNoPageLikes");
    NSMutableDictionary *dicTemp = [[NSMutableDictionary alloc]init];
    [dicTemp setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"FBAccessTokenKey"] forKey:@"access_token"];
    [_facebook requestWithGraphPath:@"me/likes" andParams:dicTemp andHttpMethod:@"GET" andDelegate:self];
//    [_facebook requestWithGraphPath:@"me/likes/312207865560522" andParams:dicTemp andHttpMethod:@"GET" andDelegate:self];//for specific page id
    
}

-(void)likeAPage
{
//    NSString *postId = [data objectForKey:@"post_id"];//Guess-This/1377239929155320
    NSString *request = [NSString stringWithFormat:@"%@/likes", @"312207865560522"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:FB_APPID forKey:@"app_id"];
    [_facebook requestWithGraphPath:request andParams:dic andHttpMethod:@"POST" andDelegate:self];
}

-(void)sharePostFaceBookParameters:(NSMutableDictionary *)dicFaceBookParameters
{
    [appDelegate showActivityIndicator];
    [SVProgressHUD showWithStatus:@"Wait..." maskType:(SVProgressHUDMaskTypeNone)];

	[dicFaceBookParameters setObject:FB_APP_SECRET forKey:@"api_key"]; //App secret
//	[_facebook dialog:@"feed" andParams:dicFaceBookParameters andDelegate:self];
    [_facebook requestWithGraphPath:@"me/photos"
                          andParams:dicFaceBookParameters
                      andHttpMethod:@"POST"
                        andDelegate:self];
}

-(void)sharePostInviteFaceBookParameters:(NSMutableDictionary *)dicFaceBookParameters
{
//	[dicFaceBookParameters setObject:kSecretKey forKey:@"api_key"]; //App secret
//	[_facebook dialog:@"feed" andParams:dicFaceBookParameters andDelegate:self];
 //    [_facebook requestWithGraphPath:@"me/feed"
  //          andParams:dicFaceBookParameters
    //   andHttpMethod:@"POST"
      //  andDelegate:self];
}

-(void)logout
{
    if(_facebook)
    {
        [_facebook logout:self];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"access_token"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"exp_date"];
        [[NSUserDefaults standardUserDefaults] synchronize];        
    }
}

-(NSMutableArray *) getFriendList
{
    @autoreleasepool {
        self.friendlistarray = [[NSMutableArray alloc] init];
        isGettingFriendList = TRUE;
        
        
        //Get friend list
        [_facebook requestWithGraphPath:@"me/friends" andDelegate:self];
        
        
        //Stay Here until netwaorking checking complete.
        NSRunLoop *rl = [NSRunLoop currentRunLoop];
        NSDate *d;
        while (isGettingFriendList) {
            d = [NSDate date];
            [rl runUntilDate:d];
        }
        
    }
    return self.friendlistarray;
}

- (void)sendInvitationRequest:(NSMutableArray *) targeted  params:(NSMutableDictionary *)dicFaceBookParameters 
{    
//	[appDelegate.activity startAnimating];
//    for (int i = 0; i < [targeted count]; i++) 
//    {
//        callotherfunction = TRUE;
////        [_facebook requestWithGraphPath:[NSString stringWithFormat:@"%@/feed",[targeted objectAtIndex:i]]
////                              andParams:dicFaceBookParameters
////                          andHttpMethod:@"POST"
////                            andDelegate:self];
//        [_facebook dialog:[NSString stringWithFormat:@"%@/feed",[targeted objectAtIndex:i]] andParams:dicFaceBookParameters andDelegate:self];
//    }
//    intInvitationFailed = 0;
//    intInvitationSuccess = 0;
//    intInvitationCount = [targeted count]; 
    
//    [_facebook dialog:@"apprequests"
//           andParams:dicFaceBookParameters
//         andDelegate:self];
    [dicFaceBookParameters setObject:[targeted objectAtIndex:0] forKey:@"to"];
    
    [_facebook dialog:@"feed"
            andParams:dicFaceBookParameters
          andDelegate:self];

}

-(BOOL)isSessionValid
{
    if(_facebook)
    {
        if(_facebook.isSessionValid)
        {
            return TRUE;
        }
        else
        {
            return FALSE;
        }
    }
    else
    {
        return FALSE;
    }
}

-(void)checkIfInvitationComplete
{
    NSLog(@"invitation status total : %d success: %d fail: %d",intInvitationCount,intInvitationSuccess,intInvitationFailed);
    if(intInvitationCount == (intInvitationFailed+intInvitationSuccess))
    {
//        [appDelegate.activity stopAnimating];
        
        if(intInvitationSuccess==0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ALERT_TITLE message:@"Invite Failed." delegate:nil cancelButtonTitle:ALERT_OK otherButtonTitles:nil];
            [alert show];            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ALERT_TITLE message:@"Invite successful." delegate:nil cancelButtonTitle:ALERT_OK otherButtonTitles:nil];
            [alert show];            
        }
    }
}
#pragma mark - Facebook API Calls
-(void)getInfo
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"id,first_name,last_name,email,gender,birthday",  @"fields",
                                   nil];
    [_facebook requestWithGraphPath:@"me" andParams:params andDelegate:self];
}

- (void)apiGraphUserPermissions 
{
    [_facebook requestWithGraphPath:@"me/permissions" andDelegate:self];
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
	NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
//    NSLog(@"status code :: %d",statusCode);
	if (statusCode == 200) 
	{
		NSString *url = [[response URL] absoluteString];
//        NSLog(@"url::%@ request didReceiveResponse",url);

		if ([url rangeOfString: @"me/photos"].location != NSNotFound) 
		{
            [self.delegate shareFBMessageStatus:TRUE Error:nil];
		}
        if ([url rangeOfString: @"me/likes"].location != NSNotFound) 
        {
			isGettingLikes = TRUE;
        }
        if([url rangeOfString:@"feed"].location != NSNotFound)
        {
            intInvitationSuccess ++;
            [self checkIfInvitationComplete];
        }
        else
        {
            isGettingLikes = FALSE;
        }
	}
}

- (void)fbDidLogin 
{
    [self storeAuthData:[_facebook accessToken] expiresAt:[_facebook expirationDate]];

	[self.delegate shareFBLoginStatus:TRUE Error:nil];
}

-(void)extendAccessTokenIfNeeded
{
//    if ([self shouldExtendAccessToken])
//    {
        [self extendAccessToken];
//    }
}
-(void)extendAccessToken
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"auth.extendSSOAccessToken", @"method",nil];
    [_facebook requestWithParams:params andDelegate:self];
}

-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt 
{
    NSLog(@"fbDidExtendToken");
    [self storeAuthData:accessToken expiresAt:expiresAt];
}

-(void)fbDidNotLogin:(BOOL)cancelled 
{

    [self.delegate shareFBLoginStatus:FALSE Error:@"Cancelled"];
}

- (void)fbDidLogout 
{
    [self.delegate shareFBLoginStatus:FALSE Error:@"LoggedOut"];
}

- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError*)error
{

    NSLog(@"didFailWithError");
//	[self.delegate shareFBLoginStatus:FALSE Error:[error description]];
    if(!callotherfunction)
        [self.delegate shareFBLoginStatus:FALSE Error:[error description]];
    else
        callotherfunction = FALSE;
}

- (void)dialogDidSucceed:(FBDialog*)dialog
{
    NSLog(@"dialogDidSucceed");
    if(!callotherfunction)
        [self.delegate shareFBLoginStatus:TRUE Error:nil];
    else
        callotherfunction = FALSE;
}

- (void)dialogDidCancel:(NSURL *)url
{
    NSLog(@"dialogDidCancel");
//    [appDelegate.activity stopAnimating];
}

- (void)dialogDidComplete:(FBDialog *)dialog
{
    NSLog(@"dialogDidComplete");
//    [appDelegate.activity stopAnimating];
}

- (void)dialogCompleteWithUrl:(NSURL *)url
{
    NSLog(@"dialogCompleteWithUrl");
}
- (void)dialogWillAppear
{
    NSLog(@"dialogWillAppear");
    appDelegate.isFBLike = FALSE;
    [appDelegate hideActivityIndicator];
}

- (void)dialogDidNotComplete:(FBDialog *)dialog
{
    NSLog(@"dialogDidNotComplete");
//    [appDelegate.activity stopAnimating];
}

- (void)request:(FBRequest *)request didLoad:(id)result 
{
//    NSLog(@"request didLoad::%@",result);
//    NSLog(@"requestdidload");
//    NSLog(@"request resuylt:: %@",[result description]);
}

- (void)storeAuthData:(NSString *)accessToken expiresAt:(NSDate *)expiresAt 
{ 
//    NSLog(@"access token::%@",accessToken);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error
{
    NSLog(@"didFailWithError");
//    NSLog(@"request didFailWithError::%@",[request url]);
	if([[[request url] substringWithRange:NSMakeRange([[request url] length]-4, 4)] isEqualToString:@"feed"])    
    {
        intInvitationFailed++;
        [self checkIfInvitationComplete];
    }


    [self.delegate shareFBMessageStatus:FALSE Error:[error description]];
}

-(void)dealloc
{
    self.delegate = nil;
}

@end
