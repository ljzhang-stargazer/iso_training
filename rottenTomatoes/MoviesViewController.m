//
//  MoviesViewController.m
//  rottenTomatoes
//
//  Created by Lin Zhang on 6/7/14.
//  Copyright (c) 2014 Lin Zhang. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "MovieDetailViewController.h"
#import "MBProgressHUD.h"

@interface MoviesViewController()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;

//- (IBAction)onTap:(id)sender;

@end

@implementation MoviesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"movies";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //display loading animation
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=g9au4hv6khv6wzvzgt55gpqs";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"%@", object);

        //hide loading animation
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    
        self.movies = object[@"movies"];
        
        [self.tableView reloadData];
        
        
        //refresh
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
        [self.tableView addSubview:refreshControl];
        
    }];
    
    [self.tableView registerNib: [UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    
    self.tableView.rowHeight = 150;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table viwe methods
- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"cell for row at index path: %d", indexPath.row);
    
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    NSDictionary *movie = self.movies[indexPath.row];
    
    cell.movieTitleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"synopsis"];
   
    
    NSURL *url = [NSURL URLWithString:movie[@"posters"][@"original"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
    
    //__weak UITableViewCell *weakCell = cell;
    
    cell.posterView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.posterView setImageWithURLRequest:request
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       //hide loading animation
                                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                                       //weakCell.imageView.image = image;
                                       //[weakCell setNeedsLayout];
                                       cell.posterView.image = image;
                                       
                                   } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       self.title = @"Network Error!";
                                   }
     
     ];
    return cell;
}

//this code is from reference, but i don't know how to link it with the UITableView. It will be good to be able to use this.
- (IBAction)onTap:(id)sender {
    NSLog(@"tapped");
    MovieDetailViewController *vc = [[MovieDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

// Tap on table Row
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

    MovieDetailViewController *vc = [[MovieDetailViewController alloc] init];
    
    
    NSDictionary *selectedMovie = [self.movies objectAtIndex:indexPath.row];
    [vc setTitle: selectedMovie[@"title"]];
    [vc setDetail: selectedMovie[@"synopsis"]];
    
    
    NSURL *url = [NSURL URLWithString:selectedMovie[@"posters"][@"original"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    [cell.posterView setImageWithURLRequest:request
                           placeholderImage:nil
                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                        //hide loading animation
                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                        //weakCell.imageView.image = image;
                                        //[weakCell setNeedsLayout];
                                        [vc setPicture:image];
                                        
                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                        self.title = @"Network Error!";
                                    }
     
     ];
    
    //set values for DetailView
    /*
    [vc setTitle: movie[@"title"]];
    [vc setTitle: movie[@"synopsis"]];
    [vc setPicture:: nil];
     */
    
    [self.navigationController pushViewController:vc animated:YES];
}

//refresh control
- (void)refresh:(UIRefreshControl *)refreshControl {
    NSLog(@"refresh");
    [refreshControl endRefreshing];
}

@end
