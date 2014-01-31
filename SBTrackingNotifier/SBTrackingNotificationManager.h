//
//  SBTrackingNotificationController.h
//  InHouseSettings
//
//  Created by Bradley Roush on 12/26/13.
//  Copyright (c) 2013 Jibjab Media, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBTrackingNotificationManager : NSObject

+(SBTrackingNotificationManager*)sharedInstance;
- (void)setUpTrackingNotifications;
- (void)showNotificationWithText:(NSString*)text;

@end
