Tracking-Notifier
=================

##Purpose:
This is intended to provide a way to visually validate the triggering of events and their attributes as they are passed to various tracking services.

##Features:
- Activate and Deactivate switches
- Small notification tray with event name and attributes

##Dependancies:
- ARC

##Integration Steps:
- Add SBTrackingNotifier to project
- In the app delegate class add the following line of code to application:didFinishLaunchingWithOptions: function"

    ```
	    
	[[SBTrackingNotificationManager sharedInstance] setUpTrackingNotifications];


    ```
- Add your various analytics and tracking providers tracking methods in SBTrackingManager.m method named -(void)tagEvent:(NSString *)event attributes:(NSDictionary *)attributes
- Each time you wish to track an envent in your code use the function:
	
	```

    [[SBTrackingManager sharedManager] tagEvent:@"[Event Name]" attributes:@{@"[Key]": @"[Value]"}];

    ```

##Usage:
- Tap three times with two fingers to activate the notification UI

