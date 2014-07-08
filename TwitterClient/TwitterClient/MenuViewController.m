//
//  MenuViewController.m
//  TwitterClient
//
//  Created by Lin Zhang on 7/6/14.
//  Copyright (c) 2014 Lin Zhang. All rights reserved.
//

#import "MenuViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UserInfo.h"

@interface MenuViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *menuOptions;

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.menuOptions = @[@"Profile", @"Timeline", @"Mentions"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Table setup
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MenuCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Add header view to table
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 58)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 48, 48)];
    [headerView addSubview:imageView];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(58, 5, 120, 20)];
    [headerView addSubview:nameLabel];
    UILabel *screennameLabel = [[UILabel alloc] initWithFrame:CGRectMake(58, 30, 120, 20)];
    [headerView addSubview:screennameLabel];
    self.tableView.tableHeaderView = headerView;
    
    // Update header view
    NSURL *avatarUrl = [NSURL URLWithString:[User currentUser].data[@"profile_image_url"]];
    [imageView setImageWithURL:avatarUrl placeholderImage:[UIImage imageNamed:@"placeholder"]];
    nameLabel.text = [User currentUser].data[@"name"];
    nameLabel.font = [UIFont boldSystemFontOfSize:13];
    screennameLabel.text = [NSString stringWithFormat:@"@%@", [User currentUser].data[@"screen_name"]];
    screennameLabel.font = [UIFont systemFontOfSize:13];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark TableView Delegate functions
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MenuCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.menuOptions[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuOptions.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self didClickProfile];
    }
    else if (indexPath.row == 1) {
        [self didClickTimeline];
    }
    else if (indexPath.row == 2) {
        [self didClickMentions];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

# pragma mark Click Table Rows
- (void)didClickProfile {
    if ([self.delegate respondsToSelector:@selector(didClickProfile)]) {
        [self.delegate didClickProfile];
    }
}

- (void)didClickTimeline {
    if ([self.delegate respondsToSelector:@selector(didClickTimeline)]) {
        [self.delegate didClickTimeline];
    }
}

- (void)didClickMentions {
    if ([self.delegate respondsToSelector:@selector(didClickMentions)]) {
        [self.delegate didClickMentions];
    }
}


@end
