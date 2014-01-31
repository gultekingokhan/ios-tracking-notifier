//
//  ViewController.m
//  SBTrackingNotifierDemo
//
//  Created by Bradley Roush on 1/9/14.
//  Copyright (c) 2014 Jibjab Media, Inc. All rights reserved.
//

#import "ViewController.h"
#import "SBTrackingManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)newEvent:(id)sender
{
    [[SBTrackingManager sharedManager] tagEvent:@"New Event" attributes:@{@"Key": @"Value"}];
}

@end
