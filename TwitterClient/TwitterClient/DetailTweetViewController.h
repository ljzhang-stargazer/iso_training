//
//  DetailTweetViewController.h
//  TwitterClient
//
//  Created by Lin Zhang on 6/27/14.
//  Copyright (c) 2014 Lin Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetInfo.h"

@protocol DetailTweetViewDelegate <NSObject>

@end

@interface DetailTweetViewController : UIViewController

- (DetailTweetViewController *)initWithTweetObject:(Tweet*)tweet;

@property (nonatomic, assign) id<DetailTweetViewDelegate> delegate;

@end
