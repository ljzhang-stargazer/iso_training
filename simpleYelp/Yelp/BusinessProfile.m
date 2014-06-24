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
        
        //self.category = [categoryArray componentsJoinedByString:@","];
        self.category = @"";
        for (int i = 0; i < categoryArray.count; i++) {
            if (i == 0) {
                self.category = categoryArray[i][0];
            }
            else {
                self.category = [self.category stringByAppendingFormat:@", %@", categoryArray[i][0]];
            }
        }
    }
    
    return self;
}

@end
