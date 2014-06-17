//
//  AppDelegate.m
//  rottenTomatoes
//
//  Created by Lin Zhang on 6/7/14.
//  Copyright (c) 2014 Lin Zhang. All rights reserved.
//

#import "AppDelegate.h"
#import "MoviesViewController.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    /*
    MoviesViewController *vc = [[MoviesViewController alloc] init];
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    self.window.rootViewController = nvc;
    */
    
    NSString* boxOfficeURL = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=g9au4hv6khv6wzvzgt55gpqs";
    NSString* dvdViewOfficeURL = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=g9au4hv6khv6wzvzgt55gpqs";
    
    MoviesViewController *boxOfficeViewController = [[MoviesViewController alloc] initWithURL:boxOfficeURL];
     MoviesViewController *dvdViewController = [[MoviesViewController alloc] initWithURL:dvdViewOfficeURL];
     
     UINavigationController *boxOfficeNavController = [[UINavigationController alloc] initWithRootViewController:boxOfficeViewController];
     //boxOfficeNavController.tabBarItem.image = ;
    boxOfficeNavController.tabBarItem.title = @"Box Office";
     
     UINavigationController *dvdNavController = [[UINavigationController alloc] initWithRootViewController:dvdViewController];
     //dvdNavController.tabBarItem.image = ;
     boxOfficeNavController.tabBarItem.title = @"Top DVDs";
    
     UITabBarController *tbc = [[UITabBarController alloc] init];
     [tbc setViewControllers:[NSArray arrayWithObjects:boxOfficeNavController, dvdNavController, nil]];
     [tbc.view setBackgroundColor:[UIColor lightGrayColor]];
     self.window.rootViewController = tbc;

    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
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
