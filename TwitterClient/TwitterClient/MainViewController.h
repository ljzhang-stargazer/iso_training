//
//  MainViewController.h
//  TwitterClient
//
//  Created by Lin Zhang on 7/6/14.
//  Copyright (c) 2014 Lin Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"

@interface MainViewController : UIViewController <MenuViewDelegate>

- (id)initWithViewControllers:(NSMutableArray *)viewControllers;

@end
