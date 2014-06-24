//
//  MainViewController.h
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterOption.h"
#import "FilterViewController.h"
#import "RestaurantProfile.h"
#import "FilterViewController.h"

@interface MainViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate, FilterViewControllerDelegate>

@end
