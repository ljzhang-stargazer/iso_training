//
//  ProfileHeader.h
//  TwitterClient
//
//  Created by Lin Zhang on 7/6/14.
//  Copyright (c) 2014 Lin Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileHeader : UIView <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (id)initWithNibName:(NSString *)nibName;

@end
