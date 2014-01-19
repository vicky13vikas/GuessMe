//
//  CallWebServiceAsync.m
//  GONO
//
//  Created by Anjani Trivedi on 19/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CallWebServiceAsync.h"

@implementation CallWebServiceAsync
@synthesize delegate;
@synthesize activeDownload;
@synthesize imageConnection;
@synthesize url;
@synthesize returnString;
@synthesize ws_type;

-(void)startDownload:(NSString*)wsURL
{
    if([appDelegate checkInternetConnection])
    {
        self.activeDownload = [NSMutableData data];
        wsURL = [wsURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:wsURL]];
        [request setTimeoutInterval:30];
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                                 request delegate:self];//appDelegate.imagename
//        // NSLog(@"wsURL %@",wsURL);
        self.imageConnection = conn;
        [conn release];        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ALERT_TITLE message:@"Internet not available." delegate:nil cancelButtonTitle:ALERT_OK otherButtonTitles:nil];
        [alert show];

        [self performSelector:@selector(callByTimer) withObject:nil afterDelay:0.1];
    }
}

-(void)callByTimer
{
    [delegate webServiceCallingFail:self.ws_type returnvalue:@""];
}

-(void)startPostDownload:(NSString*)wsURL data:(NSString *)strPostData
{
    if(appDelegate.isNetworkAvailable)
    {
        self.activeDownload = [NSMutableData data];
        
        wsURL = [wsURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        
        NSData *postData = [strPostData dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        NSMutableURLRequest *request;
        
        request = [[NSMutableURLRequest alloc] init];   
        [request setURL:[NSURL URLWithString:wsURL]];                  // set URL for the request
        [request setHTTPMethod:@"POST"];                                   // set method the request
        [request setHTTPBody:postData];          // set body the request
        [request setTimeoutInterval:60];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];//appDelegate.imagename
//        NSLog(@"wsURL %@",wsURL);
        self.imageConnection = conn;
        [conn release];
    }
    else
    {
        [self performSelector:@selector(callByTimer) withObject:nil afterDelay:0.1];

    }
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}
#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{
    [self.activeDownload setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.activeDownload = nil;
    self.imageConnection = nil;
    [self performSelector:@selector(callByTimer) withObject:nil afterDelay:0.1];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.returnString=[[NSString alloc] initWithData:self.activeDownload encoding:NSUTF8StringEncoding];
//    self.returnString = [self.returnString stringByReplacingOccurrencesOfString:@"Error message: Decoding failed: Syntax error" withString:@""];
//	NSLog(@" self.returnString %@", self.returnString);
	if([self.returnString length]>0)
    {
        [delegate webServiceCallingFinish:self.ws_type returnvalue:self.returnString];
    }
    else
    {
        [self performSelector:@selector(callByTimer) withObject:nil afterDelay:0.1];
    }
}
#pragma mark -
#pragma mark Memory Management
- (void)dealloc
{
    [activeDownload release];
    
    [imageConnection cancel];
    [imageConnection release];
    
    [super dealloc];
}

@end
