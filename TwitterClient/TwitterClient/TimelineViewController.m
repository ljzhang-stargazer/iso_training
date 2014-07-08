//
//  TimelineViewController.m
//  TwitterClient
//
//  Created by Lin Zhang on 6/27/14.
//  Copyright (c) 2014 Lin Zhang. All rights reserved.
//

#import "TimelineViewController.h"
#import "TwitterClient.h"
#import "UserInfo.h"
#import "TweetInfo.h"
#import "ProfileViewController.h"
#import <ProgressHUD/ProgressHUD.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "MainViewController.h"

@interface TimelineViewController ()
@property (weak, nonatomic) IBOutlet UITableView *feedTable;
@property (nonatomic, strong) NSMutableArray *tweetsArray;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSString *lastTweetId;
@property (strong, nonatomic) NSString *firstTweetId;
@property (nonatomic, assign) BOOL firstTimeLoaded;
@property (nonatomic, assign) BOOL loadingMoreValues;
@property (nonatomic, assign) BOOL mentions;

@end

@implementation TimelineViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //[self retrieveTweetsFromPullToRefresh:NO];
    }
    return self;
}

- (id)initWithTimeline {
    self = [super init];
    self.mentions = NO;
    [self retrieveTweetsFromPullToRefresh:NO];
    return self;
}


- (id)initWithMentions {
    self = [super init];
    self.mentions = YES;
    [self retrieveTweetsFromPullToRefresh:NO];
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadFromBeingActive)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [self setTitle:@"Home"];
    
    self.feedTable.delegate = self;
    self.feedTable.dataSource = self;
    
    // Registering table cell
    UINib *nib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.feedTable registerNib:nib forCellReuseIdentifier:@"TweetCell"];
    
    // Add navbar buttons
    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStyleDone target:self action:@selector(didClickCompose)];
    [self.navigationItem setRightBarButtonItem:composeButton];
    
    UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStyleDone target:self action:@selector(didClickSignOut)];
    [self.navigationItem setLeftBarButtonItem:signOutButton];
    
    // Refresh Control setup
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [self.feedTable addSubview:self.refreshControl];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark Button Click functions
- (void)didClickSignOut {
    [User setCurrentUser:nil];
    [[TwitterClient sharedClient].requestSerializer removeAccessToken];
    return;
}

- (void)didClickCompose {
    UIViewController *rootController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    ComposeTweetViewController *composeViewController = [[ComposeTweetViewController alloc] init];
    composeViewController.delegate = self;
    [rootController presentViewController:composeViewController animated:YES completion:^{}];
    return;
}

# pragma mark TableView Delegate functions
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [self.feedTable dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    Tweet *tweet = [self.tweetsArray objectAtIndex:indexPath.row];
    
    cell.delegate = self;
    cell.avatar.tag = indexPath.row;
    cell.tweet.text = tweet.tweet;
    cell.tweet.lineBreakMode = NSLineBreakByWordWrapping;
    cell.fullName.text = tweet.fullName;
    cell.twitterHandle.text = [NSMutableString stringWithFormat:@"@%@", tweet.username];
    [cell.avatar setImageWithURL:tweet.profilePicture placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.time.text = tweet.datePostedShorthand;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Tweet *tweet = [self.tweetsArray objectAtIndex:indexPath.row];
    NSString* tweetContent = [NSString stringWithFormat:@"%@",tweet.tweet];
    UIFont *font = [UIFont systemFontOfSize: 14];
    CGRect rect = [tweetContent boundingRectWithSize:CGSizeMake(242, MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName: font} context:nil];
    
    CGFloat dynamicHeight = rect.size.height + 20;
    CGFloat minHeight = 60;
    
    return (dynamicHeight > minHeight) ? dynamicHeight : minHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweetsArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailTweetViewController *detailTweetController = [[DetailTweetViewController alloc] initWithTweetObject:self.tweetsArray[indexPath.row]];
    detailTweetController.delegate = self;
    [self.navigationController pushViewController:detailTweetController animated:YES];
    [self.feedTable deselectRowAtIndexPath:indexPath animated:YES];
}

# pragma mark Data Processing functions
- (void)retrieveTweetsFromPullToRefresh:(BOOL)fromPullToRefresh{
    NSDictionary *parameters = nil;
    if (!fromPullToRefresh) {
        [ProgressHUD show:@"Please wait..."];
    }
    
    if (self.firstTimeLoaded) {
        parameters = @{@"since_id":self.firstTweetId};
    }

    if (self.mentions) {
        [self getMentionsTweetsWithParameters:parameters];
    }
    else {
        [self getTimlineTweetsWithParameters:parameters];
    }
    if (!fromPullToRefresh) {
        [ProgressHUD dismiss];
    }
}

- (void)getTimlineTweetsWithParameters:(NSDictionary *)parameters {
    [[TwitterClient sharedClient] getTimelineWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!self.firstTimeLoaded) {
            [self processData:(NSArray *)responseObject];
            self.firstTimeLoaded = YES;
        }
        else {
            [self addDataToFront:(NSArray *)responseObject];
        }
        [self.feedTable reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Error retreiving tweets" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}


- (void)getMentionsTweetsWithParameters:(NSDictionary *)parameters {
    [[TwitterClient sharedClient] getMentionsWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!self.firstTimeLoaded) {
            [self processData:(NSArray *)responseObject];
            self.firstTimeLoaded = YES;
        }
        else {
            [self addDataToFront:(NSArray *)responseObject];
        }
        [self.feedTable reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Error retreiving tweets" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

- (void)processData:(NSArray *)data {
    self.tweetsArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in data) {
        [self.tweetsArray addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    self.lastTweetId = ((Tweet *)[self.tweetsArray lastObject]).tweetId;
    self.firstTweetId = ((Tweet *)[self.tweetsArray firstObject]).tweetId;
}

- (void)addDataToFront:(NSArray *)data {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in data) {
        [array addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    self.tweetsArray = [[array arrayByAddingObjectsFromArray:self.tweetsArray] mutableCopy];
    self.lastTweetId = ((Tweet *)[self.tweetsArray lastObject]).tweetId;
    self.firstTweetId = ((Tweet *)[self.tweetsArray firstObject]).tweetId;
}

- (void)addDataToBack:(NSArray *)data {
    for (NSDictionary *dictionary in data) {
        [self.tweetsArray addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    self.lastTweetId = ((Tweet *)[self.tweetsArray lastObject]).tweetId;
    self.firstTweetId = ((Tweet *)[self.tweetsArray firstObject]).tweetId;
}

- (void)refreshTable {
    [self retrieveTweetsFromPullToRefresh:YES];
    [self.refreshControl endRefreshing];
}

- (void)reloadFromBeingActive {
    self.firstTimeLoaded = NO;
    [self retrieveTweetsFromPullToRefresh:NO];
}

# pragma mark Tweeting functions / delegate functions
-(void)sendTweet:(NSDictionary *)tweet {
    [[TwitterClient sharedClient] postTweet:tweet
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
                                        [self.tweetsArray insertObject:tweet atIndex:0];
                                        [self.feedTable reloadData];
                                        self.lastTweetId = ((Tweet *)[self.tweetsArray lastObject]).tweetId;
                                    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error){
                                        NSLog(@"%@", error);
                                    }
     ];
}

-(void)retweet:(NSString *)tweetId {
    [[TwitterClient sharedClient] retweet:tweetId
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        //NSLog(@"%@", responseObject);
                                    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error){
                                        NSLog(@"%@", error);
                                    }
     ];
}

- (void)displayProfile:(UIGestureRecognizer *)sender {
    ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithUserId:((Tweet *)[self.tweetsArray objectAtIndex:sender.view.tag]).username];
    [self.navigationController pushViewController:profileViewController animated:YES];
}

@end
