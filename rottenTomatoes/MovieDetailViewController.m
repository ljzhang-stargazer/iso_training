//
//  MovieDetailViewController.m
//  rottenTomatoes
//
//  Created by Lin Zhang on 6/9/14.
//  Copyright (c) 2014 Lin Zhang. All rights reserved.
//

#import "MovieDetailViewController.h"

@interface MovieDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *moviePicture;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *movieDetail;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation MovieDetailViewController


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
    self.movieTitle.text = self.title;
    self.movieDetail.text = self.detail;
    self.moviePicture.contentMode = UIViewContentModeScaleAspectFit;
    self.moviePicture.image = self.picture;
    
    self.moviePicture.alpha = 0;
    [UIView beginAnimations:@"fade in" context:nil];
    [UIView setAnimationDuration:3.0]; //fade-in duration in second
    self.moviePicture.alpha = 1.0;
    [UIView commitAnimations];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = self.contentView.bounds.size;
}

@end
