//
//  ShareKitFile.m
//  ShareKit
//
//  Created by Anjani Trivedi on 01/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FacebookNewSdk.h"



//Facebook
//static NSString* kAppId = @"250940308357307";
static NSString* kAppId = @"250940308357307";
static NSString* kSecretKey = @"20b1cf814566e38b5a39e5b4cc66b5ff";

@interface FacebookNewSdk ()

@property (strong, nonatomic) FBRequestConnection *requestConnection;
@end


@implementation FacebookNewSdk

@synthesize delegate;



#pragma mark - FaceBook Methods
- (void)sendRequests {
    // extract the id's for which we will request the profile
    NSArray *fbids = [self.textObjectID.text componentsSeparatedByString:@","];
    
    self.textOutput.text = loadingText;
    if ([self.textObjectID isFirstResponder]) {
        [self.textObjectID resignFirstResponder];
    }
    
    // create the connection object
    FBRequestConnection *newConnection = [[FBRequestConnection alloc] init];
    
    // for each fbid in the array, we create a request object to fetch
    // the profile, along with a handler to respond to the results of the request
    for (NSString *fbid in fbids) {
        
        // create a handler block to handle the results of the request for fbid's profile
        FBRequestHandler handler =
        ^(FBRequestConnection *connection, id result, NSError *error) {
            // output the results of the request
            [self requestCompleted:connection forFbID:fbid result:result error:error];
        };
        
        // create the request object, using the fbid as the graph path
        // as an alternative the request* static methods of the FBRequest class could
        // be used to fetch common requests, such as /me and /me/friends
        FBRequest *request = [[FBRequest alloc] initWithSession:FBSession.activeSession
                                                      graphPath:fbid];
        
        // add the request to the connection object, if more than one request is added
        // the connection object will compose the requests as a batch request; whether or
        // not the request is a batch or a singleton, the handler behavior is the same,
        // allowing the application to be dynamic in regards to whether a single or multiple
        // requests are occuring
        [newConnection addRequest:request completionHandler:handler];
    }
    
    // if there's an outstanding connection, just cancel
    [self.requestConnection cancel];    
    
    // keep track of our connection, and start it
    self.requestConnection = newConnection;    
    [newConnection start];
}

#pragma mark - Custom Methods
-(void)makeInviteRequest:(NSMutableDictionary *)dicInviteParameters friendList:(NSMutableDictionary *)dicFriendList
{
    
}


#pragma mark Memory Management Methods

-(void)dealloc
{
    self.delegate = nil;
}

@end
