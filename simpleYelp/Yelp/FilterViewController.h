//
//  FilterViewController.h
//  Yelp
//
//  Created by Lin Zhang on 6/22/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterOption.h"
#import "ToggleViewCell.h"

@protocol FilterViewControllerDelegate <NSObject>
- (void)searchWithFilterOption:(FilterOption *)fiterOption;
@end

@interface FilterViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) id<FilterViewControllerDelegate> delegate;
@property (strong, nonatomic) FilterOption * filterOption;

@end
