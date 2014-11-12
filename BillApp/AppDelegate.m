//
//  ParseStarterProjectAppDelegate.m
//  ParseStarterProject
//
//  Copyright 2014 Parse, Inc. All rights reserved.
//

#import <Parse/Parse.h>

// If you are using Facebook, uncomment this line
// #import <ParseFacebookUtils/PFFacebookUtils.h>

#import "AppDelegate.h"
#import "GVViewController.h"

@implementation AppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // ****************************************************************************
    // Uncomment and fill in with your Parse credentials:
    // [Parse setApplicationId:@"your_application_id" clientKey:@"your_client_key"];
    //
    // If you are using Facebook, uncomment and add your FacebookAppID to your bundle's plist as
    // described here: https://developers.facebook.com/docs/getting-started/facebook-sdk-for-ios/
    // [PFFacebookUtils initializeFacebook];
    // ****************************************************************************
    [Parse setApplicationId:@"dAhnicEdKgozj3bWI1dNhnxVb81hxE6D4nldgbKn"
                  clientKey:@"kfidbzgRxQj8aJR8ETnqkkv2bGucp1lzTC4kaD0M"];
    
    [PFUser enableAutomaticUser];
    
    PFACL *defaultACL = [PFACL ACL];
    
    // If you would like all objects to be private by default, remove this line.
    [defaultACL setPublicReadAccess:YES];
    
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    /*
     // Override point for customization after application launch.
     
     //self.window.rootViewController = self.viewController;
     //[self.window makeKeyAndVisible];
     
     if (application.applicationState != UIApplicationStateBackground) {
     // Track an app open here if we launch with a push, unless
     // "content_available" was used to trigger a background push (introduced in iOS 7).
     // In that case, we skip tracking here to avoid double counting the app-open.
     BOOL preBackgroundPush = ![application respondsToSelector:@selector(backgroundRefreshStatus)];
     BOOL oldPushHandlerOnly = ![self respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)];
     BOOL noPushPayload = ![launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
     if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
     [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
     }
     }
     
     #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
     if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
     UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
     UIUserNotificationTypeBadge |
     UIUserNotificationTypeSound);
     UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
     categories:nil];
     [application registerUserNotificationSettings:settings];
     [application registerForRemoteNotifications];
     } else
     #endif
     {
     [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound)];
     }
     */
    return YES;
}



///////////////////////////////////////////////////////////
// Uncomment this method if you are using Facebook
///////////////////////////////////////////////////////////
/*
 - (BOOL)application:(UIApplication *)application
 openURL:(NSURL *)url
 sourceApplication:(NSString *)sourceApplication
 annotation:(id)annotation {
 return [PFFacebookUtils handleOpenURL:url];
 }
 */


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    [PFPush storeDeviceToken:newDeviceToken];
    [PFPush subscribeToChannelInBackground:@"" target:self selector:@selector(subscribeFinished:error:)];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (error.code == 3010) {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
    
    if (application.applicationState == UIApplicationStateInactive) {
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
}


///////////////////////////////////////////////////////////
// Uncomment this method if you want to use Push Notifications with Background App Refresh
///////////////////////////////////////////////////////////
/*
 - (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
 if (application.applicationState == UIApplicationStateInactive) {
 [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
 }
 }
 */

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state.
     This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message)
     or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates.
     Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state
     information to restore your application to its current state in case it is terminated later.
     If your application supports background execution,
     this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark - ()

- (void)subscribeFinished:(NSNumber *)result error:(NSError *)error {
    if ([result boolValue]) {
        NSLog(@"ParseStarterProject successfully subscribed to push notifications on the broadcast channel.");
    } else {
        NSLog(@"ParseStarterProject failed to subscribe to push notifications on the broadcast channel.");
    }
}

- (void) incrementNetworkActivity
{
    _networkActivityCounter += 1;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void) decrementNetworkActivity
{
    if(_networkActivityCounter > 0) {
        _networkActivityCounter -= 1;
    }
    if(_networkActivityCounter == 0) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

- (void) resetNetworkActivity
{
    _networkActivityCounter = 0;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
@end
