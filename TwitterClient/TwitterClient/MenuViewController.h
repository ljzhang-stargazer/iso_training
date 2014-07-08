//
//  MenuViewController.h
//  TwitterClient
//
//  Created by Lin Zhang on 7/6/14.
//  Copyright (c) 2014 Lin Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuViewDelegate <NSObject>

@optional
-(void)didClickTimeline;
-(void)didClickMentions;
-(void)didClickProfile;

@end

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id<MenuViewDelegate> delegate;

@end
