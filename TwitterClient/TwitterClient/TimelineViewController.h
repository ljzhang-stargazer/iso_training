//
//  TimelineViewController.h
//  TwitterClient
//
//  Created by Lin Zhang on 6/27/14.
//  Copyright (c) 2014 Lin Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeTweetViewController.h"
#import "DetailTweetViewController.h"
#import "TweetCell.h"

@interface TimelineViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ComposeTweetViewDelegate, DetailTweetViewDelegate, TweetCellDelegate>

- (id)initWithTimeline;
- (id)initWithMentions;

@end
