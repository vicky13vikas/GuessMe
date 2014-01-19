//
//  RageIAPHelper.m
//  In App Rage
//
//  Created by Ray Wenderlich on 9/5/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "RageIAPHelper.h"

@implementation RageIAPHelper

+ (RageIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static RageIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"com.mobile.guesswhat.500Star",
                                      @"com.mobile.guesswhat.1500Stars",
                                      @"com.mobile.guesswhat.4000Stars",
                                      @"com.mobile.guesswhat.10000Stars",
                                      @"com.mobile.guesswhat.25000Stars",
                                      @"com.mobile.guesswhat.35000Stars",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
