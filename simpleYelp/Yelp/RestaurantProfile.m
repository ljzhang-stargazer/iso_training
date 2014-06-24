//
//  RestaurantProfile.m
//  Yelp
//
//  Created by Lin Zhang on 6/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "RestaurantProfile.h"

@implementation RestaurantProfile

- (id) initWithRestaurantProfileData: (NSDictionary *) businessData
{
    self = [super initWithBusinessProfileData: businessData];
    
    if (businessData != nil)
    {
        self.priceRange = businessData[@"price"];
        self.isOpen = (BOOL)businessData[@"is_open"];
    }
    
    return self;
}


@end
