//
//  AppDelegate.m
//  ClosetFriend
//
//  Created by Anna Kuznetsova on 7/13/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "Item.h"
#import <Parse/PFFacebookUtils.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

/*
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {     // Override point for customization after application launch.     ParseClientConfiguration *config = [ParseClientConfiguration   configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {                  configuration.applicationId = @"travelr";         configuration.server = @"https://ana-travelr.herokuapp.com/parse";     }];          [Parse initializeWithConfiguration:config];          [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];               return YES; }  - (BOOL)application:(UIApplication*)app openURL:(NSURL*)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {     return [[FBSDKApplicationDelegate sharedInstance] application:app openURL:url options:options]; }  - (void)applicationDidBecomeActive:(UIApplication *)application {     [FBSDKAppEvents activateApp]; }

 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    ParseClientConfiguration *config = [ParseClientConfiguration   configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        
        configuration.applicationId = @"myAppId";
        configuration.server = @"https://closet-friend.herokuapp.com/parse";
    }];
    
    [Parse initializeWithConfiguration:config];
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    return YES;
}
- (BOOL)application:(UIApplication*)app openURL:(NSURL*)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {     return [[FBSDKApplicationDelegate sharedInstance] application:app openURL:url options:options];
}
- (void)applicationDidBecomeActive:(UIApplication *)application {     [FBSDKAppEvents activateApp];
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
