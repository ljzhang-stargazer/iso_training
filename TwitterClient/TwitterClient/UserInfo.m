//
//  UserInfo.m
//  TwitterClient
//
//  Created by Lin Zhang on 6/27/14.
//  Copyright (c) 2014 Lin Zhang. All rights reserved.
//

#import "UserInfo.h"

NSString * const UserDidLoginNotification = @"UserDidLoginNotification";
NSString * const UserDidLogoutNotification = @"UserDidLogoutNotification";

@implementation User

static User *currentUser = nil;

+ (User *)currentUser {
    if (currentUser == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_user"];
        if (data) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    return currentUser;
}

+ (void)setCurrentUser:(User *)user {
    if (user) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSJSONSerialization dataWithJSONObject:user.data
                                                                                         options:NSJSONWritingPrettyPrinted
                                                                                           error:nil]
                                                  forKey:@"current_user"];
    }
    else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"current_user"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Set currentUser to user and notify of login
    if (currentUser == nil && user != nil) {
        currentUser = user;
        [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLoginNotification object:nil];
    }
    // Set currentUser to nil and notify of logout
    else if (currentUser != nil && user == nil) {
        currentUser = user;
        [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
    }
}

- (User*)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    _data = dictionary;
    return self;
}

@end
