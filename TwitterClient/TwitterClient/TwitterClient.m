//
//  TwitterClient.m
//  TwitterClient
//
//  Created by Lin Zhang on 6/26/14.
//  Copyright (c) 2014 Lin Zhang. All rights reserved.
//

#import "TwitterClient.h"

NSString * const twitterAPIKey = @"WWkS3uIV1BlY9NjUfpTB0OqUa";
NSString * const twitterAPISecret = @"YuBnkmM88iEheL5NaMVyF4TbWfLo1s52DBhOgedzJm56lhT7ms";
NSString * const twitterAccessToken = @"2601095616-bQwJXkICMAulEv74eHSI6P0f5lCllP7wZ3Qi5Z6";
NSString * const twitterAccessTokenSecret = @"f9BOg9d0P9331QuEKqdEI6eqvHS3oTKj5uukED7dtxogr";

@implementation TwitterClient

+ (TwitterClient *)sharedClient {
    static TwitterClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com/"] consumerKey:twitterAPIKey consumerSecret:twitterAPISecret];
    });
    return _sharedClient;
}

- (void)login {
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token"
                             method:@"POST"
                        callbackURL:[NSURL URLWithString:@"nttwitter://request"]
                              scope:nil
                            success:^ (BDBOAuthToken *requestToken) {
                                NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
                            }
                            failure:^(NSError *error) {
                                [[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Couldn't log in with Twitter, please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                            }];
}

- (AFHTTPRequestOperation *)getTimelineWithParameters:(NSDictionary *)dictionary
                                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self GET:@"1.1/statuses/home_timeline.json" parameters:dictionary success:success failure:failure];
}

- (AFHTTPRequestOperation *)getUserWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:success failure:failure];
}

- (AFHTTPRequestOperation *)postTweet:(NSDictionary*)tweet
                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self POST:@"1.1/statuses/update.json" parameters:tweet success:success failure:failure];
}

- (AFHTTPRequestOperation *)deleteTweet:(NSString*)tweetId
                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *endpoint = [NSString stringWithFormat:@"1.1/statuses/destroy/%@.json", tweetId];
    return [self POST:endpoint parameters:nil success:success failure:failure];
}

- (AFHTTPRequestOperation *)retweet:(NSString*)tweetId
                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *endpoint = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweetId];
    return [self POST:endpoint parameters:nil success:success failure:failure];
}

- (AFHTTPRequestOperation *)favorite:(NSDictionary*)dictionary
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self POST:@"1.1/favorites/create.json" parameters:dictionary success:success failure:failure];
}

- (AFHTTPRequestOperation *)unfavorite:(NSDictionary*)dictionary
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self POST:@"1.1/favorites/destroy.json" parameters:dictionary success:success failure:failure];
}

- (AFHTTPRequestOperation *)getUser:(NSDictionary*)dictionary success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    return [self GET:@"1.1/users/show.json" parameters:dictionary success:success failure:failure];
}

- (AFHTTPRequestOperation *)getMentionsWithParameters:(NSDictionary *)dictionary
                                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self GET:@"1.1/statuses/mentions_timeline.json" parameters:dictionary success:success failure:failure];
}

- (AFHTTPRequestOperation *)getTweetsWithParameters:(NSDictionary *)dictionary
                                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self GET:@"1.1/statuses/user_timeline.json" parameters:dictionary success:success failure:failure];
}

@end
