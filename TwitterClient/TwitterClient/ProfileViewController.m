//
//  ProfileViewController.m
//  TwitterClient
//
//  Created by Lin Zhang on 7/2/14.
//  Copyright (c) 2014 Lin Zhang. All rights reserved.
//

#import "ProfileViewController.h"
#import "TwitterClient.h"
#import "UserInfo.h"
#import "TweetCell.h"
#import "TweetInfo.h"
#import "ProfileHeader.h"
#import "ProfileInfoCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface ProfileViewController ()

@property (nonatomic, strong) NSString *username;
@property (nonatomic, assign) BOOL isSelf;
@property (nonatomic, strong) NSDictionary *data;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ProfileHeader *headerView;
@property (nonatomic, strong) NSMutableArray *tweetsArray;

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (ProfileViewController *)initWithUserId:(NSString *)username {
    self = [super init];
    
    self.username = username;
    self.isSelf = [[User currentUser].data[@"screen_name"] isEqualToString:self.username];
    
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setObject:username forKey:@"screen_name"];
    [[TwitterClient sharedClient] getUser:dictionary
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      self.data = responseObject;
                                      //NSLog(@"%@", self.data);
                                      [self updateView];
                                      [self.tableView reloadData];
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error){
                                      NSLog(@"%@", error);
                                  }
     ];
    
    [dictionary setObject:[NSNumber numberWithInt:5] forKey:@"count"];
    [[TwitterClient sharedClient] getTweetsWithParameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.tweetsArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dictionary in responseObject) {
            [self.tweetsArray addObject:[[Tweet alloc] initWithDictionary:dictionary]];
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Error retreiving tweets" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (!self.isSelf) {
        [self setTitle:self.username];
    }
    else {
        [self setTitle:@"me"];
    }
    
    // Registering table cell
    UINib *nibForProfile = [UINib nibWithNibName:@"ProfileInfoCell" bundle:nil];
    [self.tableView registerNib:nibForProfile forCellReuseIdentifier:@"ProfileInfoCell"];
    
    UINib *nibForTweet = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tableView registerNib:nibForTweet forCellReuseIdentifier:@"TweetCell"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.headerView = [[ProfileHeader alloc] initWithNibName:@"ProfileHeader"];
    self.headerView.scrollView.contentSize = CGSizeMake(640, 160);
    self.headerView.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.tableHeaderView = self.headerView;
    
}

- (void)updateView {
    // Update header view
    NSURL *avatarUrl = [NSURL URLWithString:self.data[@"profile_image_url"]];
    NSURL *backgroundUrl = [NSURL URLWithString:self.data[@"profile_background_image_url"]];
    [self.headerView.avatar setImageWithURL:avatarUrl placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.headerView.backgroundImage setImageWithURL:backgroundUrl placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.headerView.name.text = self.data[@"name"];
    self.headerView.username.text = [NSString stringWithFormat:@"@%@", self.data[@"screen_name"]];
    [self.headerView.backgroundImage setAlpha:.5];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark TableView Delegate functions
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0) {
        ProfileInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ProfileInfoCell" forIndexPath:indexPath];
        cell.tweetsCount.text = [NSString stringWithFormat:@"%@", self.data[@"statuses_count"]];
        cell.followersCount.text = [NSString stringWithFormat:@"%@", self.data[@"followers_count"]];
        cell.followingCount.text = [NSString stringWithFormat:@"%@", self.data[@"friends_count"]];
        return cell;
    }
    else {
        if (indexPath.row == 5) {
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
            cell.textLabel.text = @"See more tweets...";
            return cell;
        }
        else {
            TweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
            Tweet *tweet = [self.tweetsArray objectAtIndex:indexPath.row];
            
            cell.avatar.tag = indexPath.row;
            cell.tweet.text = tweet.tweet;
            cell.tweet.lineBreakMode = NSLineBreakByWordWrapping;
            cell.fullName.text = tweet.fullName;
            cell.twitterHandle.text = [NSMutableString stringWithFormat:@"@%@", tweet.username];
            [cell.avatar setImageWithURL:tweet.profilePicture placeholderImage:[UIImage imageNamed:@"placeholder"]];
            cell.time.text = tweet.datePostedShorthand;
            
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if(indexPath.row == 5) {
            return 44;
        }
        else {
            Tweet *tweet = [self.tweetsArray objectAtIndex:indexPath.row];
            NSString* tweetContent = [NSString stringWithFormat:@"%@",tweet.tweet];
            UIFont *font = [UIFont systemFontOfSize: 14];
            CGRect rect = [tweetContent boundingRectWithSize:CGSizeMake(242, MAXFLOAT)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName: font} context:nil];
            
            CGFloat dynamicHeight = rect.size.height + 39;
            CGFloat minHeight = 64;
            
            return (dynamicHeight > minHeight) ? dynamicHeight : minHeight;
        }
    }
    else {
        return 44;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return 1;
    }
    else {
        return 6;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

@end
