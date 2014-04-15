//  Copyright (c) 2014 Brian Dewey <bdewey@gmail.com>

#import "diceware_wordlist.h"
#import "AppDelegate.h"
#import "DWWordLookupViewController.h"

@implementation AppDelegate

////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  // Override point for customization after application launch.
  
  _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  DWWordLookupViewController *wordLookupViewController = [[DWWordLookupViewController alloc] initWithDicewareWordList:diceware_wordlist];
  wordLookupViewController.title = @"Diceware";
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:wordLookupViewController];
  _window.rootViewController = navigationController;
  [_window makeKeyAndVisible];
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
