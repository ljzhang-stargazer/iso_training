//
//  ProfileViewController.h
//  TwitterClient
//
//  Created by Lin Zhang on 7/2/14.
//  Copyright (c) 2014 Lin Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

- (ProfileViewController *)initWithUserId:(NSString *)username;

@end
