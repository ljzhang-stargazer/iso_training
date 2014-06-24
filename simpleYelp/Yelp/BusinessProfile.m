//
//  BusinessProfile.m
//  Yelp
//
//  Created by Lin Zhang on 6/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "BusinessProfile.h"

@implementation BusinessProfile

- (id) initWithBusinessProfileData: (NSDictionary *) businessData
{
    self = [super init];
    
    if (businessData != nil)
    {
        self.address = businessData[@"location"][@"address"][0];
        self.city = businessData[@"location"][@"city"];
        self.name = businessData[@"name"];
        self.distance = businessData[@"distince"];
        self.reviewNum = [NSString stringWithFormat:@"%@ Reviews",businessData[@"review_count"]];
        self.profileImage = [NSURL URLWithString: businessData[@"image_url"]];
        self.ratingImage = [NSURL URLWithString: businessData[@"rating_img_url"]];
        
        NSArray *categoryArray = businessData[@"categories"];
        
        self.category = [categoryArray componentsJoinedByString:@","];
    }
    
    return self;
}

@end
