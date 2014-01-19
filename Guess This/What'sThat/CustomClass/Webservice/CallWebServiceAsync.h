//
//  CallWebServiceAsync.h
//  GONO
//
//  Created by Anjani Trivedi on 19/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum 
{
    synchQuestion = 1,
}async_ws_type;

@protocol CallWebServiceAsyncDelegate;

@interface CallWebServiceAsync : NSObject
{
    id <CallWebServiceAsyncDelegate> delegate;
    NSMutableData *activeDownload;
    NSURLConnection *imageConnection;
    NSString* url;
    NSString *returnString;
    
    async_ws_type ws_type;
}
@property (nonatomic, retain) id <CallWebServiceAsyncDelegate> delegate;
@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *imageConnection;
@property (nonatomic, retain) NSString* url;
@property (nonatomic, retain) NSString *returnString;

@property(nonatomic,readwrite)async_ws_type ws_type;


-(void)startDownload:(NSString*)wsURL;
-(void)startPostDownload:(NSString*)wsURL data:(NSString *)strPostData;
- (void)cancelDownload;
@end

@protocol CallWebServiceAsyncDelegate

-(void)webServiceCallingFinish:(async_ws_type)wsType returnvalue:(NSString*)returnString;
-(void)webServiceCallingFail:(async_ws_type)wsType returnvalue:(NSString*)returnString;

@end

