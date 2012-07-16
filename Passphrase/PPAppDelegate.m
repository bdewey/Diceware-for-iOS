//
//  PPAppDelegate.m
//  Passphrase
//
//  Created by Brian Dewey on 7/13/12.
//  Copyright (c) 2012 Brian's Brain. All rights reserved.
//

#import "PPAppDelegate.h"

@implementation PPAppDelegate

@synthesize window = _window;

////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  // Override point for customization after application launch.
  
  UIFont *courier = [UIFont fontWithName:@"Courier New" size:21];
  NSDictionary *titleBar = [NSDictionary dictionaryWithObjectsAndKeys:courier, UITextAttributeFont,
                            [UIColor greenColor], UITextAttributeTextColor, 
                            nil];
  [[UINavigationBar appearance] setTitleTextAttributes:titleBar];
  return YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)applicationWillResignActive:(UIApplication *)application {

  [[NSNotificationCenter defaultCenter] postNotificationName:kPPNotificationEnteredBackground object:self];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)applicationDidBecomeActive:(UIApplication *)application {

  [[NSNotificationCenter defaultCenter] postNotificationName:kPPNotificationDidBecomeActive object:self];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
