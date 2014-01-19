//
//  ShareKitFile.h
//  ShareKit
//
//  Created by Anjani Trivedi on 01/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol FacebookNewSdkDelegate <NSObject>
@optional

@end

@interface FacebookNewSdk : NSObject<FBDialogDelegate, FBSessionDelegate, FBRequestDelegate>
{
}

@property (nonatomic, retain) id <FacebookNewSdkDelegate> delegate;


-(void)makeInviteRequest:(NSMutableDictionary *)dicInviteParameters friendList:(NSMutableDictionary *)dicFriendList;
- (void)sendRequests;

@end