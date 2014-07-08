//
//  TweetCell.h
//  TwitterClient
//
//  Created by Lin Zhang on 6/27/14.
//  Copyright (c) 2014 Lin Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TweetCellDelegate <NSObject>

@optional
-(void)displayProfile:(id)sender;

@end

@interface TweetCell : UITableViewCell

@property IBOutlet UIImageView *avatar;
@property IBOutlet UILabel *tweet;
@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UILabel *twitterHandle;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (nonatomic, assign) id<TweetCellDelegate> delegate;

@end
