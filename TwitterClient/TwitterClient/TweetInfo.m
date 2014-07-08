//
//  TweetInfo.m
//  TwitterClient
//
//  Created by Lin Zhang on 6/27/14.
//  Copyright (c) 2014 Lin Zhang. All rights reserved.
//

#import "TweetInfo.h"

@implementation Tweet

- (Tweet *)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    _data = dictionary;
    
    self.username = _data[@"user"][@"screen_name"];
    self.profilePicture = [NSURL URLWithString:_data[@"user"][@"profile_image_url"]];
    self.fullName = _data[@"user"][@"name"];
    self.tweet = _data[@"text"];
    self.favoriteCount = _data[@"favorite_count"];
    self.retweetCount = _data[@"retweet_count"];
    self.tweetId = _data[@"id_str"];
    
    if ([_data[@"favorited"] boolValue]) {
        self.favorited = YES;
    }
    else {
        self.favorited = NO;
    }
    
    if ([_data[@"retweeted"] boolValue]) {
        self.retweeted = YES;
    }
    else {
        self.retweeted = NO;
    }
    
    if (_data[@"in_reply_to_status_id_str"]) {
        self.inReplyToStatusId = _data[@"in_reply_to_status_id_str"];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    self.datePostedShorthand = [NSDateFormatter localizedStringFromDate:[dateFormatter dateFromString:_data[@"created_at"]]
                                   dateStyle:NSDateFormatterShortStyle
                                   timeStyle:NSDateFormatterShortStyle];
    
    return self;
}

@end
