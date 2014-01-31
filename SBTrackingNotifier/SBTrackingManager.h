//
//  SBTrackingManager.h
//  TrackingManager
//
//  Created by Gustavo Barcena on 8/20/13.
//  Copyright (c) 2013 JibJabMedia Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

// Tracking Notifications
#define kSBTrackingNotificationNewEvent             @"SBTrackingNotificationNewEvent"

@interface SBTrackingManager : NSObject


+(SBTrackingManager *)sharedManager;

-(void)tagEvent:(NSString *)event attributes:(NSDictionary *)attributes;

@end
