//
//  SBTrackingManager.m
//  TrackingManager
//
//  Created by Gustavo Barcena on 8/20/13.
//  Copyright (c) 2013 JibJabMedia Inc. All rights reserved.
//

#import "SBTrackingManager.h"

@implementation SBTrackingManager


+(SBTrackingManager *)sharedManager
{
    static SBTrackingManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[SBTrackingManager alloc] init];
        
        /*
         
         Setup various tracking providers
         
         */
        
    });
    
    return sharedManager;
}


#pragma mark - SBTrackingManager Public Access methods

-(void)tagEvent:(NSString *)event attributes:(NSDictionary *)attributes
{
    // Track events with providers here
    
    // If an app wants to extend functionality of this method, they can do so by listenting to this notification
    [[NSNotificationCenter defaultCenter] postNotificationName:kSBTrackingNotificationNewEvent object:event userInfo:attributes];
}



@end
