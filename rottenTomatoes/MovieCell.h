//
//  MovieCell.h
//  rottenTomatoes
//
//  Created by Lin Zhang on 6/7/14.
//  Copyright (c) 2014 Lin Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;

@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@end
