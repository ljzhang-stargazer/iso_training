//
//  DetailTweetViewController.m
//  TwitterClient
//
//  Created by Lin Zhang on 6/27/14.
//  Copyright (c) 2014 Lin Zhang. All rights reserved.
//

#import "ComposeTweetViewController.h"
#import "DetailTweetViewController.h"
#import "TwitterClient.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface DetailTweetViewController ()
@property (nonatomic, strong) Tweet *tweetObject;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UILabel *handle;
@property (weak, nonatomic) IBOutlet UILabel *tweet;
@property (weak, nonatomic) IBOutlet UILabel *favorites;
@property (weak, nonatomic) IBOutlet UILabel *retweets;
- (IBAction)clickReplyButton:(id)sender;
- (IBAction)clickRetweetButton:(id)sender;
- (IBAction)clickFavoriteButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;

@end

@implementation DetailTweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"Tweet"];
    
    UIBarButtonItem *replyButton = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStyleDone target:self action:@selector(didClickReply)];
    [self.navigationItem setRightBarButtonItem:replyButton];
    
    self.fullName.text = self.tweetObject.fullName;
    self.handle.text = [NSString stringWithFormat:@"@%@",self.tweetObject.username];
    self.retweets.text = [NSString stringWithFormat:@"%@ retweets", self.tweetObject.retweetCount];
    self.favorites.text = [NSString stringWithFormat:@"%@ favorites", self.tweetObject.favoriteCount];
    self.tweet.text = self.tweetObject.tweet;
    [self.avatar setImageWithURL:self.tweetObject.profilePicture placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    //borrow from Guozhang Ge's post
    self.avatar.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.avatar.layer.shadowRadius = 5.0;
    self.avatar.layer.shadowOpacity = 1.0;
    self.avatar.layer.shadowOffset = CGSizeMake(0, 0);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.avatar.bounds cornerRadius:5.0];
    self.avatar.layer.shadowPath = path.CGPath;
    self.avatar.layer.cornerRadius = 5.0;
    self.avatar.layer.borderColor = [[UIColor grayColor] CGColor];
    self.avatar.layer.borderWidth = 1.0;
    self.avatar.layer.masksToBounds = YES;
    
    // Retweet Button
    if (self.tweetObject.retweeted) {
        [self.retweetButton setHighlighted:YES];
        [self.retweetButton setSelected:YES];
        self.retweetButton.adjustsImageWhenHighlighted = NO;
    }
    //[self.retweetButton setImage:[UIImage imageNamed:@"retweet.png"] forState:UIControlStateNormal];
    [self.retweetButton setImage:[UIImage imageNamed:@"retweet_highlighted.png"] forState:UIControlStateHighlighted];
    [self.retweetButton setImage:[UIImage imageNamed:@"retweet_highlighted.png"] forState:UIControlStateSelected];
    [self.retweetButton setImage:[UIImage imageNamed:@"retweet_highlighted.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
    self.retweetButton.adjustsImageWhenHighlighted = NO;
    
    // Favorite Button
    if (self.tweetObject.favorited) {
        [self.favoriteButton setHighlighted:YES];
        [self.favoriteButton setSelected:YES];
    }
    //[self.favoriteButton setImage:[UIImage imageNamed:@"favorite.png"] forState:UIControlStateNormal];
    [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_highlighted.png"] forState:UIControlStateHighlighted];
    [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_highlighted.png"] forState:UIControlStateSelected];
    [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_highlighted.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
    self.favoriteButton.adjustsImageWhenHighlighted = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark Custom init function
- (DetailTweetViewController *)initWithTweetObject:(Tweet*)tweet {
    self = [super init];
    
    _tweetObject = tweet;
    
    return self;
}

#pragma mark Reply functions
- (IBAction)clickReplyButton:(id)sender {
    [self didClickReply];
}

- (void)didClickReply {
    NSDictionary *dictionary = @{@"handle":self.tweetObject.username, @"in_reply_to_status_id":self.tweetObject.tweetId};
    
    UIViewController *rootController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    ComposeTweetViewController *composeViewController = [[ComposeTweetViewController alloc] initWithReplyData:dictionary];
    composeViewController.delegate = (id<ComposeTweetViewDelegate>)self.delegate;
    [rootController presentViewController:composeViewController animated:YES completion:^{}];
    return;
}

#pragma mark Retweet functions
- (IBAction)clickRetweetButton:(id)sender {
    if (!self.tweetObject.retweeted) {
        UIButton *button = (UIButton *)sender;
        [button setSelected:!button.selected];
        [self retweet:self.tweetObject.tweetId];
        int value = [self.tweetObject.retweetCount intValue];
        self.tweetObject.retweetCount = [NSNumber numberWithInt:value + 1];
        self.tweetObject.retweeted = !self.tweetObject.retweeted;
        self.retweets.text = [NSString stringWithFormat:@"%@ retweets", self.tweetObject.retweetCount];
        [self.retweets setNeedsDisplay];
    }
}

-(void)retweet:(NSString *)tweetId {
    [[TwitterClient sharedClient] retweet:tweetId
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      //NSLog(@"%@", responseObject);
                                      NSLog(@"Retweeted");
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error){
                                      NSLog(@"%@", error);
                                  }
     ];
}

#pragma mark Favorite functions
- (IBAction)clickFavoriteButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    [button setSelected:!button.selected];
    
    if (self.tweetObject.favorited) {
        // Do unfavoriting
        [self sendUnfavorite:self.tweetObject.tweetId];
        
        // Decrement count
        int value = [self.tweetObject.favoriteCount intValue];
        self.tweetObject.favoriteCount = [NSNumber numberWithInt:value - 1];
    }
    else {
        // Do favoriting
        [self sendFavorite:self.tweetObject.tweetId];
        
        // Increment count
        int value = [self.tweetObject.favoriteCount intValue];
        self.tweetObject.favoriteCount = [NSNumber numberWithInt:value + 1];
    }
    self.favorites.text = [NSString stringWithFormat:@"%@ favorites", self.tweetObject.favoriteCount];
    [self.favorites setNeedsDisplay];
    self.tweetObject.favorited = !self.tweetObject.favorited;
}

- (void)sendFavorite:(NSString *)tweetId {
    NSDictionary *dictionary = @{@"id":tweetId};
    [[TwitterClient sharedClient] favorite:dictionary
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        //NSLog(@"%@", responseObject);
                                    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error){
                                        NSLog(@"%@", error);
                                    }
     ];
}

- (void)sendUnfavorite:(NSString *)tweetId {
    NSDictionary *dictionary = @{@"id":tweetId};
    [[TwitterClient sharedClient] unfavorite:dictionary
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        //NSLog(@"%@", responseObject);
                                    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error){
                                        NSLog(@"%@", error);
                                    }
     ];
}

@end
