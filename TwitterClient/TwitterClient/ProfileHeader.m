//
//  ProfileHeader.m
//  TwitterClient
//
//  Created by Lin Zhang on 7/6/14.
//  Copyright (c) 2014 Lin Zhang. All rights reserved.
//

#import "ProfileHeader.h"

@implementation ProfileHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibName
{
    NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    if (arrayOfViews.count < 1) {
        return nil;
    }
    
    self = arrayOfViews[0];
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
