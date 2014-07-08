//
//  MainViewController.m
//  TwitterClient
//
//  Created by Lin Zhang on 7/6/14.
//  Copyright (c) 2014 Lin Zhang. All rights reserved.
//

#import "MainViewController.h"
#import "TimelineViewController.h"
#import "ProfileViewController.h"
#import "UserInfo.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, assign) CGPoint previousPosition;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)initWithViewControllers:(NSMutableArray *)viewControllers {
    self = [super init];
    self.viewControllers = viewControllers;
    
    // Adding child view controllers
    for (UIViewController *viewController in self.viewControllers) {
        [self addChildViewController:viewController];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ((MenuViewController *)self.viewControllers[0]).delegate = self;
    
    UIView *firstView = ((UIViewController *)self.viewControllers[0]).view;
    UIView *secondView = ((UIViewController *)self.viewControllers[1]).view;
    
    firstView.frame = self.contentView.frame;
    secondView.frame = self.contentView.frame;
    
    // Do any additional setup after loading the view from its nib.
    [self.contentView addSubview:firstView];
    [self.contentView addSubview:secondView];
    
    for (UIViewController *viewController in self.viewControllers) {
        [viewController didMoveToParentViewController:self];
    }
    
    // Pan Gesture Recognizer
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onCustomPan:)];
    [self.contentView addGestureRecognizer:panGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onCustomPan:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint point = [panGestureRecognizer locationInView:self.contentView];
    CGPoint velocity = [panGestureRecognizer velocityInView:self.contentView];
    
    int difference = 0;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.previousPosition = point;
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        difference = self.previousPosition.x - point.x;
        self.previousPosition = point;
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        difference = self.previousPosition.x - point.x;
    }
    
    UIView *timelineView = ((UIView *)self.contentView.subviews[1]);
    timelineView.center = CGPointMake(timelineView.center.x - difference, 284);

    
    // Out of bounds prevention
    if (timelineView.center.x < 160) {
        timelineView.center = CGPointMake(160, 284);
    } else if (timelineView.center.x > 450) {
        timelineView.center = CGPointMake(450, 284);
    }
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (timelineView.center.x > 240 && velocity.x > 0) {
            [UIView animateWithDuration:.5 animations:^{
                timelineView.center = CGPointMake(450, 284);
            } completion:^(BOOL finished) {
            }];
        }
        else if (timelineView.center.x < 240 && velocity.x > 0) {
            [UIView animateWithDuration:.5 animations:^{
                timelineView.center = CGPointMake(160, 284);
            } completion:^(BOOL finished) {
            }];
        }
        else if (timelineView.center.x < 410 && velocity.x < 0) {
            [UIView animateWithDuration:.5 animations:^{
                timelineView.center = CGPointMake(160, 284);
            } completion:^(BOOL finished) {
            }];
        }
        else if (timelineView.center.x > 410 && velocity.x < 0) {
            [UIView animateWithDuration:.5 animations:^{
                timelineView.center = CGPointMake(450, 284);
            } completion:^(BOOL finished) {
            }];
        }
    }
}

#pragma mark MenuViewController delegate functions
- (void)didClickProfile {
    // Grab reference of view controller that will be removed and prepare it to be removed
    UIViewController *oldViewController = self.viewControllers[1];
    [oldViewController willMoveToParentViewController:nil];
    
    // Create the new view controller
    ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithUserId:[User currentUser].data[@"screen_name"]];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
    
    // Add the view to the containver view controller
    [self.viewControllers addObject:navigationController];
    [self addChildViewController:navigationController];
    
    [self transitionFromViewController: oldViewController
                      toViewController: navigationController
                              duration: 0.25 options:0
                            animations:^{
                                navigationController.view.frame = self.contentView.frame;
                                oldViewController.view.center = CGPointMake(480, 284);
                            }
                            completion:^(BOOL finished) {
                                [oldViewController removeFromParentViewController];
                                [navigationController didMoveToParentViewController:self];
                                [self.viewControllers removeObjectAtIndex:1];
                            }];
}


- (void)didClickTimeline {
    // Grab reference of view controller that will be removed and prepare it to be removed
    UIViewController *oldViewController = self.viewControllers[1];
    [oldViewController willMoveToParentViewController:nil];
    
    // Create the new view controller
    TimelineViewController *timelineViewController = [[TimelineViewController alloc] initWithTimeline];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:timelineViewController];
    
    // Add the view to the containver view controller
    [self.viewControllers addObject:navigationController];
    [self addChildViewController:navigationController];
    
    [self transitionFromViewController: oldViewController
                      toViewController: navigationController
                              duration: 0.25 options:0
                            animations:^{
                                navigationController.view.frame = self.contentView.frame;
                                oldViewController.view.center = CGPointMake(480, 284);
                            }
                            completion:^(BOOL finished) {
                                [oldViewController removeFromParentViewController];
                                [navigationController didMoveToParentViewController:self];
                                [self.viewControllers removeObjectAtIndex:1];
                            }];
}

- (void)didClickMentions {
    // Grab reference of view controller that will be removed and prepare it to be removed
    UIViewController *oldViewController = self.viewControllers[1];
    [oldViewController willMoveToParentViewController:nil];
        
    // Create the new view controller
    TimelineViewController *timelineViewController = [[TimelineViewController alloc] initWithMentions];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:timelineViewController];
        
    // Add the view to the containver view controller
    [self.viewControllers addObject:navigationController];
    [self addChildViewController:navigationController];
        
    [self transitionFromViewController: oldViewController
                      toViewController: navigationController
                              duration: 0.25 options:0
                            animations:^{
                                navigationController.view.frame = self.contentView.frame;
                                oldViewController.view.center = CGPointMake(480, 284);
                            }
                            completion:^(BOOL finished) {
                                [oldViewController removeFromParentViewController];
                                [navigationController didMoveToParentViewController:self];
                                [self.viewControllers removeObjectAtIndex:1];
                            }];
}

@end
