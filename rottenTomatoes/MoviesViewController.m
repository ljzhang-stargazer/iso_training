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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=g9au4hv6khv6wzvzgt55gpqs";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"%@", object);
        
        self.movies = object[@"movies"];
        
        [self.tableView reloadData];
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
    NSLog(@"cell for row at index path: %d", indexPath.row);
    
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    NSDictionary *movie = self.movies[indexPath.row];
    //NSLog(movie[@"title"]);
    //NSLog(movie[@"posters"][@"thumbnail"]);
    
    cell.movieTitleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"synopsis"];
   
    
    NSURL *url = [NSURL URLWithString:movie[@"posters"][@"thumbnail"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
    
    __weak UITableViewCell *weakCell = cell;
    
    //cell.posterView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.posterView setImageWithURLRequest:request
                          placeholderImage:placeholderImage
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       
                                       weakCell.imageView.image = image;
                                       //weakCell.imageView.contentMode = UIViewContentModeScaleAspectFit;
                                       [weakCell setNeedsLayout];
                                       
                                   } failure:nil];
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
    [self.navigationController pushViewController:vc animated:YES];
}

@end
