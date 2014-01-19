//
//  ShareKitFile.h
//  ShareKit
//
//  Created by Anjani Trivedi on 01/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"


@protocol ShareKitDelegate <NSObject>
@optional
-(void)shareFBMessageStatus:(BOOL)postMessageStatus Error:(NSString *)postError;
-(void)shareFBLoginStatus:(BOOL)loginSatus Error:(NSString *)loginError;
-(void)facebookDetails:(NSMutableDictionary *)dicFacebook;

@end

@interface ShareKitFile : NSObject<FBDialogDelegate, FBSessionDelegate, FBRequestDelegate>
{
	Facebook* _facebook;
     id <ShareKitDelegate> delegate;
    
    NSMutableDictionary *dicFaceBookDetails;
    
    NSMutableArray *friendlistarray;
    BOOL isGettingFriendList;
    BOOL isGettingLikes;
    BOOL callotherfunction;
    
    int intInvitationCount;
    int intInvitationSuccess;
    int intInvitationFailed;
    
}

@property (nonatomic, retain) id <ShareKitDelegate> delegate;
@property(nonatomic,retain)Facebook* _facebook;
@property(nonatomic,retain) NSMutableArray *friendlistarray;

//Facebook
-(void)sharePostFaceBookParameters:(NSMutableDictionary *)dicFaceBookParameters;
-(void)sharePostInviteFaceBookParameters:(NSMutableDictionary *)dicFaceBookParameters;
- (void)storeAuthData:(NSString *)accessToken expiresAt:(NSDate *)expiresAt;
-(void)doFaceBookLogn;
-(void) getInfo;
-(BOOL)isSessionValid;
-(void)getGoNoPageLikes;
-(void)logout;
-(void)likeAPage;
-(BOOL)shouldExtendAccessToken;
-(NSMutableArray *) getFriendList;
- (void)sendInvitationRequest:(NSMutableArray *) targeted  params:(NSMutableDictionary *)dicFaceBookParameters;
-(void)checkIfInvitationComplete;
-(void)extendAccessTokenIfNeeded;
-(void)extendAccessToken;

@end