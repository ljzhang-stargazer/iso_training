//
//  ComposeTweetViewController.h
//  TwitterClient
//
//  Created by Lin Zhang on 6/27/14.
//  Copyright (c) 2014 Lin Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ComposeTweetViewDelegate <NSObject>

@optional
-(void)sendTweet:(NSDictionary *)dictionary;
-(void)replyTweet:(NSDictionary *)dictionary;

@end

@interface ComposeTweetViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, assign) id<ComposeTweetViewDelegate> delegate;
@property (nonatomic, strong) NSDictionary *replyData;

- (ComposeTweetViewController *)initWithReplyData:(NSDictionary *)replyData;

@end
