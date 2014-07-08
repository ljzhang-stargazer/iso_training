//
//  TweetInfo.h
//  TwitterClient
//
//  Created by Lin Zhang on 6/27/14.
//  Copyright (c) 2014 Lin Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *datePostedShorthand;
@property (nonatomic, strong) NSString *retweetedBy;
@property (nonatomic, strong) NSString *tweet;
@property (nonatomic, strong) NSString *tweetId;
@property (nonatomic, strong) NSString *inReplyToStatusId;

@property (nonatomic, strong) NSURL *profilePicture;
@property (nonatomic, strong) NSDate *datePosted;

@property (nonatomic, strong) NSNumber *favoriteCount;
@property (nonatomic, strong) NSNumber *retweetCount;

@property (nonatomic, strong) NSDictionary *data;

@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, assign) BOOL retweeted;

- (Tweet *)initWithDictionary:(NSDictionary *)dictionary;

@end
