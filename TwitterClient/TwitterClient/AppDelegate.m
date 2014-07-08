//
//  AppDelegate.m
//  TwitterClient
//
//  Created by Lin Zhang on 6/26/14.
//  Copyright (c) 2014 Lin Zhang. All rights reserved.
//

#import "AppDelegate.h"
#import "TwitterClient.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import "TimelineViewController.h"
#import "MenuViewController.h"
#import "UserInfo.h"

@implementation NSURL (dictionaryFromQueryString)
-(NSDictionary *) dictionaryFromQueryString{
    
    NSString *query = [self query];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}
@end

@interface AppDelegate ()

- (void)updateRootViewController;

@property (nonatomic, strong) LoginViewController *loginViewController;
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) MainViewController *mainViewController;
@property (nonatomic, strong) UIViewController *currentViewController;
@property (nonatomic, strong) MenuViewController *menuViewController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [self.window setRootViewController:self.currentViewController];
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRootViewController) name:UserDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRootViewController) name:UserDidLogoutNotification object:nil];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    TwitterClient *sharedClient = [TwitterClient sharedClient];
    
    if ([url.scheme isEqualToString:@"nttwitter"])
    {
        if ([url.host isEqualToString:@"request"])
        {
            NSDictionary *parameters = [url dictionaryFromQueryString];
            if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"]) {
                [sharedClient fetchAccessTokenWithPath:@"/oauth/access_token"
                                                method:@"POST"
                                          requestToken:[BDBOAuthToken tokenWithQueryString:url.query]
                                               success:^(BDBOAuthToken *accessToken) {
                                                   [sharedClient.requestSerializer saveAccessToken:accessToken];
                                                   [sharedClient getUserWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       [User setCurrentUser:[[User alloc] initWithDictionary:(NSDictionary *)responseObject]];
                                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       NSLog(@"%@", error);
                                                   }];
                                               }
                                               failure:^(NSError *error) {
                                                   NSLog(@"Error");
                                               }];
                
            }
        }
        return YES;
    }
    return NO;
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

- (void)updateRootViewController {
    [self.window setRootViewController:self.currentViewController];
}

- (UIViewController *)currentViewController {
    TwitterClient *sharedClient = [TwitterClient sharedClient];
    
    if ([User currentUser] && sharedClient.isAuthorized) {
        if (!self.menuViewController) {
            self.menuViewController = [[MenuViewController alloc] init];
        }
        if (!self.navigationController) {
            TimelineViewController *timelineViewController = [[TimelineViewController alloc] initWithTimeline];
            self.navigationController = [[UINavigationController alloc] initWithRootViewController:timelineViewController];
        }
        
        NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithObjects:self.menuViewController, self.navigationController, nil];
        
        if (!self.mainViewController) {
            self.mainViewController = [[MainViewController alloc] initWithViewControllers:viewControllers];
            
        }
        return self.mainViewController;
    }
    else {
        if (!self.loginViewController) {
            self.loginViewController = [[LoginViewController alloc] init];
        }
        return self.loginViewController;
    }
}

@end
