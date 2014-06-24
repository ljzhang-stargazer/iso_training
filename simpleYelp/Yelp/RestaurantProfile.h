//
//  RestaurantProfile.h
//  Yelp
//
//  Created by Lin Zhang on 6/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "BusinessProfile.h"

@interface RestaurantProfile : BusinessProfile

@property (assign, nonatomic) BOOL isOpen;
@property (strong, nonatomic) NSString *priceRange;

- (id) initWithRestaurantProfileData: (NSDictionary *) businessData;

@end
