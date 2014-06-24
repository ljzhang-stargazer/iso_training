//
//  ToggleViewCell.h
//  Yelp
//
//  Created by Lin Zhang on 6/22/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ToggleViewCell;

@protocol ToggleViewCellDelegate <NSObject>

- (void)sender:(ToggleViewCell *) sender didToggle:(BOOL)value;

@end

@interface ToggleViewCell : UITableViewCell

@property (nonatomic, assign) id<ToggleViewCellDelegate> delegate;

@end





