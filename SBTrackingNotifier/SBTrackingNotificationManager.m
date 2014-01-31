//
//  SBTrackingNotificationController.m
//  InHouseSettings
//
//  Created by Bradley Roush on 12/26/13.
//  Copyright (c) 2013 Jibjab Media, Inc. All rights reserved.
//

#import "SBTrackingNotificationManager.h"
#import "SBTrackingManager.h"

#define kNotificationHeight 50
#define kNotificationDuration 3.0f
#define kNotificationAnimationDuration 0.3f

@interface SBTrackingNotificationManager () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableArray *notifications;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) BOOL active;
@end

@implementation SBTrackingNotificationManager

@synthesize active = _active;

+(SBTrackingNotificationManager*)sharedInstance
{
    static SBTrackingNotificationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[SBTrackingNotificationManager alloc] init];
        sharedInstance.notifications = [NSMutableArray array];
        
        [[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(handleTrackingEvent:) name:kSBTrackingNotificationNewEvent object:nil];
        
    });
    
    return sharedInstance;
}

#pragma mark - Custom Getter/Setter

- (void)setActive:(BOOL)active {
    
    if (active)[self showNotificationWithText:@"Activated"];
    else [self showNotificationWithText:@"Deactivated"];
    
    _active = active;
}

- (BOOL)active {
    return _active;
}

#pragma mark - Public

- (void)setUpTrackingNotifications
{
    [self performSelector:@selector(addTapGesture) withObject:Nil afterDelay:1.0];
}

- (void)showNotificationWithText:(NSString*)text
{
    // Get root view controller to add notification view
    UIViewController *topViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    if (topViewController.presentedViewController) topViewController = topViewController.presentedViewController;
    //NSLog(@"showNotificationOnController:%@",topViewController.class);
    
    // Create notification view
    UIView *notificationView = [[UIView alloc] initWithFrame:CGRectMake(topViewController.view.bounds.origin.x, topViewController.view.bounds.size.height, topViewController.view.bounds.size.width, kNotificationHeight)];
    notificationView.backgroundColor = [UIColor lightGrayColor];
    
    // Create a tray border
    UIView *notificationBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, notificationView.frame.size.width, 1)];
    notificationBorder.backgroundColor = [UIColor blackColor];
    [notificationView addSubview:notificationBorder];
    
    // Create the label
    UILabel *label = [[UILabel alloc] initWithFrame:notificationView.bounds];
    label.numberOfLines = 3;
    [notificationView addSubview:label];
    
    // Create the button
    UIButton *button = [[UIButton alloc] initWithFrame:notificationView.bounds];
    [button addTarget:self action:@selector(notificationPressed:) forControlEvents:UIControlEventTouchUpInside];
    [notificationView addSubview:button];

    // Add the notification to the view
    [topViewController.view addSubview:notificationView];
    
    if (self.notifications.count<1) {
        [UIView animateWithDuration:kNotificationAnimationDuration animations:^{
            notificationView.frame = CGRectMake(topViewController.view.bounds.origin.x, topViewController.view.bounds.size.height-notificationView.frame.size.height, notificationView.frame.size.width, notificationView.frame.size.height);
        } completion:^(BOOL finished) {
            // Start a timer
            [self restartTimer];
            [topViewController.view bringSubviewToFront:notificationView];

        }];
    } else {
        notificationView.frame = CGRectMake(topViewController.view.bounds.origin.x, topViewController.view.bounds.size.height-notificationView.frame.size.height, notificationView.frame.size.width, notificationView.frame.size.height);
        UIView *mostRecentNotification = self.notifications.lastObject;
        [topViewController.view insertSubview:notificationView belowSubview:mostRecentNotification];
    }
    
    // Add the notification to the array
    [self.notifications addObject:notificationView];
    //NSLog(@"Notifications:%@",self.notifications);
    
    // Set the text of the label
    button.tag = self.notifications.count;
    label.text = [NSString stringWithFormat:@"     %@",text];
}

#pragma mark - Private

- (void)addTapGesture
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleActivation)];
    [tapRecognizer setNumberOfTapsRequired:3];
    [tapRecognizer setNumberOfTouchesRequired:2];
    [tapRecognizer setDelegate:self];
    UIViewController *topViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [topViewController.view addGestureRecognizer:tapRecognizer];
}

- (void)toggleActivation
{
    if (self.active) self.active = NO;
    else self.active = YES;
}

- (void)restartTimer
{
    [self stopTimer];
    if (self.timer == nil)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:kNotificationDuration
                                                  target:self
                                                selector:@selector(removeTopNotification)
                                                userInfo:nil
                                                 repeats:YES];
    }
}

- (void)stopTimer
{
    if (self.timer != nil)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)removeTopNotification
{
    //NSLog(@"removeTopNotification");
    
    if (self.notifications.count<1) {
        [self stopTimer];
        return;
    }
    
    UIView *notification = self.notifications.firstObject;
    [self.notifications removeObject:notification];
    //NSLog(@"Notifications:%d",self.notifications.count);
    if (self.notifications.count<1) [self stopTimer];
    
    [UIView animateWithDuration:kNotificationAnimationDuration animations:^{
        notification.frame = CGRectMake(notification.frame.origin.x, notification.frame.origin.y+notification.frame.size.height, notification.frame.size.width, notification.frame.size.height);
    } completion:^(BOOL finished) {
        [notification removeFromSuperview];
    }];
}

#pragma mark - User Actions

- (void)notificationPressed:(id)sender
{
    [self removeTopNotification];
    
}

-(void)handleTrackingEvent:(NSNotification*)notification
{
    if (!self.active) return;
    
    NSString* eventName = notification.object;
    NSDictionary* attributes = notification.userInfo;
    NSString *attString = @"";
    for (NSString *key in attributes.allKeys) {
        NSString *keyValue = [NSString stringWithFormat:@"{%@:%@} ",key,[attributes objectForKey:key]];
        attString = [attString stringByAppendingString:keyValue];
    }
    NSString *finalString = [NSString stringWithFormat:@"%@ : %@",eventName,attString];
    [self performSelector:@selector(showNotificationWithText:) withObject:finalString afterDelay:1.0];
}

@end
