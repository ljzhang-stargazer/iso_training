//
//  UserInfo.h
//  TwitterClient
//
//  Created by Lin Zhang on 6/27/14.
//  Copyright (c) 2014 Lin Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const UserDidLoginNotification;
extern NSString *const UserDidLogoutNotification;

@interface User : NSObject

+ (User *)currentUser;
+ (void)setCurrentUser:(User*)user;
- (User *)initWithDictionary:(NSDictionary*)dictionary;

@property (nonatomic, strong) NSDictionary *data;

@end
