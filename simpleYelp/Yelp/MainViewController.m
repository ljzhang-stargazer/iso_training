//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "RestaurantProfile.h"
#import "BusinessProfile.h"
#import "IntroViewCell.h"
#import "FilterViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController ()

@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSMutableArray *businessArray;
//@property (strong, nonatomic) NSDictionary *dic;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)   UISearchBar *searchBar;


@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
        [self.client searchWithTerm:@"Thai" success:^(AFHTTPRequestOperation *operation, id response) {
            //NSLog(@"response: %@", response);
            
            self.businessArray = [[NSMutableArray alloc] init];
            
            for (NSDictionary *business in response[@"businesses"]) {
                [self.businessArray addObject:[[RestaurantProfile alloc] initWithRestaurantProfileData:business]];
                //NSLog(@"business: %@", business);
            }
            
            [self.tableView reloadData];

            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@", [error description]);
        }];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib: [UINib nibWithNibName:@"IntroViewCell" bundle:nil] forCellReuseIdentifier:@"IntroViewCell"];
    
    UINavigationBar *headerView = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    UINavigationItem *buttonCarrier = [[UINavigationItem alloc]initWithTitle:@""];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStyleDone target:self action:@selector(filter)];
    [buttonCarrier setLeftBarButtonItem:cancelButton];
    NSArray *barItemArray = [[NSArray alloc]initWithObjects:buttonCarrier,nil];
    [headerView setItems:barItemArray];
    [self.tableView setTableHeaderView:headerView];
    
    [headerView setBarTintColor:[UIColor redColor]];
    [headerView setTintColor:[UIColor whiteColor]];
    
    // Set search bar
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    
    headerView.topItem.titleView = self.searchBar;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

        return 80;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.businessArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //tableView.rowHeight = 150;
    
    IntroViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"IntroViewCell" forIndexPath:indexPath];
    RestaurantProfile *restaurant = [self.businessArray objectAtIndex:indexPath.row];
    
    cell.name.text = [NSString stringWithFormat:@"%d. %@", indexPath.row+1, restaurant.name];
    NSLog(@"restaurant.review: %@", restaurant.reviewNum);
    //NSLog(@"restaurant.isOpen: %@", restaurant.isOpen? @"YES" : @"NO");
    
    cell.name.lineBreakMode = NSLineBreakByWordWrapping;
    cell.review.text = restaurant.reviewNum;
    cell.review.lineBreakMode = NSLineBreakByWordWrapping;
    cell.address.text = [NSString stringWithFormat:@"%@, %@", restaurant.address, restaurant.city];
    cell.address.lineBreakMode = NSLineBreakByWordWrapping;
    cell.category.text = @"Thai, thai"; //restaurant.category;
    cell.category.lineBreakMode = NSLineBreakByWordWrapping;

    __weak IntroViewCell *weakCell = cell;
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
    
    NSURLRequest *restaurantImageRequest = [NSURLRequest requestWithURL:restaurant.profileImage];
    [cell.profileImage setImageWithURLRequest:restaurantImageRequest
                                placeholderImage:placeholderImage
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                             weakCell.profileImage.image = image;
                                             [weakCell setNeedsLayout];
                                         } failure:nil];
    
    NSURLRequest *ratingImageRequest = [NSURLRequest requestWithURL:restaurant.ratingImage];
    [cell.ratingImage setImageWithURLRequest:ratingImageRequest
                            placeholderImage:placeholderImage
                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                         weakCell.ratingImage.image = image;
                                         [weakCell setNeedsLayout];
                                     } failure:nil];
    
    //borrow from Guozhang Ge's post
    cell.profileImage.layer.shadowColor = [[UIColor grayColor] CGColor];
    cell.profileImage.layer.shadowRadius = 5.0;
    cell.profileImage.layer.shadowOpacity = 1.0;
    cell.profileImage.layer.shadowOffset = CGSizeMake(0, 0);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:cell.profileImage.bounds cornerRadius:5.0];
    cell.profileImage.layer.shadowPath = path.CGPath;
    cell.profileImage.layer.cornerRadius = 5.0;
    cell.profileImage.layer.borderColor = [[UIColor grayColor] CGColor];
    cell.profileImage.layer.borderWidth = 1.0;
    cell.profileImage.layer.masksToBounds = YES;
    
    return cell;
}

- (void)filter {
    [self.searchBar resignFirstResponder];
    FilterViewController *filterViewController = [[FilterViewController alloc] initWithNibName:NSStringFromClass([FilterViewController class]) bundle:nil];
    filterViewController.delegate = self;
    [self presentViewController:filterViewController animated:YES completion:^{}];
    return;
}

@end
