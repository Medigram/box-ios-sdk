//
//  AppDelegate.m
//  BoxSDK
//
//
// Copyright 2012 Box, Inc.
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import <Box/Box.h>

#if RUN_KIF_TESTS
#import "SDKTestController.h"
#endif

@interface AppDelegate()
{
    UIViewController *__rootViewController;
}

@property (nonatomic, retain, readwrite) UIViewController *rootViewController;

@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize rootViewController = __rootViewController;

- (void)dealloc
{
    [_window release];
    [__rootViewController release];
    __rootViewController = nil;
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    MainViewController * vc = [[[MainViewController alloc] init] autorelease];
    self.rootViewController = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
    [self.window addSubview:self.rootViewController.view];
	[Box setBoxAPIKey:@""]; //FIXME: SET YOUR API KEY HERE
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
#if RUN_KIF_TESTS
    [[SDKTestController sharedInstance] startTestingWithCompletionBlock:^{
        [[[[UIAlertView alloc] initWithTitle:@"Testing finished." message:[NSString stringWithFormat:@"%d failures.", [[SDKTestController sharedInstance] failureCount]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    }];
#endif
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([[url scheme] isEqualToString:@"boxsamplecustomurl"])
    {
        [Box initializeSessionWithRedirectURL:url callbacks:^(id <BoxOperationCallbacks>on)
         {
             on.after(^(BoxCallbackResponse response)
            {
                if (response == BoxCallbackResponseSuccessful)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:BOX_USER_DID_LOGIN_NOTIFICATION_NAME object:self];
                }
            });
         }];
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
